class NotificationMailer < ApplicationMailer
  default from: 'omsolutionpk@gmail.com'

  def import_file_upload_email(hash)
    @results = hash
    mail(to: "syed_shahhussain@yahoo.com", cc: 'omsolutionpk@gmail.com',subject: 'File Import Updates')
  end

end
