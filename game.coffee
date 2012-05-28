root = exports ? window


class root.Game

  constructor: (@length, @payoffs, @player_one, @player_two) ->
    @player_one_results = []
    @player_two_results = []
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
      current_scores = (arr[1] for arr in @results())
      payoffs = ([key, value] for key, value of @payoffs)
      switch player
        when 1
          return new root.Info last_turn, turn, game_length, current_scores, payoffs
        when 2
          return new root.Info last_turn.reverse(), turn, game_length, current_scores.reverse(), payoffs


  tick: =>
    [p1m, p2m] = [@player_one.move(@info 1), @player_two.move(@info 2)]
    @record p1m, p2m
    [p1v, p2v] = @value p1m, p2m
    @player_one_results.push p1v
    @player_two_results.push p2v
    @turn++

  results: ->
    one = @player_one_results.reduce (t, s) -> t + s
    two = @player_two_results.reduce (t, s) -> t + s
    one_name = "#{@player_one.name}"
    two_name = "#{@player_two.name}"
    return [[one_name, one], [two_name, two]]

  value: (p1m, p2m) =>
    switch p1m
      when 'c'
        switch p2m
          when 'c'
            return [@payoffs.c_c, @payoffs.c_c]
          when 'd'
            return [@payoffs.c_d, @payoffs.d_c]
          else null
      when 'd'
        switch p2m
          when 'c'
            return [@payoffs.d_c, @payoffs.c_d]
          when 'd'
            return [@payoffs.d_d, @payoffs.d_d]
          else null
      else null

  play: =>
    while @turn <= @length
      @tick()
    @results()


class root.Payoffs
  constructor: (@d_c, @c_c, @d_d, @c_d) ->


class root.Info
  constructor: (@last_turn, @turn, @game_length, @current_scores, @payoffs) ->



  