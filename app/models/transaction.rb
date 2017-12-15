class Transaction < ApplicationRecord
  before_create :figure_out_target_date

  belongs_to :plot_file
  belongs_to :user, optional: true
  
  alias_attribute :point_of_contact, :user

  enum state: %i(pending paid)
  enum mode: %i(cash monday_payment next_monday_payment bop sop pod custom)

  private
  def figure_out_target_date
  	case mode
	when :cash
	  #set target_date to nil
	when :monday_payment
	  #set target_date to coming monday 
	when :next_monday_payment
	  #set target_date to next monday from coming monday.
	when :bop
	  "You passed a string"
	when :sop
	  'hell'
	when :pod
	   'hello'
	when :custom
	   'hello'
	else
	  "You gave me #{a} -- I have no idea what to do with that."
	end
  end
end
