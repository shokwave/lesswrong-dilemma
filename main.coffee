fs = require 'fs'
b = require './bots'
g = require './game'
m = require './manager'

###
    The list of bots that will compete.
###
botlist = [b.TitForTat, b.Random, b.GrimTrigger, b.DefectBot, b.CooperateBot, b.TitForTatDefectLastN, b.Afterparty]

###
    Game type:
###
round_robin = false
natural_selection = true
evolution = false

###
    Options:
###
variable_length = false
message_corruption = false
game_length = 100

###
    Logging
###
class Writer

  constructor: ->
    
    @pen = fs.createWriteStream("ipd-logfile-#{ Math.random().toString()[2..10] }", {'a'})
    @first_write = true

  rr_log: (d) =>
    stri = ""
    for matchup, blob of d
      stri += "#{matchup}\n"
      for player, score of blob
        stri += "#{player}: #{score}\n"
    @pen.write stri


  ns_log: (d) =>
    if @first_write
      keyz = ""
      valz = ""
      for ky, vl of d
        keyz += "#{ky},"
        valz += "#{vl},"
      keyz += "\n" + valz + "\n"
      @pen.write keyz
      @first_write = false
    else
      valz = ""
      for ky, vl of d
        valz += ",#{vl}"
      valz += "\n"
      @pen.write valz


if round_robin
  m.round_robin(botlist, (new Writer), game_length)

if natural_selection
  m.natural_selection(botlist, (new Writer), game_length)

if variable_length
  false

if evolution
  false

if message_corruption
  false

  









