describe 'reducers/persons', () ->
  beforeEach () ->
    @mockState = _.cloneDeep __mock__[ 'persons/initialState' ]

  afterEach () ->
    @mockState = null

  describe '.reset()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'actionReduxInit' ]
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
      @mockAction = __mock__[ 'persons/actionPerconClubAdd2' ]
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
      @mockAction = __mock__[ 'persons/actionPersonAdd41208521' ]
      @testState = PersonsReducer::unshift @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should unshift person to .persons[]', () ->
      expect( _.first( @mockState.persons ) ).toEqual jasmine.objectContaining
        steamId32: '41208521'

    it 'it should update .total state', () ->
      expect( @mockState.total ).toBe( 4 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.queue()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'persons/actionPerconClubQueue' ]
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
      @mockAction = __mock__[ 'persons/actionPerconClubProcess' ]
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
      @mockAction = __mock__[ 'persons/actionPersonLoading44336602' ]
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
      @mockAction = __mock__[ 'persons/actionPersonLoaded44336602' ]
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
      mockAction = __mock__[ 'actionTest' ]
      testState = @testPersonsReducer undefined, mockAction
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      mockAction = __mock__[ 'actionTest' ]
      testState = @testPersonsReducer @mockState, mockAction
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should reset state', () ->
        mockAction = __mock__[ 'actionReduxInit' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_OUTDATED )
        expect( @mockState.persons.length ).toBe( 0 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 0 )

    describe SETTINGS_CHANGED, () ->
      it 'it should reset state', () ->
        mockAction = __mock__[ 'persons/actionSettingsChanged730_4' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_OUTDATED )
        expect( @mockState.persons.length ).toBe( 0 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 0 )

    describe PERSONSCLUB_ADD, () ->
      it 'it should populate state with persons', () ->
        mockAction = __mock__[ 'persons/actionPerconClubAdd2' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_IDLE )
        expect( @mockState.persons.length ).toBe( 2 )
        expect( @mockState.current ).toBe( 0 )
        expect( @mockState.total ).toBe( 2 )

    describe PERSONSCLUB_QUEUE, () ->
      beforeEach () ->
        @mockAction = __mock__[ 'persons/actionPerconClubQueue' ]

        @testPersonsReducer @mockState, @mockAction

      afterEach () ->
        @mockAction = null

      it "it should set .state to #{PERSONSCLUB_QUEUE}", () ->
        expect( @mockState.state ).toBe( PERSONSCLUB_QUEUE )

      it "it should set each person state to #{PERSON_QUEUE}", () ->
        expect( _.every( @mockState.persons, state: PERSON_QUEUE ) ).toBeTruthy()

    describe PERSONSCLUB_IDLE, () ->
      it "it should set .state to #{PERSONSCLUB_IDLE}", () ->
        mockAction = __mock__[ 'persons/actionPerconClubIdle' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_IDLE )

    describe PERSONSCLUB_PROCESS, () ->
      it "it should set .state to #{PERSONSCLUB_PROCESS}", () ->
        mockAction = __mock__[ 'persons/actionPerconClubProcess' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_PROCESS )

    describe PERSONSCLUB_PAUSE, () ->
      it "it should set .state to #{PERSONSCLUB_PAUSE}", () ->
        mockAction = __mock__[ 'persons/actionPerconClubPause' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_PAUSE )

    describe PERSONSCLUB_RESUME, () ->
      it "it should set .state to #{PERSONSCLUB_RESUME}", () ->
        mockAction = __mock__[ 'persons/actionPerconClubResume' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_RESUME )

    describe PERSONSCLUB_DRAIN, () ->
      it "it should set .state to #{PERSONSCLUB_DRAIN}", () ->
        mockAction = __mock__[ 'persons/actionPerconClubDrain' ]

        @testPersonsReducer @mockState, mockAction
        expect( @mockState.state ).toBe( PERSONSCLUB_DRAIN )

    describe PERSON_ADD, () ->
      it 'it should unshift person to state', () ->
        mockAction = __mock__[ 'persons/actionPersonAdd41208521' ]

        @testPersonsReducer @mockState, mockAction

        expect( _.first( @mockState.persons ) ).toEqual jasmine.objectContaining
          steamId32: '41208521'
        expect( @mockState.total ).toBe( 4 )

    describe PERSON_LOADING, () ->
      it "it should set person state to #{PERSON_LOADING}", () ->
        mockAction = __mock__[ 'persons/actionPersonLoading44336602' ]

        @testPersonsReducer @mockState, mockAction
        expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_LOADING )

    describe PERSON_ERROR, () ->
      it "it should set person state to #{PERSON_ERROR}", () ->
        mockAction = __mock__[ 'persons/actionPersonError44336602' ]

        @testPersonsReducer @mockState, mockAction
        expect( _.find( @mockState.persons, steamId32: '44336602' ).state ).toBe( PERSON_ERROR )

    describe PERSON_LOADED, () ->
      beforeEach () ->
        @mockAction = __mock__[ 'persons/actionPersonLoaded44336602' ]
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

      mockAction = __mock__[ 'actionTest' ]
      testMenuReducer = new PersonsReducer
      testMenuReducer undefined, mockAction
      expect( PersonsReducer::reducer ).toHaveBeenCalledWith undefined, mockAction
