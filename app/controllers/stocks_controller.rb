class StocksController < ApplicationController
  def index
    @results = Category.distinct_with_plot_files.map {|c| {label: c.fullname, value:c.total_worth} }
    @results << {label:'Cash' , value: Stock.total_cash}

    respond_to do |format|
      format.html
      format.json
     end
  end
end
