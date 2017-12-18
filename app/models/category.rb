class Category < ApplicationRecord
	has_many :plot_files
	has_many :transactions

	validates_presence_of :name,:unit
	validates_presence_of :size, if: Proc.new { |c| !c.cash? || !c.pia_form?}
	validates :size, numericality: { only_integer: true }, if: Proc.new { |c| !c.cash? || !c.pia_form?}
    validates_presence_of :pod_days, if: Proc.new { |c| !c.cash? || !c.pia_form?}
    
  	enum unit: %i(pia_form marla kanal cash)
	validates :unit, inclusion: { in: Category.units.keys }
  	
  	scope :distinct_with_plot_files, ->{joins(:plot_files).distinct.all}

	def fullname
		size.to_s+unit.to_s
	end

	def dim
		size.to_s+' '+unit.capitalize
	end

	def total_worth 
		base_amount * plot_files.count
	end
end
