class StocksController < ApplicationController
  def index
   categories = Category.joins(:plot_files).distinct.all
    @results = []
    categories.each do |category|
      @results << {
        :label => category.fullname ,
        :value => category.base_amount * category.plot_files.count
      }
    end
    
    respond_to do |format|
      format.html
      format.json
     end
  end
end
