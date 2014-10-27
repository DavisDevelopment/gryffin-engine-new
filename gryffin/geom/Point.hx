package gryffin.geom;

import gryffin.math.GMath;

@:forward(
	x,
	y,
	z,
	toNativePoint
)
abstract Point (CPoint) {
	private var self(get, never):Point;
	public inline function new(?x:Null<Float> = 0, ?y:Null<Float> = 0, ?z:Null<Float> = 0):Void {
		this = new CPoint(x, y, z);
	}
	private inline function get_self():Point {
		return cast this;
	}

	@:op(A == B)
	public inline function equals(other : Point):Bool {
		return (this.equals(cast other));
	}

	@:op(A != B)
	public inline function nequals(other : Point):Bool {
		return !(self.equals(other));
	}

	@:to 
	public inline function toOpenFLPoint():openfl.geom.Point {
		return this.toNativePoint();
	}

	@:from 
	public static inline function fromCPoint(cp:CPoint):Point {
		return new Point(cp.x, cp.y, cp.z);
	}

	@:from 
	public static inline function fromArray <T : Float> (set:Array<T>):Point {
		return new Point(set[0], set[1], set[2]);
	}
}

class CPoint {
	public var x:Null<Float>;
	public var y:Null<Float>;
	public var z:Null<Float>;

	public function new(?x:Null<Float> = 0, ?y:Null<Float> = 0, ?z:Null<Float> = 0):Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function equals(other : CPoint):Bool {
		return (this.x == other.x && this.y == other.y && this.z == other.z);
	}

	public function toNativePoint():openfl.geom.Point {
		return new openfl.geom.Point(this.x, this.y);
	}
}