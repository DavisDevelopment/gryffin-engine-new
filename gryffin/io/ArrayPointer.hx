package gryffin.io;

abstract ArrayPointer <Index, Value> (Index -> Value) {
	public inline function new(getter : Index -> Null<Value>):Void {
		this = getter;
	}

	@:arrayAccess
	public inline function at(key : Index):Null<Value> {
		return this(key);
	}

	@:from
	public static inline function fromArray <T> (list : Array<T>):ArrayPointer<Int, T> {
		return new ArrayPointer(function(i:Int):T return list[i]);
	}

	@:from
	public static inline function fromGetter <K, T> (gtr : K -> T):ArrayPointer<K, T> {
		return new ArrayPointer(gtr);
	}
}