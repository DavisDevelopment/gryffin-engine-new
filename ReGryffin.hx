package ;

import motion.Actuate;
//import openfl.display.Stage;
import openfl.display.Sprite;

import gryffin.Stage;
import gryffin.display.Canvas;
import gryffin.core.Entity;
import gryffin.io.ByteArray;
import gryffin.io.Pointer;

import gryffin.oreql.Lexer;
import gryffin.display.Image;

import demo.Ship;
import demo.Background;

class ReGryffin extends Sprite {
	public var movie:Stage;
	public function new():Void {
		super();
		this.movie = new Stage(this);
		this.width = stage.stageWidth;
		this.height = stage.stageHeight;
		init();
	}
	public function init():Void {

		var bg:Background = new Background();
		movie.add(bg);

		var ship:Ship = new Ship();
		movie.add(ship);

		ship.x = 200;
		ship.y = 200;

		trace(
			movie.get('..Entity[x][y][z=0]').length
		);

		trace(stage.stageWidth, stage.stageHeight);


		startHeart();
	}
	public function query(qstr:String) {
		var lexr = new Lexer(qstr);
		var tokens = lexr.lex();
		trace(tokens);
		var parsr = new gryffin.oreql.Parser();

		return parsr.parse(tokens);
	}
	public function frame():Void {
		movie.update();
		movie.render();
	}
	public function startHeart():Void {
		function tick():Void {
			frame();
			Actuate.timer(FRAME_DELAY).onComplete(tick, null);
		}
		Actuate.timer(FRAME_DELAY).onComplete(tick, null);
	}

	public static inline var FRAME_DELAY:Float = 0.02;
}
