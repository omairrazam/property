class HomesController < ApplicationController
  def index
  	#nature = params[:nature] || Transaction.natures.keys.first 
  	mode = params[:mode] || Transaction.modes.keys.second
    tab = params[:tab] || 'selling' 
    @transactions = Transaction.only_parents.includes(:children,:category,:region,:care_of, :trader).public_send('current_'+ mode)

    respond_to do |format|
        format.html 
        format.json 
    end

  end
end
