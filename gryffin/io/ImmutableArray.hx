package gryffin.io;

import haxe.ds.Vector;

@:forward(
	length,
	iterator
)
abstract ImmutableArray <T> (Vector <T>) {
	public var self(get, never):ImmutableArray<T>;
	private var firstNullIndex(get, never):Int;

	public inline function new(len : Int):Void {
		this = new Vector(len);
	}
	private inline function get_self():ImmutableArray<T> {
		return cast this;
	}
	private inline function get_firstNullIndex():Int {
		for (index in 0...self.length) {
			if (self[index] == null) return index;
		}
		return -1;
	}

	@:arrayAccess
	public inline function get(index:Int):Null<T> {
		return this.get(index);
	}

	@:arrayAccess
	public inline function set(index:Int, value:T):T {
		if (index <= self.length) {
			this.set(index, value);
			return this.get(index);
		} else {
			return value;
		}
	}

	@:from 
	public static inline function fromArray <T> (list : Array<T>):ImmutableArray<T> {
		var ia:ImmutableArray<T> = new ImmutableArray(list.length);
		for (i in 0...list.length) {
			ia[i] = list[i];
		}
		return ia;
	}
}