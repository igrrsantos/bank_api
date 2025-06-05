class UserRepository
  def find(id)
    User.find(id)
  end

  def create(attributes)
    user = User.create(attributes)
    user.save
  end

  def update(user, attributes)
    user.update(attributes)
  end

  def delete(user)
    user.destroy
  end

  def find_by(attributes)
    User.find_by!(attributes)
  end
end
