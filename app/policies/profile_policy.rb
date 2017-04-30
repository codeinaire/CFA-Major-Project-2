class ProfilePolicy < ApplicationPolicy

  def initialize(user, profile)
    @user = user #usually current user
    @profile = profile
    # this is anything
  end

  def update?
# require 'pry'; binding.pry
    @profile.user == @user

  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
