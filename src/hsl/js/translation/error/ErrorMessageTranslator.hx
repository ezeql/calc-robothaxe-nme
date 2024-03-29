/**
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
package hsl.js.translation.error;
import hsl.haxe.translation.Translation;
import hsl.haxe.translation.Translator;
import hsl.haxe.translation.NativeEvent;
import js.Dom;
import js.XMLHttpRequest;

/**
 * A translator that translates error events to strings containing the error message.
 */
class ErrorMessageTranslator implements Translator<String> {
	/**
	 * Creates a new error message translator.
	 */
	public function new():Void {
	}
	public function translate(nativeEvent:NativeEvent):Translation<String> {
		var errorEvent:Event = cast nativeEvent;
		if (Std.is(errorEvent.target, XMLHttpRequest)) {
			var xmlHttpRequest:XMLHttpRequest = cast(errorEvent.target, XMLHttpRequest);
			return new Translation<String>(xmlHttpRequest.status + " " + xmlHttpRequest.statusText, errorEvent.target);
		} else {
			return new Translation<String>("Error: the resource \"" + untyped errorEvent.target.src + "\" could not be found.", errorEvent.target);
		}
	}
	#if debug
	private function toString():String {
		return "[Translator]";
	}
	#end
}

