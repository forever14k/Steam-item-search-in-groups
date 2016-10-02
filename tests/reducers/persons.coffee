describe 'reducers/persons', () ->
  beforeEach () ->
    @mockState =
      state: PERSONSCLUB_IDLE
      current: 1
      total: 3
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

  afterEach () ->
    @mockState = null

  describe '.reset()', () ->
    beforeEach () ->
      @mockAction =
        type: REDUX_INIT
      @testState = PersonsReducer::reset @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it "it should set .state to #{PERSONSCLUB_OUTDATED}", () ->
      expect( @mockState.state ).toBe( PERSONSCLUB_OUTDATED )

    it 'it should reset .persons[]', () ->
      expect( @mockState.persons.length ).toBe( 0 )

    it 'it should reset .current', () ->
      expect( @mockState.current ).toBe( 0 )

    it 'it should reset .total', () ->
      expect( @mockState.total ).toBe( 0 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.populate()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSONSCLUB_ADD
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
        ]
      @testState = PersonsReducer::populate @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it "it should set .state to #{PERSONSCLUB_IDLE}", () ->
      expect( @mockState.state ).toBe( PERSONSCLUB_IDLE )

    it 'it should update .persons[]', () ->
      expect( @mockState.persons.length ).toBe( 2 )

    it 'it should reset .current', () ->
      expect( @mockState.current ).toBe( 0 )

    it 'it should update .total', () ->
      expect( @mockState.total ).toBe( 2 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.unshift()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSON_ADD
        person:
          steamId32: '41208521'
          steamId64: '76561198001474249'
          state: PERSON_IDLE
          status: STATUS_INGAME
      @testState = PersonsReducer::unshift @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should unshift person to .persons[]', () ->
      expect( _.first( @mockState.persons ) ).toEqual
        steamId32: '41208521'
        steamId64: '76561198001474249'
        state: PERSON_IDLE
        status: STATUS_INGAME

    it 'it should update .total state', () ->
      expect( @mockState.total ).toBe( 4 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.queue()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSONSCLUB_QUEUE
      @testState = PersonsReducer::queue @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it "it should set .state to #{PERSONSCLUB_QUEUE}", () ->
      expect( @mockState.state ).toBe( PERSONSCLUB_QUEUE )

    it "it should set each person state to #{PERSON_QUEUE} in .persons[]", () ->
      expect( _.every( @mockState.persons, state: PERSON_QUEUE ) ).toBeTruthy()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.state()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSONSCLUB_PROCESS
      @testState = PersonsReducer::state @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should set .state to action.type', () ->
      expect( @mockState.state ).toBe( PERSONSCLUB_PROCESS )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.statePerson()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSON_LOADING
        person:
          steamId32: '44336602'
          steamId64: '76561198004602330'
          state: PERSON_QUEUE
          status: STATUS_ONLINE
      @testState = PersonsReducer::statePerson @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should find and set person state to action.type', () ->
      expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_LOADING )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.increment()', () ->
    beforeEach () ->
      @mockAction =
        type: PERSON_LOADED
      @testState = PersonsReducer::increment @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should increment .current', () ->
      expect( @mockState.current ).toBe( 2 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.reducer()', () ->
    beforeEach () ->
      @testPersonsReducer = new PersonsReducer

    afterEach () ->
      @testPersonsReducer = null

    it 'it should set initial state', () ->
      testState = @testPersonsReducer undefined, type: '@@sisbf/TEST'
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      testState = @testPersonsReducer @mockState, type: '@@sisbf/TEST'
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should reset state', () ->
        mockAction =
          type: REDUX_INIT

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_OUTDATED )
        expect( @mockState.persons.length ).toBe( 0 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 0 )

    describe SETTINGS_CHANGED, () ->
      it 'it should reset state', () ->
        mockAction =
          type: REDUX_INIT

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_OUTDATED )
        expect( @mockState.persons.length ).toBe( 0 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 0 )

    describe PERSONSCLUB_ADD, () ->
      it 'it should populate state with persons', () ->
        mockAction =
          type: PERSONSCLUB_ADD
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
          ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_IDLE )
        expect( @mockState.persons.length ).toBe( 2 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 2 )

    describe PERSONSCLUB_QUEUE, () ->
      beforeEach () ->
        @mockAction =
          type: PERSONSCLUB_QUEUE

        @testPersonsReducer @mockState, @mockAction

      afterEach () ->
        @mockAction = null

      it "it should set .state to #{PERSONSCLUB_QUEUE}", () ->
        expect( @mockState.state ).toBe( PERSONSCLUB_QUEUE )

      it "it should set each person state to #{PERSON_QUEUE}", () ->
        expect( _.every( @mockState.persons, state: PERSON_QUEUE ) ).toBeTruthy()

    describe PERSONSCLUB_IDLE, () ->
      it "it should set .state to #{PERSONSCLUB_IDLE}", () ->
        mockAction =
          type: PERSONSCLUB_IDLE

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_IDLE )

    describe PERSONSCLUB_PROCESS, () ->
      it "it should set .state to #{PERSONSCLUB_PROCESS}", () ->
        mockAction =
          type: PERSONSCLUB_PROCESS

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_PROCESS )

    describe PERSONSCLUB_PAUSE, () ->
      it "it should set .state to #{PERSONSCLUB_PAUSE}", () ->
        mockAction =
          type: PERSONSCLUB_PAUSE

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_PAUSE )

    describe PERSONSCLUB_RESUME, () ->
      it "it should set .state to #{PERSONSCLUB_RESUME}", () ->
        mockAction =
          type: PERSONSCLUB_RESUME

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_RESUME )

    describe PERSONSCLUB_DRAIN, () ->
      it "it should set .state to #{PERSONSCLUB_DRAIN}", () ->
        mockAction =
          type: PERSONSCLUB_DRAIN

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_DRAIN )

    describe PERSON_ADD, () ->
      it 'it should unshift person to state', () ->
        mockAction =
          type: PERSON_ADD
          person:
            steamId32: '41208521'
            steamId64: '76561198001474249'
            state: PERSON_IDLE
            status: STATUS_INGAME

        @testPersonsReducer @mockState, mockAction

        expect( _.first( @mockState.persons ) ).toEqual
          steamId32: '41208521'
          steamId64: '76561198001474249'
          state: PERSON_IDLE
          status: STATUS_INGAME
        expect( @mockState.total ).toBe( 4 )

    describe PERSON_LOADING, () ->
      it "it should set person state to #{PERSON_LOADING}", () ->
        mockAction =
          type: PERSON_LOADING
          person:
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_QUEUE
            status: STATUS_ONLINE


        @testPersonsReducer @mockState, mockAction
        expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_LOADING )

    describe PERSON_ERROR, () ->
      it "it should set person state to #{PERSON_ERROR}", () ->
        mockAction =
          type: PERSON_ERROR
          person:
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_QUEUE
            status: STATUS_ONLINE


        @testPersonsReducer @mockState, mockAction
        expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_ERROR )

    describe PERSON_LOADED, () ->
      beforeEach () ->
        @mockAction =
          type: PERSON_LOADED
          person:
            steamId32: '44336602'
            steamId64: '76561198004602330'
            state: PERSON_QUEUE
            status: STATUS_ONLINE
        @testState = @testPersonsReducer @mockState, @mockAction

      afterEach () ->
        @mockAction = null
        @testState = null

      it 'it should increment current counter', () ->
        expect( @mockState.current ).toBe( 2 )

      it "it should set person state to #{PERSON_LOADED}", () ->
        expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_LOADED )

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn PersonsReducer::, 'reducer'

      testMenuReducer = new PersonsReducer
      testMenuReducer undefined, type: '@@sisbf/TEST'
      expect( PersonsReducer::reducer ).toHaveBeenCalledWith undefined, type: '@@sisbf/TEST'
