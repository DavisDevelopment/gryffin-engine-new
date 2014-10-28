package gryffin.io.vv;

import gryffin.io.Buffer;

import gryffin.io.vv.VVEntryType;

using gryffin.utils.PathTools;
class VVEntry {
	// what type of entry this is
	public var type:VVEntryType;
	
	// the name of this entry
	public var id:String;
	
	// this entry's data, in binary format
	public var data:Buffer;

	public function new(id:String, type:VVEntryType, ?data:Buffer):Void {
		this.id = id;
		this.type = type;
		
		// if [data] is declared
		if (data != null) {
			// bind it to [this]
			this.data = data;
		// otherwise
		} else {
			//if [this] is a standard file, or an alias
			if (Type.enumEq(this.type, VVEntryType.VVFile) || Type.enumEq(this.type, VVEntryType.VVAlias)) {
				// create an empty buffer, and bind it to [this]
				this.data = Buffer.alloc(0);
			}
		}
	}
}
