class Render

  diffDOM: null

  diff: ( $element, newHTML ) ->
    oldEl = $element.find '.sisbf_render--diff'
    newEl = $ newHTML
    newEl = newEl.find '.sisbf_render--diff' if not newEl.hasClass 'sisbf_render--diff'

    oldDOM = _.first oldEl
    newDOM = _.first newEl
    midDOM = @diffDOM.diff oldDOM, newDOM
    @diffDOM.apply oldDOM, midDOM

  constructor: ( @state ) ->
    @diffDOM = new diffDOM
