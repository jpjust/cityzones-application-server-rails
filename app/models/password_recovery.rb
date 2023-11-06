class PasswordRecovery < ApplicationRecord

  belongs_to :user

  validates :user_id, :token, :expires_at, :presence => true

  attribute :email
  
end
