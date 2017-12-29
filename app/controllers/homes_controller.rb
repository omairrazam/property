class HomesController < ApplicationController
  def index
  	#nature = params[:nature] || Transaction.natures.keys.first 
  	mode = params[:mode] || Transaction.modes.keys.second
    tab = params[:tab] || 'selling' 
  	#Transaction.modes.keys.each { |mode| instance_variable_set("@#{mode}", ::DailyTransactionProcessor.new(mode)) }
    #@data = Transaction.public_send('current_'+ mode, nature).only_parents.includes(:children)
    @table_data = Transaction.public_send('current_'+ mode, tab)
    #@data = @buying_data + @selling_data
    respond_to do |format|
        format.html 
        format.json { render json: {data:  @table_data.as_json(include:  [:category,:region,:care_of,:trader])}}
    end

  end
end
