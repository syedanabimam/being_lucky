module Dice
    #Initializes necessary variables
    @current_score = 0
    @all_dice_scores_add = false
    @rolling_all_five_again = false

    #Show current score
    def self.curr_score
        @current_score
    end
    
    #Set current turn score to zero
    def self.set_curr_score
        @current_score = 0
    end
    
    #Get status of all five dices rolling again or not
    def self.get_all_five_dice_reroll_status
       @rolling_all_five_again
    end
    
    #Check if all dice are scoring and whether score needs to be added
    def self.get_all_dice_score_status
       @all_dice_scores_add
    end
    
    #Play first roll of the turn
    def self.dice_first_turn
        #create random array between 1..6
    	@dice = Array.new(5) { rand(1...6) } 
    	
    	#Random dice patterns to test
        #@dice = [3, 3, 3, 4, 5] # OK
        #@dice = [2, 2, 2, 4, 5] # OK
        #@dice = [3, 1, 5, 3, 3] # INPROCESS, FIXED
        #@dice = [3, 5, 1, 1, 5] # FIXED, OK
        #@dice = [1, 1, 1, 1, 3] # FIXED, OK
        #@dice = [1, 1, 1, 1, 5] # FIXED, OK
        #@dice = [4, 1, 2, 3, 5] # FIXED, OK
        #@dice = [4, 3, 2, 4, 2] # DEAL WITH IT ASAP
        
        #find 3 combo pattern
    	@combo_check = @dice.select{ |e| @dice.count(e) > 2 } 
    	
    	#Get common denominator of combo pattern
    	@combo = @combo_check.first(3)
    	
    	#Isolate and find common number for 3-pattern
    	@combo_num = @combo.uniq.join()
    
        #Check combo count and determine remianing dices based on that
    	if @combo_check.count == 4
    		@remaining_dice = @dice | @combo_check
    	elsif @combo.count == 3
    		@remaining_dice = @dice - @combo_check
    	else
    		@remaining_dice = @dice - @combo_check
    	end
    end
    
    #Checks if all dices are scoring
    def self.check_if_all_dices_scores
       #Checks if all dices are scoring and validates it with conditions
       if ((@combo_num.length > 0) && (@remaining_dice.include? 1) && (@remaining_dice.include? 5))
           
           puts "================================================="
           puts "Dice results(arr): #{@dice}"
           puts "================================================="
           puts "All dices are scoring. You have the option to roll all the dices again."
           puts "================================================="
           puts "Do you want to roll them again or not (score for 5 dices will be added)?\n"
           puts "================================================="
           print "which ever it is, please proceed by entering y/n?\n"
           puts "================================================="
           #If user select to roll all the five dices again then turn is started again
           if gets.chomp.to_s == "y"
               puts "================================================="
               puts "Rolling the dices again."
               puts "================================================="
               @rolling_all_five_again = true
               dice_first_turn
           #if not players all 5 dices scores are added   
           else
               puts "================================================="
               puts "You decided not to roll the 5 dices. Score will be added for the 5 dices"
               puts "================================================="
               scoring_first_turn_combo
               scoring_first_turn_noncombo
               @rolling_all_five_again = false
               @all_dice_scores_add = true
           end
       #Player is informed not all 5 dices are scoring
       else
          puts "================================================="
          puts "Not all dices are scoring"
          puts "================================================="

       end
    end

    #Add score for combo dices as per scoring criteria
    def self.scoring_first_turn_combo
       case @combo_num
       when "1"
       	@current_score = 1000
       when "2"
       	@current_score = 200
       when "3"
       	@current_score = 300
       when "4"
       	@current_score = 400
       when "5"
       	@current_score = 500
       when "6"
       	@current_score = 600
       else
        puts "================================================="   
       	puts "No three number combo pattern detected"
       	puts "================================================="
       end
    end
    
    #Add scores for non-combo dices as per scoring criteria
    def self.scoring_first_turn_noncombo
      @single_score_dice_arr = []
      #Scores added for remaining dices
      if @remaining_dice.count != 0
       @remaining_dice.each do |num|
       	if num == 1
       		@current_score = @current_score + 100
       		@single_score_dice_arr << num
       	elsif num == 5
       		@current_score = @current_score + 50 
       		@single_score_dice_arr << num
       	end
       end
      #In case no remaining dices are there, score is added 
      else
       @dice.each do |num|
       	if num == 1
       		@current_score = @current_score + 100 	
       		@single_score_dice_arr << num
       	elsif num == 5
       		@current_score = @current_score + 50 
       		@single_score_dice_arr << num
       	end
       end  	
      end
      #Non scoring dices are determined here
      @non_dice_array = @remaining_dice - @single_score_dice_arr
    end
    
    #Add Score for Second roll
    def self.scoring_second_turn
        @accumulated_score = 0
        #Generate numbers for remaining dices
    	@second_dice = Array.new(@non_dice_array.count) { rand(1...6) }
    	@second_single_score_dice_arr = []
        
        #Scores added as per the criteria
    	@second_dice.each do |num|
    	   	if num == 1
    	   		@accumulated_score = @accumulated_score + 100 	
    	   		@second_single_score_dice_arr << num
    	   	elsif num == 5
    	   		@accumulated_score = @accumulated_score + 50 
    	   		@second_single_score_dice_arr << num
    	   	end
    	end
    	
    	#Remaining dices after second roll is calculated and results are printed out
    	@second_turn_remainder = @second_dice - @second_single_score_dice_arr
       	puts "================================================="
    	puts "Second turn results for remaining dice(s): #{@second_dice}"
    	puts "================================================="
    	puts "Second turn (Current + Accumulated) score: #{@current_score + @accumulated_score}"
    	puts "================================================="
    	puts "Remaining elements now: #{@second_turn_remainder}"
    	puts "================================================="
    	
    	#Loop runs for consecutive rolls until players rolls all dices to gain accumulated scores
    	#or lose all accumulated score if receive zero scoring dices or skip rolling in middle of it
    	#to preserve the score
        loop do
            puts "================================================="
            puts "Accumulated Score: #{@accumulated_score}"
            puts "================================================="
            #Score is only added if accumulated score for previous roll is greater than zero
            if @accumulated_score > 0
        		if @second_turn_remainder.count == 0
        		    @current_score = @current_score + @accumulated_score
        		    puts "================================================="
        			puts "Total Score by now: #{@current_score}"
        			puts "================================================="
        			puts "No more dice to roll for this turn" 
        			break 
        		end
        		#Player is prompted to answer whether to play another roll
        		print "Want another go? y/n \n"
        		puts "================================================="
        		proceed = gets.chomp.to_s
        		#If answer is yes and accumulated score is zero then dices are generated
        		#for the remaining dices and scores are added as per the scoring criteria
        		if proceed == "y" && @accumulated_score > 0
        			@second_dice_another_roll = Array.new(@second_turn_remainder.count) { rand(1...6) }
        			@second_single_score_dice_arr_again = []
        			@accumulated_score_more = 0
        			@second_dice_another_roll.each do |num|
        			   	if num == 1
        			   		@accumulated_score_more = @accumulated_score_more + 100 	
        			   		@second_single_score_dice_arr_again << num
        			   	elsif num == 5
        			   		@accumulated_score_more = @accumulated_score_more + 50 
        			   		@second_single_score_dice_arr_again << num
        			   	end
        			end 
        			#Remaining dices are calculated and results are printed out
        			@second_turn_again_remainder = @second_dice_another_roll - @second_single_score_dice_arr_again
        			@second_turn_remainder = @second_turn_again_remainder
        			puts "================================================="
        			puts "Dice array: #{@second_dice_another_roll}"
        			puts "================================================="
        			puts "@second_single_score_dice_arr_again : #{@second_single_score_dice_arr_again}"
        			puts "================================================="
        			puts "Remaining elements on second turn, second roll: #{@second_turn_again_remainder}"
        			puts "================================================="
        			puts "Total (Current + Accumulated) Score by now: #{@current_score + @accumulated_score}"
        			puts "================================================="
        			
        			#If accumulates score is zero then player is informed and results are printed out
        			if @accumulated_score_more == 0
        			   puts "================================================="
        			   puts "You scored #{@accumulated_score_more} in this roll"
        			   puts "================================================="
        			   puts "Therefore, you will lose all your accumulated score and your turn as well"
        			   puts "=================================================" 
        			   puts "Your current score is: #{@current_score}"
        			   puts "================================================="
        			   break
        			#If accumulated score is not zero then player is informed of new scores and results are printed
        			else
        			   puts "=================================================" 
        			   puts "Your current accumulated score is #{@accumulated_score}"
        			   puts "================================================="
        			   puts "You scored #{@accumulated_score_more} in this turn which will be added to your accumulated score"
        			   @accumulated_score = @accumulated_score + @accumulated_score_more 
        			   puts "================================================="
        			   puts "Your post adding accumulated score is now #{@accumulated_score}"
        			   puts "================================================="
        			end
        		end
        		#if answer to roll another is no then current score is added with any accumulated score there is
        		if proceed == "n" 
        		    @current_score = @current_score + @accumulated_score
        		    puts "You decided not to take another roll"
        		    puts "================================================="
        		    puts "Your accumulated score is #{@accumulated_score}"
        		    puts "================================================="
        			puts "Total Score by now: #{@current_score}"
        			break 
        		end
            #Otherwise, If score is zero and there are no dices, results are printed then
            else
                puts "Your score for this roll is 0 therefore no more turns for you"
        	    puts "================================================="
    			puts "Total Accumulated Score by now: #{@current_score}"
    			puts "================================================="
    			puts "No more dice to roll for this turn"
    			break     
            end
        end    	    
    end
    
    #Show accumulated score
    def self.get_accumulated_score 
        @accumulated_score
    end
    
    #Print out the results
    def self.print_results
    	puts ""
    	puts "===================SPECIFICS====================="
    	puts "Dice results(arr): #{@dice}"
    	puts "================================================="
    	puts "3-Combination: #{@combo}"
    	puts "================================================="
    	puts "Repetitive number of triple combo: #{@combo_num}"
    	if @combo.count > 1
    		puts "================================================="
    		puts "Remaining dice Array: #{@remaining_dice}"
    	end
    	puts "================================================="
    	puts "Non Dice Array: #{@non_dice_array}"
    	puts "================================================="
    	puts "Current Score: #{@current_score}"
    end
    
    #Print out the game rules
    def self.game_rules 
       puts ""
       puts "===================================================================="
       puts " 
       Are you worried about how to play this game, then have 
       no fear young padawan, Force will guide you. 
       
       (^_^メ)
       
       2 or more player roll 5 dice to play being Lucky.
       In each turn, scores are awarded based on subsequent dice 
       results. Player must be able to get 300 in a single turn
       before they are allowed to accumulate score. Once 300 score
       is attained, Players can further play to accumulate further
       score for that turn until last round.
       
       ¯\_(ツ)_/¯
       
       Turn passes from one player to another player, until game
       reaches its climax when 3000 score is attained by any player(s).
       After playing one last turn, player with highest scores win the 
       game.
       
       (ノಠ益ಠ)ノ彡┻━┻
        
       Now Lets play some game!!
        
       キタ━━━(゜∀゜)━━━!!!!! 
        "
       puts "===================================================================="
       puts ""
    end
    
    #Print out thumbs up
    def self.thumbs_up
      puts "      _ "
      puts "     /(|"
      puts "    (  :"
      puts "   __\  \  _____"
      puts " (____)  `|     | "
      puts "(____)|   |     |  "
      puts " (____).__|     |   "
      puts "  (___)__.|_____|    "
      puts "..."        
    end
    
    #Print out post win game art
    def self.not_bad
        puts "
        ░░░░░░░░▄██████████▄▄░░░░░░░░
        ░░░░░░▄█████████████████▄░░░░░
        ░░░░░██▀▀▀▀▀▀▀▀▀▀▀████████░░░░
        ░░░░██░░░░░░░░░░░░░░███████░░░
        ░░░██░░░░░░░░░░░░░░░████████░░
        ░░░█▀░░░░░░░░░░░░░░░▀███████░░
        ░░░█▄▄██▄░░░▀█████▄░░▀██████░░
        ░░░█▀███▄▀░░░▄██▄▄█▀░░░█████▄░
        ░░░█░░▀▀█░░░░░▀▀░░░▀░░░██░░▀▄█
        ░░░█░░░█░░░▄░░░░░░░░░░░░░██░██
        ░░░█░░█▄▄▄▄█▄▀▄░░░░░░░░░▄▄█▄█░
        ░░░█░░█▄▄▄▄▄▄░▀▄░░░░░░░░▄░▀█░░
        ░░░█░█▄████▀██▄▀░░░░░░░█░▀▀░░░
        ░░░░██▀░▄▄▄▄░░░▄▀░░░░▄▀█░░░░░░
        ░░░░░█▄▀░░░░▀█▀█▀░▄▄▀░▄▀░░░░░░
        ░░░░░▀▄░░░░░░░░▄▄▀░░░░█░░░░░░░
        ░░░░░▄██▀▀▀▀▀▀▀░░░░░░░█▄░░░░░░
        ░░▄▄▀░░░▀▄░░░░░░░░░░▄▀░▀▀▄░░░░
        ▄▀▀░░░░░░░█▄░░░░░░▄▀░░░░░░█▄░░
        █░░░░░░░░░░░░░░░░░░░░░░░░░░▀█▄
        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
        █▄░░█ █▀▀█ ▀▀█▀▀░░█▀▀█ █▀▀█ █▀▀▄
        █░█░█ █░░█ ░░█░░░░█▀▀▄ █▄▄█ █░░█
        █░░▀█ █▄▄█ ░░█░░░░█▄▄█ █░░█ █▄▄▀
        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 
        "
    end
    
end