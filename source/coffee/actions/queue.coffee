class Queue
  state: null
  queue: null

  delegateEvents: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    state = @state.getState().Persons.state
    switch state
      when 'PERSONSCLUB_QUEUE'
        @populate()
      when 'PERSONSCLUB_PAUSE'
        @pause()
      when 'PERSONSCLUB_RESUME'
        @resume()

  process: ( data ) ->
    @state.dispatch
      type: 'PERSON_LOADING'
      data: data

    setTimeout (()=>
      @state.dispatch
        type: 'PERSON_LOADED'
        data: data
    ), 10

  setup: () ->
    @queue = async.queue ( ( data, callback )=>
      @process data
      data._timeout = setTimeout callback, @state.getState().Persons.delay
    ), 1
    @queue.drain = () =>
      @state.dispatch
        type: 'PERSONSCLUB_DRAIN'

  populate: () ->
    persons = @state.getState().Persons.persons
    queue = _.filter persons, state: 'PERSON_QUEUE'
    @queue.push queue
    @state.dispatch
      type: 'PERSONSCLUB_PROCESS'

  pause: () ->
    @queue.pause()

  resume: () ->
    @queue.resume()

  constructor: ( @state ) ->
    @setup()
    @delegateEvents()
