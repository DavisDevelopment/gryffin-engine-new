package gryffin.events;

import gryffin.events.EventType;
import gryffin.events.GEvent;
import gryffin.geom.Rectangle;

import openfl.events.Event;

class GResizeEvent extends GEvent {
	public var from:Rectangle;
	public var to:Rectangle;

	public function new(from:Rectangle, to:Rectangle, orig:Event):Void {
		super(EventType.ResizeEvent, orig);
		this.from = from;
		this.to = to;
	}
}