class Transaction < ApplicationRecord
  belongs_to :plot_file

  enum state: %i(pending paid)

end
