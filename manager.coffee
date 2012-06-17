root = exports ? window

g = require './game'

shuffle = (arr) ->
  # Fisher Yates Knuth Durstenfeld, by your powers combined...
  # I AM A PROPERLY SHUFFLED ARRAY!
  i = arr.length
  while --i
    j = Math.floor(Math.random() * (i+1))
    [arr[i], arr[j]] = [arr[j], arr[i]]
  return arr

clone = (a_hash) ->
  new_hash = {}
  for key, value of a_hash
    new_hash[key] = value
  return new_hash


root.round_robin = (opts) ->
  records = {}
  for bot_one in opts.botlist
    for bot_two in (if opts.round_robin.play_self then opts.botlist else (bot for bot in opts.botlist when bot isnt bot_one))
      player_one = new bot_one
      player_two = new bot_two
      matchup = "#{player_one.name} vs #{player_two.name}"
      records[matchup] = {}
      tournament = new g.Game opts.variablise(opts.game_length), opts.payoff, player_one, player_two, (if opts.message_corruption.flag then opts.message_corruption.rate else 0), (if opts.information_corruption.flag then opts.information_corruption.rate else 0), opts.game_length
      [[p1, p1score], [p2, p2score]] = tournament.play()
      if opts.round_robin.play_self
        p1 = "P1-#{p1}"
        p2 = "P2-#{p2}"
      records[matchup][p1] = p1score
      records[matchup][p2] = p2score
  return records


root.natural_selection = (opts) ->
  # initialise the lookup and results dicts
  logging_results = []
  lookup = {}
  generations = opts.natural_selection.generations
  for bot in opts.botlist
    lookup[bot.name] = bot
  # initialise the scoring dict
  dict = {}
  for bot in opts.botlist
    dict[bot.name] = 0
  # initialise the pool
  pre_pool = []
  # get the number of individuals
  numl = Math.ceil(opts.natural_selection.population / opts.botlist.length)
  # avert ye eyes! (coerce to even so we can sample safely)
  numl -= numl % 2
  for bot in opts.botlist
    for n in [1..numl]
      pre_pool.push new bot
  # now iterate!
  while generations > 0
    # shuffle the pool
    pool = shuffle(pre_pool)
    # run this generation
    records = []
    while pool.length >= 2
      player_one = pool.pop()
      player_two = pool.pop()
      tournament = new g.Game opts.variablise(opts.game_length), opts.payoff, player_one, player_two, (if opts.message_corruption.flag then opts.message_corruption.rate else 0), (if opts.information_corruption.flag then opts.information_corruption.rate else 0), opts.game_length
      records.push tournament.play()
    # accumulate scores
    for result in records
      for score in result
        dict[score[0]] += score[1]
    # normalise the dict
    total = 0
    for name, value of dict
      total += value
    total /= opts.natural_selection.population
    for name, value of dict
      evnum = Math.round(value /= total)
      evnum -= evnum % 2
      dict[name] = evnum
    # record results
    logging_results.push clone(dict)
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
  # finally, return results
  return logging_results