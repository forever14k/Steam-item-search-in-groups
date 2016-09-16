class Queue
  
  state: null
  queue: null

  delegateEvents: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    state = @state.getState().Persons.state
    switch state
      when 'PERSONSCLUB_QUEUE', 'PERSONSCLUB_RESUME'
        @start()
      when 'PERSONSCLUB_PAUSE'
        @pause()

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

  start: () ->
    persons = @state.getState().Persons.persons
    queue = _.filter persons, state: 'PERSON_QUEUE'
    @queue._tasks.empty()
    @queue.push queue
    @queue.resume()
    @state.dispatch
      type: 'PERSONSCLUB_PROCESS'

  pause: () ->
    @queue.pause()

  constructor: ( @state ) ->
    @setup()
    @delegateEvents()
