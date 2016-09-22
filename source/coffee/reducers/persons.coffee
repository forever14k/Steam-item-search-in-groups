class PersonsReducer

  initialState:
    current: 0
    total: 0
    delay: 4300
    state: PERSONSCLUB_IDLE
    personSelector: '#memberList [data-miniprofile]'
    persons: []

  reset: ( state ) ->
    state.state = PERSONSCLUB_IDLE
    state.persons = []
    state.current = state.persons.length
    $persons = $ state.personSelector
    $.each $persons, ( index, element ) ->
      $element = $ element
      steamId32 = $element.attr 'data-miniprofile'
      steamId64 = Steam::toSteamId64 steamId32
      status = STATUS_UNKNOWN
      status = STATUS_OFFLINE if $element.hasClass 'offline'
      status = STATUS_INGAME if $element.hasClass 'in-game'
      status = STATUS_ONLINE if $element.hasClass 'online'
      person =
        steamId32: steamId32
        steamId64: steamId64
        state: PERSON_IDLE
        status: status
      state.persons.push person
    state.total = state.persons.length
    return state

  queue: ( state ) ->
    state.state = PERSONSCLUB_QUEUE
    _.each state.persons, ( person, index ) =>
      person.state = PERSON_QUEUE
    return state

  state: ( state, action ) ->
    state.state = action.type
    return state

  statePerson: ( state, action ) ->
    person = _.find state.persons, steamId32: action.person.steamId32
    person.state = action.type
    return state

  increment: ( state ) ->
    state.current++ if state.current < state.total
    return state

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when REDUX_INIT, SETTINGS_CHANGED
        @reset state
      when PERSONSCLUB_QUEUE
        @queue state
      when PERSONSCLUB_PROCESS, PERSONSCLUB_PAUSE, PERSONSCLUB_RESUME, PERSONSCLUB_DRAIN
        @state state, action
      when PERSON_LOADING, PERSON_ERROR
        @statePerson state, action
      when PERSON_LOADED
        @increment state
        @statePerson state, action
    return state

  constructor: () ->
    return @reducer.bind @
