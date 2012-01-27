package com.ezeql.calc.gui;
import nme.display.Sprite;
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
using hsl.avm2.plugins.MouseShortcuts;
/**
 * ...
 * @author EzeQL
 */

class Button extends Sprite
{
	static public inline var BTN_WIDTH:Int = 40;
	static public inline var BTN_HEIGHT:Int = 40;
	
	public var text(getText, setText):String;

	private var tf:TextField;
	public function new() 
	{
		super();
		draw();
		
	}
	
	private function draw() 
	{
		
		graphics.beginFill(0xCECECE);
		graphics.lineStyle(1, 0, 1);
		graphics.drawRect(0, 0, BTN_WIDTH, BTN_HEIGHT);
		graphics.endFill();
		
		useHandCursor = true;
		buttonMode = true;
		
		mouseChildren = false;

		tf = new TextField();
		tf.width = BTN_WIDTH;
		tf.height = BTN_HEIGHT;
		tf.selectable = false;
		addChild(tf);
		
		tf.autoSize = TextFieldAutoSize.CENTER;
		var textFormat = tf.defaultTextFormat;
		textFormat.size = 15;
		tf.defaultTextFormat = textFormat;
		
		//primevc.core.dispatcher.Signal
		this.getMouseEnteredSignaler().bindVoid(handleMouseEntered);
		this.getMouseExitedSignaler().bindVoid(handleMouseExited);
	}
	
	private function handleMouseEntered():Void
	{
		this.filters = [new GlowFilter() ];
	}
	
	private function handleMouseExited():Void
	{
		this.filters = [ ];
	}
	

	
	private function getText():String
	{
		return tf.text;
	}
	private function setText(strText):String
	{
		return tf.text = strText;
	}
	
	
}