g = require './game'
b = require './bots'

PAYOFF = new g.Payoffs 5, 3, 1, 0

player_one = new b.CooperateBot
player_two = new b.DefectBot

tournament = new g.Game 100, PAYOFF, player_one, player_two
console.log tournament


console.log tournament.play()


