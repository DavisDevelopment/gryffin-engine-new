package demo;

import gryffin.Stage;
import gryffin.Assets;
import gryffin.display.Surface;
import gryffin.display.Image;
import gryffin.core.Entity;
import gryffin.geom.Rectangle;
import gryffin.geom.Point;

class Laser extends Entity {
	public var image:Image;
	public var speed:Float;

	public function new(origin:Point):Void {
		super();
		this.x = origin.x;
		this.y = origin.y;
		this.width = 15;
		this.height = 15;
	}
}