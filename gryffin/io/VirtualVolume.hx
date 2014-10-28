package gryffin.io;

import gryffin.io.Buffer;
import gryffin.io.Pointer;

import gryffin.io.vv.VVEntry;
import gryffin.io.vv.VVEntryType;

using gryffin.utils.PathTools;
class VirtualVolume {
	public var entries:Array<VVEntry>;

	public function new(?entries:Array<VVEntry>):Void {
		// if restoring existing VirtualVolume
		if (entries != null) {
			// simply grab pre-existing entries
			this.entries = entries;

		// if creating new VirtualVolume
		} else {
			// initialize entry-registry
			this.entries = new Array();
			
			// initialize root directory
			this.entries.push(new VVEntry('', VVEntryType.VVDirectory));
		}
	}

	public function getEntry(id : String):Null<VVEntry> {
		id = id.simplify();

		for (entry in this.entries) {
			if (entry.id.simplify() == id)
				return entry;
		}
		return null;
	}

	public function exists(id : String):Bool {
		id = id.simplify();
		return (getEntry(id) != null);
	}

	public function isDirectory(id : String):Bool {
		id = id.simplify();
		return (exists(id) && Type.enumEq(getEntry(id).type,  VVEntryType.VVDirectory));
	}

	public function isFile(id : String):Bool {
		id = id.simplify();
		return (exists(id) && !isDirectory(id));
	}

	public function createDirectory(id : String):Void {
		id = id.toAbsolute();
		// if directory does not already exist
		if (!exists(id)) {
			var dir:VVEntry = new VVEntry(id, VVEntryType.VVDirectory);
			this.entries.push(dir);
		} else {
			fserror('Directory $id already exists');
		}
	}

	public function createFile(id : String):Void {
		id = id.toAbsolute();

		// if file does not already exist
		if (!exists(id)) {
			var file:VVEntry = new VVEntry(id, VVEntryType.VVFile);
			this.entries.push(file);
		} else {
			fserror('File $id already exists');
		}
	}
	
	/**
	  * finds all entries which are direct children of the directory referenced by [id]
	  * and returns an array of their [id]s
	  */
	public function readDirectory(id : String):Array<String> {
		var results:Array<String> = new Array();
		
		// ensure that [id] is an absolute path
		id = id.toAbsolute();

		// if [id] is a directory
		if (isDirectory(id)) {
			trace("\n === Cheeks! ===\n");

			for (entry in entries) {
				if (entry.id.parent().toAbsolute() == id)
					results.push(entry.id);
				else
					trace(entry.id.parent());
			}
			return results;
		} else {
			fserror('"$id" is not a directory');
			return [];
		}
	}

	public function readFile(id : String):Buffer {
		// if [id] exists and is a file
		if (isFile(id)) {
			return (getEntry(id).data);
		}
		// otherwise
		else {
			fserror('Cannot open "$id", as it is either non-existent, or not a file');
		}
	}

	public function writeFile(id:String, content:Buffer):Void {
		// assert that [id] is either a pre-existing file, or doesn't exist at all
		if (isFile(id) || !exists(id)) {
			var entry:Null<VVEntry> = getEntry(id);
			if (entry == null) {
				entry = new VVEntry(id, VVEntryType.VVFile);
				this.entries.push(entry);
			}
			entry.data = content;
		} else {
			fserror('Cannot write to "$id"');	
		}
	}

	public function serialize():Buffer {
		return Buffer.fromString(haxe.Serializer.run(this.entries));
	}


	public static function deserialize(buf : Buffer):VirtualVolume {
		var entries:Array<VVEntry> = [for (e in cast(haxe.Unserializer.run(buf.toString()), Array<Dynamic>)) cast(e, VVEntry)];

		return new VirtualVolume(entries);
	}


/*
 * == Error Reporting Methods ==
 */
 	private static inline function fserror(msg:String):Void {
		throw 'VirtualVolumeError: $msg';
	}
}
