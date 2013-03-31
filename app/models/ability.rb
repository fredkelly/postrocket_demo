class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      can :manage, Page
    end
  end
end
