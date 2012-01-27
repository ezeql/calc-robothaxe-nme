package com.ezeql.calc.events;
import robothaxe.event.Event;

/**
 * ...
 * @author EzeQL
 */

class ComputeEvent extends Event
{
	static public inline var COMPUTED:String = "computed";
	
	public var newValue(default, null):Int;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, pNewValue:Int = 0 )
	{
		super(type, bubbles, cancelable);
		newValue = pNewValue;
	}
	
}