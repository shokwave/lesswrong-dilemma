root = exports ? window

g = require './game'

shuffle = (arr) ->
  # Fisher Yates Knuth Durstenfeld, by your powers combined
  i = arr.length
  while --i
    j = Math.floor(Math.random() * (i+1))
    [arr[i], arr[j]] = [arr[j], arr[i]]
  return arr


root.round_robin = (botlist, writer, game_length, payoff, variablise) ->
  records = {}
  for bot_one in botlist
    for bot_two in botlist
      player_one = new bot_one
      player_two = new bot_two
      matchup = "#{player_one.name} vs #{player_two.name}"
      records[matchup] = {}
      tournament = new g.Game variablise(game_length), payoff, player_one, player_two, message_corruption, information_corruption
      [[p1, p1score], [p2, p2score]] = tournament.play()
      p1 = "P1-#{p1}"
      p2 = "P2-#{p2}"
      records[matchup][p1] = p1score
      records[matchup][p2] = p2score
  writer.rr_log records


root.natural_selection = (botlist, writer, game_length, payoff, variablise, generations, population) ->
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
    pool = shuffle(pool)
    # run this generation
    records = []
    while pool.length >= 2
      player_one = pool.pop()
      player_two = pool.pop()
      tournament = new g.Game variablise(game_length), payoff, player_one, player_two, message_corruption, information_corruption
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