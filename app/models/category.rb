class Category < ApplicationRecord
	has_many :base_amounts, dependent: :destroy
	has_many :plot_files, dependent: :destroy

	validates_presence_of :name,:size,:unit
	validates :size, numericality: { only_integer: true }

  	enum unit: %i(marla kanal)
	validates :unit, inclusion: { in: Category.units }
  	
	def fullname
		size.to_s+unit.to_s
	end

	def dim
		size.to_s+' '+unit.capitalize
	end
end
