package gryffin.display.drawing;

import gryffin.display.drawing.DrawContext;
import gryffin.io.Pointer;

enum DrawCommand {
	DCall(func:Dynamic, args:Array<Dynamic>, ctx:Pointer<DrawContext>);
	DBoundCall(func:String, args:Array<Dynamic>, ctx:Pointer<DrawContext>);
	DFieldSet(obj:Dynamic, field:String, newValue:Dynamic, ctx:Pointer<DrawContext>);
	DCommandSequence(sequence:Array<DrawCommand>, ctx:Pointer<DrawContext>);
}