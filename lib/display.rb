# frozen_string_literal: true

# Used to store all the text used in the game, as well as some simple logic to
# make some methods output slightly different texts depending on conditions.
module Display
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

    "#{invalid_input} isn't a valid input. Choose a column between 1 and 7."
  end

  def display_win(winner)
    puts "#{winner.name} won the match!"
  end

  def display_draw
    puts 'The board is full. This match has came to a draw'
  end
end
