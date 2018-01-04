class HomesController < ApplicationController
  def index
  	#nature = params[:nature] || Transaction.natures.keys.first
  	mode = params[:mode] || Transaction.modes.keys.second
    tab = params[:tab] || 'selling'
    @transactions = Transaction.only_parents.includes(:children,:category,:region,:care_of, :trader).public_send('current_'+ mode)

    attributes  = %w(id plot_file_id total_amount recieved_amount target_date mode target_date_in_days nature category_id region_id father_id duplicate_count excel_file imported_from transaction_date care_of_id trader_id)
    includes    = [:children,:category,:region,:care_of, :trader]
    search_attributes = [{name:'name',type:'ilike', search_placeholder: 'search'}, {name:'amount', type:'=', search_placeholder: 'amount'}]
    
    respond_to do |format|
        format.html
        format.json {DatatableResponse.new(view_context, Transaction, attributes, search_attributes, includes, {mode: mode}).as_json}
    end

  end
end
