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
    it 'it should set Steam Last Inventory cookie from state', () ->
      MenuReducer::setCookie @mockState
      expect( $.cookie( @mockState.cookie ) ).toBe( '570_2' )

  describe '.getCookie()', () ->
    it 'it should get Steam Last Inventory cookie to state', () ->
      $.cookie @mockState.cookie, '753_6'

      MenuReducer::getCookie @mockState
      expect( @mockState.appid ).toBe( '753' )
      expect( @mockState.contextid ).toBe( '6' )

  describe '.checkCookie()', () ->
    it 'it should update state from Steam Last Inventory cookie', () ->
      $.cookie @mockState.cookie, '753_6'

      MenuReducer::checkCookie @mockState
      expect( @mockState.appid ).toBe( '753' )
      expect( @mockState.contextid ).toBe( '6' )
      expect( $.cookie( @mockState.cookie ) ).toBe( '753_6' )

  describe '.appid()', () ->
    it 'it should update appid in state from action', () ->
      mockAction =
        appid: '440'

      MenuReducer::appid @mockState, mockAction
      expect( @mockState.appid ).toBe( '440' )

    it 'it should not update appid if appid in action is not specified', () ->
      mockAction =
        contextid: '6'

      MenuReducer::appid @mockState, mockAction
      expect( @mockState.appid ).toBe( '570' )

  describe '.contextid()', () ->
    it 'it should update contextid in state from action', () ->
      mockAction =
        contextid: '6'

      MenuReducer::contextid @mockState, mockAction
      expect( @mockState.contextid ).toBe( '6' )

    it 'it should not update contextid if contextid in action is not specified', () ->
      mockAction =
        appid: '440'

      MenuReducer::contextid @mockState, mockAction
      expect( @mockState.contextid ).toBe( '2' )

  describe '.search()', () ->
    it 'it should update search in state from action', () ->
      mockAction =
        search: 'sisbf'

      MenuReducer::search @mockState, mockAction
      expect( @mockState.search ).toBe( 'sisbf' )

    it 'it should not update search if search in action is not specified', () ->
      mockAction =
        contextid: '2'

      MenuReducer::search @mockState, mockAction
      expect( @mockState.search ).toBe( '' )

  describe '.reducer()', () ->
    beforeEach () ->
      @testMenuReducer = new MenuReducer
      $.removeCookie @mockState.cookie

    afterEach () ->
      @testMenuReducer = null

    it 'it should set initial state', () ->
      state = @testMenuReducer undefined, type: '@@sisbf/TEST'
      expect( state ).toBeDefined()

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
