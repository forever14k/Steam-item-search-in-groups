class TooltipView

  $el: null

  append: () ->
    $ 'body'
      .append sisbf.tooltip_container()
    @$el = $ '.backpack_tooltip'

  render: () ->
    @$el.html sisbf.tooltip_tooltip()

  constructor: () ->
    @append()
    @render()
