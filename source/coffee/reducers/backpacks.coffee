Backpacks =

  initialState:
    current: 0
    total: 0
    personClass: '.friendBlock'
    persons: []
    backpacks: []

  populate: ( state ) ->
    state.persons = []
    $persons = $ state.personClass
    $.each $persons, ( index, element ) ->
      $element = $ element
      steamId32 = $element.attr 'data-miniprofile'
      steamId64 = Steam.toSteamId64 steamId32
      person =
        steamId32: steamId32
        steamId64: steamId64
        state: 'PERSON_IDLE'
      state.persons.push person
    state.total = state.persons.length
    return state

  queue: ( state ) ->
    _.each state.persons, ( person, index ) =>
      if person.state is 'PERSON_IDLE'
        person.state = 'PERSON_QUEUE'
      else
        person.state = 'PERSON_IDLE'
    return state

  reducer: ( state = Backpacks.initialState, action ) ->
    switch action.type
      when '@@redux/INIT'
        Backpacks.populate state
      when 'LOAD_INVENTORIES'
        Backpacks.queue state
    return state
