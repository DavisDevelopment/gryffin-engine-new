package gryffin.core;

import gryffin.Stage;
import gryffin.io.SelectorString;
import gryffin.core.Entity;
import gryffin.core.Destructible;
import gryffin.core.Selectable;
import gryffin.core.Filterable;
#if macro
	import haxe.macro.Expr;
	import haxe.macro.Context;
#end

class Selection implements Destructible implements Selectable implements Filterable {
	public var stage(get, never):Null<Stage>;
	public var length(get, never):Int;
	public var entities:Array<Entity>;

	public function new(sel : String, ?ctx:Selectable):Void {
		var context:Selectable = (ctx != null ? ctx : this.stage);
		this.entities = (context.filter(sel));
	}

	public function iterator():Iterator<Entity> {
		return entities.iterator();
	}
	public function toArray():Array<Entity> {
		return entities.copy();
	}

	public function destroy():Void {
		for (ent in entities) ent.destroy();
	}

	public function hide():Void {
		for (ent in entities) ent.hide();
	}

	public function show():Void {
		for (ent in entities) ent.show();
	}

	public function cache():Void {
		for (ent in entities) ent.cache();
	}

	public function uncache():Void {
		for (ent in entities) ent.uncache();
	}

	public function filter(sel : String):Array<Entity> {
		return this.entities.filter(gryffin.ore.ObjectRegEx.getFunc(sel));
	}

	public function get(sel : String):Selection {
		return new Selection(sel, this);
	}

	public function on(channel:String, callback:Dynamic, ?once:Bool):Void {
		for (ent in entities) {
			ent.on(channel, callback, once);
		}
	}

	public function emit(channel:String, data:Dynamic):Void {
		for (ent in entities) {
			ent.emit(channel, data);
		}
	}

	private inline function get_stage():Null<Stage> {
		return Stage.getActiveStage();
	}
	private inline function get_length():Int {
		return this.entities.length;
	}
}