package gryffin.events;

import gryffin.events.EventType;

import openfl.events.Event;

class GEvent {
	public var type:EventType;
	public var data:Dynamic;
	public var originalEvent:Event;

	public var isDefaultPrevented:Bool;
	public var isDefaultDeferred:Bool;

	private var deferers:Array<Void->Void>;

	public function new(typ:EventType, orig:Event):Void {
		this.type = typ;
		this.originalEvent = orig;
		this.data = {};
		this.deferers = new Array();
	}

	public function preventDefault():Void {
		this.isDefaultPrevented = true;
	}

	public function defer(waitFor:Void->Void):Void {
		this.isDefaultDeferred = true;
		this.deferers.push(waitFor);
	}

	public function fire(finalTask:Void->Void):Void {
		if (!isDefaultPrevented) {
			if (isDefaultDeferred) {
				for (waitFor in deferers) {
					waitFor();
				}
			}
			finalTask();
		}
	}
}