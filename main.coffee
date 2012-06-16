root = exports ? window

fs = require 'fs'
b = require './bots'
g = require './game'
m = require './manager'


opts = 

  botlist: 
    [b.TitForTat, b.Random, b.GrimTrigger, b.DefectBot, b.CooperateBot, b.TitForTatDefectLastN, b.Afterparty]
  
  payoff: 
    new g.Payoffs 5, 3, 1, 0

  game_length:
    100

  round_robin: 
    flag: false
    do: m.round_robin

  natural_selection: 
    flag: false
    generations: 1000
    population: 400
    do: m.natural_selection

  evolution: 
    flag: false
    m: 'dunno'
    # do: m.evolution

  variable_length:
    flag: false
    methods: 
      small_uniform: (length) ->
        Math.floor(((Math.random() * length) - (length / 2)) / 3)

      big_uniform: (length) ->
        Math.floor((Math.random() * length) - (length / 2))

      exponential: (length) ->
        Math.floor((-1*(Math.log(Math.random())))*10)

  message_corruption: 
    flag: false
    rate: 0.01

  information_corruption:
    flag: false
    rate: 0.01

# change small_uniform to big_uniform or exponential.
opts.variablise = opts.variable_length.methods.small_uniform

switch process.argv[2]
  when 'round robin'
    opts.round_robin.flag = true
  when 'natural selection'
    opts.natural_selection.flag = true
  when 'evolution'
    opts.evolution.flag = true

opts.round_robin.do(opts) if opts.round_robin.flag
opts.natural_selection.do(opts) if opts.natural_selection.flag
opts.evolution.do(opts) if opts.evolution.flag
