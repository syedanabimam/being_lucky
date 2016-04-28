module Dice
    @current_score = 0
    @all_dice_scores_add = false
    @rolling_all_five_again = false

    def curr_score
        @current_score
    end
    
    def self.set_curr_score
        @current_score = 0
    end
    
    def get_all_five_dice_reroll_status
       @rolling_all_five_again
    end
    
    def get_all_dice_score_status
       @all_dice_scores_add
    end
    
    def set_all_dice_score_status(value)
        @all_dice_scores_add = value
    end
    
    def dice_first_turn
    	@dice = Array.new(5) { rand(1...6) } #create random array between 1..6
        #@dice = [3, 3, 3, 4, 5] # OK
        #@dice = [2, 2, 2, 4, 5] # OK
        #@dice = [3, 1, 5, 3, 3] # INPROCESS, FIXED
        #@dice = [3, 5, 1, 1, 5] # FIXED, OK
        #@dice = [1, 1, 1, 1, 3] # FIXED, OK
        #@dice = [1, 1, 1, 1, 5] # FIXED, OK
        #@dice = [4, 1, 2, 3, 5] # FIXED, OK
        
    	@combo_check = @dice.select{ |e| @dice.count(e) > 2 } #find 3 combo pattern
    	
    	@combo = @combo_check.first(3)
    	
    	@combo_num = @combo.uniq.join() #Isolate and find common number for 3-pattern
    
    	if @combo_check.count == 4
    		@remaining_dice = @dice | @combo_check
    	elsif @combo.count == 3
    		@remaining_dice = @dice - @combo_check
    	else
    		@remaining_dice = @dice - @combo_check
    	end
    end
    
    def check_if_all_dices_scores
       
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
           if gets.chomp.to_s == "y"
               puts "================================================="
               puts "Rolling the dices again."
               puts "================================================="
               @rolling_all_five_again = true
               dice_first_turn
           else
               puts "================================================="
               puts "You decided not to roll the 5 dices. Score will be added for the 5 dices"
               puts "================================================="
               scoring_first_turn_combo
               scoring_first_turn_noncombo
               @rolling_all_five_again = false
               @all_dice_scores_add = true
           end
       else
          puts "================================================="
          puts "Not all dices are scoring"
          puts "================================================="

       end
    end

    def scoring_first_turn_combo
       #puts "combo_num: #{@combo_num.class}"
       case @combo_num
       when "1"
       	#puts "Added 1000 score"
       	@current_score = 1000
       when "2"
       	#puts "Added 200 score"
       	@current_score = 200
       when "3"
       	#puts "Added 300 score"
       	@current_score = 300
       when "4"
       	#puts "Added 400 score"
       	@current_score = 400
       when "5"
       	#puts "Added 500 score"
       	@current_score = 500
       when "6"
       	#puts "Added 600 score"
       	@current_score = 600
       else
        puts "================================================="   
       	puts "No three number combo pattern detected"
       	puts "================================================="
       end
    end
    
    def scoring_first_turn_noncombo
      @single_score_dice_arr = []
      
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
      @non_dice_array = @remaining_dice - @single_score_dice_arr
    end
    
    def scoring_second_turn
        @accumulated_score = 0
    	@second_dice = Array.new(@non_dice_array.count) { rand(1...6) }
    	@second_single_score_dice_arr = []
    
    	@second_dice.each do |num|
    	   	if num == 1
    	   		@accumulated_score = @accumulated_score + 100 	
    	   		@second_single_score_dice_arr << num
    	   	elsif num == 5
    	   		@accumulated_score = @accumulated_score + 50 
    	   		@second_single_score_dice_arr << num
    	   	end
    	end
    	
    	@second_turn_remainder = @second_dice - @second_single_score_dice_arr
       	puts "================================================="
    	puts "Second turn results for remaining dice(s): #{@second_dice}"
    	puts "================================================="
    	puts "Second turn (Current + Accumulated) score: #{@current_score + @accumulated_score}"
    	puts "================================================="
    	puts "Remaining elements now: #{@second_turn_remainder}"
    	puts "================================================="
    	
    	
        loop do
            puts "================================================="
            puts "Accumulated Score: #{@accumulated_score}"
            puts "================================================="
            if @accumulated_score > 0
        		if @second_turn_remainder.count == 0
        		    @current_score = @current_score + @accumulated_score
        		    puts "================================================="
        			puts "Total Score by now: #{@current_score}"
        			puts "================================================="
        			puts "No more dice to roll for this turn" 
        			break 
        		end
        		print "Want another go? y/n \n"
        		puts "================================================="
        		proceed = gets.chomp.to_s
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
        			
        			if @accumulated_score_more == 0
        			   puts "================================================="
        			   puts "You scored #{@accumulated_score_more} in this roll"
        			   puts "================================================="
        			   puts "Therefore, you will lose all your accumulated score and your turn as well"
        			   puts "=================================================" 
        			   puts "Your current score is: #{@current_score}"
        			   puts "================================================="
        			   break
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
        		if proceed == "n" 
        		    @current_score = @current_score + @accumulated_score
        		    puts "You decided not to take another roll"
        		    puts "================================================="
        		    puts "Your accumulated score is #{@accumulated_score}"
        		    puts "================================================="
        			puts "Total Score by now: #{@current_score}"
        			break 
        		end
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
    
    def get_accumulated_score 
        @accumulated_score
    end
    
    
    def print_results
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
    
    def game_rules 
       puts ""
       puts "===================================================================="
       puts " 
       Are you worried about how to play this game, then have 
       no fear young padawan, Force will guide you. 
       
       (^_^メ)
       
       2 or more player roll 5 dice to play being Lucky.
       In each turn, scores are awarded based on subsequent dice 
       results. Players can further play to accumulate further
       score for that turn.
       
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
    
end