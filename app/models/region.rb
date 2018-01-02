class Region < ApplicationRecord
	has_many :plot_files
	has_many :transactions
	
	validates_presence_of :title
end
