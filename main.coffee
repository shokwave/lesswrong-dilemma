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
    play_self: true
    do: m.round_robin

  natural_selection: 
    flag: false
    generations: 600
    population: 700
    do: m.natural_selection

  evolution: 
    flag: false
    m: 'dunno'
    # do: m.evolution

  variable_length:
    flag: false
    methods: 
      small_uniform: (length) ->
        length + Math.floor(((Math.random() * length) - (length / 2)) / 3)

      big_uniform: (length) ->
        length + Math.floor((Math.random() * length) - (length / 2))

      exponential: (length) ->
        length + Math.floor((-1*(Math.log(Math.random())))*10)

  message_corruption: 
    flag: false
    rate: 0.02

  information_corruption:
    flag: false
    rate: 0.03

  variablise: (x) => x

# change small_uniform to big_uniform or exponential.
if opts.variable_length.flag
  opts.variablise = opts.variable_length.methods.small_uniform

switch process.argv[2]
  when 'round robin'
    opts.round_robin.flag = true
  when 'natural selection'
    opts.natural_selection.flag = true
  when 'evolution'
    opts.evolution.flag = true

# opts.round_robin.do(opts) if opts.round_robin.flag
console.log(opts.round_robin.do(opts)) if opts.round_robin.flag

console.log(opts.natural_selection.do(opts)) if opts.natural_selection.flag
opts.evolution.do(opts) if opts.evolution.flag
