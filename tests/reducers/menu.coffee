describe 'reducers/menu', () ->
  beforeEach () ->
    @mockState =
      appid: 570
      contextid: 2
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
        appid: 440

      MenuReducer::appid @mockState, mockAction
      expect( @mockState.appid ).toBe( mockAction.appid )

    it 'it should not update appid if appid in action is not specified', () ->
      mockAction =
        contextid: 6

      MenuReducer::appid @mockState, mockAction
      expect( @mockState.appid ).toBe( 570 )

  describe '.contextid()', () ->
    it 'it should update contextid in state from action', () ->
      mockAction =
        contextid: 6

      MenuReducer::contextid @mockState, mockAction
      expect( @mockState.contextid ).toBe( mockAction.contextid )

    it 'it should not update contextid if contextid in action is not specified', () ->
      mockAction =
        appid: 440

      MenuReducer::contextid @mockState, mockAction
      expect( @mockState.contextid ).toBe( 2 )

  describe '.search()', () ->
    it 'it should update search in state from action', () ->
      mockAction =
        search: 'sisbf'

      MenuReducer::search @mockState, mockAction
      expect( @mockState.search ).toBe( mockAction.search )

    it 'it should not update search if search in action is not specified', () ->
      mockAction =
        contextid: 2

      MenuReducer::search @mockState, mockAction
      expect( @mockState.search ).toBe( '' )

  describe '.reducer()', () ->
    beforeEach () ->
      @testMenuReducer = new MenuReducer

    afterEach () ->
      @testMenuReducer = null

    it 'it should set initial state', () ->
      state = @testMenuReducer undefined, type: '@@sisbf/TEST'
      expect( state ).toBeDefined()

    describe REDUX_INIT, () ->
      it 'it should call .checkCookie', () ->
        mockAction =
          type: REDUX_INIT
        spyOn MenuReducer::, 'checkCookie'

        @testMenuReducer @mockState, mockAction
        expect( MenuReducer::checkCookie ).toHaveBeenCalled()

    describe SETTINGS_CHANGED, () ->
      beforeEach () ->
        @mockAction =
          type: SETTINGS_CHANGED
          appid: 570
          contextid: 2

      afterEach () ->
        @mockAction = null

      it 'it should call .appid()', () ->
        spyOn MenuReducer::, 'appid'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::appid ).toHaveBeenCalled()

      it 'it should call .contextid()', () ->
        spyOn MenuReducer::, 'contextid'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::contextid ).toHaveBeenCalled()

      it 'it should call .setCookie()', () ->
        spyOn MenuReducer::, 'setCookie'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::setCookie ).toHaveBeenCalled()

    describe APPID_CHANGED, () ->
      beforeEach () ->
        @mockAction =
          type: APPID_CHANGED
          appid: 570

      afterEach () ->
        @mockAction = null

      it 'it should call .appid()', () ->
        spyOn MenuReducer::, 'appid'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::appid ).toHaveBeenCalled()

      it 'it should call .setCookie()', () ->
        spyOn MenuReducer::, 'setCookie'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::setCookie ).toHaveBeenCalled()

    describe CONTEXTID_CHANGED, () ->
      beforeEach () ->
        @mockAction =
          type: CONTEXTID_CHANGED
          contextid: 2

      afterEach () ->
        @mockAction = null

      it 'it should call .contextid()', () ->
        spyOn MenuReducer::, 'contextid'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::contextid ).toHaveBeenCalled()

      it 'it should call .setCookie()', () ->
        spyOn MenuReducer::, 'setCookie'

        @testMenuReducer @mockState, @mockAction
        expect( MenuReducer::setCookie ).toHaveBeenCalled()

    describe SEARCH_CHANGED, () ->
      it 'it should call .search()'
