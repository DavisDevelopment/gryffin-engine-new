package demo;

import gryffin.Stage;
import gryffin.Assets;
import gryffin.display.Surface;
import gryffin.core.Entity;
import gryffin.display.Image;
import gryffin.display.Sound;
import gryffin.geom.Point;
import gryffin.geom.Rectangle;
import gryffin.math.Random;
import gryffin.events.GMouseEvent;
import gryffin.events.GKeyboardEvent;

import demo.KeyMap;

class Ship extends Entity {
	public var sounds:Array<Sound>;
	public var random:Random;
	public var timescale:Float;
	public var speed:Float;
	public var texture:Image;
	public var health:Float;
	public var keys:KeyMap;

	public function new():Void {
		super();

		this.width = 50;
		this.height = 50;
		this.speed = 5;
		this.timescale = 1.0;
		this.health = 100;
		this.keys = new KeyMap();
		this.random = new Random();
		this.sounds = [for (id in [
			'sounds/laser0.wav',
			'sounds/laser1.wav',
			'sounds/laser2.wav',
			'sounds/laser3.wav'
		]) Assets.getSound(id)];

		this.on('activate', init.bind(_));
	}
	public function init(e:Dynamic):Void {
		
		this.texture = Assets.getImage('sprites/ship-human.png');
		this.stage.surface.addImage(this.texture);
		this.addAsset(this.texture);

		stage.on('key-down', function(event:GKeyboardEvent):Void {
			keys[event.key] = event;
			trace(event);
		});
		stage.on('key-up', function(event:GKeyboardEvent):Void {
			keys[event.key] = event;
			trace(event);
		});

		this.on('update', function(e) {
			this.x = (stage.width / 2 - this.width / 2);
			this.y = (stage.height - 70);
		}, true);
	}

	override public function update(stage:Stage):Void {
		super.update(stage);

		handleMovement();
		handleCollisions();

		this.texture.x = this.x;
		this.texture.y = this.y;
		this.texture.width = this.width;
		this.texture.height = this.height;
	}

	public function handleMovement():Void {
		//- Right Movement
		if (keys.exists('d')) {
			this.x += (keys['d'].shift ? this.speed : (this.speed * 1.5));
		}

		//- Left Movement
		if (keys.exists('a')) {
			this.x -= (keys['a'].shift ? this.speed : (this.speed * 1.5));
		}

		//- Fire Lasers
		if (keys.exists(32)) {
			this.fire();
			keys.remove(32);
		}
	}

	public function handleCollisions():Void {
		if (this.x + this.width > stage.width) {
			this.x = (stage.width - this.width);
		}
		else if (this.x < 0) {
			this.x = 0;
		}

	}

	public function fire():Void {
		try {
			(random.choice(this.sounds)).play();
		} catch (err : String) {
			trace(err);
		}
	}
}