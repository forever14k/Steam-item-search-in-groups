describe 'reducers/menu', () ->
  beforeEach () ->
    @mockState = _.cloneDeep __mock__[ 'menu/initialState' ]
    $.removeCookie @mockState.cookie

  afterEach () ->
    @mockState = null

  describe '.setCookie()', () ->
    beforeEach () ->
      @testState = MenuReducer::setCookie @mockState

    afterEach () ->
      @testState = null

    it 'it should set Steam Last Inventory cookie from state', () ->
      expect( $.cookie( @mockState.cookie ) ).toBe( '570_2' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.getCookie()', () ->
    beforeEach () ->
      $.cookie @mockState.cookie, '753_6'
      @testState = MenuReducer::getCookie @mockState

    afterEach () ->
      @testState = null

    it 'it should get Steam Last Inventory cookie to state', () ->
      expect( @mockState.appid ).toBe( '753' )
      expect( @mockState.contextid ).toBe( '6' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.checkCookie()', () ->
    beforeEach () ->
      $.cookie @mockState.cookie, '753_6'
      @testState = MenuReducer::checkCookie @mockState

    afterEach () ->
      @testState = null

    it 'it should update state from Steam Last Inventory cookie', () ->
      expect( @mockState.appid ).toBe( '753' )
      expect( @mockState.contextid ).toBe( '6' )
      expect( $.cookie( @mockState.cookie ) ).toBe( '753_6' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.appid()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'menu/actionAppIdChanged440' ]
      @testState = MenuReducer::appid @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should update appid in state from action', () ->
      expect( @mockState.appid ).toBe( '440' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.contextid()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'menu/actionContextIdChanged6' ]
      @testState = MenuReducer::contextid @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should update contextid in state from action', () ->
      expect( @mockState.contextid ).toBe( '6' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.search()', () ->
    beforeEach () ->
      @mockAction = __mock__[ 'menu/actionSearchChangedSisbf' ]
      @testState = MenuReducer::search @mockState, @mockAction

    afterEach () ->
      @mockAction = null
      @testState = null

    it 'it should update search in state from action', () ->
      expect( @mockState.search ).toBe( 'sisbf' )

    it 'it should return new state', () ->
      expect( @testState ).toEqual( @mockState )

  describe '.reducer()', () ->
    beforeEach () ->
      @testMenuReducer = new MenuReducer
      $.removeCookie @mockState.cookie

    afterEach () ->
      @testMenuReducer = null

    it 'it should set initial state', () ->
      mockAction = __mock__[ 'actionTest' ]
      testState = @testMenuReducer undefined, mockAction
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      mockAction = __mock__[ 'actionTest' ]
      testState = @testMenuReducer @mockState, mockAction
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should set appid and contextid from Steam Last Inventory cookie', () ->
        mockAction = __mock__[ 'actionReduxInit' ]
        $.cookie @mockState.cookie, '753_6'

        @testMenuReducer @mockState, mockAction
        expect( @mockState.appid ).toBe( '753' )
        expect( @mockState.contextid ).toBe( '6' )
        expect( $.cookie( @mockState.cookie ) ).toBe( '753_6' )

    describe SETTINGS_CHANGED, () ->
      beforeEach () ->
        @mockAction = __mock__[ 'menu/actionSettingsChanged730_4' ]

      afterEach () ->
        @mockAction = null

      it 'it should update state appid and contextid', () ->
        @testMenuReducer @mockState, @mockAction
        expect( @mockState.appid ).toBe( '730' )
        expect( @mockState.contextid ).toBe( '4' )

      it 'it should set Steam Last Inventory cookie', () ->
        @testMenuReducer @mockState, @mockAction
        expect( $.cookie( @mockState.cookie ) ).toBe( '730_4' )

    describe APPID_CHANGED, () ->
      beforeEach () ->
        @mockAction = __mock__[ 'menu/actionAppIdChanged730' ]

      afterEach () ->
        @mockAction = null

      it 'it should update state appid', () ->
        @testMenuReducer @mockState, @mockAction
        expect( @mockState.appid ).toBe( '730' )

      it 'it should set Steam Last Inventory cookie', () ->
        @testMenuReducer @mockState, @mockAction
        expect( $.cookie( @mockState.cookie ) ).toBe( '730_2' )

    describe CONTEXTID_CHANGED, () ->
      beforeEach () ->
        @mockAction = __mock__[ 'menu/actionContextIdChanged4' ]

      afterEach () ->
        @mockAction = null

      it 'it should update state contextid', () ->
        @testMenuReducer @mockState, @mockAction
        expect( @mockState.contextid ).toBe( '4' )

      it 'it should set Steam Last Inventory cookie', () ->
        @testMenuReducer @mockState, @mockAction
        expect( $.cookie( @mockState.cookie ) ).toBe( '570_4' )

    describe SEARCH_CHANGED, () ->
      it 'it should update state search', () ->
        mockAction = __mock__[ 'menu/actionSearchChangedSisbf' ]

        @testMenuReducer @mockState, mockAction
        expect( @mockState.search ).toBe( 'sisbf' )

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn MenuReducer::, 'reducer'

      mockAction = __mock__[ 'actionTest' ]
      testMenuReducer = new MenuReducer
      testMenuReducer undefined, mockAction
      expect( MenuReducer::reducer ).toHaveBeenCalledWith undefined, mockAction
