# frozen_string_literal: true

module Display
  def display_name_prompt(player)
    case player
    when 1
      "What's the first player's name?"
    when 2
      "What's the second player's name?"
    end
  end

  def display_name_warn(player)
    case player
    when 1
      "Please, enter how the first player should be called"
    when 2
      "Please, enter how the second player should be called" 
    end
  end

  def display_turn_prompt(player)
    case player
    when 1
      "It's #{player}'s turn"
    when 2
      "It's #{player}'s turn"
    end
  end

  def display_turn_warn(player)
    case player
    when 1
      "It's #{player}'s turn"
    when 2
      "It's #{player}'s turn"
    end
  end
end