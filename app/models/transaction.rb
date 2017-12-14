class Transaction < ApplicationRecord
  before_create :figure_out_target_date

  belongs_to :plot_file

  belongs_to :user, optional: true
  
  

  enum state: %i(pending paid)
  enum mode: %i(cash monday_payment next_monday_payment bop sop pod custom)

def remaining_amount
  total_amount = self.total_amount ? self.total_amount : 0
  recieved_amount = self.recieved_amount ? self.recieved_amount : 0
  return total_amount - recieved_amount
end

#def no_of_duplicates
#  return
#end
private
def figure_out_target_date
  case mode
  when :cash
    #set target_date to nil
    self.target_date = nil
  when :monday_payment
    #set target_date to coming monday
    monday = Date.today.monday
    next_monday = monday.next_week
    self.target_date = next_monday
  when :next_monday_payment
    #set target_date to next monday from coming monday
    monday = Date.today.monday
    next_monday = monday.next_week
    next_to_next_monday = next_monday.next_week
    self.target_date = next_to_next_monday
  when :bop
    "You passed a string"
    #    self.target_date = 10.days.from_now

  when :sop
    'hell'

    #    self.target_date = 10.days.from_now
  when :pod
    'hello'
  when :custom
    'hello'
  else
    "You gave me #{a} -- I have no idea what to do with that."
  end
end


def amount_calculation
  if total_amount < recieved_amount
    errors.add(:base, "Total should be greater than recieved amount")
  end
end

end