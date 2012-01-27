package com.ezeql.calc.gui;
import haxe.Timer;
import nme.text.TextField;
import nme.display.Sprite;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author EzeQL
 */

class Display extends Sprite
{
	public var tf:TextField;
		
	private var hTimer:Timer;
	
	public function new() 
	{
		super();
		draw();
	}
	
	private function draw() 
	{
		graphics.beginFill(0x607760, 1);
		graphics.drawRect(0, 0, 200, 40);
		graphics.endFill();
		
		tf = new TextField();
		tf.width = width;
		tf.height = height;
		tf.selectable = false;
		
		tf.autoSize = TextFieldAutoSize.RIGHT;
		var textFormat = tf.defaultTextFormat;
		textFormat.size = 30;
		tf.defaultTextFormat = textFormat;
		
	
		addChild(tf);
		tf.text = "NME Powered";
		hTimer = haxe.Timer.delay(function() { tf.text = "0";} , 1000);
	}
	
}