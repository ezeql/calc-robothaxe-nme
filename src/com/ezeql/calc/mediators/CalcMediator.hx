package com.ezeql.calc.mediators;
import com.ezeql.calc.CalcContext;
import nme.filters.BlurFilter;
import nme.filters.DropShadowFilter;
import robothaxe.mvcs.Mediator;

/**
 * ...
 * @author EzeQL
 */

class CalcMediator extends Mediator
{
	
	public function new() 
	{
		super();
	}
	
	override public function onRegister():Void 
	{
		super.onRegister();
		trace("CalcMediator.onRegister: "+ getViewCasted());
	}
	
	
	
	
	private function getViewCasted():CalcContext
	{
		return cast(viewComponent, CalcContext);
	}
	
	
}