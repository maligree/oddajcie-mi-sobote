class Minion < Monster
  def char
    '&'
  end

  def make_a_move(player_x, player_y)
    # If hitpoints above 80%, keep a distance:
    if hp_percent > 0.8
      if (player_x-x_pos).abs + (player_y-y_pos).abs < 10
        if rand(2) == 1
          if player_x < x_pos
            @x_pos += 1
          else
            @x_pos -= 1
          end
        else
          if player_y < y_pos
            @y_pos += 1
          else
            @y_pos -= 1
          end
        end
      else
        if rand(2) == 1
          if player_x < x_pos
            @x_pos -= 1
          else
            @x_pos += 1
          end
        else
          if player_y < y_pos
            @y_pos -= 1
          else
            @y_pos += 1
          end
        end
      end
    end

  end
end