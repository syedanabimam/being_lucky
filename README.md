# Being Lucky 

Being Lucky is an app build and ran on Ruby Console, it functions as a game played 
with atleast 2 or more players where players take turns between them to score 
points, resulting in person with most points after reaching a certain stage, wins the 
game provided player is able to pass through all the required criteria.

## Setup

Although this game has been built on core ruby, you mau be needed to cover few dependencies
and pre-requisite to run this app. Here is a step-by-step check list:

  - Recommended to use latest version of Ruby i.e. 2.2
  - Install RVM or set up ruby environment on your machine in case you need to
  - Install rspec gem as shown below:
    ```sh
    $ gem install rspec
    ```
   - Or perhaps you can add gem 'rspec' to gem file and run 'bundle install'
 
> If you have carried out the above steps properly
> then, go to console environment and enter 
> **'ruby beinglucky.rb'**. This should be able to start
> the app. Use features guide below to browse through different options

## Features

Notable features of this game are:

  - Main Menu displayed to organize the game.
  - **Options:** playing game, leaderboard, game rules, reset game, testing and exit.
  - Players are able to play game after being verified and accounted for.
  - Leaderboard shows players name and scores accordingly.
  - Rules features details the rules needed to be aware of to play this game.
  - Reset allows the game to be reset and played again from started.
  - Exit feature simply allows players to exit the Game(console app).
  
## GamePlay

Gameplay for game Being Lucky is fairly understandable. A general scenario of 
how game proceeds is mentioned below:

* Once option is selected to play game, a check would be done to determine if there are any players registered
* if players are not registered, names and other details will be taken and recorded for registration
* If players are already registered, game will proceed with first turn
* In a single turn, players must be able to get 300 score or more to accumulate score
* If they are not able to do so, turn is finished and another player plays through
* Once 300 score is achieved, score is accumulated for that turn and preceeding turns if accumulated roll score is not equal to zero
* If accumulated score is zero, player loses not only their turns but accumulated score as well
* Game progresses through with each turn going through in accordance with these rules
* Once any player scores 3000 or more points, game enters the final phase
* One more turn is played in final phase, winner is player with highest scores

## Updates & Future Enhancements

Some future enhancements would include:

  - Mechanism to automatically pass turns between players
  - Refactoring of code 
  - Profile the application to measure speed and performance
  - Making the testing feature to give output in a summarized output
  - If possible, probably publish a Rails version soon

## Issues

If you face any issue during gameplay or performance, feel free to [Contact] me.
I will be more than happy to contribute whatever way I can to make it more
fast, bug-free and beautiful.

## License
----

None.

**Free Software. Edit, Contribute or Republish at your discretion!**

[Contact]: <mailto:syedanabimam@gmail.comm>