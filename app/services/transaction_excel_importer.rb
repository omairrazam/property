class TransactionExcelImporter
	def initialize file
		@file = file
		@spreadsheet = open_spreadsheet(@file)
    @header = @spreadsheet.row(6)
    process
	end

	def process
    @spreadsheet.sheets.each do |worksheet|
      @worksheet
      #next if worksheet == 'All-City_Buying-10-M'
      begin
        ActiveRecord::Base.transaction do
          if SheetDatum.where(:sheet_name => worksheet.downcase).first.present?
            sheet_index = SheetDatum.where(:sheet_name => worksheet.downcase).first
            row_no = sheet_index.last_processed_index + 1
            next if (row_no - 1) == @spreadsheet.sheet(worksheet).last_row
          else
            row_no = 7
          end
          (row_no..@spreadsheet.sheet(worksheet).last_row).each do |i|
            row = Hash[[@header, @spreadsheet.row(i)[0..9]].transpose]
            @worksheet = worksheet
            @i = i
            get_category_and_nature worksheet
            process_row row
          end
        end
        SheetDatum.create(:sheet_name => worksheet.downcase , :last_processed_index => @i)
       NotificationMailer.import_file_upload_email({:msg => "File Import is successfully completed for sheet #{worksheet}"}).deliver_now
      rescue Exception => e
      NotificationMailer.import_file_upload_email({:msg => "Got Exception #{e.message}"}).deliver_now
      end
    end
	end

	def process_row row
		validate row
    get_region row
    get_mode row
    validate_region_mode row
    begin
      Transaction.create_in_bulk(
        :duplicate_count => row["PCS"],
        :care_of => Person.where(:username => row["C/O"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["C/O"].downcase.strip.tr(" ", "_")),
        :trader => Person.where(:username => row["NAME"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["NAME"].downcase.strip.tr(" ", "_")),
        :total_amount => row["RATE"],
        :aggregate_recieved => row["TOTAL"],
        :transaction_date => @date || row['DATE'],
        :category => @category[0],
        :region => @region[0],
        :nature => @nature[0],
        :imported_from => 1, #saved from file
        :excel_file => @file,
        :mode => @mode[0],
        :target_date_in_days => @target_no_of_days
      )
    rescue Exception => e
      raise ArgumentError.new("Exceptions is #{e}. Incorrect Data found in row #{@i} from process_row, the data was #{row.as_json} and sheet is #{@worksheet} ") 
    end
	end
  
  def get_category_and_nature worksheet
    sheetname = worksheet.strip.split('_').last.split('-')
    @nature = Transaction.natures.keys.select { |nature| nature == sheetname.first.downcase }

    if sheetname.length == 2
      if sheetname.last.downcase == "form"
        @category = Category.all.select { |category| category.unit == "pia_form" }
      elsif sheetname.last.downcase == "cash"
        @category = Category.all.select { |category| category.unit == "cash" }
      else
        raise ArgumentError.new("please correct the sheet name we found #{worksheet}")
      end
    elsif sheetname.length == 3
      @category = Category.all.select { |category| category.unit == sheetname.last.downcase.strip && category.size == sheetname.second.to_i }
    else
      raise ArgumentError.new("please correct the sheet name we found #{worksheet}")
    end
    raise ArgumentError.new("please correct the sheet name we found #{worksheet}") if (@nature.blank? || @category.blank?)
  end

  def validate_region_mode row
    raise ArgumentError.new("Incorrect Data found in row #{@i} from validate_region_mode, the data was #{row.as_json} and sheet is #{@worksheet} ") if (@mode.blank? || @region.blank?)
  end

  def get_mode row
    @mode = Transaction.modes.keys.select { |mode| mode == row["TYPE"].split(' ').last.downcase.strip }
    get_target_no_of_days row if ["bop","sop"].include? @mode[0]
  end

  def get_region row
    @region = Region.all.select { |region| region.title == row["REGION"].downcase.strip }
  end
  
	def get_target_no_of_days row
    r = row
    raise ArgumentError.new("Date or Due Date is not found at #{@i} row, the data was #{row.as_json} in worksheet #{@worksheet}") if row["DUE DATE"].blank?

    row['DATE'] = row["DATE"].strftime('%d/%m/%y') if row['DATE'].class == Date
    row['DUE DATE'] = row["DUE DATE"].strftime('%d/%m/%y') if row['DUE DATE'].class == Date
    due_date = row["DUE DATE"].strip.split("/")
    due_date = row["DUE DATE"].strip.split('-') if (due_date.length == 1 || due_date.blank?)

    if due_date.length == 3
      day = due_date[0]
      month = due_date[1]
      year = due_date[2].to_i < 2000 ? (due_date[2].to_i + 2000) : due_date[2]
      final_due_date = [day,month,year].join('/')
    end
    
    date = row["DATE"].strip.split('/')
    date = row["DATE"].strip.split('-') if (date.length == 1 || date.blank?)
    
    if date.length == 3
      day = date[0]
      month = date[1]
      year = date[2].to_i < 2000 ? (date[2].to_i + 2000) : date[2]
      @date = [day,month,year].join('/')
    end
    raise ArgumentError.new("Incorrect Data found in row #{@i} from date or final date is absent and the data was #{row} and sheet is #{@worksheet} ") if (@date.blank? || final_due_date.blank?)
    @target_no_of_days = (Date.parse(final_due_date) - Date.parse(@date)).to_i
    #debugger if (@target_no_of_days < 0)

    raise ArgumentError.new("Incorrect Data found in row #{@i} from due date is less than transaction date and the data was #{row} and sheet is #{@worksheet} ") if (@target_no_of_days < 0)
	end

  def open_spreadsheet file
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

	def validate row
		if row.values_at("PCS","NAME","C/O","RATE","TOTAL","DATE","TYPE","REGION").any?{|v|v.blank?}
      raise ArgumentError.new("Incorrect Data found in row #{@i} from validate method and the data was #{row} and sheet is #{@worksheet} ")
    end
	end

end