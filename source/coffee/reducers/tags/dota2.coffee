class TagsDOTA2Reducer extends TagsBaseReducer

  initialState:
    appId: APPID_DOTA2

  middlewares: [
    'tagDOTA2DescEvent'
    'tagDOTA2DescHeroicVictory'
    'tagDOTA2DescHeroicFirstBlood'
    'tagDOTA2DescHeroicDoubleKill'
    'tagDOTA2DescHeroicTripleKill'
    'tagDOTA2DescHeroicUltraKill'
    'tagDOTA2DescHeroicRampage'
    'tagDOTA2DescHeroicGodlike'
    'tagDOTA2DescHeroicCourierKill'
    'tagDOTA2DescHeroicAllyDenied'
    'tagDOTA2DescHeroicAegisDenied'
    'tagDOTA2DescHeroicAegisSnatch'
    'tagDOTA2DescHeroicEarlyRoshan'
    'tagDOTA2DescHeroicRapier'
    'tagDOTA2DescHeroic5EchoSlam'
    'tagDOTA2DescPlayerCardPlayer'
    'tagDOTA2DescPlayerCardTeam'
    'tagDOTA2DescGems'
  ]

  tagDOTA2DescEvent:  ( description ) ->
    config =
      regex: REGEX_EVENT_DOTA2
      option: OPTION_EVENT
    @tagDesc description, config

  tagDOTA2DescHeroicVictory: ( description ) ->
    config =
      regex: REGEX_HEROIC_VICTORY
      option: OPTION_HEROIC
      value: CHOICE_VICTORY
      order: [ OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicFirstBlood: ( description ) ->
    config =
      regex: REGEX_HEROIC_FIRSTBLOOD
      option: OPTION_HEROIC
      value: CHOICE_FIRSTBLOOD
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicDoubleKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_DOUBLEKILL
      option: OPTION_HEROIC
      value: CHOICE_DOUBLEKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicTripleKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_TRIPLEKILL
      option: OPTION_HEROIC
      value: CHOICE_TRIPLEKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicUltraKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_ULKTRAKILL
      option: OPTION_HEROIC
      value: CHOICE_ULTRAKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicRampage: ( description ) ->
    config =
      regex: REGEX_HEROIC_RAPMAGE
      option: OPTION_HEROIC
      value: CHOICE_RAMPAGE
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicGodlike: ( description ) ->
    config =
      regex: REGEX_HEROIC_GODLIKE
      option: OPTION_HEROIC
      value: CHOICE_GODLIKE
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicCourierKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_COURIERKILL
      option: OPTION_HEROIC
      value: CHOICE_COURIERKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicAllyDenied: ( description ) ->
    config =
      regex: REGEX_HEROIC_ALLYDENIED
      option: OPTION_HEROIC
      value: CHOICE_ALLYDENIED
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_PLAYER ]
    @tagDesc description, config

  tagDOTA2DescHeroicAegisDenied: ( description ) ->
    config =
      regex: REGEX_HEROIC_AEGISDENIED
      option: OPTION_HEROIC
      value: CHOICE_AEGISDENIED
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicAegisSnatch: ( description ) ->
    config =
      regex: REGEX_HEROIC_AEGISSNATCH
      option: OPTION_HEROIC
      value: CHOICE_AEGISSNATCH
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicEarlyRoshan: ( description ) ->
    config =
      regex: REGEX_HEROIC_EARLYROSHAN
      option: OPTION_HEROIC
      value: CHOICE_EARLYROSHAN
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroicRapier: ( description ) ->
    config =
      regex: REGEX_HEROIC_RAPIER
      option: OPTION_HEROIC
      value: CHOICE_RAPIER
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescHeroic5EchoSlam: ( description ) ->
    config =
      regex: REGEX_HEROIC_5ECHOSLAM
      option: OPTION_HEROIC
      value: CHOICE_5ECHOSLAM
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDOTA2DescPlayerCardPlayer: ( description ) ->
    config =
      regex: REGEX_PLAYER_DOTA2
      option: OPTION_PLAYER
    @tagDesc description, config

  tagDOTA2DescPlayerCardTeam: ( description ) ->
    config =
      regex: REGEX_TEAM_DOTA2
      option: OPTION_TEAM
    @tagDesc description, config

  tagDOTA2DescGem: ( description, gem ) ->
    trackGem = null
    trackValue = null
    isAutograph = null

    trackGem = gem[ 2 ].match REGEX_TRACK
    if trackGem?
      tag =
        category_name: OPTION_TRACK
        name: trackGem[ 1 ]
      @insert description, tag

    trackValue = gem[ 1 ].match REGEX_TRACK
    if trackValue?
      tag =
        category_name: OPTION_TRACK
        name: trackValue[ 1 ]
      @insert description, tag

    if not trackGem? and not trackValue?
      isAutograph = REGEX_AUTOGRAPHRUNE.test gem[ 2 ]
      if isAutograph
        tag =
          category_name: OPTION_AUTOGRAPHRUNE
          name: gem[ 1 ]
        @insert description, tag
      else
        tag =
          category_name: gem[ 2 ]
          name: gem[ 1 ]
        @insert description, tag

  tagDOTA2DescGems: ( description ) ->
    if @isHaveDescriptions description
      gems = null
      _.each description.descriptions, ( definition ) =>
        gems = definition.value.match REGEX_GEMS

        if gems?
          _.each gems, ( gemString ) =>
            gem = gemString.match REGEX_GEM

            if gem?
              @tagDOTA2DescGem description, gem
