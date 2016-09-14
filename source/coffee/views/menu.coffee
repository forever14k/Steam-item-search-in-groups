class Menu
  $el: null
  state: null

  delegateEvents: () ->
    @$el
      .find '#load_inventories'
      .on 'click', @onLoadInventories.bind @
    @$el
      .find '#search_selected'
      .on 'click', @onSearchSelected.bind @
    @$el
      .find '#appid, #contextid'
      .on 'change', @onSettingsChanged.bind @

  onSettingsChanged: ( event ) ->
    data =
      appid: (@$el
        .find '#appid'
        .val())
      contextid: (@$el
        .find '#contextid'
        .val())

    @state.dispatch
      type: 'SETTINGS_CHANGED'
      data: data

  onLoadInventories: ( event ) ->
    @state.dispatch
      type: 'LOAD_INVENTORIES'

  onSearchSelected: ( event ) ->
    data =
      string: (@$el
        .find '#backpack_search'
        .val())

    @state.dispatch
      type: 'SEARCH_SELECTED'
      data: data

  append: () ->
    $ '.maincontent'
      .prepend sisbf.menu_container()
    @$el = $ '#backpackscontent'

  render: () ->
    @$el.html sisbf.menu @state.getState()
    @delegateEvents()

  constructor: ( state ) ->
    @state = state if state?
    @append()
    @render()
