root = exports ? window

class root.Bot

  constructor: ( {@name: 'bot', @m: 0} ) ->

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
    super {name: 'DefectBot'}

  move: (info) =>
    'd'


class root.CooperateBot extends root.Bot

  constructor:  ->
    super {name: 'CooperateBot'}
  
  move: (info) =>
    'c'

class root.TitForTat extends root.Bot

  constructor:  ->
    super {name: 'TitForTat'}

  move: (info) =>
    if info.turn == 1 then 'c' else info.last_turn[1] 


class root.Random extends root.Bot

  constructor:  ->
    super {name: 'Random'}

  move: (info) =>
    if Math.random() > 0.5 then 'c' else 'd'


class root.GrimTrigger extends root.Bot

  constructor:  ->
    @trigger = false
    super {name: 'GrimTrigger'}
  
  move: (info) =>
    if info.last_turn[1] == 'd' then @trigger = true
    if @trigger then 'd' else 'c'

class root.TitForTatDefectLastN extends root.Bot

  constructor: (@n = 5) ->
    super {name: "TFT-D#{@n}"}

  move: (info) =>
    if info.turn == 1
      'c'
    else
      if info.game_length - info.turn <= @n
        'd'
      else
        info.last_turn[1]

class root.Afterparty extends root.Bot
# Play TitForTat, defect at n, if the opponent defected at n as well, then the opponent is also an Afterparty bot, and we should cooperate. Otherwise, the bot is an enemy, and we will defect.
  constructor: (@n = 10) ->
    super {name: "Afterparty"}
    @clone = false

  move: (info) =>
    if @clone == 'yes'
      'c'
    else if @clone == 'no'
      'd'
    else if (info.game_length - info.turn) == @n
      'd'
    else if (info.game_length - (info.turn - 1)) == @n
      if info.last_turn[1] == 'd'
        @clone = 'yes'
        'c'
      else
        @clone = 'no'
        'd'
    else if info.turn == 1
      'c'
    else 
      info.last_turn[1]


