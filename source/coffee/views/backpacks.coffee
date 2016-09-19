class BackpacksView

  $el: null

  append: () ->
    $ '.maincontent'
      .prepend sisbf.backpacks_container()
    @$el = $ '.backpacks'

  render: () ->
    @$el.html sisbf.backpacks_backpacks()

  constructor: () ->
    @append()
    @render()
