class Person < ApplicationRecord
  validates :username, uniqueness: true
  
end
