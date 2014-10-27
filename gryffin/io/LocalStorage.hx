package gryffin.io;

import gryffin.io.ByteArray;

import haxe.Serializer;
import haxe.Unserializer;

class LocalStorage {
	private static inline var LS_KEY:String = '__gryffin_ls__';
	public static var entries:Array<Entry>;

	public static function init():Void {
		#if html5
			var ls = js.Browser.getLocalStorage();
			if (ls.getItem(LS_KEY) != null) {
				var frozen:String = ls.getItem(LS_KEY);
				try {
					entries = [for (ent in cast(Unserializer.run(frozen), Array<Dynamic>)) cast ent];
				} catch (err : String) {
					trace(err);
					entries = new Array();
				}
			} else {
				entries = new Array();
			}
		#elseif !flash
			var filename:String = (LS_KEY + '.dat');
			var fs = sys.io.File;
			if (sys.FileSystem.exists(filename)) {
				var frozen:String = fs.getContent(filename);
				try {
					entries = [for (ent in cast(Unserializer.run(frozen), Array<Dynamic>)) cast ent];
				} catch (err : String) {
					trace(err);
					entries = new Array();
				}
			} else {
				entries = new Array();
			}
		#else
			entries = new Array();
		#end
	}

	public static function save():Void {
		var frozen:String = Serializer.run(entries);
		#if html5
			var ls = js.Browser.getLocalStorage();
			ls.setItem(LS_KEY, frozen);
		#elseif !flash
			sys.io.File.saveContent((LS_KEY+'.dat'), frozen);
		#else
			return;
		#end
	}

	public static function get(key : String):Null<Dynamic> {
		for (entry in entries) {
			if (entry.name == key) return entry.data;
		}
		return null;
	}

	public static function set(key:String, data:Dynamic):Void {
		var entry:Null<Entry> = null;
		for (entr in entries) {
			if (entr.name == key) {
				entry = entr;
				break;
			}
		}
		if (entry == null) {
			entry = {
				'name' : key,
				'data' : data
			};
		} else {
			entry.data = data;
		}
		save();
	}
}

private typedef Entry = {
	name:String,
	data:Dynamic
};