package gryffin.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import gryffin.display.Surface;
import gryffin.display.ImageDrawingContext;
import gryffin.core.Destructible;
import gryffin.io.Pointer;

class Image implements Destructible {
	public var surface:Surface;
	public var baseData:BitmapData;
	public var imageData:BitmapData;

	public var width(default, set):Float;
	public var height(default, set):Float;
	public var x:Float;
	public var y:Float;
	private var context:ImageDrawingContext;

	public function new(baseWidth:Int, baseHeight:Int, ?data:BitmapData):Void {
		this.x = 0;
		this.y = 0;
		this.width = baseWidth;
		this.height = baseHeight;
		if (data == null)
			data = new BitmapData(baseWidth, baseHeight, true, 0xFFFFFF);
		this.baseData = data;
		this.imageData = baseData.clone();


		this.context = new ImageDrawingContext(Pointer.literal(this.imageData), this);
	}

	public function redraw():Void {
		imageData = baseData.clone();
		context.draw();
	}

	public function getContext():ImageDrawingContext {
		return this.context;
	}

	public function destroy():Void {
		this.imageData.dispose();
	}
	/*
	 * Private Internals
	 */
	
	/**
	 * Setter Method for [width]
	 * @param nw - new width
	 */
	private inline function set_width(nw:Float):Float {
		width = nw;
		return nw;
	}

	/**
	 * Setter Method for [height]
	 * @param nh - new height
	 */
	private inline function set_height(nh:Float):Float {
		height = nh;
		return nh;
	}
}