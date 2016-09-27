class TagsReducer

  initialState: true

  cleanDefinition: [
    CHOICE_TRADABLE
    CHOICE_NOTGIFTED
    CHOICE_NOTCRAFTED
    CHOICE_NOTCHANGED_NAME
    CHOICE_NOTCHANGED_DESCRIPTION
  ]
  colorOrder: [
    OPTION_CATEGORY
    OPTION_QUALITY
    OPTION_RARITY
  ]
  colorExclude: [
    CHOICE_STANDARD
  ]

  middlewares: [
    'tagColor'
    'tagTypeLevel'
    'tagTypeLimited'
    'tagTypeStrange'
    'tagTradable'
    'tagMarketable'
    'tagChangedName'
    'tagChangedDescripion'
    'tagGifted'
    'tagCrafted'
    'tagClean'
    'tagDescStrangeKills'
    'tagDescStrange'
    'tagDescPaint'
    'tagDescStyle'
    'tagDescHalloween'
    'tagDescHoliday'
    'tagDescKillstreaker'
    'tagDescSheen'
    'tagDescUnusual'
    'tagDescMedal'
    'tagDescDedication'
    'tagDescEventDOTA2'
    'tagDescItemSetName'
    'tagDescItemSetNameTF2'
    'tagDescHeroicVictory'
    'tagDescHeroicFirstBlood'
    'tagDescHeroicDoubleKill'
    'tagDescHeroicTripleKill'
    'tagDescHeroicUltraKill'
    'tagDescHeroicRampage'
    'tagDescHeroicGodlike'
    'tagDescHeroicCourierKill'
    'tagDescHeroicAllyDenied'
    'tagDescHeroicAegisDenied'
    'tagDescHeroicAegisSnatch'
    'tagDescHeroicEarlyRoshan'
    'tagDescHeroicRapier'
    'tagDescHeroic5EchoSlam'
    'tagDescPlayerCardPlayer'
    'tagDescPlayerCardTeam'
    'tagDescGems'
    'tagDescStickers'
  ]

  _middlewares: () ->
    _.each @middlewares, ( middleware, index ) =>
      @middlewares[ index ] = @[ middleware ]

  _cleanDefinition: () ->
    @cleanDefinition = _.sortBy @cleanDefinition

  process: ( state, action ) ->
    if action?.backpack?.success? and action.backpack.success
      descriptions = action.backpack.rgDescriptions
      if descriptions?
        _.each descriptions, ( description ) =>
          _.invokeMap @middlewares, _.call, @, description

  insert: ( description, tag ) ->
    description._sisbftags = [] if not description?._sisbftags?
    description._sisbftags.push tag if tag?.name? and not _.find description._sisbftags, tag

  tagColor: ( description ) ->
    color = null

    if description?.tags?
      _.each @colorOrder, ( optionName ) ->
        tag = _.find description.tags, category_name: optionName
        if tag?.color? and not color?
          if not _.includes @colorExclude, tag.name
            color = tag.color

    tag =
      _filter: false
      _tooltip: false
      category_name: OPTION_COLOR
      name: color
      color: color
    @insert description, tag

  tagTypeLevel: ( description ) ->
    level = null

    if description?.type?
      level = description.type.match REGEX_LEVEL
      if level?
        level = level[ 1 ]

    tag =
      category_name: OPTION_LEVEL
      name: level
    @insert description, tag

  tagTypeLimited: ( description ) ->
    limited = null
    color = null

    if description?.type?
      limited = description.type.match REGEX_TYPE_LIMITED
      if limited?
        limited = limited[ 1 ]

    color = description.name_color if description?.name_color?

    tag =
      category_name: OPTION_QUALITY
      name: limited
      color: color
    @insert description, tag

  tagTypeStrange: ( description ) ->
    strange = null

    if description?.type?
      strange = description.type.match REGEX_TYPE_STRANGE
      if strange?
        strange = strange[ 1 ]

    tag =
      category_name: OPTION_TRACK
      name: strange
    @insert description, tag

  tagTradable: ( description ) ->
    tradable = null

    if description?.tradable?
      switch description.tradable
        when 0
          tradable = CHOICE_NOTTRADABLE
        when 1
          tradable = CHOICE_TRADABLE

    tag =
      category_name: OPTION_TRADABLE
      name: tradable
    @insert description, tag

  tagMarketable: ( description ) ->
    marketable = null

    if description?.marketable?
      switch description.marketable
        when 0
          marketable = CHOICE_NOTMARKETABLE
        when 1
          marketable = CHOICE_MARKETABLE

    tag =
      _tooltip: false
      category_name: OPTION_MARKETABLE
      name: marketable
    @insert description, tag

  tagChangedName: ( description ) ->
    renamed = null

    if description?.name?
      renamed = description.name.match REGEX_RENAMED

      if renamed?
        tag =
          _filter: false
          category_name: OPTION_CHANGED_NAME
          name: renamed[ 1 ]
        @insert description, tag

      if renamed?
        renamed = CHOICE_CHANGED_NAME
      else
        renamed = CHOICE_NOTCHANGED_NAME

    tag =
      _tooltip: false
      category_name: OPTION_CHANGED_NAME
      name: renamed
    @insert description, tag

  tagChangedDescripion: ( description ) ->
    renamed = null

    if description?.descriptions?
      renamed = _.filter description.descriptions, ( definition ) ->
        REGEX_RENAMED.test definition.value

      if renamed? and renamed.length > 0
        _.each renamed, ( definition ) =>
          tag =
            _filter: false
            category_name: OPTION_CHANGED_DESCRIPTION
            name: definition.value
          @insert description, tag

      if renamed? and renamed.length > 0
        renamed = CHOICE_CHANGED_DESCRIPTION
      else
        renamed = CHOICE_NOTCHANGED_DESCRIPTION

    tag =
      _tooltip: false
      category_name: OPTION_CHANGED_DESCRIPTION
      name: renamed
    @insert description, tag

  tagGifted: ( description ) ->
    gifted = null

    if description?.descriptions?
      gifted = _.filter description.descriptions, ( definition ) ->
        REGEX_GIFTED.test definition.value

      if gifted? and gifted.length > 0
        _.each gifted, ( definition ) =>
          giftedFrom = definition.value.match REGEX_GIFTED
          if giftedFrom?
            tag =
              category_name: OPTION_GIFTED_FROM
              name: giftedFrom[ 1 ]
            @insert description, tag

      if gifted? and gifted.length > 0
        gifted = CHOICE_GIFTED
      else
        gifted = CHOICE_NOTGIFTED

    tag =
      _tooltip: false
      category_name: OPTION_GIFTED
      name: gifted
    @insert description, tag

  tagCrafted: ( description ) ->
    crafted = null

    if description?.descriptions?
      crafted = _.filter description.descriptions, ( definition ) ->
        definition.color is COLOR_OPTION_CRAFTED and REGEX_CRAFTED.test definition.value

      if crafted? and crafted.length > 0
        _.each crafted, ( definition ) =>
          craftedBy = definition.value.match REGEX_CRAFTED
          if craftedBy?
            tag =
              category_name: OPTION_CRAFTED_BY
              name: craftedBy[ 1 ]
            @insert description, tag

      if crafted? and crafted.length > 0
        crafted = CHOICE_CRAFTED
      else
        crafted = CHOICE_NOTCRAFTED

    tag =
      _tooltip: false
      category_name: CHOICE_CRAFTED
      name: crafted
    @insert description, tag

  tagClean: ( description ) ->
    clean = null

    if description?._sisbftags?
      tags = _.flatMap description._sisbftags, 'name'
      intersection = _.sortBy _.intersection tags, @cleanDefinition
      clean = _.isEqual @cleanDefinition, intersection

      if clean? and clean
        clean = CHOICE_CLEAN
      else
        clean = CHOICE_DIRTY

    tag =
      category_name: OPTION_CLEAN
      name: clean
    @insert description, tag

  tagDesc: ( description, config ) ->
    desc = null
    if description?.descriptions?
      desc = _.filter description.descriptions, ( definition ) ->
        config.regex.test definition.value
      if desc? and desc.length > 0
        _.each desc, ( definition ) =>
          descMatch = definition.value.match config.regex
          if descMatch?
            tag =
              category_name: config.option
              name: if config.value? then config.value else descMatch[ 1 ]
            @insert description, tag
            if config.order?
              _.each config.order, ( option, index ) =>
                tag =
                  category_name: option
                  name: descMatch[ ++index ]
                @insert description, tag

  tagDescStrangeKills: ( description ) ->
    config =
      regex: REGEX_STRANGE_KILLS
      option: OPTION_TRACK
      value: CHOICE_KILLS
    @tagDesc description, config

  tagDescStrange: ( description ) ->
    config =
      regex: REGEX_STRANGE
      option: OPTION_TRACK
    @tagDesc description, config

  tagDescPaint: ( description ) ->
    config =
      regex: REGEX_PAINT
      option: OPTION_PAINT
    @tagDesc description, config

  tagDescStyle: ( description ) ->
    config =
      regex: REGEX_STYLE
      option: OPTION_STYLE
    @tagDesc description, config

  tagDescHalloween: ( description ) ->
    config =
      regex: REGEX_HALLOWEEN
      option: OPTION_HALLOWEEN
    @tagDesc description, config

  tagDescHoliday: ( description ) ->
    config =
      regex: REGEX_HOLIDAY
      option: OPTION_HOLIDAY
    @tagDesc description, config

  tagDescKillstreaker: ( description ) ->
    config =
      regex: REGEX_KILLSTREAKER
      option: OPTION_EFFECT
    @tagDesc description, config

  tagDescSheen: ( description ) ->
    config =
      regex: REGEX_SHEEN
      option: OPTION_EFFECT
    @tagDesc description, config

  tagDescUnusual: ( description ) ->
    config =
      regex: REGEX_UNUSUAL
      option: OPTION_EFFECT
    @tagDesc description, config

  tagDescMedal: ( description ) ->
    config =
      regex: REGEX_MEDAL
      option: OPTION_MEDAL
    @tagDesc description, config

  tagDescDedication:  ( description ) ->
    config =
      regex: REGEX_DEDICATION
      option: OPTION_DEDICATION
    @tagDesc description, config

  tagDescEventDOTA2:  ( description ) ->
    config =
      regex: REGEX_EVENT_DOTA2
      option: OPTION_EVENT
    @tagDesc description, config

  tagDescItemSetName: ( description ) ->
    if description?.descriptions?
      _.each description.descriptions, ( definition ) =>
        if definition?.app_data?.is_itemset_name? and definition.app_data.is_itemset_name is 1
          tag =
            category_name: OPTION_ITEMSET
            name: definition.value
          @insert description, tag

  tagDescItemSetNameTF2: ( description ) ->
    if description?.descriptions?
      if description.appid is APPID_TF2
        _.each description.descriptions, ( definition ) =>
          if definition.color is COLOR_OPTION_SET_TF2
            tag =
              category_name: OPTION_ITEMSET
              name: definition.value
            @insert description, tag

  tagDescHeroicVictory: ( description ) ->
    config =
      regex: REGEX_HEROIC_VICTORY
      option: OPTION_HEROIC
      value: CHOICE_VICTORY
      order: [ OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicFirstBlood: ( description ) ->
    config =
      regex: REGEX_HEROIC_FIRSTBLOOD
      option: OPTION_HEROIC
      value: CHOICE_FIRSTBLOOD
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicDoubleKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_DOUBLEKILL
      option: OPTION_HEROIC
      value: CHOICE_DOUBLEKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicTripleKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_TRIPLEKILL
      option: OPTION_HEROIC
      value: CHOICE_TRIPLEKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicUltraKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_ULKTRAKILL
      option: OPTION_HEROIC
      value: CHOICE_ULTRAKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicRampage: ( description ) ->
    config =
      regex: REGEX_HEROIC_RAPMAGE
      option: OPTION_HEROIC
      value: CHOICE_RAMPAGE
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicGodlike: ( description ) ->
    config =
      regex: REGEX_HEROIC_GODLIKE
      option: OPTION_HEROIC
      value: CHOICE_GODLIKE
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicCourierKill: ( description ) ->
    config =
      regex: REGEX_HEROIC_COURIERKILL
      option: OPTION_HEROIC
      value: CHOICE_COURIERKILL
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicAllyDenied: ( description ) ->
    config =
      regex: REGEX_HEROIC_ALLYDENIED
      option: OPTION_HEROIC
      value: CHOICE_ALLYDENIED
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_PLAYER ]
    @tagDesc description, config

  tagDescHeroicAegisDenied: ( description ) ->
    config =
      regex: REGEX_HEROIC_AEGISDENIED
      option: OPTION_HEROIC
      value: CHOICE_AEGISDENIED
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicAegisSnatch: ( description ) ->
    config =
      regex: REGEX_HEROIC_AEGISSNATCH
      option: OPTION_HEROIC
      value: CHOICE_AEGISSNATCH
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicEarlyRoshan: ( description ) ->
    config =
      regex: REGEX_HEROIC_EARLYROSHAN
      option: OPTION_HEROIC
      value: CHOICE_EARLYROSHAN
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroicRapier: ( description ) ->
    config =
      regex: REGEX_HEROIC_RAPIER
      option: OPTION_HEROIC
      value: CHOICE_RAPIER
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescHeroic5EchoSlam: ( description ) ->
    config =
      regex: REGEX_HEROIC_5ECHOSLAM
      option: OPTION_HEROIC
      value: CHOICE_5ECHOSLAM
      order: [ OPTION_PLAYER, OPTION_TEAM, OPTION_TEAM ]
    @tagDesc description, config

  tagDescPlayerCardPlayer: ( description ) ->
    config =
      regex: REGEX_PLAYER_DOTA2
      option: OPTION_PLAYER
    @tagDesc description, config

  tagDescPlayerCardTeam: ( description ) ->
    config =
      regex: REGEX_TEAM_DOTA2
      option: OPTION_TEAM
    @tagDesc description, config

  tagDescGems: ( description ) ->
    gems = null
    if description?.descriptions?
      _.each description.descriptions, ( definition ) =>
        gems = definition.value.match REGEX_GEMS
        if gems?
          _.each gems, ( gemString ) =>
            gem = gemString.match REGEX_GEM

            if gem?
              trackGem = gem[ 2 ].match REGEX_TRACK
              if trackGem?
                tag =
                  category_name: OPTION_GEM_TRACK
                  name: trackGem[ 1 ]
                @insert description, tag

              trackValue = gem[ 1 ].match REGEX_TRACK
              if trackValue?
                tag =
                  category_name: OPTION_GEM_TRACK
                  name: trackValue[ 1 ]
                @insert description, tag

              if not trackGem? and not trackValue?
                autograph = REGEX_AUTOGRAPHRUNE.test gem[ 2 ]
                if autograph
                  tag =
                    category_name: OPTION_AUTOGRAPHRUNE
                    name: gem[ 1 ]
                  @insert description, tag
                else
                  tag =
                    category_name: gem[ 2 ]
                    name: gem[ 1 ]
                  @insert description, tag

  tagDescStickers: ( description ) ->
    stickers = null
    if description?.descriptions?
      _.each description.descriptions, ( definition ) =>
        stickers = definition.value.match REGEX_STICKERS
        if stickers?
          stickers = stickers[ 1 ].split ', '
          _.each stickers, ( sticker ) =>
            tag =
              category_name: OPTION_STICKER
              name: sticker
            @insert description, tag

  reducer: ( state = @initialState, action ) ->
    switch action.type
      when PERSON_LOADED
        @process state, action
    return state

  constructor: () ->
    @_middlewares()
    @_cleanDefinition()
    return @reducer.bind @
