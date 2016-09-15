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
    state = @state.getState()
    @$statusText.text "Load inventories (#{state.Backpacks.current}/#{state.Backpacks.total})"
    switch state.Backpacks.state
      when 'BACKPACKS_IDLE'
        @$status
          .removeClass 'btn_blue_white_innerfade'
          .removeClass 'btn_darkblue_white_innerfade'
          .addClass 'btn_green_white_innerfade'
        @$search
          .removeClass 'btn_blue_white_innerfade'
          .removeClass 'btn_green_white_innerfade'
          .addClass 'btn_darkblue_white_innerfade'
      when 'BACKPACKS_PROCESS', 'BACKPACKS_RESUME'
        @$status
          .removeClass 'btn_green_white_innerfade'
          .addClass 'btn_blue_white_innerfade'
        @$search
          .removeClass 'btn_darkblue_white_innerfade'
          .addClass 'btn_blue_white_innerfade'
        @$settings
          .prop 'disabled', true
      when 'BACKPACKS_PAUSE'
        @$status
          .removeClass 'btn_blue_white_innerfade'
          .addClass 'btn_green_white_innerfade'
      when 'BACKPACKS_DRAIN'
        @$status
          .removeClass 'btn_blue_white_innerfade'
          .addClass 'btn_darkblue_white_innerfade'
        @$search
          .removeClass 'btn_blue_white_innerfade'
          .addClass 'btn_green_white_innerfade'
        @$settings
          .prop 'disabled', false

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
    @$status = @$el.find '#load_inventories'
    @$statusText = @$status.find 'span'
    @$search = @$el.find '#search_selected'
    @$settings = @$el.find '#appid, #contextid'
    @delegateEvents()

  constructor: ( @state ) ->
    @append()
    @render()
