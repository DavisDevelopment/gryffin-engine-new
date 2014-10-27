package demo;

import gryffin.Stage;
import gryffin.Assets;
import gryffin.display.Surface;
import gryffin.display.Image;
import gryffin.core.Entity;

import demo.Star;

class Stars extends Entity {
	public var image:Image;
	public var starCount:Int;
	public var stars:Array<Star>;

	public function new(count:Int):Void {
		super();

		this.starCount = count;
		this.stars = new Array();
		this.x = 0;
		this.y = 0;

		this.z = -2;

		this.on('activate', this.init.bind(_));
	}
	public function init(event:Dynamic):Void {
		makeStars();
		this.image = new Image(Std.int(this.width), Std.int(this.height));
		this.image.width = stage.width;
		this.image.height = stage.height;
		this.stage.surface.addImage(this.image);

		image.getContext().drawRect([0, 0, width, height], 0xFF0000);
	}
	public function makeStar():Void {
		var star:Star = new Star(this.stage);
		star.on('destroy', function(e) {
			stars.remove(star);
			makeStar();
		});
		stars.push(star);
	}
	public function makeStars():Void {
		for (i in 0...this.starCount) {
			makeStar();
		}
	}

	override public function update(stage:Stage):Void {
		for (star in stars) {
			star.move();
		}
	}

	override public function render(stage:Stage):Void {
		var img:Image = this.image;
		var c = img.getContext();

		// for (star in stars) {
			// c.drawRect([star.x, star.y, 2, 2], 0xFFFFFF);
		// }
// 
		// img.redraw();
	}
}