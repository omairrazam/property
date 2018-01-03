class DatatableResponse
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, model, attributes, search_attributes, includes=[], vars={mode:false}, &block)
    @view              = view
    @model             = model
    @attributes        = attributes
    @search_attributes = search_attributes
    @includes          = includes
    @vars              = vars
    @post_process_proc = block if block_given?
  end

  def as_json(options = {})
    {
        sEcho:                params[:sEcho].to_i,
        iTotalRecords:        @model.count,
        iTotalDisplayRecords: @model.count,
        aaData:               data
    }
  end

  private

  def data
    #give order as per attributes of datatable
    result = []

    records.each do |r|
      row = []
      @attributes.each do |attr|
        row << handle_associated(r, attr)
      end
      result << row
    end
    result
  end

  def post_processed_records
    # handle someother logic after records are filtered
  end

  def handle_associated(record, attr)
    # to handled associated attributes e.g disbursement.npo.ein
    splitd = attr.split('.')
    splitd.each do |s|
      record = record.send(s)
    end
    record
  end

  def records
    @records ||= fetch_records
  end

  def fetch_records
    records = @model.includes(@includes).send(:order, ("#{sort_column} #{sort_direction}"))
    records = records.public_send('current_'+ @vars[:mode]) if @vars[:mode]

    #it must be kept here
    if params[:sSearch].present?
      str         = ''
      search_hash = {}

      @search_attributes.each_with_index do |obj, i|
        placeholder = obj[:search_placeholder].to_sym

        str+= obj[:name] + " #{obj[:type]} :#{placeholder} "
        str+="or " if i < @search_attributes.length - 1

        if obj[:type] == 'ilike'
          search_hash[placeholder] = "%#{params[:sSearch]}%"
        else
          search_hash[placeholder] = params[:sSearch].to_f
        end

      end

      records = records.where(str, search_hash)
    end


    records =   @post_process_proc.call(records) if @post_process_proc.present?

    if records.is_a?(Array)
      Kaminari.paginate_array(records).page(page).per(per_page)
    else
      records = records.page(page).per(per_page)
    end


    records
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = @attributes
    ret = columns[params[:iSortCol_0].to_i]

    ActiveRecord::Base.connection.column_exists?(@model.table_name, ret) ? ret : 'id'
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
