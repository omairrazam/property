class Transaction < ApplicationRecord
  belongs_to :plot_file
  validates :total_amount,
    :numericality => {:greater_than_or_equal_to => 1},
    :presence => true
  validates :recieved_amount,
    :numericality => {:greater_than_or_equal_to => 1},
    :presence => true
  validates :target_date,
    :presence => true
  validate :amount_calculation, :on => :create

  enum state: %i(pending paid)

def remaining_amount
  total_amount = self.total_amount ? self.total_amount : 0
  recieved_amount = self.recieved_amount ? self.recieved_amount : 0
  return total_amount - recieved_amount
end
def amount_calculation
  if total_amount < recieved_amount
    errors.add(:base, "Total should be greater than recieved amount")
  end
end

end