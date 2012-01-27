package com.ezeql.calc.commands;
import com.ezeql.calc.CalcModel;
import com.ezeql.calc.events.CalcButtonEvent;
import com.ezeql.calc.ops.AddOperation;
import com.ezeql.calc.ops.ComputeOperation;
import com.ezeql.calc.ops.DiffOperation;
import com.ezeql.calc.ops.IOperation;
import robothaxe.mvcs.Command;

/**
 * ...
 * @author EzeQL
 */

class SetOperationCommand extends Command
{
	private var opsHash:Hash<IOperation>;

	@inject public var event:CalcButtonEvent;
	@inject public var calcModel:CalcModel;
	
	public function new() 
	{
		super();
		opsHash = new Hash<IOperation>();
		opsHash.set("+", new AddOperation());
		opsHash.set("-", new DiffOperation());
		opsHash.set("=", new ComputeOperation());
	}
	
	override public function execute():Void 
	{
		super.execute();
		calcModel.operation = opsHash.get(event.value);
		
	}
	
}