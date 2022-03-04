# frozen_string_literal: true

# Used to store all the text used in the game, as well as some simple logic to
# make some methods output slightly different texts depending on conditions.
module Display
  def display_intro
    puts <<~INTRO
      "This is a Connect-Four game. Each player will take turns dropping pieces
      at the top of the board - indicated by the numbers 1 to 7. The pieces will
      fall to the bottommost empty slot of that column.

      The match ends when a player complete a straight unobstructed line with 4
      pieces of the same color"
    INTRO
  end

  def display_name_prompt(player)
    case player
    when 1
      "\nWhat's the first player's name?"
    when 2
      "\nWhat's the second player's name?"
    end
  end

  def display_name_warn(player)
    case player
    when 1
      'Please, enter how the first player should be called'
    when 2
      'Please, enter how the second player should be called'
    end
  end

  def display_turn_prompt(player_name)
    "It's #{player_name}'s turn"
  end

  def display_turn_warn(invalid_input)
    return 'Choose a column between 1 and 7.' if invalid_input.zero?

    "#{invalid_input} isn't a valid input. Choose an available column between 1 and 7."
  end

  def display_win(winner)
    puts "#{winner.name} won the match!"
    puts
  end

  def display_draw
    puts 'The board is full. This match has came to a draw'
  end

  def display_another_match
    puts <<~REMATCH
      Do you want to play another match?
      [1] - Play
      [2] - Exit
    REMATCH
  end
end
