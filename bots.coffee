root = exports ? window

class root.Bot

  constructor: (@name) ->
    @results = []

  move: (info) =>
    ###

    'c' for cooperate, 'd' for defect.

    info is an object with some useful info for your bot.
    info.last_turn gives you an array of your move, their move
    e.g. ['c', 'd'].
    info.turn gives you the current turn as an integer
    e.g. 5
    info.current_scores gives you an array of your score, their score
    e.g. [51, 30]
    info.payoffs gives you a dictionary of the payoff structure
    e.g. {'d_c': 5, 'c_c': 3, 'd_d': 1, 'c_d': 0}

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
  
  move: =>
    'c'


  
  