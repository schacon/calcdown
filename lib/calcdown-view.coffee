{CompositeDisposable} = require 'event-kit'
_ = require 'underscore-plus'
{Range, View} = require 'atom'

module.exports =
class CalcDownView
  constructor: (@editor, editorElement) ->
    @subscriptions = new CompositeDisposable
    @results = {}

    @subscriptions.add @editor.onDidChange =>
      @updateCalc()

    @updateCalc()

  updateCalc: ->
    console.log("UPDATE")
    
