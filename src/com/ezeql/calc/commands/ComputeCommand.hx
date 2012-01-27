package com.ezeql.calc.commands;
import com.ezeql.calc.CalcModel;
import robothaxe.mvcs.Command;

/**
 * ...
 * @author EzeQL
 */

class ComputeCommand extends Command
{
	@inject public var calcModel:CalcModel;
	public function new() 
	{
		super();
	}
	
	override public function execute():Void 
	{
		super.execute();
		calcModel.compute();
	}
	
}