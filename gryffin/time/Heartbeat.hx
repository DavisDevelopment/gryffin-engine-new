package gryffin.time;

import motion.Actuate;

class Heartbeat {
	public static var per_tick:Array<Void->Void> = {new Array();};

	public static function tick(func:Void -> Void):Void {
		per_tick.push(func);
	}

	public static function start():Void {
		function invokeAll():Void {
			for (func in per_tick) {
				func();
			}
			Actuate.timer(0.002).onComplete(invokeAll);
		}
		Actuate.timer(0.002).onComplete(invokeAll);
	}
}