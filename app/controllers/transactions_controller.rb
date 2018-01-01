class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.only_parents.includes(:children,:category,:region, :care_of, :trader).order('id desc').limit(10)
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
      @transactions = Transaction.create_in_bulk(transaction_params)
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
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
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
        :recieved_amount,:target_date,:care_of_id,:region_id,
        :trader_id, :mode, :nature, :target_date_in_days, :duplicate_count
        )
    end
end
