#!/usr/bin/env python

import json, sys
from string import Template

newline = '\n'
space = ' '
tab = (space * 4)

def capitalize(snippet):
	return (snippet[0:1].upper() + snippet[1:].lower())

def dashedToCamel(snippet):
	pieces = snippet.split('-')
	segments = []
	segments.append(pieces.pop().lower())

	for piece in pieces:
		segments.append(capitalize(piece))
	return (''.join(segments))


def method(localName, actualName, *args):
	code = 'public function {0}'.format(localName)
	code += '('

	decls = []
	argnames = []
	for (argName, argType) in args:
		argnames.append(argName)
		decls.append("{0}:{1}".format(argName, argType))
	code += ', '.join(decls)
	code += ')'
	code += ':Void'
	code += ' {'
	code += newline

	code += tab
	code += "var args:Array<Dynamic> = [{0}];".format((', '.join(argnames)))
	code += newline
	code += tab
	code += 'call("{0}", args);'.format(actualName)
	code += newline
	code += '}'

	return code

def generateMethods(models):
	code = ""
	for model in models:
		localName = model["name"]
		actualName = model["refName"]
		args = []
		for (key, value) in model['arguments']:
			args.append((key, value))


		code += newline
		code += method(localName, actualName, *args)
		code += newline
	return code

def boundField(name, refName, type):
	code = ""

	#- Declaration
	code += "public var $name(get, set):$type;"
	code += newline*2
	code += "//- [$name] Getter Method"
	code += newline

	#- Getter Method
	code += "private inline function get_$name():$type {"
	code += newline
	code += tab
	code += "return currentState.$refName;"
	code += newline
	code += '}'

	#- Setter Method
	code += newline*2
	code += "//- [$name] Setter Method"
	code += newline
	code += "private inline function set_$name(nv:$type):$type {"
	code += newline
	code += tab
	code += "currentState.$refName = nv;"
	code += newline
	code += tab
	code += "return nv;"
	code += newline
	code += '}'
	code += newline

	tm = Template(code)
	return tm.substitute({
		"name": name,
		"refName": refName,
		"type": type
	})

def generateBoundFields(boundFields):
	code = ""

	for cbf in boundFields:
		code += newline
		code += boundField(*cbf)
		code += newline

	return code

def main(args=[]):
	txt = open('data.json', 'r', 1).read()
	model = json.loads(txt)

	code = ""
	code += generateMethods(model['methods'])
	code += generateBoundFields(model['contextFields'])

	f = open('snippet.txt', 'w', 1)
	f.write(code)
	f.close()

if __name__ == "__main__":
	main(sys.argv[2:])