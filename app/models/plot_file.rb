class PlotFile < ApplicationRecord
	has_many :transactions, dependent: :destroy
	has_many :installments, dependent: :destroy
	belongs_to :category
	belongs_to :region, optional: true
	
	state_machine :state, initial: :pending do
		
	end
end





