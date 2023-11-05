class Worker < ApplicationRecord

  validates :token, :name, :tasks, :total_time, :presence => true
  validates :token, :uniqueness => true
  validates :total_time, :numericality => { :greater_than_or_equal_to => 0 }
  validates :tasks, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

end
