package gryffin.display;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import gryffin.Stage;
import gryffin.display.Image;
import gryffin.time.Heartbeat;
import gryffin.core.EventDispatcher;

import gryffin.geom.Rectangle;
import gryffin.geom.Point;

class Surface extends EventDispatcher {
	public var stage:Stage;
	public var sprite:Sprite;
	public var screen_wrapper:Bitmap;
	public var screen:BitmapData;

	public var width(default, set):Float;
	public var height(default, set):Float;
	public var rect(get, set):Rectangle;

	public function new(movie:Stage):Void {
		super();

		this.stage = movie;
		this.sprite = new Sprite();
		this.screen = new BitmapData(Std.int(movie.width), Std.int(movie.height), true, 0xFFFFFF00);
		this.screen_wrapper = new Bitmap(screen);

		screen_wrapper.width = movie.width;
		screen_wrapper.height = movie.height;

		trace(new Rectangle(0, 0, screen_wrapper.width, screen_wrapper.height));

		sprite.addChild(screen_wrapper);

		movie.pane.addChild(screen_wrapper);

		Heartbeat.tick(this.update.bind());

		movie.window.addEventListener(openfl.events.Event.RESIZE, function(e:Dynamic):Void {
			this.screen = new BitmapData(Std.int(movie.width), Std.int(movie.height), true, 0xFFFFFF00);
			this.screen_wrapper.bitmapData = this.screen;
			screen_wrapper.width = movie.width;
			screen_wrapper.height = movie.height;
		});
	}
	public function reset():Void {
		screen.fillRect(new openfl.geom.Rectangle(0, 0, stage.width, stage.height), 0xFFFFFF);
	}
	public function render():Void {
		emit('render', null);
	}
	public function update():Void {
		emit('update', null);


	}
	public function drawImage(img:BitmapData, x:Float, y:Float, width:Float, height:Float):Void {

	}
	public function addImage(img : Image):Void {
		img.surface = this;

		var bm = new Bitmap(img.imageData);
		this.sprite.addChild(bm);
		bm.width = img.width;
		bm.height = img.height;
		bm.x = img.x;
		bm.y = img.y;

		var dummy:BitmapData = new BitmapData(Std.int(img.imageData.width), Std.int(img.imageData.height), true, 0xFFFFFF);
		dummy.draw(bm);

		var src = new Rectangle(0, 0, dummy.width, dummy.height).toFlashRectangle();
		var dest = new Point(bm.x, bm.y).toNativePoint();

		screen.copyPixels(dummy, src, dest, null, null, true);

		on('render', function(x) {
			img.redraw();
			bm.bitmapData = img.imageData;
			bm.width = img.width;
			bm.height = img.height;
			bm.x = img.x;
			bm.y = img.y;

			var scaleX:Float = (img.width / img.imageData.width);
			var scaleY:Float = (img.height / img.imageData.height);
			var matrix = new openfl.geom.Matrix();
			matrix.scale(scaleX, scaleY);

			var dummy:BitmapData = new BitmapData(Std.int(img.width), Std.int(img.height), true, 0xFFFFFF);
			dummy.draw(bm, matrix);

			var src = new Rectangle(0, 0, dummy.width, dummy.height).toFlashRectangle();
			var dest = new Point(bm.x, bm.y).toNativePoint();

			screen.copyPixels(dummy, dummy.rect.clone(), dest, null, null, true);
		});
	}

	private inline function set_width(nw:Float):Float {
		width = nw;
		this.sprite.width = nw;
		this.screen = new BitmapData(Std.int(nw), Std.int(height), true, 0xFFFFFF);
		this.screen_wrapper.bitmapData = this.screen;
		screen_wrapper.width = nw;
		screen_wrapper.height = height;

		return nw;
	}

	private inline function set_height(nh:Float):Float {
		height = nh;
		this.sprite.height = nh;
		this.screen = new BitmapData(Std.int(width), Std.int(nh), true, 0xFFFFFF);
		this.screen_wrapper.bitmapData = this.screen;
		screen_wrapper.height = nh;
		screen_wrapper.width = width;

		return nh;
	}

	private inline function get_rect():Rectangle {
		return new Rectangle(0, 0, this.width, this.height);
	}

	private inline function set_rect(nrect:Rectangle):Rectangle {
		this.sprite.height = nrect.height;
		this.sprite.width = nrect.width;
		this.screen = new BitmapData(Std.int(nrect.width), Std.int(nrect.height), true, 0xFFFFFF);
		this.screen_wrapper.bitmapData = this.screen;
		screen_wrapper.height = nrect.height;
		screen_wrapper.width = nrect.width;

		return nrect;
	}
}