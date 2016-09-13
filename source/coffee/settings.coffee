class Settings
  options:
    appid: 570
    contextid: 2
    interval: 4300
    cookie: 'strInventoryLastContext'

  get: ( key ) ->
    @options[ key ] if @options[ key ]?
  set: ( key, value ) ->
    @options[ key ] = value if key? and value?


  update: () ->
    lastContext = $.cookie(@options.cookie)
    if lastContext?
      lastContext = lastContext.split '_'
      @set 'appid', lastContext.shift()
      @set 'contextid', lastContext.shift()
    else
      $.cookie @options.cookie, "#{@get('appid')}_#{@get('contextid')}", { expires: 7, path: '/' }

  constructor: ( options ) ->
    @options = _.extend {}, @options, options if options?
    @update()
