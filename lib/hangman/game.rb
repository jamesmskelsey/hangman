module Hangman
  class Game

    def intro
      puts "Welcome to Hangman!"
      puts %q{
       1. Play a game.
       2. Load stats
       3. Exit}
    end

    def get_word_list
      $wordslist = File.readlines("#{Dir.pwd}/lib/hangman/dictionary.txt")
      $wordslist.map { |word| word.strip! }
    end

    def get_single_word

      word_to_find = ""
      while (word_to_find.length < 5 || word_to_find.length > 12)
        word_to_find = $wordslist.sample
      end
      return word_to_find.downcase

    end

    def play_game
      get_word_list

      loop do
        intro
        option = gets.chomp
        case option
        when '1'
          new_game
        when '2'
          #load a character from a File
        when '3'
          break
      end
    end

    def game_over?(word_to_display, word_to_find)
      return true if word_to_display.join("") == word_to_find
    end

    def update_word_to_display(guess, word_to_display, word_to_find)
      new_word = []
      word_to_display.each_with_index do |letter, index|
        if letter != "_"
          new_word << letter
        elsif guess == word_to_find[index]
          new_word << guess
        else
          new_word << "_"
        end
      end
      return new_word
    end

    def reset_word_to_display(word_to_find)
      word_to_find.split("").collect{ |letter| letter = "_"}
    end

    def scoreboard(word_to_display, guesses, misses)
      puts "Word: #{word_to_display.join(" ")}"
      puts "Guess: #{guesses}"
      puts "Misses: #{misses}"
    end


    def new_game
      puts "New game... enter your name: "
      name = gets.chomp

      player1 = Player.new(name)

      player1.word_to_find = get_single_word
      puts "DEBUG: Word will be #{player1.word_to_find}"
      word_to_display = reset_word_to_display(player1.word_to_find)

      puts "Okay, #{player1.name}, I've got your word. You've got 10 guesses. GO!"

      loop do
        # show a status, get a letter
        scoreboard(word_to_display, player1.guesses, player1.misses)
        print "Guess a letter: "
        guess = gets.chomp

        # handle the guess
        player1.handle_guess_storage(guess)

        word_to_display = update_word_to_display(guess, word_to_display, player1.word_to_find)

        # decide if the game is over, or continue
        if game_over?(word_to_display, player1.word_to_find)
          scoreboard(word_to_display, player1.guesses, player1.misses)
          player1.add_win
          puts "*** You got it! ***"
          break
        elsif player1.guesses.length > 10
          puts "*** You took too long :( ***"
          player1.add_loss
          break
        end

      end
    end

  end
end
