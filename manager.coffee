root = exports ? window

g = require './game'

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
    5, 3, 1, 0 is the classic Prisoner's Dilemma structure.
###

###
    the round robin tournament
###

root.round_robin = (botlist, writer, game_length) ->
  records = {}
  for bot_one in botlist
    for bot_two in botlist
      player_one = new bot_one
      player_two = new bot_two
      matchup = "#{player_one.name} vs #{player_two.name}"
      records[matchup] = {}
      tournament = new g.Game game_length, PAYOFF, player_one, player_two
      [[ p1, p1score], [p2, p2score]] = tournament.play()
      p1 = "P1-#{p1}"
      p2 = "P2-#{p2}"
      records[matchup][p1] = p1score
      records[matchup][p2] = p2score
  writer.rr_log records

###
    the natural selection tournament
###

root.natural_selection = (botlist, writer, game_length) ->
  ###
      Options.
  ###
  generations = 1000
  population = 1000

  # initialise the lookup dict
  lookup = {}
  for bot in botlist
    lookup[bot.name] = bot

  # initialise the scoring dict
  dict = {}
  for bot in botlist
    dict[bot.name] = 0
  
  # initialise the pool
  pool = []
  # get the number of individuals
  numl = Math.ceil(population/botlist.length)
  # avert ye eyes! (coerce to even so we can sample safely)
  numl -= numl % 2
  for bot in botlist
    for n in [1..numl]
      pool.push new bot
  
  # now iterate!
  while generations > 0

    # shuffle the pool
    pool.sort( -> 0.5 - Math.random())
    
    # run this generation
    records = []
    while pool.length >= 2
      player_one = pool.pop()
      player_two = pool.pop()
      tournament = new g.Game game_length, PAYOFF, player_one, player_two
      records.push tournament.play()

    # accumulate scores
    for result in records
      for score in result
        dict[score[0]] += score[1]
    # normalise the dict
    total = 0
    for name, value of dict
      total += value
    total /= population
    for name, value of dict
      evnum = Math.round(value /= total)
      evnum -= evnum % 2
      dict[name] = evnum

    # record results
    writer.ns_log dict

    console.log("pool not emptied!", pool) unless pool.length == 0


    # fill the pool with the new generation
    for name, value of dict
      if value > 0
        for n in [1..value]
          pool.push new lookup[name]
    
    # clean up, go back to the top of the while loop
    for name, value of dict
      dict[name] = 0
    generations -= 1















