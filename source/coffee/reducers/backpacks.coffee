class BackpacksReducer

  initialState:
    items: []
    descriptions: {}
    results: {}
    state: BACKPACKS_IDLE
    order: [
      STATUS_ONLINE
      STATUS_INGAME
      STATUS_OFFLINE
      STATUS_UNKNOWN
    ]
    colorOrder: [
      OPTION_CATEGORY
      OPTION_QUALITY
      OPTION_RARITY
    ]
    colorExclude: [
      CHOICE_STANDARD
    ]

  reset: ( state ) ->
    state.items = []
    state.descriptions = {}
    state.results = {}
    state.state = BACKPACKS_NOTDISPLAYED
    return state

  state: ( state, action ) ->
    state.state = action.type
    return state

  color: ( state, description ) ->
    color = null

    if description?.tags?
      _.each state.colorOrder, ( optionName ) ->
        tag = _.find description.tags, category_name: optionName
        if tag?.color? and not color?
          if not _.includes state.colorExclude, tag.name
            color = tag.color

    return color

  push: ( state, action ) ->
    if action.backpack.success? and action.backpack.success is true
      person = action.person
      items = action.backpack.rgInventory
      descriptions = action.backpack.rgDescriptions

      _.each items, ( item ) =>
        itemId = item.id
        descriptionId = "#{item.classid}_#{item.instanceid}"
        description = descriptions[ descriptionId ]

        if description?
          color = @color state, description
          state.descriptions[ descriptionId ] = description

          state.items.push
            itemId: itemId
            descriptionId: descriptionId
            person: person
            color: color

    return state

  passed: ( state, descriptionId ) ->
    items = _.filter state.items, descriptionId: descriptionId
    _.each items, ( item ) =>
      person = item.person
      status = person.status
      steamId32 = person.steamId32
      itemId = item.itemId
      description = state.descriptions[ descriptionId ]

      state.results[ status ] = {} if not state.results[ status ]?
      state.results[ status ][ steamId32 ] = {} if not state.results[ status ][ steamId32 ]?
      state.results[ status ][ steamId32 ][ itemId ] =
        asset: item
        person: person
        description: description
        
    return state

  search: ( state, action ) ->
    state.results = {}
    search = action.search

    filters = {}
    _.each action.filters, ( filter, option ) =>
      filters[ option ] = filter.selected if filter.enabled and filter.selected.length > 0

    _.each state.descriptions, ( description ) =>
      if @filter description, search, filters
        @passed state, "#{description.classid}_#{description.instanceid}"

    state.state = BACKPACKS_NOTDISPLAYED
    return state

  filter: ( description, search, filters ) ->
    accept = false
    inspection = {}

    inspection.have_market_name = if description?.market_name? then true else false

    name = if description?.name? then description.name.toLowerCase() else ''
    search = search.toLowerCase()
    inspection.string = _.includes name, search

    _.each filters, ( selected, option ) ->
      inspection[ option ] = false
      _.each selected, ( choice ) ->
        tag =
          name: choice.name
          category_name: option
        inspection[ option ] = true if _.find description.tags, tag

      # tf2 levels
      if option is OPTION_LEVEL
        if description?.type?
          inspection[ option ] = true if _.some selected, ( choice ) ->
            level = "#{OPTION_LEVEL} #{choice.name}"
            level += " " if description.type.length > level.length
            return _.startsWith description.type, level

    accept = not _.includes _.values( inspection ), false
    return accept

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when REDUX_INIT, SETTINGS_CHANGED
        @reset state
      when PERSON_LOADED
        @push state, action
      when BACKPACKS_SEARCH
        @search state, action
      when BACKPACKS_DISPLAYED
        @state state, action
    return state

  constructor: () ->
    return @reducer.bind @
