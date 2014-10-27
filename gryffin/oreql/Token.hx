package gryffin.oreql;
 
enum Token {
	TNumber( num:Float );
	TString( str:String );
	TIdent( id:String );
	TKeyword( id:String );
	TComment( message:String );
	TMacro( mac_ro:Array<Token> );
	TRegExp( pattern:String, modifiers:String );
	TORegExp( pattern:String );
	TGroup( tokens:Array < Token > );
	//TTuple( tokens:Array < Token > );
	TBooleanOperator(operator:String);
	TBinaryOperator(operator:String);
	TUnaryOperator(operator:String);

	TStar;
	THash;
	TDot;
	TOr;
	TAnd;
	TDoubleDot;
	TColon;
	TComma;
	TQuestion;
	TOpenBracket;
	TCloseBracket;
	TEquals;
	TNEquals;
	TDEquals;
	TArrow;
	TSemiEquals;
}