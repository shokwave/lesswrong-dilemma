g = require './game'
b = require './bots'


###
    options:
###
round_robin = true
natural_selection = false
LENGTH = 100



###
    set your payoff structure here.
###
PAYOFF = new g.Payoffs 5, 3, 1, 0
###
    you need to provide:
      the value of defecting against a cooperator
      the value of cooperating with a cooperator
      the value of defecting against a defector
      the value of cooperating against a defector.
    also note that `new Payoffs(a, b, c, d)` should satisfy:
      a > b > c > d
      b * 2 > a + d  
    otherwise, the interesting things that are true about the iterated prisoner's dilemma aren't true of tournaments using this structure.
###


###
    the round robin tournament
###

# console.log PAYOFF['c']['d']
# console.log "outside"

if round_robin
  botlist = [b.TitForTat, b.Random, b.GrimTrigger, b.DefectBot, b.CooperateBot, b.TitForTatDefectLastN, b.Afterparty]
  records = []
  # console.log PAYOFF['c']['d']
  # console.log "in round_robin"
  for bot_one in botlist
    for bot_two in botlist
      player_one = new bot_one
      player_two = new bot_two
      # console.log PAYOFF['c']['d']
      # console.log "in bot_two"
      tournament = new g.Game LENGTH, PAYOFF, player_one, player_two
      records.push tournament.play()

  dict = 
    'TitForTat': 0
    'Random': 0
    'GrimTrigger': 0
    'DefectBot': 0
    'CooperateBot': 0
    'TFT-Dn': 0
    'Afterparty': 0

  for record in records
    for contestant in record
      dict[contestant[0]] += contestant[1]

console.log dict
  









