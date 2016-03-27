class PalletPolicy < ApplicationPolicy

  def create?
    !user.guest?
  end

  def update?
    user.admin? || record.user == user
  end

  def destroy?
    update?
  end
end
