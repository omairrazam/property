module HomesHelper
	def beautify_display str
		str.split('_').map(&:capitalize).join(' ')
	end
end
