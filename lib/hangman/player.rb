# Keeping track of a player should only be his stats... I don't think I'll track
# which words the player has figured out. So, except for updating his own stats...

# Oh, and the player should keep track of the word that he is currently on...
# to facilitate saving the game easily.

module Hangman
  class Player
      attr_accessor :name, :wins, :losses, :word_to_find, :guesses, :misses

      def initialize(name, wins=0, losses=0, word_to_find="default", guesses="", misses=[])
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
          if !guess.any?(word_to_find.split(""))
            misses << guess
          end
      end


  end
end
