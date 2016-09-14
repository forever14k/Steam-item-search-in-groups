class Persons
  $el: null
  $persons: null
  state: null

  delegateEvents: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    @highLight()

  highLight: () ->
    persons = @state.getState().Backpacks.persons
    _.each persons, ( person, index ) =>
      $person = @$persons.filter("[data-miniprofile=#{person.steamId32}]")
      switch person.state
        when 'PERSON_QUEUE'
          $person.css 'background', 'none'
        when 'PERSON_IDLE', 'PERSON_LOADED'
          $person.css 'background', ''

  append: () ->
    @$el = $ @state.getState().Backpacks.personClass
      .parent()
    @$persons = $ @state.getState().Backpacks.personClass

  render: () ->
    @delegateEvents()

  constructor: ( state ) ->
    @state = state if state?
    @append()
    @render()
