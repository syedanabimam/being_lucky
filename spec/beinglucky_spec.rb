require 'spec_helper'
#require_relative '../spec_helper'

describe "beinglucky game" do
  before :each do  
    @testing_beinglucky = BeingLucky.new 
  end        
  context "the beinglucky class" do
    it "must show main menu" do
      expect { testing_beinglucky }.to output("BEING LUCKY - MAIN MENU").to_stdout
    end
    
    it "must show options in main menu" do
      
    end
    
    it "must be able to access game options" do
        
    end
            
    it "must be able to show leaderboard" do
        
    end
            
    it "must be able to show rules" do
        
    end
            
    it "must be able to exit" do
        
    end    
    
    it "must not allows less than 2 players to play the game" do
    
    end
    
    it "must register atleast 2 players to begin the game" do
        
    end
    
    it "must store values for player names and scores" do
        
    end
    
    it "must ask players to play first turn" do
        
    end
        
    it "should not allow players to accumulate score if score in one turn is less than 300" do
        
    end
        
    it "should generate 5 random number between 1 and 6 for five dices" do
        
    end
        
    it "must check if all dices are scoring" do
        
    end
        
    it "should find all combo pattern in 5 dices" do
        
    end
        
    it "should calculate score for 5 dices as per the scoring criteria" do
        
    end
        
    it "must allow players to accumulate score if player has already scored 300" do
        
    end
        
    it "must print results on each roll" do
        
    end
            
    it "must allow players to have an option to roll 5 dices again or not if they are scoring" do
        
    end
            
    it "must check if score is greater than zero before asking for second roll" do
        
    end
            
    it "must be able to find non scoring dices" do
        
    end
            
    it "must allow to play second roll" do
        
    end
            
    it "must allow to play another roll after second roll" do
        
    end
            
    it "must discard accumulated score if any roll after second roll scores in zero" do
        
    end
            
    it "must manage turns properly by maintaining counter" do
        
    end
            
    it "must move from player to player between game turns for consistence performance" do
        
    end
            
    it "must check if current turn is final turn by comparing scores of player" do
        
    end
            
    it "must notify players about game entering final round" do
        
    end
            
    it "must allow all players to avail final turn" do
        
    end
            
    it "must print out final results" do
        
    end
            
    it "must declare the victor among players" do
        
    end
  end
end