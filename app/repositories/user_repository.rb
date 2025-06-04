class UserRepository
  class << self
    def find(id)
      User.find_by(id: id)
    end

    def create(attributes)
      User.create(attributes)
    end

    def update(user, attributes)
      user.update(attributes)
    end

    def delete(user)
      user.destroy
    end
  end
end