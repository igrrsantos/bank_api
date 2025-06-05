class UserRepository
  def find(id)
    User.find(id)
  rescue StandardError => e
    e
  end

  def create(attributes)
    user = User.create(attributes)
    user.save
  rescue StandardError => e
    e
  end

  def update(user, attributes)
    user.update(attributes)
  rescue StandardError => e
    e
  end

  def delete(user)
    user.destroy
  rescue StandardError => e
    e
  end

  def find_by(attributes)
    User.find_by!(attributes)
  rescue StandardError => e
    e
  end
end
