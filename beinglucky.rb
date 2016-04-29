require "rubygems"
#require "highline/import"
require "./dice"

class String
    #Method to check if string has integers or Numericals insides
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

class BeingLucky
    #Extend Dice Module
    extend Dice
    
    #This allows these three variables outside with Being Lucky instance
    attr_accessor :player_numbers, :final_turn, :last_turn_counter
    
    #Initializes all the important variables that are used to measure, record and manage the player turns
    def initialize
      @player_numbers = 0 #
      @counter_turn = 0
      @game_start_counter = 0
      @final_turn = false #
      @last_turn_counter = 0 #
      @all_players_this_turn_record = {}
    end
    
    #Register Players such as number of players, names and other important details
    def register_players
      #Number of Player
      puts "================================================="
      puts "Please state the number of players that are going to play?"
      puts "================================================="
      @player_numbers = gets.chomp.to_i
      while @player_numbers < 2 
        puts "Not valid number of players. Please enter atleast two players to play"
        puts "================================================="
        @player_numbers = gets.chomp.to_i
        if @player_numbers >= 2
          puts "#{@player_numbers} players will be participating in this game."
          puts "================================================="
          break
        end
      end
      
      #Players Names
      puts "Please enter the name for #{@player_numbers} players"
      @players_names = []
      @playername = ""
      @player_numbers.times do |i|
        while @playername.length < 2
          puts "Player Name(#{i+1}):"
          @playername = gets.chomp.to_s  
          if @playername.length >= 2 && !@playername.is_i?
              @players_names << @playername
              @playername = ""
              break
          else
              puts "Enter a name with atleast two characters" if @playername.length <= 2
              puts "Enter a name in string format i.e. John is correct, 123 is not" if @playername.is_i?
          end
        end
        puts "================================================="
      end
      
      #Player scores will be stored in hash created here
      @player_scores = Hash.new
      if @players_names.count > 0
          @players_names.each do |name|
            score = 0
            name = name.to_sym
            @player_scores[name] = score
          end
          Hash[@player_scores.map{ |k, v| [k.to_sym, v] }]
      end
      
      #Counter is created for turns
      create_turns_counter
      
      #Hash to check if current player has availed the current game turn
      @players_names.each do |name|
        @all_players_this_turn_record[name.to_sym] = false
      end
      
      #Message printed showing all players have been added and registered
      puts "All added players registered. Exiting to Main Menu"
      puts "Select the option of 1. Play game to begin Being Lucky"
    end
    
    #Leaderboard shows the player names and scores
    def leaderboards
      #Leaderboard would show if atleast 2 players are registered
      if @player_numbers >= 2
        puts "=================LEADERBOARD====================="
        puts "Number of Players: #{@player_numbers}"
        puts "==================SCORING========================"
        leaderboard_hash = Hash[@player_scores.sort_by{|k, v| v}.reverse]
        leaderboard_hash.each do |name, score|
          puts "Name: #{name}        |||        Score: #{score}"
        end
        puts "================================================="
      #If no players are added then no leaderboard will be displayed
      else
        puts "================================================="
        puts "No players added to display any leaderboard"
        puts "================================================="
      end
    end
    
    #Increase turn counter to manage turns
    def increase_turn_counter
      #This loop finds the record of current player and increases the counter
      @player_turns_counter.each do |name, turn_counter|
        if name == @players_names[@selected_player_name].to_sym
          @player_turns_counter[name.to_sym] += 1
          @game_start_counter += 1
          @all_players_this_turn_record[name.to_sym] = true
        end
      end
      
      #Here it checks if total number of current turn counter is equal to the number of player
      #if there are 8 players, then for one game turn to complete, 8 turns will be availed by 8 players
      if @game_start_counter == @player_numbers
        @counter_turn += 1 
        @game_start_counter = 0
        @all_players_this_turn_record.each { |name, status| @all_players_this_turn_record[name.to_sym] = false } 
        puts "Check leaderboard if you want to know the score"
      end
    end
    
    #Game is played with this method
    def play_game
        #Gets current player name and score
        @curr_player_score = @player_scores[@players_names[@selected_player_name].to_sym]
        puts "Current player name: #{@players_names[@selected_player_name]}, Score: #{@curr_player_score}"
        
        #Method call to increase turn counter for this player
        increase_turn_counter
        
        #Sets game current score to zero
        Dice.set_curr_score
        
        #Turn - First roll initiated
        print "Turn - First Roll? y/n\n"
        puts "================================================="
        #if answer is yes it calls the method to roll five dices
        if gets.chomp.to_s == "y"
        	Dice.dice_first_turn
        	#Then it checks if all dices are scoring
        	Dice.check_if_all_dices_scores
        	if Dice.get_all_dice_score_status == true
        	  if Dice.get_all_five_dice_reroll_status == true
        	      #Once confirmed that all 5 dices that were scoring have been rolled again
        	      #It runs the first roll and calculate results
              	puts "PRINTING RESULTS FOR TURN - REROLL"
        	      Dice.scoring_first_turn_combo
          	    Dice.scoring_first_turn_noncombo          	
              	Dice.print_results
        	  end
        	else
        	  #If all dices are not scoring then turn is resumed as usual
        	  Dice.scoring_first_turn_combo
          	Dice.scoring_first_turn_noncombo
          	puts "PRINTING RESULTS FOR TURN - FIRST ROLL FOR 5 DICES SCORE"
          	Dice.print_results
          	#If player availed the chance to roll all five dices again then player will be asked for second turn
          	if Dice.get_all_five_dice_reroll_status == true && (@curr_player_score >= 300 || Dice.curr_score >= 300)
          	  print "Turn - Another roll? y/n\n"
              puts "================================================="
              if gets.chomp.to_s == "y"
                puts "PRINTING RESULTS FOR TURN - SECOND ROLL"
              	Dice.scoring_second_turn
              	puts "================================================="
              	puts "Exiting this turn"
              	puts "================================================="
              	puts "Accumulated score by now is : #{Dice.get_accumulated_score}"
              else
                puts "you decided not to take another turn for accumulated score after re-rolling"
              end
          	end
        	end
        	puts "================================================="
        else
          #If player chooses not to roll all five dices again but add their score then code below caters for it
          if Dice.get_all_dice_score_status == true
            puts "================================================="
            puts "You have availed to add score from all 5 dices"
        #Once checking if the score is atleast greater than 300, score is added.
        #It should be noted this 300 score condition only needs to be satisfied once
        if Dice.curr_score >= 300
      	  update_score
      	  #puts "line 189"
      	end
            puts "================================================="
          else
            #If some unexpected issues occur, Player is informed to roll in next turn
            puts "================================================="
          	puts "Couldn`t Roll. Wait for next turn."
          	puts "================================================="
          end
        end
        
        #Once a turn`s first roll has been catered for, second turn mechanism will be initiated
        if (@curr_player_score >= 300 || Dice.curr_score >= 300) && Dice.get_all_dice_score_status == false
          #If current score is greater than zero, game will proceed
          if Dice.curr_score > 0
            puts "Current score is #{Dice.curr_score}"
            print "Turn - Accumulated Roll? y/n\n"
            puts "================================================="
            #If answes is yes then dices for second turn will be rolled - For more info see this method in Dice Module
            if gets.chomp.to_s == "y"
              puts "PRINTING RESULTS FOR TURN - SECOND ROLL"
            	Dice.scoring_second_turn
            	puts "================================================="
            	puts "Exiting this turn"
            	puts "================================================="
            	puts "Accumulated score by now is : #{Dice.get_accumulated_score}"
            	#Score updated which will be curren score + accumulated score
            	update_score
            	#puts "line 221 - #{Dice.curr_score}"
            	Dice.set_curr_score
            	puts "================================================="
            else
              #If user answers no then score is updated to add current score 
              #and then reset current score to zero
              update_score
              #puts "Line 225"
              #puts "update_score already done on line 174"
              puts "Score updated. Your current score is #{Dice.curr_score}."
              puts "================================================="   
              Dice.set_curr_score
            	puts "No Another Turn availed or available"
            	puts "================================================="
            end
          else
            #If score is zero, then player is informed that all 5 dices score amounts to zero
            puts "================================================="
            puts "Your first roll score for five dices amount to zero"
            puts "================================================="            
            puts "Therefore you cannot play any further. Exiting to Main Menu"
          end
        else
          if Dice.get_all_dice_score_status == true
            #if all five dices were scoring in first roll then score will be updated and 
            #player informed no more dices are remaining to play for this turn            
            update_score
            #puts "line 235"
            puts "Score updated. Your current score is #{Dice.curr_score}."
            puts "=================================================" 
            Dice.set_curr_score
          	puts "No Another Turn availed or available"
          	puts "=================================================" 
          elsif Dice.get_all_five_dice_reroll_status == true
            #if all five dices in first roll were scoring and player rolled them again, the score will be updated here
            update_score
            puts "Line 248 - Score updated to #{Dice.curr_score}"
            Dice.set_curr_score
          else
            #In case if player was trying to "Enter Game" by trying to get score of 300 but could not then 
            #message below will be printed out
            puts "Oops, Your score #{Dice.curr_score} is less than 300. You can`t enter game"
            puts "unless you get 300 in a single turn, Next player Will take turn"
          end
        end
    end
    
    #Select the player to play the turn
    def select_player_to_play
      #All player names are printed in accordance with whether they have already availed their turn
      puts "Players Names:"
      puts "================================================="
      counter = 0
    
      @all_players_this_turn_record.each do |name, status|
       counter += 1
        if status == true
          puts "#{counter} - Player Name: #{name} (Have taken the turn)"
        elsif status == false
          puts "#{counter} - Player Name: #{name} (Have not taken the turn)"
        end
      end
      puts "================================================="
      puts "Select Which player wants to take the first turn? i.e. Type Numeric no. of player name"
      puts "================================================="
      #The response would be verified to make sure it points to actual user and does not crash the app
      begin
        @selected_player_name = gets.chomp
        @selected_player_name = Integer(@selected_player_name)
        @selected_player_name -= 1
        @selected_player_record_name = @players_names[@selected_player_name]
        if @players_names.include? @selected_player_record_name
          puts "#{@players_names[@selected_player_name]} will take this turn"
          puts "================================================="
        else
          puts "No such name exist in the record. Select the correct player"
          puts "================================================="
          raise "Issue has occured with matching the name to existing players record"
        end
      rescue
        puts "Please enter an integer number to select a player:" 
        puts "To select a player (1 - Player Name: joe) i.e. Type Numeric no. of player name '1' to select joe"
        puts "================================================="
        retry
      end  
    end
    
    #Score is updated whenever this method is called
    def update_score
        #Current player score is updated by looping through player_scores hash and adding new score to the current
        @player_scores.each do |name, score|  
          curr_player = @players_names[@selected_player_name].to_sym
          if name == curr_player
            score = score + Dice.curr_score 
            @player_scores[name] = score
            puts "#{curr_player} new score is: #{score}"
          end
        end
    end
    
    #Turns counter is created when this method is called
    def create_turns_counter
      #Creates turn counter which assist in managing turns
      @player_turns_counter = {}
      @players_names.each do |name|
        @player_turns_counter[name.to_sym] = 0
      end
    end
    
    #Checks if it is the last turn
    def check_if_it_is_end_turn
      #Checks if the current turn is the end turn if score is above or equal to 3000
      @player_scores.each do |name, score|  
        #For testing final turn
        # if name.to_s == "joe"
        #   @player_scores[name] = 3000
        # elsif name.to_s == "roe"
        #   @player_scores[name] = 3200
        # end
        
        if @player_scores[name] >= 3000
            @final_turn = true
            puts "Game Entering Final Round because player '#{name}' have scored #{@player_scores[name]} which meets"
            puts "the criteria of having 3000 or more points which qualifies the game to enter final round"
        end
      end  
    end
    
    #Displays out the winner
    def display_winner
      #If all players have taken their turn then their scores are compared and winner is announced
      if @last_turn_counter == @player_numbers
          @player_end_results = Hash[@player_scores.sort_by{|k, v| v}.reverse]
          name = @player_end_results.keys[0]
          score = @player_end_results.values[0]
          
          puts "Thank you for playing Being Lucky this far. Scores will now be calculated to determine winner"
          Dice.thumbs_up
          puts "Winner for Being Lucky is #{name} and score is #{score}"
          leaderboards
          Dice.not_bad
          puts "Game will exit now. Please play again and try being lucky :) if you were not this time"
          puts ""
          exit
      #if not all players have taken their turns, then players are informed to finish their turn first
      else
          puts "Let all players finish their turn first"
          #This print helps in checking out if all players have taken turns or not
          puts "Last turn counter: #{@last_turn_counter} -- Player Numbers: #{@player_numbers}"
      end
    end
end

#Intializes BingLucky class instance
playing_beinglucky = BeingLucky.new

while(true) do
  puts "================================================="
  puts "             BEING LUCKY - MAIN MENU             "
  puts "================================================="
  puts "Choose Option:
  1. Play game
  2. Leaderboard
  3. Game Rules
  4. Reset Game
  5. Testing
  6. Exit"
  
  puts "Select an option by entering an option number. i.e. 3 for game rules"
  
  puts "================================================="
  
  n = gets.chomp.to_i
  
  case n
    #Upon Selecting 1, player are opting to play the game
    when 1
      #If less than two players are registered then it means no players are registered
      #Therefore players are asked to register themeselves
      if playing_beinglucky.player_numbers < 2
        puts "No players registerd. Please register at least two players"
        playing_beinglucky.register_players
      else
        #Select the player to play
        playing_beinglucky.select_player_to_play
        #Check if this is the end turn
        playing_beinglucky.check_if_it_is_end_turn
        #if it is the final turn then methods for playing one last turn and display out the winer is called
        if playing_beinglucky.final_turn == true
          puts "Game has entered into final phase"
          playing_beinglucky.play_game
          playing_beinglucky.last_turn_counter += 1
          playing_beinglucky.display_winner
        else
          puts "Game has not entered into final phase yet"
          playing_beinglucky.play_game          
        end
      end
    #Option 2 display the leaderboard  
    when 2
      playing_beinglucky.leaderboards
    #Option 3 displays the game rules  
    when 3
      Dice.game_rules
    #Option 4 resets the game by simply reinitializing the Being Lucky class  
    when 4
      # code for reset
      puts "================================================="
      puts "Are you sure you want to Reset the game? (y/n)"
      puts "================================================="
      if gets.chomp.to_s == "y"
        puts "================================================="
        puts "Game being reset now"
        puts "================================================="
        playing_beinglucky = BeingLucky.new
      else
        puts "================================================="
        puts "Game will not be reset"
        #puts "================================================="
      end
    #Call to Rspec test cases  
    when 5
      # code TESTING
      puts "================================================="
      puts "Ideally this option should run and show the all the examples being run"
      puts "and their result displayed in a summarized and presentable way"
    #Exits the game  
    when 6
      puts "================================================="
      puts "Exiting"
      puts "================================================="
      exit  
    #If invalid choice is typed, then menu is printed again  
    else 
      puts "================================================="
      puts "Invalid selection. Please select the appropriate choice again"
  end
end