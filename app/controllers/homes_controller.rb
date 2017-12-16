class HomesController < ApplicationController
  def index
  	Transaction.modes.keys.each { |mode| instance_variable_set("@#{mode}", ::DailyTransactionProcessor.new(mode)) }
  end
end
