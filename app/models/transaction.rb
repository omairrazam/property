class Transaction < ApplicationRecord
  belongs_to :plot_file

  enum state: %i(pending paid)
def remaining_amount
  total_amount = self.total_amount ? self.total_amount : 0
  recieved_amount = self.recieved_amount ? self.recieved_amount : 0
  return total_amount - recieved_amount
end

end
