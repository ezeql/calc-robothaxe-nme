﻿/**
 * Copyright (c) 2009-2010, The HSL Contributors.
 *
 * This file is part of HSL. HSL, pronounced "hustle", stands for haXe Signaling Library.
 *
 * HSL is free software. Redistribution and use in source and binary forms, with or without modification, are permitted
 * provided that the following conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright notice, this list of conditions and the following
 *     disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HSL CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE HSL
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * End of conditions.
 * 
 * The license of this software might change in the future, most likely to match the license of the haXe core libraries. In
 * such event, you may use this version of this software under either the terms above or under the terms of the new license of
 * this software.
 */
package hsl.avm2.plugins;
import hsl.avm2.translating.AVM2Signaler;
import hsl.haxe.Signaler;
import hsl.haxe.translation.Translator;
import flash.events.IEventDispatcher;
#if !(nme || jeash)
import flash.utils.TypedDictionary;
#end

#if (nme || jeash)
/**
 * A vault that stores signalers for the AVM2 target, that doesn't use the dictionary class (as, in some cases that class is
 * not available).
 */
class AVM2SignalerVault {
	private var signalerCells:Hash<List<SignalerCell>>;
	public function new():Void {
		signalerCells = new Hash();
	}
	/**
	 * Gets a translating signaler for the passed native dispatcher and the passed native event type. This method creates a new
	 * translating signaler if it cannot find one that has been created earlier. If a new translating signaler is created, the
	 * passed createTranslator function is called to create a translator.
	 */
	public function getSignaler<Datatype>(nativeDispatcher:IEventDispatcher, nativeEventType:String, createTranslator:Void -> Translator<Datatype>):Signaler<Datatype> {
		var signalerCellList:List<SignalerCell> =
			if (signalerCells.exists(nativeEventType)) {
				signalerCells.get(nativeEventType);
			} else {
				var result:List<SignalerCell> = new List();
				signalerCells.set(nativeEventType, result);
				result;
			}
		for (signalerCell in signalerCellList) {
			if (signalerCell.nativeDispatcher == nativeDispatcher) {
				return untyped signalerCell.signaler;
			}
		}
		var result:Signaler<Datatype> = new AVM2Signaler(nativeDispatcher, nativeDispatcher, nativeEventType, createTranslator());
		signalerCellList.add(new SignalerCell(nativeDispatcher, result));
		return result;
	}
}
class SignalerCell {
	public var nativeDispatcher(default, null):Dynamic;
	public var signaler(default, null):Signaler<Dynamic>;
	public function new(nativeDispatcher:Dynamic, signaler:Signaler<Dynamic>):Void {
		this.nativeDispatcher = nativeDispatcher;
		this.signaler = signaler;
	}
}
#else
/**
 * A vault that stores signalers, for the AVM2 target.
 */
class AVM2SignalerVault {
	private var signalers:TypedDictionary<IEventDispatcher, Hash<Signaler<Dynamic>>>;
	/**
	 * Creates a new AVM2 signaler vault.
	 */
	public function new():Void {
		signalers = new TypedDictionary(true);
	}
	/**
	 * Gets a translating signaler for the passed native dispatcher and the passed native event type. This method creates a new
	 * translating signaler if it cannot find one that has been created earlier. If a new translating signaler is created, the
	 * passed createTranslator function is called to create a translator.
	 */
	public function getSignaler<Datatype>(nativeDispatcher:IEventDispatcher, nativeEventType:String, createTranslator:Void -> Translator<Datatype>):Signaler<Datatype> {
		var hash:Hash<Signaler<Dynamic>> =
			// If a hash for this native dispatcher already exists, return it.
			// This line should use the "exists" method, rather then the "get" method. However, "exists" in haXe 2.06 - which is the
			// latest stable haXe release - is buggy. It will be fixed in the next version, and the line below will be changed back
			// as soon as that version is released.
			if (null != signalers.get(nativeDispatcher)) {
				signalers.get(nativeDispatcher);
			// If there is no hash for this native dispatcher, create it, add it and return it.
			} else {
				var result:Hash<Signaler<Dynamic>> = new Hash();
				signalers.set(nativeDispatcher, result);
				result;
			}
		return
			// If the hash contains a signaler for this native event type, return it.
			if (hash.exists(nativeEventType)) {
				hash.get(nativeEventType);
			} else {
			// If there is no signaler for this native event type, create it, add it and return it.
				var result:Signaler<Datatype> = new AVM2Signaler(nativeDispatcher, nativeDispatcher, nativeEventType, createTranslator());
				hash.set(nativeEventType, result);
				return result;
			}
	}
}
#end
