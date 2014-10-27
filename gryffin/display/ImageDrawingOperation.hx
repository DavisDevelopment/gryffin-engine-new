package gryffin.display;

import gryffin.geom.Point;
import gryffin.geom.Rectangle;

import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.display.BitmapData;

abstract ImageDrawingOperation (EDraw) {
	public inline function new(op : EDraw):Void {
		this = op;
	}

	public inline function perform(g:Graphics, b:BitmapData, sprite:Sprite):Void {
		g.clear();

		switch (this) {
			case EDraw.DSetPixel(pt, color):
				b.setPixel32(i(pt.x * b.width), i(pt.y * b.height), color);

			case EDraw.DDrawRect(rect, color):
				var myrect:Rectangle = [(rect.x * b.width), (rect.y * b.height), (rect.width * b.width), (rect.height * b.height)];
				b.fillRect(myrect.toFlashRectangle(), 0xFF0000);

			case EDraw.DDrawImage(img, sx, sy, sw, sh, dx, dy, dw, dh):
				if (dx == null) dx = 0;
				if (dy == null) dy = 0;
				if (dw == null) dw = b.width;
				if (dh == null) dh = b.height;

				var i:Float->Int = Std.int.bind(_);
				var wrapper:openfl.display.Bitmap = new openfl.display.Bitmap();
				var bitmap:BitmapData = new BitmapData(i(sw), i(sh), true, 0xFFFFFF);
				var src = new Rectangle(sx, sy, sw, sh).toFlashRectangle();
				var dest = new Point(dx, dy).toNativePoint();

				bitmap.copyPixels(img, src, dest);
				wrapper.bitmapData = bitmap;
				wrapper.width = dw;
				wrapper.height = dh;
				wrapper.x = dx;
				wrapper.y = dy;

				b.draw(wrapper);


		}
	}

	private inline function i(f:Float):Int {
		return Std.int(f);
	}
}

enum EDraw {
	DSetPixel(point:Point, color:Int);
	DDrawRect(rect:Rectangle, color:Int);
	DDrawImage(img:BitmapData, sx:Float, sy:Float, sw:Float, sh:Float, ?dx:Float, ?dy:Float, ?dw:Float, ?dh:Float);
}