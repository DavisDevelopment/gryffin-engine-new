package gryffin.core;

import gryffin.core.Entity;
import gryffin.io.SelectorString;

interface Filterable {
	function filter(sel : String):Array<Entity>;
}