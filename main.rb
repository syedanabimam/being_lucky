require "rubygems"
require "highline/import"
require "./dice"

class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

class BeingLucky

    extend Dice
    
    attr_accessor :player_numbers, :final_turn, :last_turn_counter
    
    def initialize
      @player_numbers = 0 #
      @counter_turn = 0
      @game_start_counter = 0
      @final_turn = false #
      @last_turn_counter = 0 #
      @all_players_this_turn_record = {}
    end

    
    def get_player_numbers 
      @player_numbers
    end
    
    def self.get_last_turn_counter
      @last_turn_counter
    end
    
    def self.get_final_turn
      @final_turn
    end
    
    def register_players
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
      
      @player_scores = Hash.new
      if @players_names.count > 0
          @players_names.each do |name|
            score = 0
            name = name.to_sym
            @player_scores[name] = score
          end
          Hash[@player_scores.map{ |k, v| [k.to_sym, v] }]
      end
      
      create_turns_counter
      
      @players_names.each do |name|
        @all_players_this_turn_record[name.to_sym] = false
      end
      
      puts "All added players registered. Exiting to Main Menu"
      puts "Select the option of 1. Play game to begin Being Lucky"
    end
    
    def leaderboards
      if @player_numbers >= 2
        puts "=================LEADERBOARD====================="
        puts "Number of Players: #{@player_numbers}"
        puts "==================SCORING========================"
        leaderboard_hash = Hash[@player_scores.sort_by{|k, v| v}.reverse]
        leaderboard_hash.each do |name, score|
          puts "Name: #{name}        |||        Score: #{score}"
        end
        puts "================================================="
      else
        puts "================================================="
        puts "No players added to display any leaderboard"
        puts "================================================="
      end
    end
    
    def increase_turn_counter
      @player_turns_counter.each do |name, turn_counter|
        if name == @players_names[@selected_player_name].to_sym
          @player_turns_counter[name.to_sym] += 1
          @game_start_counter += 1
          @all_players_this_turn_record[name.to_sym] = true
        end
      end
      
      if @game_start_counter == @player_numbers
        @counter_turn += 1 
        @game_start_counter = 0
        @all_players_this_turn_record.each { |name, status| @all_players_this_turn_record[name.to_sym] = false } 
        puts "Check leaderboard if you want to know the score"
      end
    end
    
    def play_game
        @curr_player_score = @player_scores[@players_names[@selected_player_name].to_sym]
        puts "Score is: #{@curr_player_score} and name is #{@players_names[@selected_player_name]}"
        increase_turn_counter
        Dice.set_curr_score
        print "Turn - First Roll? y/n\n"
        puts "================================================="
        if gets.chomp.to_s == "y"
        	Dice.dice_first_turn
        	Dice.check_if_all_dices_scores
        	if Dice.get_all_dice_score_status == true
        	  if Dice.get_all_five_dice_reroll_status == true
              	puts "PRINTING RESULTS FOR TURN - REROLL"
        	      Dice.scoring_first_turn_combo
          	    Dice.scoring_first_turn_noncombo          	
              	Dice.print_results
        	  end
        	else
        	  Dice.scoring_first_turn_combo
          	Dice.scoring_first_turn_noncombo
          	puts "PRINTING RESULTS FOR TURN - FIRST ROLL FOR 5 DICES SCORE"
          	Dice.print_results
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
          if Dice.get_all_dice_score_status == true
            puts "================================================="
            puts "You have availed to add score from all 5 dices"
        if Dice.curr_score >= 300
      	  update_score
      	  #puts "line 189"
      	end
            puts "================================================="
          else
            puts "================================================="
          	puts "Couldn`t Roll. Roll again perhaps."
          	puts "================================================="
          end
        end
    
        if (@curr_player_score >= 300 || Dice.curr_score >= 300) && Dice.get_all_dice_score_status == false
          #if condition to check if curr score > 0
          print "Turn - Accumulated Roll? y/n\n"
          puts "================================================="
          if gets.chomp.to_s == "y"
            puts "PRINTING RESULTS FOR TURN - SECOND ROLL"
          	Dice.scoring_second_turn
          	puts "================================================="
          	puts "Exiting this turn"
          	puts "================================================="
          	puts "Accumulated score by now is : #{Dice.get_accumulated_score}"
          	update_score
          	#puts "line 221 - #{Dice.curr_score}"
          	Dice.set_curr_score
          	puts "================================================="
          else
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
          if Dice.get_all_dice_score_status == true
            update_score
            #puts "line 235"
            puts "Score updated. Your current score is #{Dice.curr_score}."
            puts "=================================================" 
            Dice.set_curr_score
          	puts "No Another Turn availed or available"
          	puts "=================================================" 
          elsif Dice.get_all_five_dice_reroll_status == true
            update_score
            puts "Line 248 - Score updated to #{Dice.curr_score}"
            Dice.set_curr_score
          else
            puts "Oops, Your score #{Dice.curr_score} is less than 300. You can`t enter game"
            puts "unless you get 300 in a single turn, Next player Will take turn"
          end
        end
    end
    
    def select_player_to_play
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
    
    def update_score
        @player_scores.each do |name, score|  
          curr_player = @players_names[@selected_player_name].to_sym
          if name == curr_player
            score = score + Dice.curr_score 
            @player_scores[name] = score
            puts "#{curr_player} new score is: #{score}"
          end
        end
    end
    
    def create_turns_counter
      @player_turns_counter = {}
      @players_names.each do |name|
        @player_turns_counter[name.to_sym] = 0
      end
    end
    
    def check_if_it_is_end_turn
      @player_scores.each do |name, score|  
        #curr_player = @players_names[@selected_player_name].to_sym
        
        # if name.to_s == "joe"
        #   @player_scores[name] = 3000
        # elsif name.to_s == "roe"
        #   @player_scores[name] = 3200
        # end
        
        #puts "Score: #{@player_scores[name]}"
        if @player_scores[name] >= 3000
            #@player_scores[name] = score
            @final_turn = true
            puts "Game Entering Final Round because player '#{name}' have scored #{@player_scores[name]} which meets"
            puts "the criteria of having 3000 or more points which qualifies the game to enter final round"
        end
      end  
    end
    
    def display_winner
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
      else
          puts "Let all players finish their turn first"
          puts "Last turn counter: #{@last_turn_counter} -- Player Numbers: #{@player_numbers}"
      end
    end
end

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
    when 1
      if playing_beinglucky.player_numbers < 2
        puts "No players registerd. Please register at least two players"
        playing_beinglucky.register_players
      else
        playing_beinglucky.select_player_to_play
        playing_beinglucky.check_if_it_is_end_turn
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
    when 2
      playing_beinglucky.leaderboards
    when 3
      Dice.game_rules
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
    when 5
      # code TESTING      
    when 6
      puts "================================================="
      puts "Exiting"
      puts "================================================="
      exit     
    else 
      puts "================================================="
      puts "Invalid selection. Please select the appropriate choice again"
  end
end