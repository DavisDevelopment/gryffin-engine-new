package gryffin.display;

import gryffin.Stage;
import gryffin.core.Entity;
import gryffin.io.Pointer;
import gryffin.display.drawing.DrawCommand;
import gryffin.display.drawing.DrawContext;
import gryffin.display.drawing.TextFormat;
import gryffin.display.drawing.DrawProgram;
import gryffin.display.Label;

private typedef Sprite = openfl.display.Sprite;
private typedef Graphics = openfl.display.Graphics;
private typedef DisplayObject = openfl.display.DisplayObject;

class Canvas {
	public var parent:Null<gryffin.Stage>;
	public var owner:Null<Entity>;
	public var assets:Array<DisplayObject>;
	public var sprite:Sprite;
	public var program:DrawProgram;
	public var currentState:DrawContext;
	public var stack:Null<Array<DrawCommand>>;

	//- Computed Properties
	public var width(default, set):Float;
	public var height(default, set):Float;

	public function new():Void {
		this.parent = null;
		this.owner = null;
		this.assets = new Array();
		initSprite();
		this.program = new DrawProgram();
		this.currentState = new DrawContext();
		this.stack = null;
	}
	private function initSprite(?alreadyDone:Bool = false):Void {
		this.sprite = new Sprite();
		if (alreadyDone) {
			parent.pane.addChild(this.sprite);
		}
	}
	private function state():Pointer<DrawContext> {
		var clone:DrawContext = currentState.clone();
		return Pointer.getter(function() return clone);
	}
	private inline function call(field:String, args:Array<Dynamic>):Void {
		if (stack != null)
			stack.push(DrawCommand.DBoundCall(field, args, state()));
	}
	private inline function invoke(func:Dynamic, args:Array<Dynamic>):Void {
		if (stack != null)
			stack.push(DrawCommand.DCall(func, args, state()));
	}
	//- Path Handling Methods
	public function beginPath():Void {
		stack = new Array();
	}
	public function closePath():Void {
		var command:DrawCommand = DrawCommand.DCommandSequence(stack, state());
		program.push(command);
		stack = null;
	}
	public function reset():Void {
		sprite.graphics.clear();
		program.restart();
		initSprite(true);
	}

	//- Path Creation Methods
	
	public function moveTo(x:Float, y:Float):Void {
	    var args:Array<Dynamic> = [x, y];
	    call("moveTo", args);
	}

	public function lineTo(x:Float, y:Float):Void {
	    var args:Array<Dynamic> = [x, y];
	    call("lineTo", args);
	}

	public function circle(x:Float, y:Float, radius:Float):Void {
	    var args:Array<Dynamic> = [x, y, radius];
	    call("drawCircle", args);
	}

	public function ellipse(x:Float, y:Float, width:Float, height:Float):Void {
	    var args:Array<Dynamic> = [x, y, width, height];
	    call("drawEllipse", args);
	}

	public function rect(x:Float, y:Float, width:Float, height:Float):Void {
	    var args:Array<Dynamic> = [x, y, width, height];
	    trace(args);
	    call("drawRect", args);
	}

	public function roundRect(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Float):Void {
	    var args:Array<Dynamic> = [x, y, width, height, ellipseWidth, ellipseHeight];
	    call("drawRoundRect", args);
	}

	public function label(text:String, x:Float, y:Float, ?ptr:Pointer<Null<Label>>):Pointer<Null<Label>> {
		var lab:Null<Label> = null;
		if (ptr == null)
			ptr = Pointer.getter(function() return lab);

		function addLabel(pctx:Pointer<DrawContext>):Void {
			if (ptr.get() == null) {
				var ctx:DrawContext = pctx.get();
				var labl = new Label();
				lab = labl;
				labl.text = text;
				labl.canvas = this;
				labl.settings = ctx;
				labl.reconfig();
			}

			if (ptr.get() != null && !sprite.contains(ptr.get())) {
				sprite.addChild(ptr.get());
			}
		}
		invoke(addLabel, [state()]);
		return ptr;
	}

	//- End Path Creation Methods
	
	public function paint():Void {
		sprite.graphics.clear();
		if (owner != null) {
			sprite.x = owner.x;
			sprite.y = owner.y;
		}
		program.execute(sprite);
	}

	public function bind(movie:Stage):Void {
		movie.pane.addChild(this.sprite);
		this.parent = movie;
	}

	public function claim(owner:Entity):Void {
		this.owner = owner;
	}

	public function destroy():Void {
		if (parent != null) {
			parent.pane.removeChild(this.sprite);
		}
		this.sprite.removeChildren(0, this.sprite.numChildren);
	}

	private function set_width(nw:Float):Float {
		sprite.width = nw;
		width = nw;
		return nw;
	}
	private function set_height(nh:Float):Float {
		sprite.height = nh;
		height = nh;
		return nh;
	}

	//- Context-Bound Fields
	public var fillStyle(get, set):Int;

	//- [fillStyle] Getter Method
	private inline function get_fillStyle():Int {
	    return currentState.fillStyle;
	}

	//- [fillStyle] Setter Method
	private inline function set_fillStyle(nv:Int):Int {
	    currentState.fillStyle = nv;
	    return nv;
	}


	public var strokeStyle(get, set):Int;

	//- [strokeStyle] Getter Method
	private inline function get_strokeStyle():Int {
	    return currentState.strokeStyle;
	}

	//- [strokeStyle] Setter Method
	private inline function set_strokeStyle(nv:Int):Int {
	    currentState.strokeStyle = nv;
	    return nv;
	}


	public var textStyle(get, set):TextFormat;

	//- [textStyle] Getter Method
	private inline function get_textStyle():TextFormat {
		return currentState.textStyle;
	}

	//- [textStyle] Setter Method
	private inline function set_textStyle(nv:TextFormat):TextFormat {
		currentState.textStyle = nv;
		return nv;
	}


	public var lineWidth(get, set):Float;

	//- [lineWidth] Getter Method
	private inline function get_lineWidth():Float {
	    return currentState.lineWidth;
	}

	//- [lineWidth] Setter Method
	private inline function set_lineWidth(nv:Float):Float {
	    currentState.lineWidth = nv;
	    return nv;
	}


	public var lineCap(get, set):Int;

	//- [lineCap] Getter Method
	private inline function get_lineCap():Int {
	    return currentState.lineCap;
	}

	//- [lineCap] Setter Method
	private inline function set_lineCap(nv:Int):Int {
	    currentState.lineCap = nv;
	    return nv;
	}


	public var lineJoin(get, set):Int;

	//- [lineJoin] Getter Method
	private inline function get_lineJoin():Int {
	    return currentState.lineJoin;
	}

	//- [lineJoin] Setter Method
	private inline function set_lineJoin(nv:Int):Int {
	    currentState.lineJoin = nv;
	    return nv;
	}


	public var alpha(get, set):Float;

	//- [alpha] Getter Method
	private inline function get_alpha():Float {
	    return currentState.alpha;
	}

	//- [alpha] Setter Method
	private inline function set_alpha(nv:Float):Float {
	    currentState.alpha = nv;
	    return nv;
	}


	public var scaleX(get, set):Float;

	//- [scaleX] Getter Method
	private inline function get_scaleX():Float {
	    return currentState.scaleX;
	}

	//- [scaleX] Setter Method
	private inline function set_scaleX(nv:Float):Float {
	    currentState.scaleX = nv;
	    return nv;
	}


	public var scaleY(get, set):Float;

	//- [scaleY] Getter Method
	private inline function get_scaleY():Float {
	    return currentState.scaleY;
	}

	//- [scaleY] Setter Method
	private inline function set_scaleY(nv:Float):Float {
	    currentState.scaleY = nv;
	    return nv;
	}
}