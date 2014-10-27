package gryffin.oreql;
	
import haxe.io.Error;
import gryffin.oreql.Token;
import gryffin.oreql.Expr;

import gryffin.io.ImmutableArray;

class Parser {
	public var tree:Array<Token>;
	public var ast:Array<Expr>;
	public var _stache:Array<Token>;
	public var snapshots:Array<Array<Token>>;

	public function new():Void {
		reset();
	}
	private inline function reset():Void {
		this.tree = new Array();
		this._stache = new Array();
		this.snapshots = new Array();
		this.ast = new Array();
	}
	private inline function addStache(item:Token):Void {
		this._stache.push(item);
	}
	private inline function stache(?lookback:Int = 0):Null<Token> {
		return this._stache[this._stache.length - (lookback + 1)];
	}
	private inline function save():Void {
		this.snapshots.push(this.saveStack());
	}
	private inline function restore():Void {
		var saved:Null<Array<Token>> = snapshots.pop();
		if (save != null) {
			this.tree = saved;
		}
	}
	private inline function token():Null<Token> {
		return this.tree.shift();
	}
	private inline function popback(tk:Token):Void {
		tree.unshift(tk);
	}
	private inline function back():Null<Expr> {
		return ast.pop();
	}
	private inline function forward(e : Expr):Void {
		ast.push(e);
	}

	public function parseNext():Null<Expr> {
		var tk:Null<Token> = token();
		if (tk == null) eoi();

		switch (tk) {
			case Token.TString(str):
				return Expr.EConst(Const.CString(str));

			case Token.TNumber(num):
				return Expr.EConst(Const.CNumber(num));

			case Token.TIdent(id):
				save();
				var next:Expr = parseNext();
				switch (next) {
					case Expr.ETuple(items):
						return Expr.ECall(id, items);

					default:
						restore();
						switch (id) {
							case "*":
								return Expr.EAnything;
							
							default:
								return Expr.EIdent(id);
						}
				}

			case Token.TKeyword(kw):
				switch (kw) {
					case "select":
						var what:Null<Expr> = parseNext();
						if (what == null) {
							error('Unexpected "select"');
						} else {
							return Expr.ESelect(what);
						}

					case "from":
						var nxt:Null<Expr> = parseNext();
						trace(nxt);
						if (nxt == null) {
							error('Unexpected "from"');
						} else {
							switch (nxt) {
								case Expr.EIdent(tableName):
									var from:Expr = Expr.EFrom(nxt);
									trace(from);
									return from;

								default:
									error('Unexpected $nxt');
							}
						}

					default:
						trace(kw);
						return null;
				}

			case Token.TGroup(subtree):
				var expressionList:Array<Expr> = parse_tuple(subtree);
				return Expr.ETuple(cast expressionList);

			case Token.TBinaryOperator(op):
				var left:Null<Expr> = back();
				var right:Null<Expr> = parseNext();

				if (left == null || right == null) {
					var operand:Expr = (right != null ? right : left);
					return Expr.EUnOp(op, operand);
				} else {
					return Expr.EBinOp(op, left, right);
				}

			default:
				throw 'Unexpected $tk';
	
	/*
		== Atom Expressions ==
	 */
			case Token.TComma:
				return Expr.ESeparator;
		}
		return null;
	}

	public function parseTuple(tokenList:Array<Token>):Array<Expr> {
		reset();
		this.tree = tokenList;

		while (true) {
			try {
				var e:Null<Expr> = parseNext();
				if (e != null) {
					switch (e) {
						case Expr.ESeparator:
							null; //- Ignore
						default:
							forward(e);
					}
				}
			} catch (err : Error) {
				switch (err) {
					case Error.Custom(msg):
						if (msg == EOI) {
							break;
						} else {
							throw err;
						}
					default:
						throw err;
				}
			}
		}

		return this.ast;
	}

	public function parse(tokenList:Array<Token>):Array<Expr> {
		reset();
		this.tree = tokenList;

		while (true) {
			try {
				var e:Null<Expr> = parseNext();
				if (e != null) {
					forward(e);
				}
			} catch (err : Error) {
				switch (err) {
					case Error.Custom(msg):
						if (msg == EOI) {
							break;
						} else {
							throw err;
						}
					default:
						throw err;
				}
			}
		}

		return this.ast;
	}

	private function saveStack():Array<Token> {
		var copy:Array<Token> = new Array();
		for (tk in tree) {
			var clone:Token = Type.createEnumIndex(Token, Type.enumIndex(tk), Type.enumParameters(tk));
			copy.push(clone);
		}
		return copy;
	}

	private function format(set:Array<Expr>, mode:String):Array<Expr> {
		switch (mode) {
			case "select":
				var results:Array<Expr> = new Array();

				for (e in set) {
					switch (e) {
						case Expr.ETuple(items):
							if (items.length == 1) {
								results.push(items[0]);
							} else {
								results.push(e);
							}

						default:
							results.push(e);
					}
				}
				return results;

			default:
				return set;
		}
	}

	private static macro function error(msg:haxe.macro.Expr):haxe.macro.Expr {
		var pos = haxe.macro.Context.getPosInfos(haxe.macro.Context.currentPos());

		return macro throw {
			'message': $v{msg},
			'filename': $v{pos.file},
			'pos': [$v{pos.min}, $v{pos.max}]
		};
	}
	private static inline function parse_tree(tree:Array<Token>):Array<Expr> {
		return (new Parser().parse(tree));
	}
	private static inline function parse_tuple(tree:Array<Token>):Array<Expr> {
		return (new Parser().parseTuple(tree));
	}
	private static inline function eoi():Void {
		throw Error.Custom(EOI);
	}
	private static inline var EOI:String = '--EOIError--';
}