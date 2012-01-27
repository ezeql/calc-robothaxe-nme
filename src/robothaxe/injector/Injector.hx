/*
* Copyright (c) 2009-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.injector;

import robothaxe.core.IInjector;
import robothaxe.injector.injectionpoints.ConstructorInjectionPoint;
import robothaxe.injector.injectionpoints.InjectionPoint;
import robothaxe.injector.injectionpoints.MethodInjectionPoint;
import robothaxe.injector.injectionpoints.NoParamsConstructorInjectionPoint;
import robothaxe.injector.injectionpoints.PostConstructInjectionPoint;
import robothaxe.injector.injectionpoints.PropertyInjectionPoint;
import robothaxe.injector.injectionresults.InjectClassResult;
import robothaxe.injector.injectionresults.InjectOtherRuleResult;
import robothaxe.injector.injectionresults.InjectSingletonResult;
import robothaxe.injector.injectionresults.InjectValueResult;
import robothaxe.util.Register;
import haxe.rtti.Meta;

class Injector implements IInjector
{
	//static var INJECTION_POINTS_CACHE = new Hash<Dynamic>();
	public var attendedToInjectees(default, null):Register<Dynamic>;
	public var parentInjector(default, set_parentInjector):Injector;

	var m_parentInjector:Injector;
	var m_mappings:Hash<Dynamic>;
	var m_injecteeDescriptions:ClassHash<InjecteeDescription>;
	
	public function new()
	{
		m_mappings = new Hash<Dynamic>();
		m_injecteeDescriptions = new ClassHash<InjecteeDescription>();
		attendedToInjectees = new Register<Dynamic>();
	}
	
	public function mapValue(whenAskedFor:Class<Dynamic>, useValue:Dynamic, ?named:String = ""):Dynamic
	{
		var config = getMapping(whenAskedFor, named);
		config.setResult(new InjectValueResult(useValue));
		return config;
	}
	
	public function mapClass(whenAskedFor:Class<Dynamic>, instantiateClass:Class<Dynamic>, ?named:String=""):Dynamic
	{
		var config = getMapping(whenAskedFor, named);
		config.setResult(new InjectClassResult(instantiateClass));
		return config;
	}
	
	public function mapSingleton(whenAskedFor :Class<Dynamic>, ?named:String="") :Dynamic
	{
		return mapSingletonOf(whenAskedFor, whenAskedFor, named);
	}
	
	public function mapSingletonOf(whenAskedFor:Class<Dynamic>, useSingletonOf:Class<Dynamic>, ?named:String=""):Dynamic
	{
		var config = getMapping(whenAskedFor, named);
		config.setResult(new InjectSingletonResult(useSingletonOf));
		return config;
	}
	
	public function mapRule(whenAskedFor:Class<Dynamic>, useRule:Dynamic, ?named:String = ""):Dynamic
	{
		var config = getMapping(whenAskedFor, named);
		config.setResult(new InjectOtherRuleResult(useRule));
		return useRule;
	}
	
	function getClassName(forClass:Class<Dynamic>):String
	{
		if (forClass == null) return "Dynamic";
		else return Type.getClassName(forClass);
	}

	public function getMapping(forClass:Class<Dynamic>, ?named:String=""):Dynamic
	{
		var requestName = getClassName(forClass) + "#" + named;
		
		if (m_mappings.exists(requestName))
		{
			return m_mappings.get(requestName);
		}
		
		var config = new InjectionConfig(forClass, named);
		m_mappings.set(requestName, config);
		return config;
	}
	
	public function injectInto(target:Dynamic):Void
	{
		if (attendedToInjectees.has(target))
		{
			return;
		}

		attendedToInjectees.add(target);
		
		//get injection points or cache them if this target's class wasn't encountered before
		var targetClass = Type.getClass(target);

		var injecteeDescription:InjecteeDescription = null;

		if (m_injecteeDescriptions.exists(targetClass))
		{
			injecteeDescription = m_injecteeDescriptions.get(targetClass);
		}
		else
		{
			injecteeDescription = getInjectionPoints(targetClass);
		}

		if (injecteeDescription == null) return;

		var injectionPoints:Array<Dynamic> = injecteeDescription.injectionPoints;
		var length:Int = injectionPoints.length;
		
		for (i in 0...length)
		{
			var injectionPoint:InjectionPoint = injectionPoints[i];
			injectionPoint.applyInjection(target, this);
		}
	}
	
	public function instantiate<T>(forClass:Class<T>):T
	{
		var injecteeDescription:InjecteeDescription;

		if (m_injecteeDescriptions.exists(forClass))
		{
			injecteeDescription = m_injecteeDescriptions.get(forClass);
		}
		else
		{
			injecteeDescription = getInjectionPoints(forClass);
		}

		var injectionPoint:InjectionPoint = injecteeDescription.ctor;
		var instance:Dynamic = injectionPoint.applyInjection(forClass, this);
		injectInto(instance);

		return instance;
	}
	
	public function unmap(theClass:Class<Dynamic>, ?named:String=""):Void
	{
		var mapping = getConfigurationForRequest(theClass, named);
		
		if (mapping == null)
		{
			throw new InjectorError('Error while removing an injector mapping: No mapping defined for class ' + getClassName(theClass) + ', named "' + named + '"');
		}

		mapping.setResult(null);
	}

	public function hasMapping(forClass:Class<Dynamic>, ?named :String = '') :Bool
	{
		var mapping = getConfigurationForRequest(forClass, named);
		
		if (mapping == null)
		{
			return false;
		}

		return mapping.hasResponse(this);
	}

	public function getInstance<T>(ofClass:Class<T>, ?named:String=""):T
	{
		var mapping = getConfigurationForRequest(ofClass, named);
		
		if (mapping == null || !mapping.hasResponse(this))
		{
			throw new InjectorError('Error while getting mapping response: No mapping defined for class ' + getClassName(ofClass) + ', named "' + named + '"');
		}

		return mapping.getResponse(this);
	}
	
	function getInjectionPoints(forClass:Class<Dynamic>):InjecteeDescription
	{
		var typeMeta = Meta.getType(forClass);

		if (typeMeta != null && Reflect.hasField(typeMeta, "interface"))
		{
			throw new InjectorError("Interfaces can't be used as instantiatable classes.");
		}

		var fieldsMeta = getFields(forClass);

		var ctorInjectionPoint:InjectionPoint = null;
		var injectionPoints:Array<InjectionPoint> = [];
		var postConstructMethodPoints:Array<Dynamic> = [];
		
		for (field in Reflect.fields(fieldsMeta))
		{
			var fieldMeta:Dynamic = Reflect.field(fieldsMeta, field);

			var inject = Reflect.hasField(fieldMeta, "inject");
			var post = Reflect.hasField(fieldMeta, "post");
			var type = Reflect.field(fieldMeta, "type");
			var args = Reflect.field(fieldMeta, "args");
			
			if (field == "_") // constructor
			{
				if (args.length > 0)
				{
					ctorInjectionPoint = new ConstructorInjectionPoint(fieldMeta, forClass, this);
				}
			}
			else if (Reflect.hasField(fieldMeta, "args")) // method
			{
				if (inject) // injection
				{
					var injectionPoint = new MethodInjectionPoint(fieldMeta, this);
					injectionPoints.push(injectionPoint);
				}
				else if (post) // post construction
				{
					var injectionPoint = new PostConstructInjectionPoint(fieldMeta, this);
					postConstructMethodPoints.push(injectionPoint);
				}
			}
			else if (type != null) // property
			{
				var injectionPoint = new PropertyInjectionPoint(fieldMeta, this);
				injectionPoints.push(injectionPoint);
			}
		}

		if (postConstructMethodPoints.length > 0)
		{
			postConstructMethodPoints.sort(function(a, b) { return a.order - b.order; });
			
			for (point in postConstructMethodPoints)
			{
				injectionPoints.push(point);
			}
		}

		if (ctorInjectionPoint == null)
		{
			ctorInjectionPoint = new NoParamsConstructorInjectionPoint();
		}

		var injecteeDescription = new InjecteeDescription(ctorInjectionPoint, injectionPoints);
		m_injecteeDescriptions.set(forClass, injecteeDescription);
		return injecteeDescription;
	}

	function getConfigurationForRequest(forClass:Class<Dynamic>, named:String, ?traverseAncestors:Bool=true):InjectionConfig
	{
		var requestName = getClassName(forClass) + '#' + named;
		
		if(!m_mappings.exists(requestName))
		{
			if (traverseAncestors && parentInjector != null && parentInjector.hasMapping(forClass, named))
			{
				return getAncestorMapping(forClass, named);
			}

			return null;
		}

		return m_mappings.get(requestName);
	}
	/* pretty sure this is only used by xml config, which we don't use.
	function addParentInjectionPoints(description:Classdef, injectionPoints:Array<Dynamic>):Void
	{
		var parentClassName = description.superClass.path;

		if (parentClassName == null)
		{
			return;
		}

		var parentClass = Type.resolveClass(parentClassName);
		var parentDescription:InjecteeDescription = null;

		if (m_injecteeDescriptions.exists(parentClass))
		{
			parentDescription = m_injecteeDescriptions.get(parentClass);
		}
		else
		{
			parentDescription = getInjectionPoints(parentClass);
		}

		injectionPoints.push(injectionPoints);
		injectionPoints.push(parentDescription.injectionPoints);
	}
	*/
	function set_parentInjector(value:Injector):Injector
	{
		//restore own map of worked injectees if parent injector is removed
		if (parentInjector != null && value == null)
		{
			attendedToInjectees = new Register<Dynamic>();
		}

		parentInjector = value;

		//use parent's map of worked injectees
		if (parentInjector != null)
		{
			attendedToInjectees = parentInjector.attendedToInjectees;
		}

		return parentInjector;
	}

	public function createChildInjector():IInjector
	{
		var injector = new Injector();
		injector.parentInjector = this;
		return injector;
	}

	public function getAncestorMapping(forClass:Class<Dynamic>, named:String=null):InjectionConfig
	{
		var parent = parentInjector;

		while (parent != null)
		{
			var parentConfig = parent.getConfigurationForRequest(forClass, named, false);

			if (parentConfig != null && parentConfig.hasOwnResponse())
			{
				return parentConfig;
			}

			parent = parent.parentInjector;
		}
		
		return null;
	}

	function getFields(type:Class<Dynamic>)
	{
		var meta = {};

		while (type != null)
		{
			var typeMeta = haxe.rtti.Meta.getFields(type);

			for (field in Reflect.fields(typeMeta))
			{
				Reflect.setField(meta, field, Reflect.field(typeMeta, field));
			}

			type = Type.getSuperClass(type);
		}

		return meta;
	}
}

class ClassHash<T>
{
	var hash:Hash<T>;

	public function new()
	{
		hash = new Hash<T>();
	}

	public function set(key:Class<Dynamic>, value:T):Void
	{
		hash.set(Type.getClassName(key), value);
	}

	public function get(key:Class<Dynamic>):T
	{
		return hash.get(Type.getClassName(key));
	}

	public function exists(key:Class<Dynamic>):Bool
	{
		return hash.exists(Type.getClassName(key));
	}
}

class InjecteeDescription
{
	public var ctor:InjectionPoint;
	public var injectionPoints:Array<InjectionPoint>;

	public function new(ctor:InjectionPoint, injectionPoints:Array<InjectionPoint>)
	{
		this.ctor = ctor;
		this.injectionPoints = injectionPoints;
	}
}
