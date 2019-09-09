class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    response = DatatableResponse.new(view_context)
    @transactions = response.transactions
    @total_transactions_count = response.total_transactions_count
    # @transactions = Transaction.only_parents.includes(:children,:category,:region, :care_of, :trader).distinct.order('id desc')
  end
def indexold
    per_page =   params[:length].to_i > 0 ? params[:length].to_i : 10
    page     =   params[:start].to_i/per_page + 1

    columns = ['duplicate_count','category_id','region_id','care_of_id','trader_id','total_amount','total_amount','aggregate_recieved','remaining_amount','nature','mode','transaction_date','','' ]
    # sort=columns[params[:iSortCol_0].to_i]
    # sort_dir=params[:sSortDir_0] == "desc" ? "desc" : "asc"
    sort_column = params["order"]["0"]["column"].to_i rescue 0
    attr = columns[sort_column]
    sort_order =  params["order"]["0"]["dir"] rescue 'asc'

    @transactions = Transaction.joins(:region,:category,:care_of,:trader).only_parents.distinct.order(attr+' '+sort_order)
    @transactions = @transactions.page(page).per(per_page)
    if params["search"].present? and params["search"]["value"].present?

      search = params["search"]["value"]
      search = "%#{search}%".downcase
      # byebug
      if search == "%mp%"
        @transactions =   @transactions.where(mode: 1)
      elsif search== "%cash%"
        @transactions =   @transactions.where(mode: 0)
      elsif search== "%nmp%"
        @transactions =   @transactions.where(mode: 2)
      elsif search== "%tp%"
        @transactions =   @transactions.where(mode: 3)
      elsif search== "%wp%"
        @transactions =   @transactions.where(mode: 4)
      elsif search== "%thp%"
        @transactions =   @transactions.where(mode: 5)
      elsif search== "%fp%"
        @transactions =   @transactions.where(mode: 6)
      elsif search== "%bop%"
        @transactions =   @transactions.where(mode: 7)
      elsif search== "%sop%"
        @transactions =   @transactions.where(mode: 8)
      elsif search== "%pod%"
        @transactions =   @transactions.where(mode: 9)
      elsif search == "%buy%"
            @transactions =   @transactions.where(nature: 0)
          elsif search == "%sell%"
              @transactions =   @transactions.where(nature: 1)
            else

              @transactions =   @transactions.where(' lower(categories.name) like ?
                OR transactions.duplicate_count::text like ?
                OR people.username like ?
                OR transactions.aggregate_recieved::text like ?
                OR people.username like ?
                OR lower(regions.title) like ?',search,search,search,search,search,search)

          end
      end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    begin
      @transactions = Transaction.create_in_bulk(transaction_params).select{|t|t.father_id.blank?}

      respond_to do |format|
        format.json { render :show, status: :created}
      end
    rescue Exception => e
      respond_to do |format|
        format.json { render json: {error:e.message}.to_json, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|

      if @transaction.update(transaction_params)
        @transactions =[@transaction] # for datatable
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:excel_file].present?
      uploader = ExcelImportUploader.new
      uploader.store!(params[:excel_file])
      #processor = TransactionExcelImporter.new(uploader.file)
      processor = TransactionExcelImporter.delay(:retry => false).new(uploader.file)
      redirect_to transactions_url, notice: 'Transactions are being imported. You will be informed about the progress via email.'
    else
      redirect_to transactions_url, notice: 'Please add a file to import transactions. Thanks'
    end
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(
        :total_amount,:plot_file_id,:category_id,
        :recieved_amount,:target_date,:care_of_id,:region_id,:transaction_date,
        :trader_id, :mode, :nature, :target_date_in_days, :duplicate_count, :comment, :aggregate_recieved
        )
    end
end
