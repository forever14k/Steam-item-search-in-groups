describe 'reducers/menu', () ->
  beforeEach () ->
    @mockState =
      appid: '570'
      contextid: '2'
      search: ''
      cookie: 'strInventoryLastContext'
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
      @mockAction =
        appid: '440'
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
      @mockAction =
        contextid: '6'
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
      @mockAction =
        search: 'sisbf'
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
      testState = @testMenuReducer undefined, type: '@@sisbf/TEST'
      expect( testState ).toBeDefined()

    it 'it should return new state', () ->
      testState = @testMenuReducer @mockState, type: '@@sisbf/TEST'
      expect( testState ).toEqual( @mockState )

    describe REDUX_INIT, () ->
      it 'it should set appid and contextid from Steam Last Inventory cookie', () ->
        mockAction =
          type: REDUX_INIT
        $.cookie @mockState.cookie, '753_6'

        @testMenuReducer @mockState, mockAction
        expect( @mockState.appid ).toBe( '753' )
        expect( @mockState.contextid ).toBe( '6' )
        expect( $.cookie( @mockState.cookie ) ).toBe( '753_6' )

    describe SETTINGS_CHANGED, () ->
      beforeEach () ->
        @mockAction =
          type: SETTINGS_CHANGED
          appid: '730'
          contextid: '4'

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
        @mockAction =
          type: APPID_CHANGED
          appid: '730'

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
        @mockAction =
          type: CONTEXTID_CHANGED
          contextid: '4'

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
        mockAction =
          type: SEARCH_CHANGED
          search: 'sisbf'

        @testMenuReducer @mockState, mockAction
        expect( @mockState.search ).toBe( 'sisbf' )

  describe '.constructor()', () ->
    it 'it should return .reducer()', () ->
      spyOn MenuReducer::, 'reducer'

      testMenuReducer = new MenuReducer
      testMenuReducer undefined, type: '@@sisbf/TEST'
      expect( MenuReducer::reducer ).toHaveBeenCalledWith undefined, type: '@@sisbf/TEST'
