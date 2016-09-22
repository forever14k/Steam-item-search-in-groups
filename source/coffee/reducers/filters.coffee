class FiltersReducer

  initialState:
    initial:
      enabled: false
      options: []
      selected: []

  reset: ( state ) ->
    _.each state, ( filter, name ) =>
      filter.enabled = false
      filter.options = []
      filter.selected = []
    return state

  push: ( state, option, name, color ) ->
    if not state[ option ]?
      state[ option ] =
        enabled: false
        options: []
        selected: []
    filter = state[ option ]
    filter.enabled = true
    if not _.find filter.options, { name: name }
      choice =
        name: name
        color: if color? then color else null
      filter.options.push choice

  filter: ( state, action ) ->
    if action.backpack.success? and action.backpack.success is true
      backpack = action.backpack
      descriptions = backpack.rgDescriptions
      if descriptions?
        _.each descriptions, ( description ) =>
          if description?.tags?
            _.each description.tags, ( tag ) =>
              if tag?.category_name? and tag?.name?
                if tag?.color?
                  @push state, tag.category_name, tag.name, tag.color
                else
                  @push state, tag.category_name, tag.name
          # tf2 levels
          if description?.type?
            level = description.type.match /Level\s(\d+)/i
            if level?
              @push state, 'Level', level[ 1 ]
    return state

  select: ( state, action ) ->
    filter = state[ action.option ]
    if not _.find filter.selected, action.added
      filter.selected.push action.added
    return state

  remove: ( state, action ) ->
    filter = state[ action.option ]
    _.remove filter.selected, action.removed
    return state

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when REDUX_INIT, SETTINGS_CHANGED
        @reset state
      when PERSON_LOADED
        @filter state, action
      when FILTERS_SELECTED
        @select state, action
      when FILTERS_REMOVED
        @remove state, action
      when FILTERS_REPLACED
        @remove state, action
        @select state, action
    return state

  constructor: () ->
    return @reducer.bind @
