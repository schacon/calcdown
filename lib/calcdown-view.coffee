{CompositeDisposable} = require 'event-kit'
_ = require 'underscore-plus'
{Range, View} = require 'atom'

module.exports =
class CalcDownView
  constructor: (@editor, editorElement, parser) ->
    @subscriptions = new CompositeDisposable
    @results = {}
    @values = {}
    @parser = parser

    @subscriptions.add @editor.onDidChange (content) =>
      @updateCalc(content)

    @updateCalc()

  # parse the markdown file,
  #  run all the calculations
  #  and update the completions
  updateCalc: (content) ->
    try
      parsed = @parser.parse @editor.getText()
      for item in parsed
        console.log item

        # value assigned to a variable
        if item[0] == 'assign'
          @values[item[1]] = @calculateValue(item[2])

        # calculated value to be displayed in the doc
        if item[0] == 'complete'
          @total = 0

          # find the completions to add the overlays
          re = new RegExp(item[1] + '\\s+\\=\\>', 'g')
          @editor.scan re, ({range}) =>
            @total += 1
            @updateResult(item[1] + '-' + @total, range.end, @values[item[1]])

    catch error
      # TODO: display parse error?
      console.log error

  # take the parse tree and figure out what the actual value to be assigned is
  calculateValue: (parsed) ->
    console.log parsed
    vtype = typeof parsed
    if vtype == 'number'
      return parsed
    if vtype == 'string'
      if @values[parsed]
        return @values[parsed]
    if parsed['type'] == 'compute'
      val1 = @calculateValue(parsed['args'][0])
      val2 = @calculateValue(parsed['args'][1])
      switch parsed['name']
        when "+"
          return val1 + val2
        when "-"
          return val1 - val2
        when "*"
          return val1 * val2
        when "/"
          return val1 / val2
    console.log typeof parsed
    return "Err"

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
      item = decoration.getProperties().item
      item.innerHTML = result

      # move the decoration's marker if it changed (?)
      marker = @editor.markBufferPosition(position, invalidate: 'never')
      if !decoration.marker.isEqual(marker)
        @results[id] = @editor.decorateMarker(marker, {type: 'overlay', item})
