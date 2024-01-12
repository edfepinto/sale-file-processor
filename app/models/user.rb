require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # Define o método para criar a senha hash
  def password=(new_password)
    @password = new_password
    self.password_digest = Password.create(new_password)
  end

  # Define o método para verificar a senha
  def authenticate(input_password)
    Password.new(password_digest) == input_password
  end
end
