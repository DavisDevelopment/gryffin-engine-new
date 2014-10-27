package gryffin.display;

import openfl.text.TextField;

import gryffin.display.Canvas;
import gryffin.display.drawing.DrawContext;

class Label extends TextField {
	public var canvas:Null<Canvas>;
	public var settings:Null<DrawContext>;

	public function new():Void {
		super();
		this.type = openfl.text.TextFieldType.DYNAMIC;
		this.canvas = null;
		this.settings = null;
	}
	public function reconfig():Void {
		if (settings != null) {
			this.setTextFormat(settings.textStyle.toNativeTextFormat(), 0, this.text.length);
		}
	}
}