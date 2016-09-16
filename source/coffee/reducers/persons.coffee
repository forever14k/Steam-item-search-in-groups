class PersonsReducer

  initialState:
    current: 0
    total: 0
    delay: 1
    state: 'PERSONSCLUB_IDLE'
    personClass: '.friendBlock'
    persons: []

  populate: ( state ) ->
    state.persons = []
    state.current = state.persons.length
    $persons = $ state.personClass
    $.each $persons, ( index, element ) ->
      $element = $ element
      steamId32 = $element.attr 'data-miniprofile'
      steamId64 = Steam::toSteamId64 steamId32
      person =
        steamId32: steamId32
        steamId64: steamId64
        state: 'PERSON_IDLE'
      state.persons.push person
    state.total = state.persons.length
    return state

  reset: ( state ) ->
    state.state = 'PERSONSCLUB_IDLE'
    _.each state.persons, ( person, index ) =>
      person.state = 'PERSON_IDLE'
    return state

  queueStart: ( state ) ->
    state.state = 'PERSONSCLUB_QUEUE'
    _.each state.persons, ( person, index ) =>
      person.state = 'PERSON_QUEUE' if person.state is 'PERSON_IDLE'
    return state

  queueProcess: ( state ) ->
    state.state = 'PERSONSCLUB_PROCESS'
    return state

  queuePause: ( state ) ->
    state.state = 'PERSONSCLUB_PAUSE'
    return state

  queueDrain: ( state ) ->
    state.state = 'PERSONSCLUB_DRAIN'
    return state

  queueResume: ( state ) ->
    state.state = 'PERSONSCLUB_RESUME'
    return state

  personLoaded: ( state, action ) ->
    state.current++ if state.current < state.total
    person = _.find state.persons, steamId32: action.data.steamId32
    person.state = 'PERSON_LOADED'
    return state

  personLoading: ( state, action ) ->
    person = _.find state.persons, steamId32: action.data.steamId32
    person.state = 'PERSON_LOADING'
    return state

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when '@@redux/INIT'
        @populate state
      when 'SETTINGS_CHANGED'
        @reset state
        @populate state
      when 'PERSONSCLUB_QUEUE'
        @queueStart state
      when 'PERSONSCLUB_PROCESS'
        @queueProcess state
      when 'PERSONSCLUB_PAUSE'
        @queuePause state
      when 'PERSONSCLUB_RESUME'
        @queueResume state
      when 'PERSONSCLUB_DRAIN'
        @queueDrain state
      when 'PERSON_LOADING'
        @personLoading state, action
      when 'PERSON_LOADED'
        @personLoaded state, action
    return state

  constructor: () ->
    return @reducer.bind @
