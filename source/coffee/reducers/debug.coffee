Debug =
  reducer: ( state = true, action ) ->
    console.log 'ACTION', action
    return state
