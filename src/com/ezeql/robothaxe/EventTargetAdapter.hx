package com.ezeql.robothaxe;
import nme.events.Event;

/**
 * ...
 * @author EzeQL
 */

class EventTargetAdapter extends Event
{

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, ?target:Dynamic) 
	{
		super(type, bubbles, cancelable);
		#if js
		this.target = this.currentTarget = target;
		#end

	}
	
}