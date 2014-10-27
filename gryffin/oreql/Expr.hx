package gryffin.oreql;

import gryffin.io.ImmutableArray;

enum Expr {
	EConst(c : Const);
	EIdent(id : String);
	ETuple(items : ImmutableArray<Expr>);
	ECall(id:String, params:ImmutableArray<Expr>);

	EBinOp(op:String, left:Expr, right:Expr);
	EUnOp(op:String, operand:Expr);

/*
 * == Query-Construction Expressions ==
 */
 	ESelect(what:Expr);
 	EFrom(where:Expr);
 	ESetContext(select:Expr, from:Expr);

/*
 * == Atom Expressions ==
 */
 	ESeparator;
 	EAnything;
}

enum Const {
	CString(str : String);
	CNumber(num : Float);
}