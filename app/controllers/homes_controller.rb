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

  def dashboard_search
    @mode = params[:mode]
    transactions = Transaction.with_mode(@mode).due
    from = params["start_#{@mode}"].to_datetime
    to = params["end_#{@mode}"].to_datetime
    transactions = transactions.in_range_alarm(from,to) if from.present? & to.present?
    transactions = transactions.where(trader_id:params["trader_#{@mode}"]) if params["trader_#{@mode}"].present?
    transactions = transactions.where(care_of_id:params["c_o_#{@mode}"]) if params["c_o_#{@mode}"].present?

    @data = transactions.report 

    respond_to do |format|
        format.html
        format.js
    end
  end
end
