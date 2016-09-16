StateReducers = Redux.combineReducers
  Debug: new DebugReducer
  Settings: new SettingsReducer
  Persons: new PersonsReducer

State = Redux.createStore StateReducers

if State.getState().Debug
  State.subscribe () ->
    console.log 'STATE', State.getState()
