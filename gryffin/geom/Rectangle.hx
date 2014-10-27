package gryffin.geom;

import gryffin.geom.Point;
import gryffin.io.ArrayPointer;

@:forward(
	x,
	y,
	width,
	height
)
abstract Rectangle (CRectangle) {
	public inline function new(?x:Float = 0, ?y:Float = 0, ?width:Float = 0, ?height:Float = 0):Void {
		this = new CRectangle(x, y, width, height);
	}

	@:to 
	public inline function toArray():Array<Float> {
		return [this.x, this.y, this.width, this.height];
	}

	@:to 
	public inline function toPointArray():Array<Point> {
		var points:Array<Point> = new Array();
		for (px in Std.int(this.x)...Std.int(this.width)) {
			for (py in Std.int(this.y)...Std.int(this.height)) {
				points.push(new Point(px, py, 0));
			}
		}
		return points;
	}

	@:to 
	public inline function toFlashRectangle():openfl.geom.Rectangle {
		return new openfl.geom.Rectangle(this.x, this.y, this.width, this.height);
	}

	@:to 
	public inline function toString():String {
		return 'Rectangle(${this.x}, ${this.y}, ${this.width}, ${this.height})';
	}

	@:from 
	public static inline function fromArray <T : Float> (arr : Array<T>):Rectangle {
		return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
	}
}


class CRectangle {
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public function new(?x:Float = 0, ?y:Float = 0, ?width:Float = 0, ?height:Float = 0):Void {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

	}
}