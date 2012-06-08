root = exports ? window


class root.Game

  constructor: (@length, @payoffs, @player_one, @player_two) ->
    @player_one_results = 0
    @player_two_results = 0
    @history = {}
    @turn = 1

  record: (one_move, two_move) =>
    @history[@turn] = [[@player_one.name, one_move], [@player_two.name, two_move]]
    

  info: (player) =>
    if @turn == 1
      new root.Info [], @turn, @length, [], ([key, value] for key, value of @payoffs)
    else
      turn = @turn
      last_turn = [@history[(@turn - 1)][0][1], @history[(@turn - 1)][1][1]]
      game_length = @length
      current_scores = [@player_one_results, @player_two_results]
      switch player
        when 1
          return new root.Info last_turn, turn, game_length, current_scores
        when 2
          return new root.Info last_turn.reverse(), turn, game_length, current_scores.reverse()


  tick: =>
    [p1m, p2m] = [@player_one.move(@info 1), @player_two.move(@info 2)]
    @record p1m, p2m
    @player_one_results += @value(p1m, p2m)
    @player_two_results += @value(p2m, p1m)
    @turn++

  results: ->
    one = @player_one_results
    two = @player_two_results
    one_name = "#{@player_one.name}"
    two_name = "#{@player_two.name}"
    return [[one_name, one], [two_name, two]]

  value: (my_move, others_move) =>
    @payoffs[my_move][others_move]

  play: =>
    while @turn <= @length
      @tick()
    @results()


class root.Payoffs
  constructor: (d_c, c_c, d_d, c_d) ->
    @c = {'c': c_c, 'd': c_d}
    @d = {'c': d_c, 'd': d_d}


class root.Info
  constructor: (@last_turn, @turn, @game_length, @current_scores) ->



  