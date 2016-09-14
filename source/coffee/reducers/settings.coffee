Settings =

  initialState:
    appid: 570
    contextid: 2
    interval: 4300
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
    Settings.getCookie state
    Settings.setCookie state
    return state

  reducer: ( state = Settings.initialState, action ) ->
    switch action.type
      when '@@redux/INIT'
        Settings.checkCookie state
      when 'SETTINGS_CHANGED'
        state.appid = action.data.appid if action.data?.appid?
        state.contextid = action.data.contextid if action.data?.contextid?
        Settings.setCookie state
      when 'APPID_CHANGED'
        state.appid = action.data.appid if action.data?.appid?
        Settings.setCookie state
      when 'CONTEXTID_CHANGED'
        state.contextid = action.data.contextid if action.data?.contextid?
        Settings.setCookie state
    return state
