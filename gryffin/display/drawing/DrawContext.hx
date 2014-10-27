package gryffin.display.drawing;

import gryffin.utils.Object;
import gryffin.display.drawing.TextFormat;

class DrawContext {
	public var fillStyle:Int;
	public var strokeStyle:Int;
	public var textStyle:TextFormat;
	public var lineWidth:Float;
	public var lineCap:Int;
	public var lineJoin:Int;
	public var alpha:Float;
	public var scaleX:Float;
	public var scaleY:Float;

	public function new():Void {
		this.fillStyle = 0x00000000;
		this.strokeStyle = 0x00000000;
		this.textStyle = new TextFormat();
		this.lineWidth = 0;
		this.lineCap = 2;
		this.lineJoin = 0;
		this.alpha = 1;
		this.scaleX = this.scaleY = 1.0;
	}

	public function clone():DrawContext {
		var copy:DrawContext = new DrawContext();
		var ocopy:Object = new Object(copy);
		ocopy.merge(cast this);
		copy.textStyle = this.textStyle.clone();
		return copy;
	}
}