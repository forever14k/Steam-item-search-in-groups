class TooltipView

  $el: null
  state: null

  delegateEvents: () ->
    $ document
      .on 'mouseover', '.backpack .items [data-itemid]', @onMouseOver.bind @
      .on 'mouseout', '.backpack .items [data-itemid]', @onMouseOut.bind @

  onMouseOver: ( event ) ->
    @update event, () =>
      @show event

  onMouseOut: () ->
    @hide event

  show: ( event ) ->
    $target = $ event.target
    position = $target.position()
    width = @$el.outerWidth()

    @$el.css
      top: position.top - 8

    if (width + position.left + 50) >= $(window).width()
      @$el.css
        left: position.left - width
    else
      @$el.css
        left: position.left + 82

  hide: ( event ) ->
    @$el.css
      top: -1000
      left: -1000

  build: ( description ) ->
    tooltip =
      description: description
      tooltip: {}

    tooltip.tooltip[ 'Name' ] =
      name: description.name

    _.each description.tags, ( tag ) ->
      tooltip.tooltip[ tag.category_name ] =
        name: tag.name
        color: if tag.color? then tag.color else null

    # tf2 levels
    if description?.type?
      level = description.type.match /Level\s(\d+)/i
      if level?
        tooltip.tooltip[ OPTION_LEVEL ] =
          name: level[ 1 ]

    return tooltip

  append: () ->
    $ 'body'
      .append sisbf.tooltip_container()
    @$el = $ '.backpack_tooltip'

  render: () ->
    @$el.html sisbf.tooltip_tooltip()
    @delegateEvents()

  update: ( event, callback ) ->
    $target = $ event.target
    state = @state.getState().Backpacks.descriptions

    descriptionId = $target.attr 'data-descriptionid'
    description = state[ descriptionId ]
    if description?
      @$el.html sisbf.tooltip_tooltip @build description
      callback()

  constructor: ( @state ) ->
    @append()
    @render()
