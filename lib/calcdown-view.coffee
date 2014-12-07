{CompositeDisposable} = require 'event-kit'
_ = require 'underscore-plus'
{Range, View} = require 'atom'

module.exports =
class CalcDownView
  constructor: (@editor, editorElement, parser) ->
    @subscriptions = new CompositeDisposable
    @results = {}
    @parser = parser

    @subscriptions.add @editor.onDidChange (content) =>
      @updateCalc(content)

    @updateCalc()

  updateCalc: (content) ->
    try
      parsed = @parser.parse @editor.getText()
      @updateResult('test-1', [1, 9], Math.random())
      console.log parsed
    catch error
      console.log error

  updateResult: (id, position, result) ->
    result = "&nbsp;" + result
    if !@results[id]
      # create an overlay element to hold the result
      item = document.createElement('div')
      item.classList.add 'calcdown-result'
      item.innerHTML = result

      # create a marker at the position and add the overlay to display the result
      marker = @editor.markBufferPosition(position, invalidate: 'never')
      decoration = @editor.decorateMarker(marker, {type: 'overlay', item})
      @results[id] = decoration
    else
      # find the overlay for this result and update the value
      decoration = @results[id]
      decoration.getProperties().item.innerHTML = result

      # move the decoration's marker if it changed (?)
      marker = @editor.markBufferPosition(position, invalidate: 'never')
      if !decoration.marker.isEqual(marker)
        decoration.marker = marker
