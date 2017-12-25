class TransactionExcelImporter
	def initialize file
		@file = file
		@spreadsheet = open_spreadsheet(@file)
    	@header = @spreadsheet.row(6)
	end

	def process
    	ActiveRecord::Base.transaction do
      		(7..spreadsheet.last_row).each do |i|
      			process_row row[i]
      		end
      	end
	end

	def process_row row
		validate row
		row = Hash[[@header, spreadsheet.row].transpose]
        get_target_no_of_days row
        
        #TODO need to check further data validity. don't know how to do so.

        Transaction.create_in_bulk(
          :duplicate_count => row["PCS"],
          :care_of => Person.where(:username => row["C/O"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["C/O"].downcase.strip.tr(" ", "_")),
          :trader => Person.where(:username => row["NAME"].downcase.strip.tr(" ", "_")).first_or_create(:username => row["NAME"].downcase.strip.tr(" ", "_")),
          :total_amount => row["RATE"],
          :recieved_amount => row["TOTAL"]/row["PCS"],
          :transaction_date => row["DATE"],
          :category => Category.first, #TODO make dynamic
          :region => Region.first, #TODO make dynamic
          :nature => 1, #TODO make dynamic
          :imported_from => 1, #saved from file
          :excel_file => file,
          :mode => 0,
          :target_date_in_days => @target_no_of_days
        )
	end

	def get_target_no_of_days row
		if row["TIME"].present?
          no_of_days = row["TIME"].split(" ").reject(&:blank?)
          if !(no_of_days.length > 2) # Temporary fix
            hash = {:week => 7, :days => 1,:month => 30, :months => 30}
            @target_no_of_days = no_of_days.first.to_i * hash[no_of_days.last.downcase.strip.to_sym]
          else
            NotificationMailer.import_file_upload_email({:msg => "Incorrect Data found in row #{i} and the data was #{row} please correct the data and reload the file."})
            raise ArgumentError.new("Incorrect Data found in row #{i} and the data was #{row}")
            @target_no_of_days = nil
          end
        else
          NotificationMailer.import_file_upload_email({:msg => "Incorrect Data found in row #{i} and the data was #{row} please correct the data and reload the file."})
          raise ArgumentError.new("Incorrect Data found in row #{i} and the data was #{row}")
          @target_no_of_days = nil
        end
	end

	def validate row
		if row.values_at("PCS","C/O","NAME","RATE","TOTAL","DATE").any?{|v|v.blank?}
          NotificationMailer.import_file_upload_email({:msg => "Incorrect Data found in row #{i} and the data was #{row} please correct the data and reload the file."})
          raise ArgumentError.new("Incorrect Data found in row #{i} and the data was #{row}")
        end
	end

end