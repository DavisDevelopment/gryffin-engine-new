package gryffin.core;

import gryffin.io.SelectorString;
import gryffin.core.Selection;
import gryffin.core.Filterable;

interface Selectable extends Filterable {
	function get(sel : String):Selection;
}