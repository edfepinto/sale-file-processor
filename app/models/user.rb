# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  enum role: [:comum, :admninistrador]
end
