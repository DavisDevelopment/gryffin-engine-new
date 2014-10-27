package gryffin.gscript.types;

import gryffin.gscript.types.GSObject;

class GSProperty {
	public var name:GSObject;
	public var enumerable:Bool;
	public var value:Null<GSObject>;
	public var get:Null<Void -> GSObject>;
	public var set:Null<GSObject -> GSObject>;

	public function new(name:GSObject, ?value:GSObject, ?getter:Void->GSObject, ?setter:Void->GSObject):Void {
		this.name = name;
		this.value = value;
		this.get = getter;
		this.set = setter;

		if (getter == null && value == null) {
			throw 'Must provide either [value] or [getter] arguments';
		}
		else if (getter != null && setter == null || getter == null && setter != null) {
			throw 'If either [getter] or [setter] arguments are provided, both must be';
		}
	}

	/*
	 * Internal Utility Methods
	 */
	
	/**
	 * Tests for key equality with object property access
	 * @param  key - The key being tested
	 * @return Booean
	 */
	public function is(key:GSObject):Bool {
		return (key.__is__(this.name));
	}


	public function val(?newvalue:GSObject):GSObject {
		
	}
}