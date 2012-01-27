package com.ezeql.calc.events;
import robothaxe.event.Event;

/**
 * ...
 * @author EzeQL
 */

class CalcButtonEvent extends Event
{
	public var value(default, default):String;

	static public var NUMERIC_VALUE_PRESSED:String = "numericValuePressed";
	static public var OPERATOR_PRESSED:String = "OpPressed";
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, pVal:String = "")
	{
		super(type, bubbles, cancelable);
		value = pVal;
		
	}
	
	override public function clone():Event 
	{
		return new CalcButtonEvent(type, bubbles, cancelable, value);
	}
	
}