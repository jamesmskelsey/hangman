module Hangman
  class Game
    MAX_MISSES = 10

    def initialize
      @player1 = Game::Player.new
    end

    def intro
      puts "Welcome to Hangman!"
      puts "#{@player1.name}: #{@player1.wins}W / #{@player1.losses}L"
      puts %q{
       1. Play a game.
       2. Load stats
       3. Save stats
       4. Exit}
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
          @player1.load_stats
        when '3'
          @player1.save_stats
        when '4'
          break
        end
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
      puts "\n\nEnter 'save' to save your stats and exit to menu."
      puts "---------"
      puts "Word: #{word_to_display.join(" ")}"
      puts "Last guess: #{guesses}"
      puts "( #{MAX_MISSES - misses.length} / #{MAX_MISSES} ) Misses: #{misses.join(" ")}"
    end


    def new_game
      # Once save function works, this should check if a @player is already there
      # Or, it allows us to continue as @player 1.

      if @player1.name != "default"
        puts "Okay, #{@player1.name}, good luck! You've won #{@player1.wins} #{@player1.wins == 1 ? "time" : "times"} so far."
      else
        puts "New game... enter your name: "
        name = gets.chomp
        @player1 = Game::Player.new(name)
      end
      # Then, once we've got ourselves a @player we can continue
      @player1.word_to_find = get_single_word
      puts "DEBUG: Word will be #{@player1.word_to_find}"
      word_to_display = reset_word_to_display(@player1.word_to_find)

      puts "Okay, #{@player1.name}, I've got your word. You've got 10 misses. GO!"

      loop do
        # show a status, get a letter
        scoreboard(word_to_display, @player1.guesses, @player1.misses)
        print "Guess a letter: "
        guess = gets.chomp

        # handle the guess
        if guess.length > 1
          case guess
          when "save"
            @player1.save_stats
          when "exit"
            break
          when "quit"
            break
          when /.+/
            puts "Your guess should just be one letter!"
          end
        else
          @player1.handle_guess_storage(guess)
          word_to_display = update_word_to_display(guess, word_to_display, @player1.word_to_find)
        end
        # decide if the game is over, or continue
        if game_over?(word_to_display, @player1.word_to_find)
          scoreboard(word_to_display, @player1.guesses, @player1.misses)
          @player1.add_win
          puts "*** You got it! *** You've won #{@player1.wins}"
          break
        elsif @player1.misses.length > 10
          puts "*** You took too long :( ***"
          @player1.add_loss
          break
        end

      end
    end

  end
end
