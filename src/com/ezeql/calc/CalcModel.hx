package com.ezeql.calc;
import com.ezeql.calc.events.ComputeEvent;
import com.ezeql.calc.ops.AddOperation;
import com.ezeql.calc.ops.IOperation;
import robothaxe.mvcs.Actor;

/**
 * ...
 * @author EzeQL
 */

 using Std;
class CalcModel extends Actor
{

	public var ansValue(default, setAnsValue):Int;
	
	public var currentValue(default, setCurrentValue):Int;
	public var operation(null, setOperation):IOperation;
	
	private var op1:Int;
	
	public function new() 
	{
		super();
	}
	
	private function setAnsValue(value:Int):Int
	{
		return ansValue = value;
	}
	
	private function setCurrentValue(value:Int):Int
	{
		currentValue = value;
		dispatch( new ComputeEvent(ComputeEvent.COMPUTED, false, false, currentValue));
		return currentValue;
	}
	
	public function pushDigitToCurrentValue(digit:Int):Void
	{
		currentValue = currentValue * 10 + digit;
		
	}
	
	public function saveOp():Void
	{
		op1 = currentValue;
		currentValue  = 0;
	}
	
	public function compute():Void
	{
		if (op1 != 0 )
		{
			currentValue = operation.compute(op1, currentValue);
			op1 = 0;
		}
		else
		{
			op1 = currentValue;
			currentValue = 0;
		}
	}
	
	private function setOperation(newOperation:IOperation):IOperation
	{
		if (operation != null)
		{
			compute();
		}
		else
		{
			saveOp();
		}
		return operation = newOperation;
	}

}