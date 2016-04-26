require "rubygems"
require "highline/import"
require "./dice"

include Dice
#print "Player, please Enter your name: "
#player_name = gets.chomp.to_s
@player_numbers = 0

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

def play_game
    print "Roll first Turn? y/n\n"
    puts "================================================="
    if gets.chomp.to_s == "y"
    	Dice.dice_first_turn
    	Dice.scoring_first_turn_combo
    	Dice.scoring_first_turn_noncombo
    	puts "PRINTING RESULTS FOR TURN - FIRST ROLL"
    	Dice.print_results
    	update_score # Need to call this appt place
    	puts "================================================="
    else
    	puts "Couldn`t Roll. Roll again perhaps."
    	puts "================================================="
    end
    
    print "Roll Second Turn? y/n\n"
    puts "================================================="
    if gets.chomp.to_s == "y"
      puts "PRINTING RESULTS FOR TURN - SECOND ROLL"
    	Dice.scoring_second_turn
    	#print_results
    	#update_score
    	puts "================================================="
    else
    	puts "No Second Turn availed or available"
    	puts "================================================="
    end
end

def select_player_to_play
  puts "Players Names:"
  puts "================================================="
  counter = 0
  @players_names.each do |name|
    counter += 1
    puts "#{counter} - Player Name: #{name}"
  end
  puts "================================================="
  puts "Select Which player wants to take the first turn? i.e. Type Numeric no. of player name"
  puts "================================================="
  @selected_player_name = gets.chomp.to_i - 1
  puts "#{@players_names[@selected_player_name]} will take this turn"
  puts "================================================="
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
        #puts "this is new score: #{score}"
        #puts @player_scores
      end
    end
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