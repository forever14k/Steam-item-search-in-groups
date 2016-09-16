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
    state = @state.getState().Settings
    @state.dispatch
      type: 'PERSON_LOADING'
      data: data

    # console.log "//steamcommunity.com/profiles/#{data.steamId64}/inventory/json/#{state.appid}/#{state.contextid}/?l=english"

    setTimeout (()=>
      if Math.random().toFixed() > 0.5
        @state.dispatch
          type: 'PERSON_LOADED'
          data: data
      else
        @queue.unshift data
        @state.dispatch
          type: 'PERSON_ERROR'
          data: data
    ), 100

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
