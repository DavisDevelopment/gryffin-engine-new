package gryffin.display;

import gryffin.display.Image;
import openfl.display.BitmapData;
import gryffin.display.ImageDrawingContext;
import gryffin.display.ImageDrawingOperation;

import gryffin.io.Pointer;
import gryffin.geom.Point;
import gryffin.geom.Rectangle;

private typedef EDraw = ImageDrawingOperation.EDraw;

class ImageDrawingProgram {
	public var owner:Pointer<Image>;
	public var o(get, never):Image;
	public var operations:Array<ImageDrawingOperation>;
	public var aliases:Map<String, String>;

	public function new(ownr:Pointer<Image>):Void {
		this.owner = ownr;
		this.operations = new Array();
		this.aliases = [
			"set_pixel" => "DSetPixel"
		];
	}

	public function setPixel(pt:Point, color:Int):Void {
		var mypoint:Point = new Point((pt.x/o.width), (pt.y/o.height));
		this.operations.push(new ImageDrawingOperation(EDraw.DSetPixel(mypoint, color)));
	}

	public function drawRect(rect:Rectangle, color:Int):Void {
		var myrect:Rectangle = new Rectangle((rect.x/o.width), (rect.y/o.height), (rect.width/o.width), (rect.height/o.height));
		this.operations.push(new ImageDrawingOperation(EDraw.DDrawRect(myrect, color)));
	}

	public function drawImage(img:BitmapData, sx:Float, sy:Float, sw:Float, sh:Float, ?dx:Float, ?dy:Float, ?dw:Float, ?dh:Float):Void {
		this.operations.push(
			new ImageDrawingOperation(EDraw.DDrawImage(img, sx, sy, sw, sh, dx, dy, dw, dh))
		);
	}

	public function execute(ctx : ImageDrawingContext):Void {
		for (op in operations) {
			op.perform(ctx.sprite.graphics, ctx.data, ctx.sprite);
		}
	}

	private inline function get_o():Image {
		return owner.get();
	}
	
	public static inline var SET_PIXEL:Int = 0;
}