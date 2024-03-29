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
package hsl.js.plugins;
import hsl.haxe.plugins.SignalerVault;
import hsl.haxe.Signaler;
import hsl.js.translating.JSSignaler;
import hsl.js.translation.keyboard.KeyCodeTranslator;
import js.Dom;

/**
 * Shortcuts for keyboard actions.
 */
class KeyboardShortcuts {
	private static inline var KEY_PRESSED:String = "keyPressed";
	private static var signalerVault:SignalerVault<HtmlDom>;
	private static function createKeyPressedSignaler(nativeDispatcher:HtmlDom):JSSignaler<Int> {
		return new JSSignaler(nativeDispatcher, nativeDispatcher, JSEventType.KEYPRESS, new KeyCodeTranslator());
	}
	/**
	 * Gets a signaler that dispatches signals when the user presses a key on the keyboard. The dispatched signals contain the
	 * key code of the associated key. This method either creates a new signaler, or uses an existing one, depending on whether
	 * this method has been called before. If you call this method twice on the same object, the same signaler instance will be
	 * returned.
	 */
	public static inline function getKeyPressedSignaler(nativeDispatcher:HtmlDom):Signaler<Int> {
		if (null == signalerVault) {
			signalerVault = new SignalerVault<HtmlDom>();
		}
		return signalerVault.getSignaler(nativeDispatcher, KEY_PRESSED, createKeyPressedSignaler);
	}
}