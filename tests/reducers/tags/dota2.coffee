describe 'reducers/tags/dota2', () ->
  describe '.tagDOTA2DescEvent()', () ->
    it 'it should detect major dota events item', () ->
      description = __mock__[ 'tags/dota2/description/event/the international 2013' ]

      TagsDOTA2Reducer::tagDOTA2DescEvent description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Event'
        name: 'The International 2013'

  describe '.tagDOTA2DescHeroicVictory()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/victory' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicVictory @description

    afterEach () ->
      @description = null

    it 'it should detect heroic victory item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Victory'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Unknown Team'

  describe '.tagDOTA2DescHeroicFirstBlood()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/first blood' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicFirstBlood @description

    afterEach () ->
      @description = null

    it 'it should detect heroic first blood item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'First Blood'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Invictus Gaming'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'WWW of RaTtLeSnAkE. CN GaMiNg'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'biubiubiu!'

  describe '.tagDOTA2DescHeroicDoubleKill()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/double kill' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicDoubleKill @description

    afterEach () ->
      @description = null

    it 'it should detect heroic double kill item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Double Kill'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'BBUBU+4'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Combos Nich\'s'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Lexbreaker'

  describe '.tagDOTA2DescHeroicTripleKill()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/triple kill' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicTripleKill @description

    afterEach () ->
      @description = null

    it 'it should detect heroic triple kill item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Triple Kill'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Unknown Team'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'queens'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Rizza'

  describe '.tagDOTA2DescHeroicUltraKill()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/ultra kill' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicUltraKill @description

    afterEach () ->
      @description = null

    it 'it should detect heroic ultra kill item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'ULTRA KILL'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Suck My Dagon'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: '[rewind]'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Ardi'

  describe '.tagDOTA2DescHeroicRampage()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/rampage' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicRampage @description

    afterEach () ->
      @description = null

    it 'it should detect heroic rampage item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'RAMPAGE!'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Unknown Team'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'SeriousModeOn'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Chur'

  describe '.tagDOTA2DescHeroicGodlike()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/godlike' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicGodlike @description

    afterEach () ->
      @description = null

    it 'it should detect heroic godlike item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Godlike'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Duck &amp; Cover'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: '-Godlike-'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Splash'

  describe '.tagDOTA2DescHeroicCourierKill()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/courier kill' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicCourierKill @description

    afterEach () ->
      @description = null

    it 'it should detect heroic courier kill item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Courier Kill'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Natus Vincere'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Alliance'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Food'

  describe '.tagDOTA2DescHeroicAllyDenied()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/ally denied' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicAllyDenied @description

    afterEach () ->
      @description = null

    it 'it should detect heroic ally denied item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Allied Hero Denial'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'APETACO'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'solen'

  describe '.tagDOTA2DescHeroicAegisDenied()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/aegis denied' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicAegisDenied @description

    afterEach () ->
      @description = null

    it 'it should detect heroic aegis denied item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Aegis Denial'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'GameOn.'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Tegu Opa'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Speedy'

  describe '.tagDOTA2DescHeroicAegisSnatch()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/aegis snatch' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicAegisSnatch @description

    afterEach () ->
      @description = null

    it 'it should detect heroic aegis snatch item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Aegis Stolen'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'MOSCOWITA POWER'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: '300 The Return'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Hello'

  describe '.tagDOTA2DescHeroicEarlyRoshan()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/early roshan' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicEarlyRoshan @description

    afterEach () ->
      @description = null

    it 'it should detect heroic early roshan item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Early Roshan'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name:'New Age AR'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name:'VolcaniaGaming'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'zhimoneta'

  describe '.tagDOTA2DescHeroicRapier()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/rapier' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroicRapier @description

    afterEach () ->
      @description = null

    it 'it should detect heroic rapier item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Rapier'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Immortal Fire.'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Yolo Swagerino'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'FUCK YOU CHINA'

  describe '.tagDOTA2DescHeroic5EchoSlam()', () ->
    beforeEach () ->
      @description = __mock__[ 'tags/dota2/description/heroic/echo slam' ]
      TagsDOTA2Reducer::tagDOTA2DescHeroic5EchoSlam @description

    afterEach () ->
      @description = null

    it 'it should detect heroic 5 echo slam item', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Heroic event'
        name: 'Echo Slam'

    it 'it should detect teams', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Team Empire'
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Cloud9 G2A'

    it 'it should detect players', () ->
      expect( @description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'VANSKOR'

  describe '.tagDOTA2DescPlayerCardPlayer()', () ->
    it 'it should detect player card item player', () ->
      description = __mock__[ 'tags/dota2/description/player/card/player/maximilian broecker' ]

      TagsDOTA2Reducer::tagDOTA2DescPlayerCardPlayer description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'Maximilian Broecker'

    it 'it should support player nickname', () ->
      description = __mock__[ 'tags/dota2/description/player/card/player/qojqva' ]

      TagsDOTA2Reducer::tagDOTA2DescPlayerCardPlayer description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Professional Player'
        name: 'qojqva (Maximilian Broecker)'

  describe '.tagDOTA2DescPlayerCardTeam()', () ->
    it 'it should detect player card item team', () ->
      description = __mock__[ 'tags/dota2/description/player/card/team/alliance' ]

      TagsDOTA2Reducer::tagDOTA2DescPlayerCardTeam description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Team'
        name: 'Alliance'

  describe '.tagDOTA2DescGem()', () ->
    it 'it should detect track gem in gem name', () ->
      description = __mock__[ 'tags/dota2/description/gem/track/name/games watched/navi' ]
      gem = __mock__[ 'tags/dota2/description/gem/track/name/games watched/matched/navi' ]

      TagsDOTA2Reducer::tagDOTA2DescGem description, gem
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Track'
        name: 'Games Watched (NaVi)'

    it 'it should detect track gem in gem value', () ->
      description = __mock__[ 'tags/dota2/description/gem/track/value/barracks destroyed' ]
      gem = __mock__[ 'tags/dota2/description/gem/track/value/matched/barracks destroyed' ]

      TagsDOTA2Reducer::tagDOTA2DescGem description, gem
      # console.log description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Track'
        name: 'Barracks Destroyed'

    it 'it should detect autograph rune', () ->
      description = __mock__[ 'tags/dota2/description/gem/autograph/andrey dread golubev' ]
      gem = __mock__[ 'tags/dota2/description/gem/autograph/matched/andrey dread golubev' ]

      TagsDOTA2Reducer::tagDOTA2DescGem description, gem
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Autograph Rune'
        name: 'Autographed by Andrey \'Dread\' Golubev'

    it 'it should detect others gems', () ->
      description = __mock__[ 'tags/dota2/description/gem/kinetic/sylvan cascade' ]
      gem = __mock__[ 'tags/dota2/description/gem/kinetic/matched/sylvan cascade' ]

      TagsDOTA2Reducer::tagDOTA2DescGem description, gem
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Kinetic Gem'
        name: 'Sylvan Cascade!'

  describe '.tagDOTA2DescGems()', () ->
    it 'it should detect all gems', () ->
      description = __mock__[ 'tags/dota2/description/gem/kinetic/sylvan cascade' ]

      TagsDOTA2Reducer::tagDOTA2DescGems description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Track'
        name: 'Buildings Focus Fired'
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Kinetic Gem'
        name: 'Sylvan Cascade!'
