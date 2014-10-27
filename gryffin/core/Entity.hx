package gryffin.core;

import gryffin.core.EventDispatcher;
import gryffin.display.Canvas;
import gryffin.utils.Memory;
import gryffin.Stage;
import gryffin.io.SelectorString;
import gryffin.geom.Point;
import gryffin.core.Destructible;

class Entity extends EventDispatcher implements Destructible {
	//- Public Properties
	public var id:String;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var width:Float;
	public var height:Float;

	public var willNotRedraw:Bool;
	public var isCurrentlyCached:Bool;
	public var _assets:Array<Destructible>;

	//- Computed Properties
	public var stage(get, never):Null<Stage>;
	public var point(get, set):Point;

	public function new():Void {
		super();
		var cn:String = Type.getClassName(Type.getClass(this));
		cn = (cn.substring(cn.lastIndexOf('.')+1));
		this.id = Memory.uniqueId(cn);

		this.x = 0;
		this.y = 0;
		this.z = 0;
		this.width = 0;
		this.height = 0;

		this.willNotRedraw = false;
		this.isCurrentlyCached = false;
		this._assets = new Array();

		super.on('activate', this.__initialize.bind(_));
	}
	private function __initialize(x:Dynamic):Void {

	}

	public function is(sel : SelectorString):Bool {
		var predicate:Entity -> Bool = cast sel;
		return predicate(this);
	}

	public function addAsset(asset:Destructible):Void {
		this._assets.push(asset);
	}

	public function render(stage:Stage):Void {
		super.emit('render', stage);
	}

	public function update(stage:Stage):Void {
		super.emit('update', stage);
	}

	public function hide():Void {
		this.willNotRedraw = true;
	}

	public function show():Void {
		this.willNotRedraw = false;
	}

	public function cache():Void {
		this.isCurrentlyCached = true;
	}

	public function uncache():Void {
		this.isCurrentlyCached = false;
	}

	public function destroy():Void {
		for (asset in _assets) {
			asset.destroy();
		}
		super.emit('destroy', null);
	}

/*
 * == Computed Properties ==
 */
	private inline function get_stage():Null<Stage> {
		return Stage.getContainingStage(this);
	}

	private inline function get_point():Point {
		return new Point(this.x, this.y, this.z);
	}

	private inline function set_point(npoint:Point):Point {
		this.x = npoint.x;
		this.y = npoint.y;
		this.z = npoint.z;
		return this.point;
	}
}