class Person < ApplicationRecord
  validates :username, uniqueness: true
  
  def fullname
  	username.humanize
  end
end
