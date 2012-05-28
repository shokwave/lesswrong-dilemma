import game
import bots

PAYOFF = Payoffs 5, 3, 1, 0

player_one = CooperateBot
player_two = DefectBot

game = Game PAYOFF, player_one, player_two
console.log game.play


