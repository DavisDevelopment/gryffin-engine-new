package gryffin.utils;

import gryffin.io.Pointer;
import gryffin.utils.Memory;

import haxe.macro.Expr;
import haxe.macro.Context;

class Worker {
	public var _run:Void -> Void;
	public var thread_id:String;
	public var onMessage:Dynamic->Void;

	public function new(task:Void -> Void):Void {
		this._run = task;
		instances.push(this);
	}

	public function run(args:Array<Dynamic>):Void {
		var thred:Thread = Thread.create(_run);
		thred.sendMessage(Thread.current());

		this.thread_id = Memory.uniqueId('thread');
		thred.sendMessage(this.thread_id);

		function stopChecker():Void {}

		stopChecker = Worker.spawnChecker(thread_id, function(packet:Dynamic):Void {
			if (packet.EOP == true && packet.data == null) {
				stopChecker();
			} else {
				if (this.onMessage != null) {
					this.onMessage(packet);
				}
			}
		});
		
		for (i in 0...args.length) {
			thred.sendMessage(args[i]);
		}
	}

	public static macro function create(tsk:Expr):ExprOf<Worker> {
		var minArgC:Expr;
		var maxArgC:Expr;
		var taskexpr = tsk.expr;
		switch (taskexpr) {
			case ExprDef.EFunction(name, f):
				var min:Int = 0;
				var max:Int = 0;
				for (arg in f.args) {
					if (arg.opt) {
						max++;
					} else {
						min++;
						max++;
					}

				}
				min -= 2;
				max -= 2;
				minArgC = (Context.makeExpr(min, Context.currentPos()));
				maxArgC = (Context.makeExpr(max, Context.currentPos()));

			default:
				throw 'Invalid worker task $tsk';
		}
		return macro new Worker(function():Void {
			var Thread = gryffin.utils.Worker.Thread;
			var self:Thread = Thread.current();
			var creator:Thread = Thread.readMessage(true);
			var thread_id:String = Thread.readMessage(true);

			var argc:Array<Int> = [$minArgC, $maxArgC];
			trace(argc);
			var args:Array<Dynamic> = new Array();

			for (i in 0...argc[1]) {
				trace('reading argument '+i);
				args.push(Thread.readMessage((i <= argc[0]-1)));
				trace('got argument '+i);
			}

			//- Wait for last arg
			//var lastArg:Pointer<Dynamic> = Pointer.literal(Thread.readMessage(false));

			var returns:Array<Dynamic> = new Array();
			var exit = function(?code:Int = 0) {
				creator.sendMessage({
					'thread': thread_id,
					
					//End-Of-Process
					'EOP': true 
				});
			};

			var postMessage = function(data:Dynamic):Void {
				creator.sendMessage({
					'thread': thread_id,
					'data': data
				});
			};

			var defaultArgs:Array<Dynamic> = [exit, postMessage];
			args = (defaultArgs).concat(args);

			Reflect.callMethod(null, ($tsk), args);

		});
	}

#if !macro
	private static function spawnChecker(thread_id:String, on_message:Dynamic->Void):Void->Void {
		var is_active:Bool = true;
		var queued_message:Pointer<Null<Dynamic>> = Pointer.literal(Thread.readMessage(false));


		function check():Void {
			var msg:Null<Dynamic> = queued_message;
			if (msg != null && msg.thread == thread_id) {
				if (is_active) on_message(msg);
			}

			if (is_active) {
				motion.Actuate.timer(0.0001).onComplete(check, []);
			}
		}
		motion.Actuate.timer(0.0001).onComplete(check, []);
		return function():Void {
			is_active = false;
		};
	}
#else
	private static function spawnChecker(thread_id:String, on_message:Dynamic->Void):Void->Void {
		return function() {};
	}
#end

	private static var instances:Array<Worker> = {
		new Array();
	};
}

#if cpp
	typedef Thread = cpp.vm.Thread;
#elseif (neko||macro)
	typedef Thread = neko.vm.Thread;
#end