lesswrong-dilemma
=================

TODOS:  
* Combine all options into a big hash and pass that around instead.  
* Fisher-Yates instead of ` -> Math.random() - 0.5  
* Evolution      

An Iterated Prisoner's Dilemma simulator and Tournament manager.    

The payoff strucutre is handled by PAYOFF: an object in manager.coffee    
Other options are in main.coffee:    
* set `round_robin` to `true` to have each bot play each other bot. Output is written to root directory.  
* set `natural_selection` to `true` to run a population simulation. The default is a population of 1000, run for 1000 generations. Alter `root.natural_selection`'s generations and population variables to alter. Output is written as a CSV formatted .txt file to root directory.  
* `variable_length` is not yet implemented.  
* `evolution` is not yet implemented.  
* `message_corruption` is not yet implemented.  
* set `game_length` to the desired number of rounds.    

Writing your bot
================

Instructions in `bots.coffee` reproduced here.    


Use `super {name: 'Your-Name-Bot'}` to name your bot.  

your bot should have a custom move method, taking the info argument.  

move should return 'c' for cooperate, 'd' for defect.  

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
`