CalcDownView = require './calcdown-view'

module.exports =
  configDefaults:
    grammars: [
      'source.gfm'
      'text.plain'
      'text.plain.null-grammar'
    ]

  activate: ->
    atom.workspace.observeTextEditors (editor) ->
      grammars = atom.config.get('calcdown.grammars') ? []
      return unless editor.getGrammar().scopeName in grammars

      editorElement = atom.views.getView(editor)
      new CalcDownView(editor, editorElement)
