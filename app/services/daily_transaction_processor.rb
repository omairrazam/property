class DailyTransactionProcessor
	attr_accessor :mode

	def initialize(mode)
		@mode = mode
		@transactions = Transaction.daily_all.with_mode(mode.to_sym)
		@sellings = @transactions.with_nature(:selling)
		@buyings = @transactions.with_nature(:buying)
	end

	def amount_sellings
		@sellings.sum(&:total_amount).to_i
	end

	def amount_buyings
		@buyings.sum(&:total_amount).to_i
	end

	def net_amount
		amount_sellings - amount_buyings
	end

	def total_amount
		@transactions.sum(&:total_amount).to_f
	end

	def net_amount_percent
		return 0 if total_amount == 0
		(net_amount.to_i / total_amount * 100).to_i
	end
end