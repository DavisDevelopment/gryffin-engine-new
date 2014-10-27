package gryffin.events;

import gryffin.events.GEvent;
import gryffin.events.EventType;
import gryffin.geom.Point;

import openfl.events.MouseEvent;

class GMouseEvent extends GEvent {
	public var position:Point;

	public function new(orig:MouseEvent):Void {
		super(EventType.MouseEvent, orig);
		
		this.position = new Point(orig.stageX, orig.stageY, 0);
	}
}