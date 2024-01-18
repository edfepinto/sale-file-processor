# app/models/user.rb
class User < ApplicationRecord
  has_many :sales
  has_secure_password
  enum role: [:comum, :admnistrador]

  validates :email, uniqueness: true, format: { 
    with: URI::MailTo::EMAIL_REGEXP, 
  }

  
  def admin?
    role == 'admnistrador'
  end
end
