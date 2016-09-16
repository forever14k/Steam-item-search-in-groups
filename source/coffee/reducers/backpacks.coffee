Backpacks =

  initialState:
    current: 0
    total: 0
    delay: 1
    state: 'BACKPACKS_IDLE'
    personClass: '.friendBlock'
    persons: []
    backpacks: []

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
    state.state = 'BACKPACKS_IDLE'
    _.each state.persons, ( person, index ) =>
      person.state = 'PERSON_IDLE'
    return state

  queueStart: ( state ) ->
    state.state = 'BACKPACKS_QUEUE'
    _.each state.persons, ( person, index ) =>
      person.state = 'PERSON_QUEUE' if person.state is 'PERSON_IDLE'
    return state

  queueProcess: ( state ) ->
    state.state = 'BACKPACKS_PROCESS'
    return state

  queuePause: ( state ) ->
    state.state = 'BACKPACKS_PAUSE'
    return state

  queueDrain: ( state ) ->
    state.state = 'BACKPACKS_DRAIN'
    return state

  queueResume: ( state ) ->
    state.state = 'BACKPACKS_RESUME'
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

  reducer: ( state = Backpacks.initialState, action ) ->
    switch action.type
      when '@@redux/INIT'
        Backpacks.populate state
      when 'SETTINGS_CHANGED'
        Backpacks.reset state
        Backpacks.populate state
      when 'BACKPACKS_QUEUE'
        Backpacks.queueStart state
      when 'BACKPACKS_PROCESS'
        Backpacks.queueProcess state
      when 'BACKPACKS_PAUSE'
        Backpacks.queuePause state
      when 'BACKPACKS_RESUME'
        Backpacks.queueResume state
      when 'BACKPACKS_DRAIN'
        Backpacks.queueDrain state
      when 'PERSON_LOADING'
        Backpacks.personLoading state, action
      when 'PERSON_LOADED'
        Backpacks.personLoaded state, action
    return state
