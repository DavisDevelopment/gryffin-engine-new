package demo;

import gryffin.Stage;
import gryffin.Assets;
import gryffin.core.Entity;
import gryffin.display.Surface;
import gryffin.display.Image;
import gryffin.geom.Rectangle;
import gryffin.geom.Point;

import gryffin.io.Pointer;

class HUDBar extends Entity {
	public var image:Image;
	public var value:Pointer<Float>;
	public var color:Int;

	public function new (ptr:Pointer<Float>, color:Int):Void {
		super();
		this.value = ptr;
		this.color = color;

		this.width = 100;
		this.height = 35;

		this.on('activate', this.init.bind(_));
	}
	public function init(event:Dynamic):Void {
		this.image = new Image(100, 35);
		this.on('update', function(e:Dynamic):Void {
			image.x = this.x;
			image.y = this.y;
			image.height = this.height;
			image.width = this.width;
		});
		stage.surface.addImage(image);
	}
	override public function update(stage : Stage):Void {
		image.redraw();
		image.imageData.fillRect(Rectangle.fromArray([0, 0, 100, 35]).toFlashRectangle(), this.color);
	}
}