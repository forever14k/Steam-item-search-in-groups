class Queue
  state: null
  queue: null

  delegateEvents: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    state = @state.getState().Backpacks.state
    switch state
      when 'BACKPACKS_QUEUE'
        @populate()
      when 'BACKPACKS_PAUSE'
        @pause()
      when 'BACKPACKS_RESUME'
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
      data._timeout = setTimeout callback, @state.getState().Backpacks.delay
    ), 1
    @queue.drain = () =>
      @state.dispatch
        type: 'BACKPACKS_DRAIN'

  populate: () ->
    persons = @state.getState().Backpacks.persons
    queue = _.filter persons, state: 'PERSON_QUEUE'
    @queue.push queue
    @state.dispatch
      type: 'BACKPACKS_PROCESS'

  pause: () ->
    @queue.pause()

  resume: () ->
    @queue.resume()

  constructor: ( @state ) ->
    @setup()
    @delegateEvents()
