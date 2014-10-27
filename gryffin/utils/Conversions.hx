package gryffin.utils;

import openfl.utils.ByteArray;
import haxe.io.Bytes;

class Conversions {
	public static function ByteArrayToBytes(bits:ByteArray):Bytes {
		var bytes:Bytes = Bytes.alloc(bits.length);
		bits.position = 0;

		while (bits.bytesAvailable > 0) {
			var pos:Int = bits.position;
			bytes.set(pos, bits.readByte());
		}

		return bytes;
	}
}