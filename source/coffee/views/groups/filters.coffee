class FiltersGroupsView extends FiltersView

  elAppendTo: '#memberList'

  reset: () ->
    @$el.remove()

    @append()
    @updateSelectors()

  append: () ->
    $( @elAppendTo ).before sisbf.filters_container @state.getState()
    @updateSelectors()

  onWindowMessage: ( event ) ->
    data = event?.originalEvent?.data
    if data?.hook__FlipToTab?.tab is 'members'
      @reset()
