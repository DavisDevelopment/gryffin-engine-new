package gryffin.display;

import gryffin.core.EventDispatcher;

private typedef NativeSound = openfl.media.Sound;

class Sound extends EventDispatcher {
	private var component:NativeSound;
	private var playing:Bool;

	public var volume:Float;

	public function new(ns:NativeSound):Void {
		super(); 

		this.component = ns;
		this.playing = false;
		this.volume = 100;
	}
	public function play():Void {
		this.component.play(0, 0, new openfl.media.SoundTransform((100 / this.volume)));
	}
}