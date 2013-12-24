require 'ruby-debug'

class Player

  @warrior = nil
  @health = nil
  @attacked = false
  @back_wall = false
  @ahead = nil
  @behind = nil
  @resting = false
  @full_health = true

  def init_turn warrior
    @ahead = warrior.feel
    @behind = warrior.feel :backward
    @back_wall = true if @behind.wall? or @back_wall
    @warrior = warrior
    @full_health = (warrior.health == 20)
    @taking_damage = taking_damage?
  end

  def taking_damage?
    if @health.nil?
      @health = @warrior.health
      return false
    elsif @health > @warrior.health
      @health = @warrior.health
      return true
    else
      @health = @warrior.health
      return false
    end
  end

  def defend?
    @resting = false if @full_health
    return false if @ahead.stairs?
    if @resting
      @warrior.rest!
    elsif @warrior.health > 6
      return false
    elsif @ahead.enemy?

      if /Sludge/.match(@ahead.to_s).nil? # if NOT a sludge
        return false
      else
        @warrior.walk! :backward
      end

    elsif @taking_damage
      @warrior.walk! :backward
    else
      @warrior.rest!
      @resting = true
    end
    return true
  end

  def rescue?
    if @behind.captive?
      @warrior.rescue!(:backward)
      return true
    elsif @ahead.captive?
      @warrior.rescue!
      return true
    end
    return false
  end

  def play_turn warrior
    init_turn warrior
    
    return warrior.pivot! if @ahead.wall?
    return warrior.walk!(:backward) if @behind.empty? and !@back_wall
    
    return if rescue?
    return if defend?

    if @ahead.enemy?
      warrior.attack!
    else
      warrior.walk!
    end
  end

end
