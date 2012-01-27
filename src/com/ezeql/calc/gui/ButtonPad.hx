package com.ezeql.calc.gui;
import com.ezeql.calc.events.CalcButtonEvent;
import hsl.haxe.data.mouse.MouseCondition;
import hsl.haxe.Signaler;
import nme.display.Sprite;
import com.ezeql.calc.gui.Button;
import nme.events.MouseEvent;


using Std;
using hsl.avm2.plugins.MouseShortcuts;
/**
 * ...
 * @author EzeQL
 */

class ButtonPad extends Sprite
{
	static public inline var VERTICAL_SEP:Int = 5;
	static public inline var HORIZONTAL_SEP:Int = 5;
	static public inline var ITEMS_PER_LINE:Int = 3;

	//public var buttonPressedSignal(getButtonPressedSignal, null):hsl.haxe.si
	public var operationPressedSignal(default, null):Signaler<String>;
	public var digitPressedSignal(default, null):Signaler<String>;
	
	public function new() 
	{
		super();
		operationPressedSignal = new hsl.haxe.DirectSignaler(this);
		digitPressedSignal = new hsl.haxe.DirectSignaler(this);
		
		for (i in 0...10) 
		{
			var btn = new Button();
			addChild(btn);
			btn.name = "btn" + (9 - i).string();
			btn.text = (9 - i).string();
			btn.x = (ITEMS_PER_LINE-1) * (btn.width + HORIZONTAL_SEP) - (btn.width + HORIZONTAL_SEP) * (i % ITEMS_PER_LINE);
			btn.y = 50 + (btn.width + VERTICAL_SEP) * (i / ITEMS_PER_LINE).int();
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			if (i == 9) btn.x = 0;
		}
		
		var plusSignBtn = new Button();
		addChild(plusSignBtn);
		plusSignBtn.name = "btnPlus";
		plusSignBtn.text = "+";
		plusSignBtn.x = 200;
		plusSignBtn.y = 50;
		plusSignBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseOperationPressed, false, 0, true);
		
		
		var minusSign = new Button();
		addChild(minusSign);
		minusSign.name = "btnMinus";
		minusSign.text = "-";
		minusSign.x = 200;
		minusSign.y = 100;
		minusSign.addEventListener(MouseEvent.MOUSE_DOWN, mouseOperationPressed, false, 0, true);
		
		
		var computeBtn = new Button();
		addChild(computeBtn);
		computeBtn.name = "computeBtn";
		computeBtn.text = "=";
		computeBtn.x = 200;
		computeBtn.y = 200;
		computeBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseOperationPressed, false, 0, true);
	
		var clearBtn = new Button();
		//addChild(clearBtn);
		clearBtn.name = "clearBtn";
		clearBtn.text = "AC";
		clearBtn.x = 150;
		clearBtn.y = 200;
		clearBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseOperationPressed, false, 0, true);
		
	}
	
	private function mouseOperationPressed(e:MouseEvent):Void 
	{
		var value = cast(e.currentTarget, Button).text;
		operationPressedSignal.dispatch(value);
		//dispatchEvent( new CalcButtonEvent(CalcButtonEvent.OPERATOR_PRESSED, false, false, value));
	}
	
	private function mouseDownHandler(e:MouseEvent):Void 
	{
		var value = cast(e.currentTarget, Button).text;
		digitPressedSignal.dispatch(value);
		//dispatchEvent( new CalcButtonEvent(CalcButtonEvent.NUMERIC_VALUE_PRESSED, false, false, value));
	}
	

	
}