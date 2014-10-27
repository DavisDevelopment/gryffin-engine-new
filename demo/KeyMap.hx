package demo;

import gryffin.io.Byte;
import gryffin.events.GKeyboardEvent;

@:forward(
	iterator
)
abstract KeyMap (CKeyMap) {
	public inline function new():Void {
		this = new CKeyMap();
	}
	public inline function keys():Iterator<Int> {
		return this.allKeys();
	}
	public inline function exists(code : Byte):Bool {
		return this.hasKey(code);
	}
	public inline function remove(code : Byte):Void {
		this.removeKey(code);
	}

	@:arrayAccess
	public inline function get(code : Byte):Null<Key> {
		return this.getKey(cast code);
	}

	@:arrayAccess
	public inline function set(code:Byte, keyevent:GKeyboardEvent):Void {
		this.setKey(cast code, keyevent);
	}

	public inline function toString():String {
		var pieces:Array<String> = new Array();
		var codes:Array<Byte> = [for (code in this.allKeys()) Byte.fromInt(code)];
		for (code in codes) {
			var tuple:Key = this.getKey(code);
			var codeTuple:String = '(${code.toInt()}, ${code.toString()})';
			var keyTuple:String = '(${tuple.alt}, ${tuple.ctrl}, ${tuple.shift})';
			pieces.push('$codeTuple => $keyTuple');
		}

		return ('KeyMap(\n' + pieces.join(',\n') + '\n)');
	}
}

class CKeyMap {
	public var keys:Map<Int, Key>;

	public function new():Void {
		this.keys = new Map();
	}
	public inline function iterator():Iterator<Key> {
		return keys.iterator();
	}
	public inline function allKeys():Iterator<Int> {
		return keys.keys();
	}
	public inline function hasKey(code : Int):Bool {
		return keys.exists(code);
	}
	public inline function removeKey(code : Int):Void {
		keys.remove(code);
	}
	public inline function getKey(code : Int):Null<Key> {
		return keys[code];
	}
	public inline function setKey(code:Int, event:GKeyboardEvent):Void {
		keys.remove(code);
		if (!event.up) {
			var key = {
				'shift' : event.shiftKey,
				'alt'   : event.altKey,
				'ctrl'  : event.ctrlKey
			};

			keys[code] = key;
		}
	}
}

private typedef Key = {
	shift:Bool,
	alt:Bool,
	ctrl:Bool
};