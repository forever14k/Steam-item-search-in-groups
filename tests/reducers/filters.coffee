describe 'reducers/filters', () ->
  beforeEach () ->
    @mockState = _.cloneDeep __mock__[ 'filters/initialState' ]
  afterEach () ->
    @mockState = null

  describe '.reset()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'actionReduxInit' ]
      @testState = FiltersReducer::reset @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should disable all filters', () ->
      _.each @mockState, ( filter ) =>
        expect( filter.enabled ).toBe( false )

    it 'it should clear all options', () ->
      _.each @mockState, ( filter ) =>
        expect( filter.options.length ).toBe( 0 )

    it 'it should clear all selected options', () ->
      _.each @mockState, ( filter ) =>
        expect( filter.selected.length ).toBe( 0 )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.push()', () ->
    beforeEach () ->
      @idleOptions = FiltersReducer::idleOptions
      FiltersReducer::idleOptions = __mock__[ 'filters/functionPushIdleOptions' ]
      _.each __mock__[ 'filters/functionPushOptions' ], ( data ) =>
        @testState = FiltersReducer::push @mockState, data[ 0 ], data[ 1 ], data[ 2 ]

    afterEach () ->
      FiltersReducer::idleOptions = @idleOptions
      @testState = null

    it 'it should create new filter', () ->
      expect( @mockState[ 'Tradable' ] ).toBeDefined()

    it 'it should push option to filter', () ->
      expect( @mockState[ 'Tradable' ].options.length ).toBe( 2 )

    it 'it should support option color', () ->
      expect( _.first( @mockState[ 'Tradable' ].options ).color ).toBe( 'ffffff' )

    it 'it should enable filter if atleast 1 option', () ->
      expect( @mockState[ 'Marketable' ].enabled ).toBe( true )

    describe 'idle filters', () ->
      it 'it should not enable filter if only 1 option', () ->
        expect( @mockState[ 'Name Changed' ].enabled ).toBe( false )

      it 'it should enable filter if more then 1 options', () ->
        expect( @mockState[ 'Description Changed' ].enabled ).toBe( true )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.process()', () ->
    it 'it should not .push() filter if tag is disclosed ( ._filter: true )', () ->
      spyOn FiltersReducer::, 'push'

      FiltersReducer::process @mockState, __mock__[ 'filters/functionProcessTrue' ]
      expect( FiltersReducer::push ).toHaveBeenCalled()

    it 'it should not .push() filter if tag is disclosed ( ._filter: undefined )', () ->
      spyOn FiltersReducer::, 'push'

      FiltersReducer::process @mockState, __mock__[ 'filters/functionProcessUndefined' ]
      expect( FiltersReducer::push ).toHaveBeenCalled()

    it 'it should .push() filter if tag is not disclosed ( ._filter: false )', () ->
      spyOn FiltersReducer::, 'push'

      FiltersReducer::process @mockState, __mock__[ 'filters/functionProcessFalse' ]
      expect( FiltersReducer::push ).not.toHaveBeenCalled()

    it 'it should support tag color', () ->
      spyOn FiltersReducer::, 'push'

      FiltersReducer::process @mockState, __mock__[ 'filters/functionProcessColorFfffff' ]
      expect( FiltersReducer::push ).toHaveBeenCalledWith @mockState, 'Tradable', 'Tradable', 'ffffff'

    it 'it should return new state', () ->
      testState = FiltersReducer::process @mockState, __mock__[ 'filters/functionProcessTrue' ]
      expect( testState ).toEqual( @mockState )

  describe '.filter()', () ->
    it 'it should not treat failed backpacks', () ->
      @mockAction = __mock__[ 'filters/actionPersonLoadedFalse' ]

      testState = FiltersReducer::filter @mockState, @mockAction
      expect( @mockState[ 'Clean' ] ).not.toBeDefined()

    beforeEach () ->
      @mockAction = __mock__[ 'filters/actionPersonLoaded' ]
      @testState = FiltersReducer::filter @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should process descriptions .tags', () ->
      expect( @mockState[ 'Tradable' ] ).toBeDefined()

    it 'it should process descriptions .sisbftags', () ->
      expect( @mockState[ 'Marketable' ] ).toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.select()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'filters/actionFiltersSelectedInitialThird' ]
      @testState = FiltersReducer::select @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should push filter option to selected', () ->
      expect( _.find( @mockState.initial.selected, name: 'third' ) ).toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.remove()', () ->
    beforeEach () ->
      @mockState.initial = __mock__[ 'filters/stateInitialSelectedSecond' ]
      @mockAction = __mock__[ 'filters/actionFiltersRemovedInitialSecond' ]
      @testState = FiltersReducer::remove @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should remove selected option from filter', () ->
      expect( _.find( @mockState.initial.selected, name: 'second' ) ).not.toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.reducer()', () ->
    beforeEach () ->
      @testFiltersReducer = new FiltersReducer

    afterEach () ->
      @testFiltersReducer = null

    it 'it should set initial state', () ->
      mockAction = __mock__[ 'actionTest' ]

      testState = @testFiltersReducer undefined, mockAction
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      mockAction = __mock__[ 'actionTest' ]

      testState = @testFiltersReducer @mockState, mockAction
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should reset state', () ->
        mockAction = __mock__[ 'actionReduxInit' ]

        @testFiltersReducer @mockState, mockAction
        _.each @mockState, ( filter ) =>
            expect( filter.enabled ).toBe( false )
            expect( filter.options.length ).toBe( 0 )
            expect( filter.selected.length ).toBe( 0 )

    describe SETTINGS_CHANGED, () ->
      it 'it should reset state', () ->
        mockAction = __mock__[ 'filters/actionSettingsChanged730_4' ]

        @testFiltersReducer @mockState, mockAction
        _.each @mockState, ( filter ) =>
            expect( filter.enabled ).toBe( false )
            expect( filter.options.length ).toBe( 0 )
            expect( filter.selected.length ).toBe( 0 )

    describe PERSON_LOADED, () ->
      it 'it should treat backpacks to filters', () ->
        mockAction = __mock__[ 'filters/actionPersonLoaded' ]

        @testFiltersReducer @mockState, mockAction
        expect( @mockState[ OPTION_TRADABLE ] ).toBeDefined()
        expect( @mockState[ OPTION_MARKETABLE ] ).toBeDefined()

    describe FILTERS_SELECTED, () ->
      it 'it should select option in filter', () ->
        mockAction = __mock__[ 'filters/actionFiltersSelectedInitialThird' ]

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'third' ) ).toBeDefined()

    describe FILTERS_REMOVED, () ->
      it 'it should remove selected option in filter', () ->
        @mockState.initial = __mock__[ 'filters/stateInitialSelectedSecond' ]
        mockAction = __mock__[ 'filters/actionFiltersRemovedInitialSecond' ]

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'second' ) ).not.toBeDefined()

    describe FILTERS_REPLACED, () ->
      it 'it should replace selected option in filter', () ->
        @mockState.initial = __mock__[ 'filters/stateInitialSelectedSecond' ]
        mockAction = __mock__[ 'filters/actionFiltersReplacedInitialSecondThird' ]

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'third' ) ).toBeDefined()
        expect( _.find( @mockState.initial.selected, name: 'second' ) ).not.toBeDefined()

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn FiltersReducer::, 'reducer'

      mockAction = __mock__[ 'actionTest' ]
      testFiltersReducer = new FiltersReducer
      testFiltersReducer undefined, mockAction
      expect( FiltersReducer::reducer ).toHaveBeenCalledWith undefined, mockAction
