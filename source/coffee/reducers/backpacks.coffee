class BackpacksReducer

  initialState:
    backpacks: []

  reset: ( state ) ->
    state.backpacks = []
    return state

  push: ( state, action ) ->
    if action.backpack.success? and action.backpack.success is true
      backpack =
        person: action.person
        backpack: action.backpack
      state.backpacks.push backpack
    return state

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when '@@redux/INIT', 'SETTINGS_CHANGED'
        @reset state
      when 'PERSON_LOADED'
        @push state, action
    return state

  constructor: () ->
    return @reducer.bind @
