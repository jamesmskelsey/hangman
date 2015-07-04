# Keeping track of a player should only be his stats... I don't think I'll track
# which words the player has figured out. So, except for updating his own stats...

# Oh, and the player should keep track of the word that he is currently on...
# to facilitate saving the game easily.
require 'yaml'

module Hangman
  class Game
    class Player
        attr_accessor :name, :wins, :losses, :word_to_find, :guesses, :misses

        def initialize(name="default", wins=0, losses=0, word_to_find="default", guesses="", misses=[])
          @name = name
          @wins = wins
          @losses = losses
          @word_to_find = word_to_find
          @guesses = guesses
          @misses = misses
        end

        def add_win
          @wins += 1
        end

        def add_loss
          @losses += 1
        end

        def handle_guess_storage(guess)
          @guesses = guess
          if !word_to_find.split("").any? { |letter| letter == guess }
            misses << guess
          end
        end

        def save_stats
          yaml = YAML::dump(self)
          save_file = File.open("./lib/hangman/savegame/#{self.name}_save.yaml", "w")
          save_file.write(yaml)
          save_file.close
        end

        def load_stats

            print "Type 'cancel' to go back. Enter name of player: "
            playername = gets.chomp
            if playername == "cancel"
              return
            else
              begin
              tempobj = YAML::load( File.open("./lib/hangman/savegame/#{playername}_save.yaml", "r"))
              initialize(tempobj.name, tempobj.wins, tempobj.losses, tempobj.word_to_find, tempobj.guesses, tempobj.misses)
              rescue
              puts "That player name may not exist. Case matters!"
              retry
            end

          end
        end
#Ends of class/class/module
    end
  end
end
