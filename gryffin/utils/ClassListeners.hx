package gryffin.utils;

import haxe.macro.Expr;
import haxe.macro.Context;

class ClassListeners {
	//- Listens for start of Application
	public static macro function onStart(cl:ExprOf<{init:Void->Void}>):Expr {
		return macro gryffin.Stage.addInittable($cl);
	}
}