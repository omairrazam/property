class PlotFile < ApplicationRecord
	has_paper_trail
	
	after_initialize :set_default_state
	after_create :sync_state_with_region

	has_many :transactions
	has_many :installments

	belongs_to :category
	belongs_to :region, optional: true

	validates_presence_of :serial_no,:state #also validate column types e.g pod_days must be integer

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

	def self.file_stats(unit,category,returnn=nil)
		one_canal_cat  = Transaction.by_category(unit,category)
		buy_one_canal  = one_canal_cat.with_nature('buying').count 
		return buy_one_canal if returnn == 'b'
     	sell_one_canal = one_canal_cat.with_nature('selling').count
		return sell_one_canal if returnn == 's'
		buy_one_canal-sell_one_canal
	end

	private
	def set_default_state
		self.state = :pending
	end
end
