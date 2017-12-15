class PlotFile < ApplicationRecord
	after_initialize :set_default_state
	after_create :sync_state_with_region

	has_many :transactions, dependent: :destroy
	has_many :installments, dependent: :destroy
	
	belongs_to :category
	belongs_to :region, optional: true

	validates_presence_of :serial_no,:state

	enum state:{pending:0, in_stock:1, open:2, assigned:3} do

	    event :sync_state_with_region do
	      transition :pending => :in_stock, if: -> { region.present? }
	    end

	    event :downpayment_complete do
	      transition :in_stock => :open
	    end

	    event :assign_file do
	      transition :open => :assigned
	    end

	end

	private
	def set_default_state
		self.state = :pending
	end

end





