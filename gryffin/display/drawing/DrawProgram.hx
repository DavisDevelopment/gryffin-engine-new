package gryffin.display.drawing;

import openfl.display.Sprite;
import openfl.display.Graphics;

import gryffin.display.drawing.DrawCommand;
import gryffin.display.drawing.DrawContext;

class DrawProgram {
	var operations:Array<DrawCommand>;

	public function new(?ops:Array<DrawCommand>):Void {
		this.operations = (ops != null ? ops : new Array());
	}

	public function push(op:DrawCommand):Void {
		operations.push(op);
	}
	public function pop():Null<DrawCommand> {
		return operations.pop();
	}
	public function unshift(op:DrawCommand):Void {
		operations.unshift(op);
	}
	public function shift():Null<DrawCommand> {
		return operations.shift();
	}
	public function restart():Void {
		operations = new Array();
	}
	private function startAppropriateFill(ctx:DrawContext, g:Graphics, sprite:Sprite):Void {
		g.beginFill(ctx.fillStyle, ctx.alpha);
	}
	private function setLineStyles(ctx:DrawContext, g:Graphics, sprite:Sprite):Void {
		//- Resolve Line-Cap Style
		var lcap:openfl.display.CapsStyle = openfl.display.CapsStyle.NONE;
		if (ctx.lineCap == 1) lcap = openfl.display.CapsStyle.ROUND;
		else if (ctx.lineCap >= 2) lcap = openfl.display.CapsStyle.SQUARE;

		if (ctx.lineWidth == 0) {
			g.lineStyle(0, 0x000000, 0);
		} else {
			g.lineStyle(ctx.lineWidth, ctx.strokeStyle, ctx.alpha, true, null, lcap);
		}
	}
	private function configure(ctx:DrawContext, g:Graphics, sprite:Sprite):Void {
		sprite.scaleX = ctx.scaleX;
		sprite.scaleY = ctx.scaleY;
	}
	public function perform(op:DrawCommand, g:Graphics, sprite:Sprite):Void {
		switch (op) {
			case DrawCommand.DCommandSequence(commands, ctx):
				startAppropriateFill(ctx.get(), g, sprite);
				for (comm in commands) {
					perform(comm, g, sprite);
				}
				g.endFill();

			case DrawCommand.DBoundCall(field, args, ctx):
				try {
					configure(ctx.get(), g, sprite);
					setLineStyles(ctx.get(), g, sprite);
					Reflect.callMethod(g, Reflect.getProperty(g, field), args);
				} catch (err : String) {
					trace(err);
				}

			case DrawCommand.DCall(func, args, ctx):
				try {
					configure(ctx.get(), g, sprite);
					setLineStyles(ctx.get(), g, sprite);
					Reflect.callMethod(null, func, args);
				} catch (err : String) {
					trace(err);
				}

			case DrawCommand.DFieldSet(obj, field, newValue, ctx):
				try {
					configure(ctx.get(), g, sprite);
					setLineStyles(ctx.get(), g, sprite);
					Reflect.setProperty(obj, field, newValue);
				} catch (err : String) {
					trace(err);
				}

			default:
				throw op;
		}
	}
	public function execute(context:Sprite):Void {
		var g:Graphics = context.graphics;
		for (op in operations) {
			perform(op, g, context);
		}
	}
}