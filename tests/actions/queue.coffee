describe 'actions/queue', () ->

  beforeEach () ->

    @fakeState =
      state: {}
      dispatch: () ->
        # console.log 'dispatch'
      getState: () ->
        @state
      subscribe: () ->
        # console.log 'subscribe'

    @queue = new Queue @fakeState

    $.ajax = ( options ) ->
      @options = _.extend {}, @options, options
      return {}

  afterEach () ->
    @fakeState = null
    @queue = null

  describe '.setup()', () ->

    it 'it should setup @queue', () ->
      expect(@queue.queue).not.toBeNull()

    describe '@queue should have', () ->

      it '._tasks.empty()', () ->
        expect( @queue.queue._tasks.empty ).toBeDefined()

      it '.drain()', () ->
        expect( @queue.queue.drain ).toBeDefined()

      it '.push()', () ->
        expect( @queue.queue.push ).toBeDefined()

      it '.unshift()', () ->
        expect( @queue.queue.unshift ).toBeDefined()

      it '.pause()', () ->
        expect( @queue.queue.pause ).toBeDefined()

      it '.resume()', () ->
        expect( @queue.queue.resume ).toBeDefined()

  describe '.onStateChange()', () ->

    describe 'it should call .start() when .Persons.state is', () ->

      it 'PERSONSCLUB_QUEUE', () ->

        @fakeState.state.Persons =
          state: PERSONSCLUB_QUEUE

        spyOn @queue, 'start'
        @queue.onStateChange()

        expect( @queue.start ).toHaveBeenCalled()

      it 'PERSONSCLUB_RESUME', () ->

        @fakeState.state.Persons =
          state: PERSONSCLUB_RESUME

        spyOn @queue, 'start'
        @queue.onStateChange()

        expect( @queue.start ).toHaveBeenCalled()

    describe 'it should not call .start() when .Persons.state is', () ->

      it 'other TYPE', () ->

        @fakeState.state.Persons =
          state: PERSONSCLUB_IDLE

        spyOn @queue, 'start'
        @queue.onStateChange()

        expect( @queue.start ).not.toHaveBeenCalled()

    describe 'it should call .pause() when .Persons.state is', () ->

      it 'PERSONSCLUB_PAUSE', () ->

        @fakeState.state.Persons =
          state: PERSONSCLUB_PAUSE

        spyOn @queue, 'pause'
        @queue.onStateChange()

        expect( @queue.pause ).toHaveBeenCalled()

    describe 'it should not call .pause() when .Persons.state is', () ->

      it 'other TYPE', () ->

        @fakeState.state =
          Persons:
            state: PERSONSCLUB_IDLE

        spyOn @queue, 'pause'
        @queue.onStateChange()

        expect( @queue.pause ).not.toHaveBeenCalled()

  describe '.start()', () ->

    beforeEach () ->
      @fakeState.state.Persons =
        persons: [
          {
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_QUEUE
            status: STATUS_ONLINE
          }
          {
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_QUEUE
            status: STATUS_ONLINE
          }
          {
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_IDLE
            status: STATUS_ONLINE
          }
        ]

    describe 'it should populate queue from .Persons.persons', () ->

      it 'where .person.state is PERSON_QUEUE', () ->

        @fakeState.state.Settings =
          appid: 570
          contextid: 2

        @queue.start()
        expect( @queue.queue.length() ).toBe( 2 )

    it 'it should start/resume queue', () ->

      @fakeState.state.Settings =
        appid: 570
        contextid: 2

      spyOn @queue.queue, 'resume'
      @queue.start()
      expect( @queue.queue.resume ).toHaveBeenCalled()

    it 'it should dispatch PERSONSCLUB_PROCESS', () ->

      @fakeState.state.Settings =
        appid: 570
        contextid: 2

      spyOn @fakeState, 'dispatch'
      @queue.start()
      expect( @fakeState.dispatch ).toHaveBeenCalledWith jasmine.objectContaining type: PERSONSCLUB_PROCESS

  describe '.process()', () ->

    it 'it should call Steam public API using .Settings', () ->

      spyOn $, 'ajax'
        .and
        .callThrough()

      @fakeState.state.Settings =
        appid: 570
        contextid: 2

      @queue.process
        steamId32: '44336602'
        steamId64: '76561198004602330'
        state: PERSON_QUEUE
        status: STATUS_ONLINE

      expect( $.ajax ).toHaveBeenCalledWith jasmine.objectContaining url: '//steamcommunity.com/profiles/76561198004602330/inventory/json/570/2/?l=english'

    describe 'it should call', () ->
      it '.onLoading() before API call starts'
      it '.onLoaded() after  API call success'
      it '.onError() after API call fails'

  describe '.onLoading()', () ->

    it 'it should dispatch PERSON_LOADING'

  describe '.onLoaded()', () ->

    it 'it should dispatch PERSON_LOADED'

  describe '.onError()', () ->

    it 'it should unshift person to queue'
    it 'it should dispatch PERSON_ERROR'

  describe '.pause()', () ->

    it 'it should pause queue'
