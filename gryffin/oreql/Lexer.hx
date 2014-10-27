package gryffin.oreql;

import haxe.io.Error;
import gryffin.oreql.Tools;
import gryffin.io.Pointer;

using StringTools;
class Lexer {
	public var input:Array < String >;
	public var tokens:Array < Token >;
	public var operator_aliases:Map<String, String>;

	public var operator_precedence:Array<Array<String>>;
	public var non_symbolic_operators:Array<String>;
	public var symbolic_operators:Array<String>;

	public function new(sel:String) {
		this.input = sel.split('');
		this.tokens = [];

		this.operator_precedence = [
			['+', '-'],
			['*', '/', '**', '//']
		];
		trace(Tools.flattenArray(operator_precedence));

		this.symbolic_operators = [for (x in Tools.flattenArray(operator_precedence)) cast(x, String)];
		this.non_symbolic_operators = [
			"in"
		];
		this.operator_aliases = [
			"is" => "==",
			"isnt" => "!=",
			"not" => "!",
			"and" => "&&",
			"or" => "||",
			"plus" => "+",
			"minus" => "-",
			"times" => '*'
		];
	}
	private function isDigit( c:String ):Bool {
		return ~/[0-9]/.match( c );
	}
	private function isAlphaNumeric( c:String ):Bool {
		return ~/[A-Za-z0-9_\-@\*]/.match(c);
	}
	private function isKeyword( c:String ):Bool {
		return Lambda.has([
			"select",
			"from",
			"where"
		], c.toLowerCase());
	}
	private function isOperatorAlias( c:String ):Bool {
		return Lambda.has([
			for (key in operator_aliases.keys())
				key
		], c);
	}
	private function isOperator( c:String ):Bool {
		return Lambda.has(symbolic_operators.concat(non_symbolic_operators), c);
	}
	private function advance():String {
		return this.input.shift();
	}
	private function next(?distance:Int = 0):String {
		return this.input[distance];
	}
	private function push( tk : Token ):Void {
		this.tokens.push(tk);
	}

	/**
	 * Retrieves and returns either the next available token, or `null`. 
	 * `Null` values are silently ignored, while valid tokens are pushed
	 * into the `tokens` Array
	 * @throws Error(EOI) - when end-of-input is reached and accepted
	 * @throws Error(UEOI) - when end-of-input is reached and not expected
	 * @return Null<Token>
	 */
	public function lexNext():Null<Token> {
		var c:String = advance();

		/*
		 * == End of Input ==
		 */
		if ( c == null ) {
			throw Error.Custom(EOIERR);
		}
		/*
		 * == Strings ==
		 */
		else if ( c == "'" || c == '"' ) {
			//- Store which symbol was used to initiate the String
			var delimiter:String = c;
			//- Create empty string to store the String in
			var str:String = "";
			while ( next() != null && next() != delimiter ) {
				c = advance();
				str += c;
			}
			//- Invoke 'advance' once more to skip the final string
			advance();
			return TString(str);
		}

		/*
		 * == Numbers ==
		 */
		else if ( isDigit(c) ) {
			var strNum:String = c;
			while ( next() != null && (isDigit(next()) || next() == "." || next().toLowerCase() == "e") ) {
				c = advance();
				strNum += c;
			}
			var num:Float = Std.parseFloat( strNum );
			return TNumber(num);
		}

		/*
		 * == Identifiers, Keywords, and Operator Aliases
		 */
		else if (isAlphaNumeric(c)) {
			var ident:String = c;
			while (next() != null && isAlphaNumeric(next())) {
				c = advance();
				ident += c;
			}
			/*
			 * == Keywords
			 */
			if (isKeyword(ident)) {
				return Token.TKeyword(ident.toLowerCase());
			}
			/*
			 * Operator Alias
			 */
			else if (isOperatorAlias(ident)) {
				return Token.TBinaryOperator(operator_aliases[ident]);
			}
			/*
			 * Non-Symbolic operator
			 */
			else if (isOperator(ident) && !Lambda.has(symbolic_operators, ident)) {
				return Token.TBinaryOperator(ident);
			}
			/*
			 * == Identifier ==
			 */
			else {
				return Token.TIdent(ident);
			}
		}

		/*
		 * == Binary Operators ==
		 */
		
		else if (isOperator(c)) {
			var opstring:String = ('' + c);
			while (next() != null && isOperator(next())) {
				opstring += advance();
			}
			return Token.TBinaryOperator(opstring);
		}


		/*
		 * == Macros and Hex-Notation Numbers
		 */
		else if ( c == "#" ) {
			//- Macro
			if (next() == '{') {
				advance();
				var macroString:String = "";
				var brackits:Int = 1;
				while ( brackits > 0 ) {
					if ( next() == ")" ) brackits--;
					else if ( next() == "(" ) brackits++;
					if ( brackits > 0 ) {
						c = advance();
						macroString += c;
					}
				}
				advance();
				var toks:Array<Token> = (function(macString:String) 
					return (new Lexer(macString).lex()
				))(macroString);
				return Token.TMacro(toks);
			} else {
				unexpected('#');
			}
		}

		/*
		 * == Comments ==
		 */
		else if ( c == "/" && next() == "*" ) {
			advance();
			var comm:String = "";
			while ( true ) {
				//- End of Input
				if (next() == null) {
					unexpected('EndOfInput');
					return null;
				}

				//- End of Stream-Comment
				else if ((next() == "*" && next(1) == "/")) {
					advance();
					advance();
					return Token.TComment(comm);
				}

				//- Comment-Contents
				else {
					comm += next();
				}
				advance();
			}
		}
		/*
		 * == Groups and Tuples ==
		 */
		else if ( c == "(" ) {
			var groupString:String = "";
			var parens:Int = 1;
			while ( parens > 0 ) {
				if ( next() == ")" ) parens--;
				else if ( next() == "(" ) parens++;
				if ( parens > 0 ) {
					c = advance();
					groupString += c;
				}
			}
			advance();

			if (!groupString.endsWith(',')) {
				groupString = (groupString + ',');
			}
			var group:Array < Token > = (function() {
				var lexer = new Lexer( groupString );
				return lexer.lex();
			}());

			return Token.TGroup(group);
		}
		/*
		 * == Atom Tokens ==
		 */
		else if ( c == ',' ) {
			return Token.TComma;
		}

		else {
			trace(c);
			return null;
		}
	}
	public function lex():Array < Token > {
		var c:String = "";

		/*
		 * while-true-loop, which continues to `try` the `lexNext` method
		 * until the EOI error is caught
		 */
		while( true ) {
			//- Attempt invokation of `this.lexNext`
			try {
				var tk:Null<Token> = lexNext();
				//- If return value is not `null`, push it onto `this.tokens`
				if (tk != null) {
					push(tk);
				}
			//- If at any point an error is thrown
			} catch (err : Error) {
				//- check what kind of error it is
				switch (err) {
					//- in the case where it's a `Custom` error
					case Error.Custom(message):
						//- check if it is the `EOI` error
						if (message == EOIERR) {
							//- If so, break out of while-true-loop
							break;
						//- otherwise
						} else {
							//- rethrow it
							throw err;
						}
					//- in any other case
					default:
						//- rethrow it
						throw err;
				}
			}
		}

		//- End-Of-Input has been reached, so return the results
		return this.tokens;
	}

	private static inline function error(c : String):Void {
		throw Error.Custom(c);
	}

	private static inline function unexpected (c:String):Void {
		throw error('Unexpected "$c"');
	}


	private static inline var EOIERR:String = '__EOI__';
}