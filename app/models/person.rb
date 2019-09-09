class Person < ApplicationRecord
  validates :username, uniqueness: true
  before_save :format_name
  
  def format_name
  	self.username = self.username.downcase.strip.tr(" ", "_")
  end

  def fullname
  	username.humanize
  end
end
