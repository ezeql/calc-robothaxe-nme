/*
* Copyright (c) 2009 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package robothaxe.core;

import robothaxe.core.IViewContainer;

/**
 * The Robotlegs ViewMap contract. All IViewMap automatic injections occur AFTER the view components are added to the stage.
 */
interface IViewMap
{
	/**
	 * Map an entire package (including sub-packages) for automatic injection
	 * 
	 * @param packageName The substring to compare
	 */		
	function mapPackage(packageName:String):Void;
	
	/**
	 * Unmap a package
	 * 
	 * @param packageName The substring to compare
	 */		
	function unmapPackage(packageName:String):Void;
	
	/**
	 * Check if a package has been registered for automatic injection
	 *
	 * @param packageName The substring to compare
	 * @return Whether a package has been registered for automatic injection
	 */
	function hasPackage(packageName:String):Bool;
	
	/**
	 * Map a view component class or interface for automatic injection
	 *
	 * @param type The concrete view Interface
	 */
	function mapType(type:Class<Dynamic>):Void;
	
	/**
	 * Unmap a view component class or interface
	 *
	 * @param type The concrete view Interface
	 */
	function unmapType(type:Class<Dynamic>):Void;
	
	/**
	 * Check if a class or interface has been registered for automatic injection
	 *
	 * @param type The concrete view interface 
	 * @return Whether an interface has been registered for automatic injection
	 */
	function hasType(type:Class<Dynamic>):Bool;
	
	/**
	 * The <code>IViewMap</code>'s <code>IViewContainer</code>
	 *
	 * @return view The <code>IViewContainer</code> to use as scope for this <code>IViewMap</code>
	 */
	var contextView(default, set_contextView):IViewContainer;
	
	/**
	 * The <code>IViewMap</code>'s enabled status
	 *
	 * @return Whether the <code>IViewMap</code> is enabled
	 */
	var enabled(default, set_enabled):Bool;
}
