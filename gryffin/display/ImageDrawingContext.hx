package gryffin.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import gryffin.io.Pointer;
import gryffin.display.Image;
import gryffin.display.ImageDrawingProgram;

import gryffin.geom.Point;
import gryffin.geom.Rectangle;

class ImageDrawingContext {
	public var data(get, never):BitmapData;
	public var width(get, never):Float;
	public var height(get, never):Float;
	public var program(get, never):Null<ImageDrawingProgram>;

	public var mode:Int;
	public var programs:Array<ImageDrawingProgram>;

	public var sprite:Sprite;

	private var data_pointer:Pointer<BitmapData>;

	public function new(dp:Pointer<BitmapData>, owner:Image):Void {
		this.data_pointer = dp;
		this.sprite = new Sprite();
		this.mode = 0;
		this.programs = new Array();
		var me = this;
		this.programs.push(new ImageDrawingProgram(Pointer.literal(owner)));
	}
	/*
	 * Drawing Methods
	 */
	
	public function setPixel(where:Point, what:Int):Void {
		if (program != null) {
			program.setPixel(where, what);
		}
	}

	public function drawRect(rect:Rectangle, color:Int):Void {
		if (program != null) {
			program.drawRect(rect, color);
		}
	}

	public function drawImage(img:BitmapData, sx:Float, sy:Float, sw:Float, sh:Float, ?dx:Float, ?dy:Float, ?dw:Float, ?dh:Float):Void {
		if (program != null) {
			program.drawImage(img, sx, sy, sw, sh, dx, dy, dw, dh);
		}
	}

	/*
	 * Public Internals
	 */
	public function draw():Void {
		this.sprite.width = data.width;
		this.sprite.height = data.height;
		if (program != null) {
			program.execute(this);
		}
	}

	 /*
	  * Private Internals
	  */
	private inline function get_data():BitmapData {
		return data_pointer.get();
	}

	private inline function get_program():Null<ImageDrawingProgram> {
		return programs[mode];
	}

	private inline function get_width():Float {
		return data.width;
	}

	private inline function get_height():Float {
		return data.height;
	}
}