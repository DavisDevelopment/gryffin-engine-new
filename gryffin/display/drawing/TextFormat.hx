package gryffin.display.drawing;

import gryffin.io.Pointer;
import gryffin.utils.Object;

class TextFormat {
	public var font:String;
	public var size:Float;
	public var color:Int;
	public var align:String;
	public var bold:Bool;
	public var italic:Bool;
	public var underline:Bool;
	public var lineSpacing:Float;
	public var letterSpacing:Float;
	public var leftMargin:Float;
	public var rightMargin:Float;

	public function new():Void {
		font = 'Arial';
		size = 12;
		color = 0x000000;
		align = 'left';
		bold = false;
		italic = false;
		underline = false;
		lineSpacing = 0;
		letterSpacing = 0;
		leftMargin = 0;
		rightMargin = 0;
	}

	public function point():Pointer<TextFormat> {
		return Pointer.getter(function() return this);
	}

	public function clone():TextFormat {
		var copy:TextFormat = new TextFormat();
		var ocopy:Object = new Object(copy);
		ocopy.merge(cast this);
		return copy;
	}

	public function toNativeTextFormat():openfl.text.TextFormat {
		var tf:openfl.text.TextFormat = new openfl.text.TextFormat(font, size, color, bold, italic, underline);
		// tf.font = this.font;
		// tf.size = this.size;
		// tf.color = this.color;
		tf.align = (function() {
			return switch (align.toLowerCase()) {
				case 'left': openfl.text.TextFormatAlign.LEFT;
				case 'right': openfl.text.TextFormatAlign.RIGHT;
				case 'center': openfl.text.TextFormatAlign.CENTER;
				case 'justify': openfl.text.TextFormatAlign.JUSTIFY;
				default: openfl.text.TextFormatAlign.LEFT;
			}
		}());
		// tf.bold = this.bold;
		// tf.italic = this.italic;
		// tf.underline = this.underline;
		tf.leading = this.lineSpacing;
		tf.letterSpacing = this.letterSpacing;
		tf.leftMargin = this.leftMargin;
		tf.rightMargin = this.rightMargin;

		return tf;
	}
}