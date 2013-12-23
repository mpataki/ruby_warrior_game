class Player

  def defend?(warrior)
    return false if warrior.health > 3
    unless warrior.feel.enemy?
      warrior.rest!
    else
      warrior.walk!(:backward)
    end
    return true
  end

  def play_turn(warrior)
    return if defend?(warrior)
    if warrior.feel.enemy?
      warrior.attack!
    else
      warrior.walk!
    end
  end

end
