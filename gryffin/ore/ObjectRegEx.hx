package gryffin.ore;

import gryffin.io.ByteArray;

class ObjectRegEx {
	public static var selectors:Map < String, Dynamic -> Bool > = new Map();
	public static var helpers:Map < String, Dynamic > = new Map();
	private static var memoize:Bool = true;
	
	public static function bindHelpers( compiler:Compiler ):Void {
		for ( key in helpers.keys() ) {
			var helper:Dynamic -> Bool = helpers.get(key);
			compiler.registerHelper( key, helper );
		}
	}
	public static function helper(key:String, helper:Dynamic ):Void {
		helpers.set(key, helper);
	}
	public static inline function getFunc( sel:ByteArray ):Dynamic -> Bool {
		var selector:String = sel.toString();

		if ( memoize ) {
			if ( selectors.exists(selector) ) {
				return selectors.get( selector );
			} else {
				var lexer = new Lexer(sel);
				var tokens = lexer.lex();
				var parser = new Parser(tokens);
				var sel = parser.parse();
				var compiler = new Compiler(sel);
				bindHelpers( compiler );
				var func = compiler.compile();
				selectors.set( selector, func );
				return func;
			}
		} else {
			var lexer = new Lexer(selector);
			var tokens = lexer.lex();
			var parser = new Parser(tokens);
			var sel = parser.parse();
			var compiler = new Compiler(sel);
			bindHelpers( compiler );
			var func = compiler.compile();
			return func;
		}
	}
	
	public static function compile( selector:String ):Selection {
		var func:Dynamic -> Bool = getFunc( selector );
		return new Selection( func );
	}
	
	public static function registerHelper( name:String, helper:Dynamic -> Bool ):Void {
		helpers.set( name, helper );
	}
}