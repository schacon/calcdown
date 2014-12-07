CalcDownView = require './calcdown-view'
{allowUnsafeEval} = require 'loophole'

PEG = require 'pegjs'
fs = require 'fs-plus'
path = require 'path'

module.exports =
  configDefaults:
    grammars: [
      'source.gfm'
      'text.plain'
      'text.plain.null-grammar'
    ]

  activate: ->
    grammarFile = path.join(__dirname, '..', 'grammar.pegjs')
    fs.readFile grammarFile, (error, contents) ->
      allowUnsafeEval ->
        @parser = PEG.buildParser(contents.toString())

      atom.workspace.observeTextEditors (editor) ->
        grammars = atom.config.get('calcdown.grammars') ? []
        return unless editor.getGrammar().scopeName in grammars

        editorElement = atom.views.getView(editor)
        new CalcDownView(editor, editorElement, @parser)
