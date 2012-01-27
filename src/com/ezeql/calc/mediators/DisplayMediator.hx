package com.ezeql.calc.mediators;
import com.ezeql.calc.events.ComputeEvent;
import com.ezeql.calc.gui.Display;
import robothaxe.mvcs.Mediator;
using Std;

/**
 * ...
 * @author EzeQL
 */

class DisplayMediator  extends Mediator
{
	@inject	public var display:Display;
	
	public function new() 
	{
		super();
	}
	
	override public function onRegister():Void 
	{
		super.onRegister();
		addContextListener(ComputeEvent.COMPUTED, computedEventHandler, ComputeEvent);
	}
	
	private function computedEventHandler(e:ComputeEvent):Void 
	{
		display.tf.text = e.newValue.string();
	}
	
}