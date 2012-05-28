g = require './game'
b = require './bots'

PAYOFF = new g.Payoffs 5, 3, 1, 0
###
    set your payoff structure here.
    you need to provide:
      the value of defecting against a cooperator
      the value of cooperating with a cooperator
      the value of defecting against a defector
      the value of cooperating against a defector
    and these should be in decreasing order.
    that is, new Payoffs(a, b, c, d) should satisfy:
      a > b > c > d
    otherwise, the interesting things that are true about the iterated prisoner's dilemma aren't true of tournaments using this structure.
###

test: ->
  player_one = new b.CooperateBot
  player_two = new b.DefectBot

  tournament = new g.Game 100, PAYOFF, player_one, player_two
  console.log tournament

  console.log tournament.play()




