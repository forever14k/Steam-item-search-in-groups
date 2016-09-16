class DebugReducer
  reducer: ( state = true, action ) ->
    console.log 'ACTION', action
    return state

  constructor: () ->
    return @reducer.bind @
