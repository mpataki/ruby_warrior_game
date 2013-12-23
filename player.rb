require 'ruby-debug'

class Player

  @health = nil
  @attacked = false

  def taking_damage? warrior
    if @health.nil?
      @health = warrior.health
      return false
    elsif @health > warrior.health
      @health = warrior.health
      return true
    else
      @health = warrior.health
      return false
    end
  end

  def defend? warrior
    return false if warrior.health > 3
    if warrior.feel.enemy?
      if /Sludge/.match(warrior.feel.to_s).nil?
        return false
      else
        warrior.walk! :backward
      end
    else
      warrior.rest! unless taking_damage? warrior
    end
    return true
  end

  def play_turn warrior
    return if defend? warrior
    if warrior.feel.enemy?
      warrior.attack!
    else
      warrior.walk!
    end
  end

end
