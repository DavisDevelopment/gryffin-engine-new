package demo;

import gryffin.Stage;
import gryffin.math.Random;
import gryffin.display.Image;
import gryffin.utils.Memory;
import gryffin.geom.Point;
import gryffin.geom.Rectangle;

import gryffin.core.EventDispatcher;
import gryffin.core.Destructible;

class Star extends EventDispatcher implements Destructible {
	public var stage:Stage;
	public var id:String;
	public var x:Float;
	public var y:Float;
	public var speed:Float;

	public function new(stage:Stage):Void {
		super();
		this.stage = stage;
		this.id = Memory.uniqueId('star-');
		var random:Random = Random.stringSeed(this.id);
		this.y = -10;
		this.x = random.randint(0, Std.int(stage.width));
		this.speed = random.randint(6, 18);
	}
	public function move():Void {
		this.y += this.speed;

		if (this.y > stage.height) {
			this.destroy();
		}
	}
	public function destroy():Void {
		this.emit('destroy', null);
	}
}