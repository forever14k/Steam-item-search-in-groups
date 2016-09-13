class Menu
  $el: null
  data:
    appid: 570
    contextid: 2
    inventories:
      current: 0
      total: 0

  collect: () ->
    if settings?
      @data.appid = settings.get 'appid'
      @data.contextid = settings.get 'contextid'

  append: () ->
    $ '.maincontent'
      .prepend sisbf.menu_container()
    @$el = $ '#backpackscontent'

  render: () ->
    @collect()
    @$el.html sisbf.menu @data

  constructor: () ->
    @append()
    @render()
