class TagsTF2Reducer extends TagsBaseReducer

  initialState:
    appId: APPID_TF2

  setExclude: [
    CHOICE_SETBONUS
  ]

  middlewares: [
    'tagTF2TypeLevel'
    'tagTF2TypeLimited'
    'tagTF2TypeStrange'
    'tagTF2DescStrangeKills'
    'tagTF2DescStrange'
    'tagTF2DescPaint'
    'tagTF2DescHalloween'
    'tagTF2DescHoliday'
    'tagTF2DescKillstreaker'
    'tagTF2DescSheen'
    'tagTF2DescUnusual'
    'tagTF2DescMedal'
    'tagTF2DescItemSetName'
  ]

  tagTF2TypeLevel: ( description ) ->
    level = null

    if description?.type?
      level = description.type.match REGEX_LEVEL
      if level?
        level = level[ 1 ]

    if level?
      tag =
        category_name: OPTION_LEVEL
        name: level
      @insert description, tag

  tagTF2TypeLimited: ( description ) ->
    limited = null
    color = null

    if description?.type?
      limited = description.type.match REGEX_TYPE_LIMITED
      if limited?
        limited = limited[ 1 ]

    color = description.name_color if description?.name_color?

    if limited?
      tag =
        category_name: OPTION_QUALITY
        name: limited
        color: color
      @insert description, tag

  tagTF2TypeStrange: ( description ) ->
    strange = null

    if description?.type?
      strange = description.type.match REGEX_TYPE_STRANGE
      if strange?
        strange = strange[ 1 ]

    if strange?
      tag =
        category_name: OPTION_TRACK
        name: strange
      @insert description, tag

  tagTF2DescStrangeKills: ( description ) ->
    config =
      regex: REGEX_STRANGE_KILLS
      option: OPTION_TRACK
      value: CHOICE_KILLS
    @tagDesc description, config

  tagTF2DescStrange: ( description ) ->
    config =
      regex: REGEX_STRANGE
      option: OPTION_TRACK
    @tagDesc description, config

  tagTF2DescPaint: ( description ) ->
    config =
      regex: REGEX_PAINT
      option: OPTION_PAINT
    @tagDesc description, config

  tagTF2DescHalloween: ( description ) ->
    config =
      regex: REGEX_HALLOWEEN
      option: OPTION_HALLOWEEN
    @tagDesc description, config

  tagTF2DescHoliday: ( description ) ->
    config =
      regex: REGEX_HOLIDAY
      option: OPTION_HOLIDAY
    @tagDesc description, config

  tagTF2DescKillstreaker: ( description ) ->
    config =
      regex: REGEX_KILLSTREAKER
      option: OPTION_EFFECT
    @tagDesc description, config

  tagTF2DescSheen: ( description ) ->
    config =
      regex: REGEX_SHEEN
      option: OPTION_EFFECT
    @tagDesc description, config

  tagTF2DescUnusual: ( description ) ->
    config =
      regex: REGEX_UNUSUAL
      option: OPTION_EFFECT
    @tagDesc description, config

  tagTF2DescMedal: ( description ) ->
    config =
      regex: REGEX_MEDAL
      option: OPTION_MEDAL
    @tagDesc description, config

  tagTF2DescItemSetName: ( description ) ->
    if @isHaveDescriptions description
      _.each description.descriptions, ( definition ) =>
        if definition.color is COLOR_OPTION_SET_TF2
          if not _.includes @setExclude, definition.value
            tag =
              category_name: OPTION_ITEMSET
              name: definition.value
            @insert description, tag
