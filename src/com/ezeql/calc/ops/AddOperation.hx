package com.ezeql.calc.ops;

/**
 * ...
 * @author EzeQL
 */

class AddOperation implements IOperation
{

	public function new() 
	{
	}
	
	/* INTERFACE com.ezeql.calc.ops.IOperation */
	
	public function compute(operand1:Int, operand2:Int):Int 
	{
		return operand1 + operand2;
	}
	
}