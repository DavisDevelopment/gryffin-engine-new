package gryffin;

import gryffin.display.Image;
import gryffin.display.Sound;

import openfl.display.BitmapData;

class Assets {
	public static function getImage(id:String):Image {
		var bmd:BitmapData = NativeAssets.getBitmapData(id);
		var img = new Image(bmd.width, bmd.height, bmd);
		img.redraw();
		return img;
	}
	public static function getSound(id:String):Sound {
		return new Sound(NativeAssets.getSound(id));
	}
}

private typedef NativeAssets = openfl.Assets;