class Category < ApplicationRecord
	has_many :plot_files
	has_many :transactions

	validates_presence_of :name,:unit
	validates_presence_of :size, if: Proc.new { |c| !%w(cash form).include?(c.unit)}
	validates :size, numericality: { only_integer: true }, if: Proc.new { |c| !%w(cash form).include?(c.unit)}
    validates_presence_of :pod_days, if: Proc.new { |c| !%w(cash form).include?(c.unit)}

  	enum unit: %i(form m k cash)
	validates :unit, inclusion: { in: Category.units.keys }

  	scope :distinct_with_plot_files, ->{joins(:plot_files).distinct.all}
		scope :by_category, ->(val,unit){where('unit=? AND size=?', Category.units[unit], val)}
    
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
