package com.ezeql.calc;

import com.ezeql.calc.commands.PullValueCommand;
import com.ezeql.calc.commands.SetOperationCommand;
import com.ezeql.calc.events.CalcButtonEvent;
import com.ezeql.calc.gui.ButtonPad;
import com.ezeql.calc.gui.Display;
import com.ezeql.calc.mediators.ButtonPadMediator;
import com.ezeql.calc.mediators.CalcMediator;
import com.ezeql.calc.mediators.DisplayMediator;
import com.ezeql.robothaxe.EventTargetAdapter;
import nme.display.Sprite;
import nme.events.Event;
import robothaxe.mvcs.Context;


class CalcContext extends Sprite, implements robothaxe.core.IViewContainer
{
	static var context:Context;
	private var buttonPad:ButtonPad;
	private var display:Display;
	
	public function new(root)
	{
		super();
		context = new Context(this);

		#if flash 
		addEventListener(Event.ADDED_TO_STAGE, onAdded, true);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, true);
		#end
		
		
		context.commandMap.mapEvent(CalcButtonEvent.NUMERIC_VALUE_PRESSED, PullValueCommand);
		context.commandMap.mapEvent(CalcButtonEvent.OPERATOR_PRESSED, SetOperationCommand);
		
		context.mediatorMap.mapView(Display, DisplayMediator );
		context.mediatorMap.mapView(ButtonPad, ButtonPadMediator);
		context.mediatorMap.mapView(CalcContext, CalcMediator);
		
		context.injector.mapSingleton(CalcModel);

		display = new Display();
		buttonPad = new ButtonPad();
		
		addChild(display);
		addChild(buttonPad);
		
		#if js
		onAdded(new EventTargetAdapter(Event.ADDED_TO_STAGE, true, false, display));
		onAdded(new EventTargetAdapter(Event.ADDED_TO_STAGE, true, false, buttonPad));
		#end

		root.addChild(this);
		
		this.y = 200;
	}
	
	/* INTERFACE robothaxe.core.IViewContainer */
	
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;
	
	public function isAdded(view:Dynamic):Bool
	{
		return (view.stage != null);
	}

	function onAdded(e)
	{
		if (viewAdded != null) viewAdded(e.target);
	}

	function onRemoved(e)
	{
		if (viewRemoved != null) viewRemoved(e.target);
	}

	
}