package com.ezeql.calc.mediators;
import com.ezeql.calc.events.CalcButtonEvent;
import com.ezeql.calc.gui.ButtonPad;
import robothaxe.mvcs.Mediator;

/**
 * ...
 * @author EzeQL
 */

class ButtonPadMediator extends Mediator
{
	@inject	public var buttonPad:ButtonPad;

	public function new() 
	{
		super();
	}
	
	override public function onRegister():Void 
	{
		super.onRegister();
		buttonPad.operationPressedSignal.bind(operatorPressedHandler);
		buttonPad.digitPressedSignal.bind(numericValuePressedHandler);
		//buttonPad.addEventListener(CalcButtonEvent.NUMERIC_VALUE_PRESSED, numericValuePressedHandler);
		//buttonPad.addEventListener(CalcButtonEvent.OPERATOR_PRESSED, operatorPressedHandler);
	}
	
	private function operatorPressedHandler(value:String):Void 
	{
		dispatch(new CalcButtonEvent(CalcButtonEvent.OPERATOR_PRESSED, false, false, value));
	}
	
	private function numericValuePressedHandler(value:String):Void 
	{

		dispatch(new CalcButtonEvent(CalcButtonEvent.NUMERIC_VALUE_PRESSED, false, false, value));
	}
	
}