package gryffin;

import openfl.display.Sprite;
import gryffin.core.EventDispatcher;
import gryffin.core.Entity;
import gryffin.io.SelectorString;
import gryffin.core.Selection;
import gryffin.display.Surface;

import gryffin.core.Selectable;
import gryffin.core.Filterable;

class Stage extends EventDispatcher implements Filterable implements Selectable {
	//- Public Properties
	public var window:Sprite;
	public var pane:Sprite;
	public var childNodes:Array<Entity>;
	public var surface:Surface;

	//- Computed Properties
	public var width(get, never):Float;
	public var height(get, never):Float;

	public function new(win : Sprite):Void {
		super();
		this.window = win;
		this.pane = new Sprite();
		this.childNodes = new Array();
		window.addChild(pane);

		pane.width = window.stage.stageWidth;
		pane.height = window.stage.stageHeight;

		init();
	}
	private function get_width():Float {
		return window.stage.stageWidth;
	}
	private function get_height():Float {
		return window.stage.stageHeight;
	}
	private function init():Void {
		instances.push(this);
		this.surface = new Surface(this);

		gryffin.time.Heartbeat.start();
		initEvents();

		for (obj in needInitting) {
			try {
				obj.init();
			} catch (err : String) {
				trace(err);
			}
		}

		gryffin.io.LocalStorage.init();
	}
	public function add(ent : Entity):Void {
		var alreadyHad:Bool = (containsEntity(ent));
		childNodes.push(ent);
		if (!alreadyHad) {
			ent.emit('activate', this);
		}
	}

	public function update():Void {
		pane.graphics.clear();

		pane.width = this.width;
		pane.height = this.height;

		haxe.ds.ArraySort.sort(this.childNodes, function ( x:Entity, y:Entity ):Int {
			return (Std.int(x.z) - Std.int(y.z));
		});

		for (child in childNodes) {
			if (!child.isCurrentlyCached) {
				child.update(this);
			}
		}
	}

	public function render():Void {
		surface.reset();
		for (child in childNodes) {
			if (!child.willNotRedraw) {
				child.render(this);
			}
		}
		surface.render();
	}

	public function filter(sel : String):Array<Entity> {

		var ff:Entity->Bool = gryffin.ore.ObjectRegEx.getFunc(gryffin.io.ByteArray.fromString(sel));
		return childNodes.filter(ff);
	}

	public function get(sel : String):Selection {
		return new Selection(sel);
	}

	private function initEvents():Void {
		function fireMouseEvent(type:String, me:openfl.events.MouseEvent):Void {
			var ge:gryffin.events.GMouseEvent = new gryffin.events.GMouseEvent(me);
			this.emit(type, ge);
			ge.fire(function() {

			});
		}
		this.window.addEventListener(openfl.events.MouseEvent.CLICK, fireMouseEvent.bind('click', _));
		this.window.addEventListener(openfl.events.MouseEvent.RIGHT_CLICK, fireMouseEvent.bind('right-click', _));
		this.window.addEventListener(openfl.events.MouseEvent.MOUSE_MOVE, fireMouseEvent.bind('mouse-move', _));

		this.window.addEventListener(openfl.events.Event.RESIZE, function(ev:openfl.events.Event):Void {
			var from = new gryffin.geom.Rectangle(0, 0, pane.width, pane.height);
			var to = new gryffin.geom.Rectangle(0, 0, this.width, this.height);
			var ge:gryffin.events.GResizeEvent = new gryffin.events.GResizeEvent(from, to, ev);
			this.emit('resize', ge);

			ge.fire(function():Void {
				trace(from, to);
			});
		});

		function fireKeyboardEvent(type:String, event:openfl.events.KeyboardEvent):Void {
			var ge:gryffin.events.GKeyboardEvent = new gryffin.events.GKeyboardEvent(event);

			this.emit(type, ge);

			ge.fire(function():Void {
				trace(ge);
			});
		}

		this.window.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, fireKeyboardEvent.bind('key-up', _));
		this.window.stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, fireKeyboardEvent.bind('key-down', _));
	}

	private function containsEntity(ent:Entity):Bool {
		for (child in childNodes) {
			if (child == ent) return true;
		}
		return false;
	}

	public static function getContainingStage(ent : Entity):Null<Stage> {
		for (stage in instances) {
			if (stage.containsEntity(ent)) return stage;
		}
		return null;
	}
	public static function getActiveStage():Null<Stage> {
		return instances[0];
	}
	public static function addInittable(inittable:Dynamic):Void {
		needInitting.push(inittable);
	}
	private static var instances:Array<Stage> = {new Array();};
	private static var needInitting:Array<Dynamic> = {new Array();};

	private static function __init__():Void {
		needInitting = new Array();
	}
}