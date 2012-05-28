root = exports ? window


class root.Game

  constructor: (@length = 100, @payoffs, @player_one, @player_two) ->
    @history = {}
    @turn = 0

  record: (one_move, two_move) =>
    [p1name, p2name] = [@player_one.name, @player_two.name]
    @history[@turn] = {p1name: one_move, p2name: two_move}

  tick: =>
    info = 1
    [p1m, p2m] = [@player_one.move(info), @player_two.move(info)]
    @record p1m, p2m
    [p1v, p2v] = @value p1m, p2m
    @player_one.results.push p1v
    @player_two.results.push p2v
    @turn++

  results: =>
    one = @player_one.results.reduce (t, s) -> t + s
    two = @player_two.results.reduce (t, s) -> t + s
    return [one, two]

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
    while @turn < @length
      @tick()
    @results()


class root.Payoffs

  constructor: (@d_c, @c_c, @d_d, @c_d) ->
    # yay




  