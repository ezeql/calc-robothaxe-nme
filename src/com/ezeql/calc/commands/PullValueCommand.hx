package com.ezeql.calc.commands;
import com.ezeql.calc.CalcModel;
import com.ezeql.calc.events.CalcButtonEvent;
import robothaxe.mvcs.Command;
using Std;
/**
 * ...
 * @author EzeQL
 */

class PullValueCommand extends Command
{
	@inject public var event:CalcButtonEvent;
	@inject public var calcModel:CalcModel;

	public function new() 
	{
		super();
	}
	
	override public function execute():Void 
	{
		calcModel.pushDigitToCurrentValue(event.value.parseInt());
		super.execute();
	}
}