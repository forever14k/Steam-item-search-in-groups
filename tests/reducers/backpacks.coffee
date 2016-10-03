describe 'reducers/backpacks', () ->
  beforeEach () ->
    @mockState =
      items: [
        {
          itemId: '0'
          descriptionId: '0_1'
          person:
            steamId32: '443336602'
            steamId64: '76561198004602330'
            state: 'PERSON_LOADED'
            status: 'STATUS_INGAME'
          color: 'ffffff'
        }
        {
          itemId: '1'
          descriptionId: '0_2'
          person:
            steamId32: '443336602'
            steamId64: '76561198004602330'
            state: 'PERSON_LOADED'
            status: 'STATUS_INGAME'
          color: null
        }
        {
          itemId: '3'
          descriptionId: '0_1'
          person:
            steamId32: '443336602'
            steamId64: '76561198004602330'
            state: 'PERSON_LOADED'
            status: 'STATUS_INGAME'
          color: null
        }
      ]
      descriptions:
        '0_1':
          market_name: 'item 1'
          classid: '0'
          instanceid: '1'
          _sisbftags: [
            {
              category_name: OPTION_TRADABLE
              name: CHOICE_TRADABLE
            }
          ]
        '0_2':
          market_name: 'item 2'
          classid: '0'
          instanceid: '2'
          _sisbftags: [
            {
              category_name: OPTION_TRADABLE
              name: CHOICE_TRADABLE
            }
          ]
        '0_3':
          market_name: 'item 3'
          classid: '0'
          instanceid: '3'
          _sisbftags: [
            {
              category_name: OPTION_TRADABLE
              name: CHOICE_NOTTRADABLE
            }
          ]
      results:
        'STATUS_INGAME':
          '443336602':
            '1':
              asset:
                itemId: '0'
                descriptionId: '0_1'
                person:
                  steamId32: '443336602'
                  steamId64: '76561198004602330'
                  state: 'PERSON_LOADED'
                  status: 'STATUS_INGAME'
                color: 'ffffff'
              person:
                steamId32: '443336602'
                steamId64: '76561198004602330'
                state: 'PERSON_LOADED'
                status: 'STATUS_INGAME'
              description: {}

      state: BACKPACKS_IDLE
      order: [
        STATUS_ONLINE
        STATUS_INGAME
        STATUS_OFFLINE
        STATUS_UNKNOWN
      ]

  afterEach () ->
    @mockState = null

  describe '.reset()', () ->
    beforeEach () ->
      @mockAction =
        type: REDUX_INIT
      @testState = BackpacksReducer::reset @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should reset .items[]', () ->
      expect( @mockState.items.length ).toBe( 0 )

    it 'it should reset .descriptions{}', () ->
      expect( _.keys( @mockState.descriptions ).length ).toBe( 0 )

    it 'it should reset .results[]', () ->
      expect( _.keys( @mockState.results ).length ).toBe( 0 )

    it "it should set .state to #{BACKPACKS_NOTDISPLAYED}", () ->
      expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.state()', () ->
    beforeEach () ->
      @mockAction =
        type: BACKPACKS_NOTDISPLAYED
      @testState = BackpacksReducer::state @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should set .state to action.type', () ->
      expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.push()', () ->
    it 'it should not treat failed backpacks', () ->
      mockAction =
        type: PERSON_LOADED
        backpack:
          success: false
      spyOn @mockState.items, 'push'

      BackpacksReducer::push @mockState, mockAction
      expect( @mockState.items.push ).not.toHaveBeenCalled()

    beforeEach () ->
      @mockAction =
        type: PERSON_LOADED
        backpack:
          success: true
          rgInventory:
            '14000':
              id: '14000'
              classid: '0'
              instanceid: '14000'
          rgDescriptions:
            '0_14000':
              _sisbftags: [
                {
                  category_name: OPTION_COLOR
                  name: 'ffffff'
                  color: 'ffffff'
                }
              ]
        person:
          steamId32: '443336602'
          steamId64: '76561198004602330'
          state: 'PERSON_LOADED'
          status: 'STATUS_INGAME'

    afterEach () ->
      @mockAction = null

    it 'it should detect description color', () ->
      spyOn @mockState.items, 'push'

      BackpacksReducer::push @mockState, @mockAction
      expect( @mockState.items.push ).toHaveBeenCalledWith jasmine.objectContaining
        color: 'ffffff'

    beforeEach () ->
      @testState = BackpacksReducer::push @mockState, @mockAction

    afterEach () ->
      @testState = null

    it 'it should push item description to .descriptions', () ->
      expect( @mockState.descriptions[ '0_14000' ] ).toBeDefined()

    it 'it should push item asset to .items', () ->
      expect( _.find( @mockState.items, itemId: '14000' ) ).toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.passed()', () ->
    beforeEach () ->
      @mockState.results = {}
      @testState = BackpacksReducer::passed @mockState, '0_1'

    afterEach () ->
      @testState = null

    it 'it should populate results with passed descriptionId', () ->
      expect( @mockState.results?[ STATUS_INGAME ]?[ '443336602' ]?[ 0 ] ).toBeDefined()
      expect( @mockState.results?[ STATUS_INGAME ]?[ '443336602' ]?[ 3 ] ).toBeDefined()
      expect( @mockState.results?[ STATUS_INGAME ]?[ '443336602' ]?[ 1 ] ).not.toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.search()', () ->
    beforeEach () ->
      @mockAction =
        type: BACKPACKS_SEARCH
        search: ''
        filters: {}
      @mockAction.filters[ OPTION_TRADABLE ] =
        enabled: true
        selected: [
          {
            name: CHOICE_TRADABLE
          }
        ]
      @testState = BackpacksReducer::search @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should populate results', () ->
      expect( _.keys( @mockState.results?[ STATUS_INGAME ]?[ '443336602' ] ).length ).toBe( 3 )

    it "it should set .state to #{BACKPACKS_NOTDISPLAYED}", () ->
      expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.filter()', () ->
    it 'it should check market_name', () ->
      search = ''
      filters = {}
      description =
        market_name: ''
      inspection = BackpacksReducer::filter description, search, filters
      expect( inspection ).toBe( true )

    it 'it should compare search string to market_name', () ->
      search = 'item'
      filters = {}
      description =
        market_name: 'item 1'
      inspection = BackpacksReducer::filter description, search, filters
      expect( inspection ).toBe( true )

    it 'it should check .tags', () ->
      search = ''
      filters = {}
      filters[ OPTION_TRADABLE ] =
        selected: {
          name: CHOICE_TRADABLE
        }
      description =
        market_name: ''
        tags: [
          {
            category_name: OPTION_TRADABLE
            name: CHOICE_TRADABLE
          }
        ]
      inspection = BackpacksReducer::filter description, search, filters
      expect( inspection ).toBe( true )
    it 'it should check .sisbftags', () ->
      search = ''
      filters = {}
      filters[ OPTION_TRADABLE ] =
        selected: {
          name: CHOICE_TRADABLE
        }
      description =
        market_name: ''
        _sisbftags: [
          {
            category_name: OPTION_TRADABLE
            name: CHOICE_TRADABLE
          }
        ]
      inspection = BackpacksReducer::filter description, search, filters
      expect( inspection ).toBe( true )

  describe '.reducer()', () ->
    beforeEach () ->
      @testBackpacksReducer = new BackpacksReducer

    afterEach () ->
      @testBackpacksReducer = null

    it 'it should set initial state', () ->
      testState = @testBackpacksReducer undefined, type: '@@sisbf/TEST'
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      testState = @testBackpacksReducer @mockState, type: '@@sisbf/TEST'
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should reset state', () ->
        mockAction =
          type: REDUX_INIT

        @testBackpacksReducer @mockState, mockAction
        expect( @mockState.items.length ).toBe( 0 )
        expect( _.keys( @mockState.descriptions ).length ).toBe( 0 )
        expect( _.keys( @mockState.results ).length ).toBe( 0 )
        expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    describe SETTINGS_CHANGED, () ->
      it 'it should reset state', () ->
        mockAction =
          type: SETTINGS_CHANGED

        @testBackpacksReducer @mockState, mockAction
        expect( @mockState.items.length ).toBe( 0 )
        expect( _.keys( @mockState.descriptions ).length ).toBe( 0 )
        expect( _.keys( @mockState.results ).length ).toBe( 0 )
        expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    describe PERSON_LOADED, () ->
      it 'it should populate state filters', () ->
        mockAction =
          type: PERSON_LOADED
          backpack:
            success: true
            rgInventory:
              '14000':
                id: '14000'
                classid: '0'
                instanceid: '14000'
            rgDescriptions:
              '0_14000':
                _sisbftags: [
                  {
                    category_name: OPTION_COLOR
                    name: 'ffffff'
                    color: 'ffffff'
                  }
                ]
          person:
            steamId32: '443336602'
            steamId64: '76561198004602330'
            state: 'PERSON_LOADED'
            status: 'STATUS_INGAME'

        @testBackpacksReducer @mockState, mockAction
        expect( @mockState.descriptions[ '0_14000' ] ).toBeDefined()
        expect( _.find( @mockState.items, itemId: '14000' ) ).toBeDefined()

    describe BACKPACKS_SEARCH, () ->
      it 'it should search items using action.filters', () ->
        mockAction =
          type: BACKPACKS_SEARCH
          search: ''
          filters: {}
        mockAction.filters[ OPTION_TRADABLE ] =
          enabled: true
          selected: [
            {
              name: CHOICE_TRADABLE
            }
          ]

        @testBackpacksReducer @mockState, mockAction
        expect( _.keys( @mockState.results?[ STATUS_INGAME ]?[ '443336602' ] ).length ).toBe( 3 )
        expect( @mockState.state ).toBe( BACKPACKS_NOTDISPLAYED )

    describe BACKPACKS_DISPLAYED, () ->
      it "it should set .state to #{BACKPACKS_DISPLAYED}", () ->
        mockAction =
          type: BACKPACKS_DISPLAYED

        @testBackpacksReducer @mockState, mockAction
        expect( @mockState.state ).toBe( BACKPACKS_DISPLAYED )

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn PersonsReducer::, 'reducer'

      testBackpacksReducer = new PersonsReducer
      testBackpacksReducer undefined, type: '@@sisbf/TEST'
      expect( PersonsReducer::reducer ).toHaveBeenCalledWith undefined, type: '@@sisbf/TEST'
