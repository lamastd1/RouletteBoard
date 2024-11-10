## Dom Lamastra
## Data Mining Final Project
#### High Level Overview
The following application simulates a Roulette table, where people come and go and place certain bets according to popular strategies collected. 

#### Strategies
There is a finite number of strategies a player can be playing with. The strategies indicate what the player does on their given turn to increase/decrease the next bet given what happened in the current round
- **fibonacci:** 
  - increase or decrease bet based on the fibonacci series starting at 5
  - 5, 8, 13, 21, 34...
- **martingale:** 
  - increase or decrease by doubling on the following bet, starting at 5
  - 5, 10, 20, 40, 80...
- **minimum net gain:** 
  - the minimum sequence that ensures that any win you have using this method will result in a gain of wealth where if you are increasing the bet on losses, any win would give you a profit no matter how many previous losses the player has had in that sequence, starting at 5
  - 5, 6, 12, 24, 48...

#### Player Bets
Players only bet on one type of bet or series of bets, with these following possibilites
- reds (18 pieces)
- lower third (12 pieces)
- lower third and middle third (24 pieces)
- street bet (6 pieces)
- special street bet (5 pieces including 0, 00, 1, 2, and 3)
- a corner (4 pieces)
- four corners method (all corner bets connected to one singular piece)
- a single piece

#### Character Qualities
- **sore loser:** if the player is a sore loser, if they lose 3 turns in a row they will leave
- **impatient loser:** if the player is an impatient loser they will throw all of their money on the bet in the next bet
- **addict:** if the player is an addict then they need to keep playing until they leave with more then they came with or they leave with nothing

#### Output Documentation
The application returns 4 output files

###### Bet.csv
A list of possible bets a player can bet
- **name:** the name of the bet
- **odds:** odds of the payout
- **payout:** the amount a player would get back multiplied by their bet after winning the bet, including the money they bet with

###### Board.csv
A list of available pieces on the board to be included in bets
- **value:** the value of the piece on the board
- **color:** the color of the piece on the board

###### Rounds.csv
A list of the rounds that were played in a particular game
- **round number:** the round that was played
- **value:** the value of the piece that was drawn at that round
- **color:** the color of the piece that was drawn at that round

###### People.csv
A list of all the players that played and information about them
- **id:** the player id
- **starting wallet:** the amount of money that the player brought to bet with
- **strategy:** the strategy that the player plans on using
- **increase on win:** 
  - if **true** then the player will increase their bet after winning a round 
  - if **false** then the player will increase their bet after a loss
- **max rounds:** the longest amount of rounds a player will play for
- **starting round:** the round id that the player entered in
- **ending round:** the round id that the player left in
- **starting bet** the bets that the player uses for their first bet, and all subsequent bets
- **starting bet amount:** the amount that the player starts with 
- **average bet:** the player's overall average bet per round over all rounds played
- **sore loser:** 
  - if **true** then the player is a sore loser 
  - if **false** then the player is not a sore loser
- **impatient loser:** 
  - if **true** then the player is an impatient loser 
  - if **false** then the player is not an impatient loser
- **addict:** 
  - if **true** then the player is an addict 
  - if **false** then the player is not an addict
- **profit:** the player's final earned money subtracted by what they started with
  

#### Future Enhancements 
- adding more strategies
- adding more character qualities 
- adding more complex strategies where players bet specific bets on specific turns based on the outcomes of previous rounds
