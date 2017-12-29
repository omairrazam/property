class TransactionExcelImporter
	def initialize file
		@file = file
		@spreadsheet = open_spreadsheet(@file)
    @header = @spreadsheet.row(6)
    process
	end

	def process
    @spreadsheet.sheets.each do |worksheet|
      begin
        ActiveRecord::Base.transaction do
          (7..@spreadsheet.sheet(worksheet).last_row).each do |i|
            row = Hash[[@header, @spreadsheet.row(i)].transpose]
            @i = i
            get_category_and_nature worksheet
            process_row row
          end
        end
        NotificationMailer.import_file_upload_email({:msg => "File Import is successfully completed"}).deliver_now
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

        Transaction.create_in_bulk(
          :duplicate_count => row["PCS"],
          :care_of => Person.where(:username => row["C/O"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["C/O"].downcase.strip.tr(" ", "_")),
          :trader => Person.where(:username => row["NAME"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["NAME"].downcase.strip.tr(" ", "_")),
          :total_amount => row["RATE"],
          :recieved_amount => row["TOTAL"]/row["PCS"],
          :transaction_date => row["DATE"],
          :category => @category[0],
          :region => @region[0],
          :nature => @nature[0],
          :imported_from => 1, #saved from file
          :excel_file => @file,
          :mode => @mode[0],
          :target_date_in_days => @target_no_of_days
        )
	end
  
  def get_category_and_nature worksheet
    sheetname = worksheet.strip.split('-')
    if sheetname.length == 2
      @nature = Transaction.natures.keys.select { |nature| nature == sheetname.first.downcase }
      if sheetname.last.downcase == "form"
        cat = sheetname.last.downcase.split("")
        @category = Category.all.select { |category| category.unit == "form" }
      elsif sheetname.last.downcase == "cash"
        @category = Category.all.select { |category| category.unit == "cash" }
      elsif sheetname.last.downcase.split("").length == 2
        cat = sheetname.last.downcase.split("")
        @category = Category.all.select { |category| category.unit.split("").first == cat.last.downcase.strip && category.size == cat.first.to_i }
      else
        raise ArgumentError.new("please correct the sheet name we found #{worksheet}")
      end
    else
      raise ArgumentError.new("please correct the sheet name we found #{worksheet}")
    end
    raise ArgumentError.new("please correct the sheet name we found #{worksheet}") if (@nature.blank? || @category.blank?)
  end

  def validate_region_mode row
    raise ArgumentError.new("Incorrect Data found in row #{@i} and the data was #{row}") if (@mode.blank? || @region.blank?)
  end

  def get_mode row
    @mode = Transaction.modes.keys.select { |mode| mode == row["TYPE"].downcase.strip }
    get_target_no_of_days row if ["bop","sop"].include? @mode[0]
  end

  def get_region row
    @region = Region.all.select { |region| region.title == row["REGION"].downcase.strip }
  end
  
	def get_target_no_of_days row
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
      final_date = [day,month,year].join('/')
    end
    raise ArgumentError.new("Incorrect Data found in row #{@i} and the data was #{row}") if (final_date.blank? || final_due_date.blank?)
    @target_no_of_days = (Date.parse(final_due_date) - Date.parse(final_date)).to_i
    raise ArgumentError.new("Incorrect Data found in row #{@i} and the data was #{row}") if (@target_no_of_days < 0)
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
		if row.values_at("PCS","NAME","C/O","RATE","TOTAL","DATE","TYPE","DUE DATE","REGION").any?{|v|v.blank?}
      raise ArgumentError.new("Incorrect Data found in row #{@i} and the data was #{row}")
    end
	end

end