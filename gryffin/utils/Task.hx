package gryffin.utils;

import gryffin.core.EventDispatcher;
import gryffin.io.Pointer;

class Task {
	public var result:Null<Dynamic>;
	public var error:Null<String>;
	public var onComplete:Null<String> -> Null<Dynamic> -> Void;
	public var action:(Void->Void) -> Pointer<Null<String>> -> Pointer<Null<Dynamic>> -> Void;

	public function new(act:(Void->Void) -> Pointer<Null<String>> -> Pointer<Null<Dynamic>> -> Void):Void {
		this.action = act;
		this.result = null;
		this.error = null;
	}
	public function perform():Void {
		var errPtr:Pointer<Null<String>> = (function() return null);
		var resultPtr:Pointer<Null<Dynamic>> = (function() return null);

		function declareComplete():Void {
			this.error = errPtr.get();
			this.result = resultPtr.get();

			if (this.onComplete != null) {
				this.onComplete(this.error, this.result);
			}
		}

		this.action(declareComplete, errPtr, resultPtr);
	}
}

private typedef CompletionNotice = Void->Void;