package gryffin.io;

import gryffin.core.Destructible;

class Promise <T> {
	private var result:T;
	private var error:Null<String>;

	private var _waiting:Array<Job<T>>;

	public function new(task:Job<T> -> Void):Void {
		this.error = null;
		this._waiting = new Array();

		start(task);
	}
	public function start(task:Job<T> -> Void):Void {
		task(function(err:Null<String>, result:Null<T>):Void {
			done(err, result);
		});
	}
	private function done(err:Null<String>, result:Null<T>):Void {
		for (waiter in _waiting) {
			waiter(err, result);
		}
	}
	public function then(waiter:Job<T>):Void {
		_waiting.push(waiter);
	}
}

private typedef Job <T> = Null<String> -> Null<T> -> Void;