package gryffin.oreql;

import haxe.io.Error;

class Tools {
	public static function typeName(obj : Dynamic):String {
		if (Reflect.isFunction(obj)) {
			return 'Function';
		}
		else if (Reflect.isEnumValue(obj)) {
			var enumer = Type.getEnum(obj);
			if (enumer != null) {
				return Type.getEnumName(enumer);
			} else {
				return 'Dynamic';
			}
		}
		else if (Reflect.isObject(obj)) {
			if (Std.is(obj, Class)) {
				try {
					var klass = Type.createEmptyInstance(cast obj);
					return Type.getClassName(klass);
				} catch (error : String) {
					try {
						var enumer = Type.getEnumName(cast obj);
						if (enumer != null && enumer != '') {
							return enumer;
						} else {
							return 'Dynamic';
						}
					} catch (err : String) {
						return 'Dynamic';
					}
				}
			} else {
				return Type.getClassName(Type.getClass(obj));
			}
		} else {
			return 'Dynamic';
		}
	}

	public static function flattenArray(list:Array<Dynamic>):Array<Dynamic> {
		var results:Array<Dynamic> = new Array();
		function itemAsChunk(item:Dynamic):Array<Dynamic> {
			if (typeName(item) == 'Array') {
				try {
					return flattenArray(cast(item, Array<Dynamic>));
				} catch (err:String) {
					return cast [item];
				}
			} else {
				return cast [item];
			}
		}
		for (item in list) {
			results = results.concat(itemAsChunk(item));
		}

		return results;
	}
}