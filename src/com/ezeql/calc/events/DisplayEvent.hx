package com.ezeql.calc.events;
import nme.events.Event;

/**
 * ...
 * @author EzeQL
 */

class DisplayEvent extends Event
{
	static public inline UPDATE

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
	
}