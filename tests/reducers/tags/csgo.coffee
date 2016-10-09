describe 'reducers/tags/csgo', () ->
  describe '.tagCSGODescStickers()', () ->
    it 'it should detect stickers', () ->
      description = __mock__[ 'tags/csgo/description/stickers/4']

      TagsCSGOReducer::tagCSGODescStickers description
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Sticker'
        name: 'byali (Gold) | Cologne 2015'
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Sticker'
        name: 'Fnatic (Gold) | Cologne 2015'
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Sticker'
        name: 'Virtus.Pro (Gold) | Cologne 2015'
      expect( description._sisbftags ).toContain jasmine.objectContaining
        category_name: 'Sticker'
        name: 'ESL (Gold) | Cologne 2015'
