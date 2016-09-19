class BackpacksReducer

  initialState:
    items: []
    descriptions: {}
    results: {}

  reset: ( state ) ->
    state.items = []
    state.descriptions = {}
    state.results = {}
    return state

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
          state.descriptions[ descriptionId ] = description
          state.items.push
            itemId: itemId
            descriptionId: descriptionId
            person: person
    return state

  passed: ( state, descriptionId ) ->
    items = _.filter state.items, descriptionId: descriptionId
    _.each items, ( item ) =>
      person = item.person
      status = person.status
      steamId32 = person.steamId32
      description = state.descriptions[ descriptionId ]
      state.results[ status ] = {} if not state.results[ status ]?
      state.results[ status ][ steamId32 ] = [] if not state.results[ status ][ steamId32 ]?
      state.results[ status ][ steamId32 ].push description
    return state

  search: ( state, action ) ->
    search = action.search
    filters = action.filters

    _.each state.descriptions, ( description ) =>
      if @filter description, search, filters
        @passed state, "#{description.classid}_#{description.instanceid}"

    return state

  filter: ( description, search, filters ) ->
    accept = false
    inspection = {}

    inspection.have_market_name = if description?.market_name? then true else false

    inspection.string = _.includes description.name, search

    accept = not _.includes _.values( inspection ), false
    return accept

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when '@@redux/INIT', 'SETTINGS_CHANGED'
        @reset state
      when 'PERSON_LOADED'
        @push state, action
      when 'SEARCH_SELECTED'
        @search state, action
    return state

  constructor: () ->
    return @reducer.bind @
