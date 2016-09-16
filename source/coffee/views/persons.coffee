class PersonsView

  $el: null
  $persons: null
  state: null

  delegateEvents: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    persons = @state.getState().Persons.persons
    _.each persons, ( person, index ) =>
      $person = @$persons.filter("[data-miniprofile=#{person.steamId32}]")
      switch person.state
        when 'PERSON_QUEUE'
          $person.css 'background', 'none'
        when 'PERSON_LOADING'
          $person.css 'background', 'black'
        when 'PERSON_ERROR'
          $person.css 'background', 'red'
        when 'PERSON_IDLE', 'PERSON_LOADED'
          $person.css 'background', ''

  append: () ->
    @$el = $ @state.getState().Persons.personClass
      .parent()
    @$persons = $ @state.getState().Persons.personClass

  render: () ->
    @delegateEvents()

  constructor: ( @state ) ->
    @append()
    @render()
