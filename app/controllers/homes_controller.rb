class HomesController < ApplicationController
  def index
  	nature = params[:nature] || Transaction.natures.keys.first 
  	mode = params[:mode] || Transaction.modes.keys.second  
  	#Transaction.modes.keys.each { |mode| instance_variable_set("@#{mode}", ::DailyTransactionProcessor.new(mode)) }
    @data = Transaction.public_send('current_'+ mode, nature).only_parents.includes(:children)
    respond_to do |format|
        format.html 
        format.json { render json: {data:@data.as_json(include: [:children,:category]) }}
    end
  end
end
