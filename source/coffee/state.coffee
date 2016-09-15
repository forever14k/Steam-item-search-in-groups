StateReducers = Redux.combineReducers
  Debug: Debug.reducer
  Settings: Settings.reducer
  Backpacks: Backpacks.reducer

State = Redux.createStore StateReducers

if State.getState().Debug
  State.subscribe () ->
    console.log 'STATE', State.getState()
