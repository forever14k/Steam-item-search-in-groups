class SettingsReducer

  initialState:
    appid: 570
    contextid: 2
    cookie: 'strInventoryLastContext'

  setCookie: ( state ) ->
    $.cookie state.cookie, "#{state.appid}_#{state.contextid}", { expires: 7, path: '/' }
    return state

  getCookie: ( state ) ->
    cookie = $.cookie state.cookie
    if cookie?
      cookie = cookie.split '_'
      state.appid = cookie.shift()
      state.contextid = cookie.shift()
    return state

  checkCookie: ( state ) ->
    @getCookie state
    @setCookie state
    return state

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when '@@redux/INIT'
        @checkCookie state
      when 'SETTINGS_CHANGED'
        state.appid = action.data.appid if action.data?.appid?
        state.contextid = action.data.contextid if action.data?.contextid?
        @setCookie state
      when 'APPID_CHANGED'
        state.appid = action.data.appid if action.data?.appid?
        @setCookie state
      when 'CONTEXTID_CHANGED'
        state.contextid = action.data.contextid if action.data?.contextid?
        @setCookie state
    return state

  constructor: () ->
    return @reducer.bind @
