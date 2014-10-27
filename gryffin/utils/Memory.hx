package gryffin.utils;

class Memory {
	public static function uniqueId(?prefix:String = 'object'):String {
		var id:Int = 0;
		if (id_registry.exists(prefix)){
			id_registry[prefix] = (id_registry[prefix] + 1);
			id = (id_registry[prefix]);
		} else {
			id_registry[prefix] = id;
		}
		return (prefix + id);
	}

	private static var id_registry:Map<String, Int> = {
		new Map();
	};
}