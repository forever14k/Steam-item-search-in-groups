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

    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    @update()

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
    switch @state.getState().Backpacks.state
      when 'BACKPACKS_IDLE'
        @state.dispatch
          type: 'BACKPACKS_QUEUE'
      when 'BACKPACKS_QUEUE', 'BACKPACKS_RESUME', 'BACKPACKS_PROCESS'
        @state.dispatch
          type: 'BACKPACKS_PAUSE'
      when 'BACKPACKS_PAUSE'
        @state.dispatch
          type: 'BACKPACKS_RESUME'

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

  update: () ->
    render.diff @$el.find(':first-child'), sisbf.menu(@state.getState())

  constructor: ( @state ) ->
    @append()
    @render()
