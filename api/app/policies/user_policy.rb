class UserPolicy < ApplicationPolicy

  def create?
    user.admin?
  end

  def update?
    user.admin? || record == user
  end

  def destroy?
    update?
  end
end
