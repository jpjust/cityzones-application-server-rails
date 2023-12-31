class User < ApplicationRecord

  has_secure_password

  has_many :tasks
  has_many :password_recoveries

  validates :email, :password_digest, :name, :presence => true
  validates :email, :uniqueness => true, :format => { :with => URI::MailTo::EMAIL_REGEXP }

end
