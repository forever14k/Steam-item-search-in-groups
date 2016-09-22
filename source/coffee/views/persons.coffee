class PersonsView

  $el: null
  $persons: null
  state: null

  subscribe: () ->
    @state.subscribe @onStateChange.bind @

  onStateChange: () ->
    persons = @state.getState().Persons.persons
    _.each persons, ( person, index ) =>
      $person = @$el.filter("[data-miniprofile=#{person.steamId32}]")
      switch person.state
        when PERSON_QUEUE
          $person
            .removeClass 'sisbf_person--loading sisbf_person--error'
            .addClass 'sisbf_person--queue'
        when PERSON_LOADING
          $person
            .removeClass 'sisbf_person--queue sisbf_person--error'
            .addClass 'sisbf_person--loading'
        when PERSON_ERROR
          $person
            .removeClass 'sisbf_person--queue sisbf_person--loading'
            .addClass 'sisbf_person--error'
        when PERSON_IDLE, PERSON_LOADED
          $person
            .removeClass 'sisbf_person--queue sisbf_person--loading sisbf_person--error'

  append: () ->
    @$el = $ @state.getState().Persons.personSelector

  constructor: ( @state ) ->
    @append()
    @subscribe()
