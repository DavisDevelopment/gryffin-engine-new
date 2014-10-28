package gryffin;

import gryffin.display.Image;
import gryffin.display.Sound;
import gryffin.io.Buffer;

import openfl.display.BitmapData;

class Assets {

	/**
	 * retrieve the asset referenced by [id] as a gryffin Image object
	 */
	public static function getImage(id:String):Image {
		var bmd:BitmapData = NativeAssets.getBitmapData(id);
		var img = new Image(bmd.width, bmd.height, bmd);
		img.redraw();
		return img;
	}

	/**
	 * retrieves the asset referenced by [id] as a gryffin Sound object
	 */
	public static function getSound(id:String):Sound {
		return new Sound(NativeAssets.getSound(id));
	}

	/**
	 * retrieve asset referenced by [id] as a gryffin Buffer object
	 */
	public static function getBytes(id : String):Buffer {
		return Buffer.fromByteArray(NativeAssets.getBytes(id));
	}

}

private typedef NativeAssets = openfl.Assets;
