class DebugReducer

  initialState: true

  reducer: ( state = @initialState, action ) ->
    console.log 'ACTION', action
    return state

  constructor: () ->
    return @reducer.bind @
