package gryffin.io;

import gryffin.ore.ObjectRegEx;

abstract SelectorString (String) {
	public inline function new(sel : String) {
		this = sel;
	}

	@:op( !A )
	public inline function negate():SelectorString {
		return new SelectorString('!($this)');
	}

	@:op( A + B )
	public inline function plusString(other : String):SelectorString {
		return new SelectorString('($this)&($other)');
	}

	@:op( A - B )
	public inline function minusString(other : String):SelectorString {
		return new SelectorString('($this)!($other)');
	}

	@:op( A - B )
	public inline function minusClass <T> (other : Class<T>):SelectorString {
		return new SelectorString('($this)!(${className(other)})');
	}

	@:to 
	public inline function toFilterFunction():Dynamic -> Bool {
		return cast ObjectRegEx.getFunc(this);
	}

	@:from 
	public static inline function fromString(s:String):SelectorString {
		return new SelectorString(s);
	}

	@:from 
	public inline static function fromClass <T> (cl:Class<T>):SelectorString {
		var className:String = Type.getClassName(cl);
		className = className.substring(className.lastIndexOf('.'));
		return new SelectorString(className);
	}

	private static inline function className <T> (cl : Class<T>):String {
		var _ref:String = Type.getClassName(cl);
		return (_ref.substring(_ref.lastIndexOf('.')));
	}
}