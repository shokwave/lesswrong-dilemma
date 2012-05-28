root = exports ? window

class root.Bot

  constructor: (@name) ->

  move: (info) =>
    ###

    'c' for cooperate, 'd' for defect.

    info is an object with some useful info for your bot.
    info.last_turn gives you an array of your move, their move
    e.g. ['c', 'd']. it is undefined if this is the first turn.
    info.turn gives you the current turn as an integer
    e.g. 5
    note that turn starts at 1.
    info.game_length gives you the length of the game as an integer
    e.g. 100
    note that the game ends after the turn counter hits this number, so that info.turn == 100 means the last turn in this case. 
    info.current_scores gives you an array of your score, their score
    e.g. [51, 30]. it is undefined if this is the first turn.
    info.payoffs gives you an array of arrays of the payoff structure
    e.g. [ ['d_c', 5], ['c_c', 3], ['d_d', 1], ['c_d', 0] ]

    your bot should shadow the move method, taking the info argument.

    ###


class root.DefectBot extends root.Bot

  constructor: ->
    super 'DefectBot'

  move: (info) =>
    'd'


class root.CooperateBot extends root.Bot

  constructor: ->
    super 'CooperateBot'
  
  move: (info) =>
    'c'

class root.TitForTat extends root.Bot

  constructor: ->
    super 'TitForTat'

  move: (info) =>
    
    if info.turn == 1 then 'c' else info.last_turn[1] 


class root.Random extends root.Bot

  constructor: ->
    super 'Random'

  move: (info) =>
    if Math.random() > 0.5 then 'c' else 'd'


class root.GrimTrigger extends root.Bot

  constructor: ->
    @trigger = false
    super 'GrimTrigger'
  
  move: (info) =>
    if info.last_turn[1] == 'd' then @trigger = true
    if @trigger then 'd' else 'c'

  