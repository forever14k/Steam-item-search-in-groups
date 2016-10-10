class BackpackGroupssView extends BackpacksView

  elAppendTo: '#memberList'

  reset: () ->
    @$el.remove()

    @append()
    @render()
    @updateSelectors()

  append: () ->
    $( @elAppendTo ).before sisbf.backpacks_container @state.getState()
    @updateSelectors()

  onWindowMessage: ( event ) ->
    data = event?.originalEvent?.data
    if data?.hook__FlipToTab?.tab is 'members'
      @reset()
