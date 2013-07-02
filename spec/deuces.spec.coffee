deuces = require "../deuces2"

describe "The module", ->
	it "is not null", ->
		expect(deuces).not.toBe null

game = new deuces.Game()
###
console.log(game)

describe "The Deck", ->
	it "is not null", ->
		expect(typeof(game.deck)).not.toBe 'undefined'

	it "has 52 cards", ->
		expect(game.deck.cards.length).toBe 52
###
