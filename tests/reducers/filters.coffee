describe 'reducers/filters', () ->
  beforeEach () ->
    @mockState =
      initial:
        enabled: true
        options: [
          {
            name: 'first'
            color: null
          }
          {
            name: 'second'
            color: 'ffffff'
          }
        ]
        selected: [
          {
            name: 'second'
          }
        ]
      Rarity:[
        {
          name: 'Rare'
          color: null
        }
        {
          name: 'Common'
          color: null
        }
      ]
      selected: [
        {
          name: 'Rare'
        }
        {
          name: 'Common'
        }
      ]

  afterEach () ->
    @mockState = null

  describe '.reset()', () ->
    beforeEach () ->
      @mockAction =
        type: REDUX_INIT
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
      FiltersReducer::idleOptions = [
        OPTION_CHANGED_NAME
        OPTION_CHANGED_DESCRIPTION
      ]
      @testState = FiltersReducer::push @mockState, OPTION_TRADABLE, CHOICE_TRADABLE, 'ffffff'
      @testState = FiltersReducer::push @mockState, OPTION_TRADABLE, CHOICE_TRADABLE, null
      @testState = FiltersReducer::push @mockState, OPTION_TRADABLE, CHOICE_NOTTRADABLE, null
      @testState = FiltersReducer::push @mockState, OPTION_MARKETABLE, CHOICE_MARKETABLE, null
      @testState = FiltersReducer::push @mockState, OPTION_CHANGED_NAME, CHOICE_CHANGED_NAME, null
      @testState = FiltersReducer::push @mockState, OPTION_CHANGED_DESCRIPTION, CHOICE_CHANGED_DESCRIPTION, null
      @testState = FiltersReducer::push @mockState, OPTION_CHANGED_DESCRIPTION, CHOICE_NOTCHANGED_DESCRIPTION, null

    afterEach () ->
      FiltersReducer::idleOptions = @idleOptions
      @testState = null

    it 'it should create new filter', () ->
      expect( @mockState[ OPTION_TRADABLE ] ).toBeDefined()

    it 'it should push option to filter', () ->
      expect( @mockState[ OPTION_TRADABLE ].options.length ).toBe( 2 )

    it 'it should support option color', () ->
      expect( _.first( @mockState[ OPTION_TRADABLE ].options ).color ).toBe( 'ffffff' )

    it 'it should enable filter if atleast 1 option', () ->
      expect( @mockState[ OPTION_MARKETABLE ].enabled ).toBe( true )

    describe 'idle filters', () ->
      it 'it should not enable filter if only 1 option', () ->
        expect( @mockState[ OPTION_CHANGED_NAME ].enabled ).toBe( false )

      it 'it should enable filter if more then 1 options', () ->
        expect( @mockState[ OPTION_CHANGED_DESCRIPTION ].enabled ).toBe( true )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.process()', () ->
    it 'it should not .push() filter if tag is disclosed ( ._filter: true )', () ->
      spyOn FiltersReducer::, 'push'
      FiltersReducer::process @mockState,
        _filter: true
        category_name: OPTION_TRADABLE
        name: CHOICE_TRADABLE
      expect( FiltersReducer::push ).toHaveBeenCalled()

    it 'it should not .push() filter if tag is disclosed ( ._filter: undefined )', () ->
      spyOn FiltersReducer::, 'push'
      FiltersReducer::process @mockState,
        category_name: OPTION_TRADABLE
        name: CHOICE_TRADABLE
      expect( FiltersReducer::push ).toHaveBeenCalled()

    it 'it should .push() filter if tag is not disclosed ( ._filter: false )', () ->
      spyOn FiltersReducer::, 'push'
      FiltersReducer::process @mockState,
        _filter: false
        category_name: OPTION_TRADABLE
        name: CHOICE_TRADABLE
      expect( FiltersReducer::push ).not.toHaveBeenCalled()

    it 'it should support tag color', () ->
      spyOn FiltersReducer::, 'push'
      FiltersReducer::process @mockState,
        category_name: OPTION_TRADABLE
        name: CHOICE_TRADABLE
        color: 'ffffff'
      expect( FiltersReducer::push ).toHaveBeenCalledWith @mockState, OPTION_TRADABLE, CHOICE_TRADABLE, 'ffffff'

    it 'it should return new state', () ->
      testState = FiltersReducer::process @mockState,
        category_name: OPTION_TRADABLE
        name: CHOICE_TRADABLE
      expect( testState ).toEqual( @mockState )

  describe '.filter()', () ->
    it 'it should not treat failed backpacks', () ->
      @mockAction =
        type: PERSON_LOADED
        backpack:
          success: false
          rgDescriptions:
            '0_0':
              tags: [
                {
                  category_name: OPTION_CLEAN
                  name: CHOICE_CLEAN
                }
              ]
      testState = FiltersReducer::filter @mockState, @mockAction
      expect( @mockState[ OPTION_CLEAN ] ).not.toBeDefined()

    beforeEach () ->
      @mockAction =
        type: PERSON_LOADED
        backpack:
          success: true
          rgDescriptions:
            '0_0':
              tags: [
                {
                  category_name: OPTION_TRADABLE
                  name: CHOICE_TRADABLE
                }
              ]
              _sisbftags: [
                {
                  category_name: OPTION_MARKETABLE
                  name: CHOICE_MARKETABLE
                }
              ]
      @testState = FiltersReducer::filter @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should process descriptions .tags', () ->
      expect( @mockState[ OPTION_TRADABLE ] ).toBeDefined()

    it 'it should process descriptions .sisbftags', () ->
      expect( @mockState[ OPTION_MARKETABLE ] ).toBeDefined()

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.select()', () ->
    beforeEach () ->
      @mockAction =
        type: FILTERS_SELECTED
        option: 'initial'
        added:
          name: 'third'
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
      @mockState.initial.selected = [
        {
          name: 'second'
        }
      ]
      @mockAction =
        type: FILTERS_REMOVED
        option: 'initial'
        removed:
          name: 'second'
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
      testState = @testFiltersReducer undefined, type: '@@sisbf/TEST'
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      testState = @testFiltersReducer @mockState, type: '@@sisbf/TEST'
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should reset state', () ->
        mockAction =
          type: REDUX_INIT

        @testFiltersReducer @mockState, mockAction
        _.each @mockState, ( filter ) =>
            expect( filter.enabled ).toBe( false )
            expect( filter.options.length ).toBe( 0 )
            expect( filter.selected.length ).toBe( 0 )

    describe SETTINGS_CHANGED, () ->
      it 'it should reset state', () ->
        mockAction =
          type: REDUX_INIT

        @testFiltersReducer @mockState, mockAction
        _.each @mockState, ( filter ) =>
            expect( filter.enabled ).toBe( false )
            expect( filter.options.length ).toBe( 0 )
            expect( filter.selected.length ).toBe( 0 )

    describe PERSON_LOADED, () ->
      it 'it should treat backpacks to filters', () ->
        mockAction =
          type: PERSON_LOADED
          backpack:
            success: true
            rgDescriptions:
              '0_0':
                tags: [
                  {
                    category_name: OPTION_TRADABLE
                    name: CHOICE_TRADABLE
                  }
                ]
                _sisbftags: [
                  {
                    category_name: OPTION_MARKETABLE
                    name: CHOICE_MARKETABLE
                  }
                ]

        @testFiltersReducer @mockState, mockAction
        expect( @mockState[ OPTION_TRADABLE ] ).toBeDefined()
        expect( @mockState[ OPTION_MARKETABLE ] ).toBeDefined()

    describe FILTERS_SELECTED, () ->
      it 'it should select option in filter', () ->
        mockAction =
          type: FILTERS_SELECTED
          option: 'initial'
          added:
            name: 'third'

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'third' ) ).toBeDefined()

    describe FILTERS_REMOVED, () ->
      it 'it should remove selected option in filter', () ->
        @mockState.initial.selected = [
          {
            name: 'second'
          }
        ]
        mockAction =
          type: FILTERS_REMOVED
          option: 'initial'
          removed:
            name: 'second'

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'second' ) ).not.toBeDefined()

    describe FILTERS_REPLACED, () ->
      it 'it should replace selected option in filter', () ->
        @mockState.initial.selected = [
          {
            name: 'second'
          }
        ]
        mockAction =
          type: FILTERS_REPLACED
          option: 'initial'
          removed:
            name: 'second'
          added:
            name: 'third'

        @testFiltersReducer @mockState, mockAction
        expect( _.find( @mockState.initial.selected, name: 'third' ) ).toBeDefined()
        expect( _.find( @mockState.initial.selected, name: 'second' ) ).not.toBeDefined()

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn FiltersReducer::, 'reducer'

      testFiltersReducer = new FiltersReducer
      testFiltersReducer undefined, type: '@@sisbf/TEST'
      expect( FiltersReducer::reducer ).toHaveBeenCalledWith undefined, type: '@@sisbf/TEST'
