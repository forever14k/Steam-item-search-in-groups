class MenuGroupsView extends MenuView

  elAppendTo: '#memberList'

  reset: () ->
    @$el.remove()

    @append()
    @render()
    @updateSelectors()

    @state.dispatch
      type: SETTINGS_CHANGED

  append: () ->
    $( @elAppendTo ).before sisbf.menu_container @state.getState()
    @updateSelectors()

  update: () ->
    @updateSelectors()
    if @$el.length isnt 0
      super

  onWindowMessage: ( event ) ->
    data = event?.originalEvent?.data
    if data?.hook__FlipToTab?.tab is 'members'
      @reset()
