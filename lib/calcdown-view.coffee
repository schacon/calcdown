{CompositeDisposable} = require 'event-kit'
_ = require 'underscore-plus'
{Range, View} = require 'atom'

module.exports =
class CalcDownView
  constructor: (@editor, editorElement, parser) ->
    @subscriptions = new CompositeDisposable
    @results = {}
    @parser = parser

    item = document.createElement('div')
    item.classList.add 'calcdown-result'
    newContent = document.createTextNode("RESULT")
    item.appendChild(newContent)

    marker = editor.markBufferPosition([0, 0], invalidate: 'never')
    decoration = editor.decorateMarker(marker, {type: 'overlay', item})

    @subscriptions.add @editor.onDidChange (content) =>
      @updateCalc(content)

    @updateCalc()

  updateCalc: (content) ->
    console.log(content)
    console.log(@editor.getText())
    try
      parsed = @parser.parse @editor.getText()
      console.log parsed
    catch error
      console.log error
