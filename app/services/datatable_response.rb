class DatatableResponse
  delegate :params, :h, :link_to, to: :@view
  attr_accessor :total_transactions_count

  def initialize(view)
    @view = view
  end

  def transactions
    @transactions ||= fetch_transactions
  end

private

  def fetch_transactions
    #transactions = Transaction.order("#{sort_column} #{sort_direction}")
    transactions = Transaction.only_parents.includes(:children,:category,:region, :care_of, :trader).distinct.order('id desc')

    @total_transactions_count = transactions.count
    transactions = transactions.page(page).per(per_page)

    if params[:search] && search = params[:search][:value]
      query = "comment::text ilike :search"
      transactions = transactions.where(query, search: "%#{search}%")
    end
    transactions
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[duplicate_count total_amount dealer_total_amount ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
