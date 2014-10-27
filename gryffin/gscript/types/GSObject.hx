package gryffin.gscript.types;

import gryffin.gscript.types.GSProperty;

class GSObject {
	public var _properties:Array<GSProperty>;

	public function new():Void {
		this._properties = new Array();
	}

	/*
	 * Internal Utility Methods
	 */
	public function keys():Array<GSObject> {
		return [for (prop in _properties.filter(function(x:GSProperty) return x.enumerable)) prop.name];
	}

	/*
	 * Access Methods 
	*/
	public function __getitem__(gskey : GSObject):GSObject {
		
	}

	/*
	 * Boolean Operator Methods
	 */
	
	public function __is__(other : GSObject):GSObject {

	}

	/*
	 * Type-Casting Methods - Internal
	 */
	
	public function toString():String {
		var bits:Array<String> = [];
		for (key in this.keys()) {
			var value:GSObject = prop.val();
			bits.push('$key => ')
		}
	}
}