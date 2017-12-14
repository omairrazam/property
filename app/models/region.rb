class Region < ApplicationRecord
	has_many :plot_files

	validates_presence_of :title
end
