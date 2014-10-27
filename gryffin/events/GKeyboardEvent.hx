package gryffin.events;

import gryffin.events.EventType;
import gryffin.events.GEvent;
import gryffin.io.Byte;

private typedef KE = openfl.events.KeyboardEvent;

class GKeyboardEvent extends GEvent {
	public var up:Bool;
	public var key:Byte;
	public var altKey:Bool;
	public var ctrlKey:Bool;
	public var shiftKey:Bool;

	public function new (orig:KE):Void {
		super(EventType.KeyboardEvent(orig.type == KE.KEY_UP), orig);

		var isUp:Bool = (orig.type == KE.KEY_UP);

		this.up = isUp;
		this.key = Byte.fromInt(orig.charCode);
		this.altKey = orig.altKey;
		this.ctrlKey = orig.ctrlKey;
		this.shiftKey = orig.shiftKey;
	}
}