# app/models/user.rb
class User < ApplicationRecord
  has_many :sales
  has_secure_password
  enum role: [:comum, :admnistrador]

  validates :email, presence: true, uniqueness: { message: "já está em uso" }

  def admin?
    role == 'admnistrador'
  end
end
