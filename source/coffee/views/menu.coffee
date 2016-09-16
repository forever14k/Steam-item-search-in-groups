class MenuView
  
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
    switch @state.getState().Persons.state
      when 'PERSONSCLUB_IDLE'
        @state.dispatch
          type: 'PERSONSCLUB_QUEUE'
      when 'PERSONSCLUB_QUEUE', 'PERSONSCLUB_RESUME', 'PERSONSCLUB_PROCESS'
        @state.dispatch
          type: 'PERSONSCLUB_PAUSE'
      when 'PERSONSCLUB_PAUSE'
        @state.dispatch
          type: 'PERSONSCLUB_RESUME'

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
