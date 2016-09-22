class BackpacksView

  $el: null
  state: null

  subscribe: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    @update()
    
  profiles: () ->
    @$el
      .find '.backpack .user'
      .each ( index, user ) ->
        $user = $ user
        steamId32 = $user.attr 'data-steamid32'
        $profile = $ "[data-miniprofile=#{steamId32}]"
        $profile
          .clone()
          .appendTo $user

  append: () ->
    $ '.maincontent'
      .prepend sisbf.backpacks_container()
    @$el = $ '.backpacks'

  render: () ->
    @$el.html sisbf.backpacks_backpacks @state.getState()
    @profiles()

  update: () ->
    state = @state.getState().Backpacks
    if state.state is BACKPACKS_NOTDISPLAYED
      @render()
      @state.dispatch
        type: BACKPACKS_DISPLAYED

  constructor: ( @state ) ->
    @append()
    @render()
    @subscribe()
