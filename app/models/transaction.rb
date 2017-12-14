class Transaction < ApplicationRecord
  belongs_to :plot_file
  belongs_to :user, optional: true
  alias_attribute :point_of_contact, :user

  enum state: %i(pending paid)
end
