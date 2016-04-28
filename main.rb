require "rubygems"
require "highline/import"
require "./dice"

include Dice
#print "Player, please Enter your name: "
#player_name = gets.chomp.to_s
@player_numbers = 0
@counter_turn = 0
@game_start_counter = 0
@all_players_this_turn_record = {}

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
      if @playername.length >= 2
          @players_names << @playername
          @playername = ""
          break
      else
          puts "Enter a name with atleast two characters" 
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
    #puts "================================================="
    #puts "Player Names: #{@players_names.join(", ")}"
    puts "==================SCORING========================"
    leaderboard_hash = Hash[@player_scores.sort_by{|k, v| v}.reverse]
    #puts leaderboard_hash
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

def check_if_all_players_have_taken_turn
    @all_players_played = false
    
    @player_turns_counter.each do |name, turn_counter|
      if turn_counter == @counter_turn
        #@all_players_played = true
        puts "This player #{name} has same number of turns (player turn counter#{turn_counter} : game turn counter#{@counter_turn})"
        @all_players_played_record[name.to_sym] = true 
      else
        puts "Player #{name} has played #{turn_counter} which is not same as the turns taken: #{@counter_turn}"
        @all_players_played_record[name.to_sym] = false  
        #@all_players_played = false
      end
    end
    puts "Players for this turn have played status: #{@all_players_played_record}"
    if @all_players_played_record.include? false
      puts "Not all players have played their turns"
    else
      puts "All players have played their turns"
      @all_players_played = true
      #@counter_turn += 1
      @player_turns_counter
    end
     #if @all_players_played == true
end

def increase_turn_counter
  #@all_players_not_played = true
  #puts "Increasing turn counter"
  #puts "Current player is #{@players_names[@selected_player_name]}"
  @player_turns_counter.each do |name, turn_counter|
    if name == @players_names[@selected_player_name].to_sym
      #puts "Increasing turn counter for player #{name} now"
      @player_turns_counter[name.to_sym] += 1
      @game_start_counter += 1
      @all_players_this_turn_record[name.to_sym] = true
    end
    #if @player_turns_counter[name.to_sym] == 1
     #  @game_start_counter += 1
    #end
    #puts "Turn counter for #{name} is #{@player_turns_counter[name.to_sym]}"
  end
  
  if @game_start_counter == @player_numbers
    @counter_turn += 1 
    @game_start_counter = 0
    @all_players_this_turn_record.each { |name, status| @all_players_this_turn_record[name.to_sym] = false } 
    puts "Check leaderboard if you want to know the score"
    #@all_players_not_played = false
    #puts "After this counter for turn has increased, currently: #{@all_players_this_turn_record}"
  else
    #puts "Not all players have taken their turn"
    @all_players_this_turn_record.each do |name, status|
      if status == false
       # @all_players_not_played = true
        #puts "This player #{name} has not taken turn"
      end
    end
    puts @all_players_this_turn_record
  end
  
  #puts "Currently players turns are: #{@player_turns_counter} and counter_turn is #{@counter_turn}"
end

def play_game
    increase_turn_counter
    Dice.set_curr_score
    #check_if_all_players_have_taken_turn
    #puts "Players turn current status #{@all_players_played} and counter is #{@counter_turn}"
    print "Roll first Turn? y/n\n"
    puts "================================================="
    if gets.chomp.to_s == "y"
    	Dice.dice_first_turn
    	Dice.check_if_all_dices_scores
    	if Dice.get_all_dice_score_status == true
    	  if Dice.get_all_five_dice_reroll_status == true
    	      #Dice.scoring_first_turn_combo 1
          	#Dice.scoring_first_turn_noncombo 1
          	puts "PRINTING RESULTS FOR TURN - REROLL"
    	      Dice.scoring_first_turn_combo
      	    Dice.scoring_first_turn_noncombo          	
          	Dice.print_results
          	#update_score
    	  else
    	      #update_score EBD
    	  end
    	else
    	  Dice.scoring_first_turn_combo
      	Dice.scoring_first_turn_noncombo
      	puts "PRINTING RESULTS FOR TURN - FIRST ROLL"
      	Dice.print_results
      	if Dice.get_all_five_dice_reroll_status == true && Dice.curr_score >= 300
      	  #puts "line 175"
      	  #update_score
      	  print "Roll another turn? y/n\n"
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

    	 # Need to call this appt place
    	puts "================================================="
    else
      if Dice.get_all_dice_score_status == true
        puts "================================================="
        puts "You have availed to add score from all 5 dices"
        if Dice.curr_score >= 300
      	  update_score
      	  puts "line 189"
      	end
        puts "================================================="
      else
        puts "================================================="
      	puts "Couldn`t Roll. Roll again perhaps."
      	puts "================================================="
      end
    end
    
    # if Dice.get_all_dice_score_status
    #   update_score
    #   Dice.set_all_dice_score_status(false)
    # end
    
    if Dice.curr_score >= 300 && Dice.get_all_dice_score_status == false
      #update_score
      print "Roll another turn? y/n\n"
      puts "================================================="
      if gets.chomp.to_s == "y"
        puts "PRINTING RESULTS FOR TURN - SECOND ROLL"
      	Dice.scoring_second_turn
      	puts "================================================="
      	puts "Exiting this turn"
      	puts "================================================="
      	puts "Accumulated score by now is : #{Dice.get_accumulated_score}"
      	if Dice.get_accumulated_score > 0
      	  #update_score 
      	  #puts "line 217 - #{Dice.curr_score}"
      	  #Dice.set_curr_score
      	end
      	update_score
      	puts "line 221 - #{Dice.curr_score}"
      	Dice.set_curr_score
      	#print_results
      	#update_score
      	puts "================================================="
      else
        update_score
        puts "Line 225"
        puts "update_score already done on line 174"
        puts "Score updated. Your current score is #{Dice.curr_score}."
        puts "================================================="   
        Dice.set_curr_score
      	puts "No Another Turn availed or available"
      	puts "================================================="
      end
    else
      if Dice.get_all_dice_score_status == true
        update_score
        puts "line 235"
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
        puts "Oops, Your score #{Dice.curr_score} is less than 300. You can`t roll another turn on"
        puts "top of your previous turn, Next player Will take turn"
      end
    end
end

def select_player_to_play
  puts "Players Names:"
  puts "================================================="
  counter = 0
  #@players_names.each do |name|
   # counter += 1
   # puts "#{counter} - Player Name: #{name}"
  #end
  
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
  @selected_player_name = gets.chomp.to_i - 1
  #if (@players_name.include? @players_names[@selected_player_name])
    puts "#{@players_names[@selected_player_name]} will take this turn"
    puts "================================================="
 # else
  #  puts "Select a valid player again"
 #   select_player_to_play
  #end
end

def update_score
   # @player_scores[@selected_player_name] = @current_score
   #puts @player_scores
    @player_scores.each do |name, score|  
     # puts "Name: #{name} and score: #{score.class}, current turn score is #{Dice.curr_score.class} and add is 
      #{score + Dice.curr_score}"
      curr_player = @players_names[@selected_player_name].to_sym
      
      if name == curr_player
        #puts "curr player is #{curr_player}"
        score = score + Dice.curr_score 
        @player_scores[name] = score
        puts "#{curr_player} is new score: #{score}"
        #puts @player_scores
      end
    end
end

def create_turns_counter
  #player names assigned to turns they have taken
  @player_turns_counter = {}
  @players_names.each do |name|
    @player_turns_counter[name.to_sym] = 0
  end
  #puts @player_turns_counter
end

while(true) do
  puts "================================================="
  puts "             BEING LUCKY - MAIN MENU             "
  puts "================================================="
  puts "Choose Option:
  1. Play game
  2. Leaderboard
  3. Game Rules
  4. Testing
  5. Exit"
  
  puts "Select an option by entering an option number. i.e. 3 for game rules"
  
  puts "================================================="
  
  n = gets.chomp.to_i
  
  case n
    when 1
      if @player_numbers < 2
        puts "No players registerd. Please register at least two players"
        register_players
      else
        select_player_to_play
        play_game
      end
    when 2
      leaderboards
    when 3
      Dice.game_rules
    when 4
      # code      
    else 
      puts "================================================="
      puts "Exiting"
      puts "================================================="
      exit
  end
end