root = exports ? window


class root.Game

  constructor: (@length, @payoffs, @player_one, @player_two) ->
    @player_one_results = 0
    @player_two_results = 0
    @history = []
    @turn = 1
    @message_corruption = 0.01
    @corrupt = {'d': 'c', 'c': 'd'}
    @information_corruption = 0.01
    @gameinfo = {}

  info: (player) =>
    if @turn == 1
      @gameinfo = new root.Info [], @turn, @length, []
    else
      @gameinfo.turn = @turn
      @gameinfo.last_turn = @history
      @gameinfo.game_length = @length
      @gameinfo.current_scores = [@player_one_results, @player_two_results]
      switch player
        when 1
          @gameinfo
        when 2
          @gameinfo.last_turn.reverse()
          @gameinfo.current_scores.reverse()
          @gameinfo

  maybe_corrupt: (move, factor) =>
    if (Math.random() > factor) then @corrupt[move] else move

  tick: =>
    [p1m, p2m] = [@maybe_corrupt(@player_one.move(@info 1), @message_corruption), @maybe_corrupt(@player_two.move(@info 2), @message_corruption)]
    @history = [@maybe_corrupt(p1m, @information_corruption), @maybe_corrupt(p2m, @information_corruption)]
    @player_one_results += @payoffs[p1m][p2m]
    @player_two_results += @payoffs[p2m][p1m]
    @turn++

  results: ->
    one = @player_one_results
    two = @player_two_results
    one_name = "#{@player_one.name}"
    two_name = "#{@player_two.name}"
    return [[one_name, one], [two_name, two]]

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



  