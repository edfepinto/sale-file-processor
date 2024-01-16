# app/models/user.rb
class User < ApplicationRecord
  has_many :sales
  has_secure_password
  enum role: [:comum, :admnistrador]
end
