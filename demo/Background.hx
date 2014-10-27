package demo;

import gryffin.Stage;
import gryffin.Assets;
import gryffin.display.Surface;
import gryffin.display.Image;
import gryffin.core.Entity;

import gryffin.math.GMath;
import gryffin.math.Random;
import gryffin.geom.Rectangle;
import gryffin.geom.Point;
import gryffin.io.LocalStorage;

class Background extends Entity {
	public var image:Image;

	public function new():Void {
		super();
		this.image = Assets.getImage('sprites/background_1.png');
		this.x = 0;
		this.y = 0;

		this.on('activate', this.init.bind(_));
	}
	public function init(e:Dynamic):Void {
		this.width = this.stage.width;
		this.height = this.stage.height;

		this.stage.surface.addImage(this.image);

		if (LocalStorage.get('name') == null) {
			LocalStorage.set('name', 'Ryan Davis');
		} else {
			trace(LocalStorage.get('name'));
		}
	}
	override public function update(stage:Stage):Void {
		super.update(stage);

		this.z = GMath.smallest(stage.get('*'), function(ent) {
			return (ent.z);
		});


		this.image.width = this.stage.width;
		this.image.height = this.stage.height;
		this.image.redraw();

	}
}