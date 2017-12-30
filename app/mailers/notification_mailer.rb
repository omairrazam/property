class NotificationMailer < ApplicationMailer
  default from: ENV["GMAIL_USER_NAME"]

  def import_file_upload_email(hash)
    @results = hash
    mail(to: "shahbaz.uollhr@gmail.com", subject: 'File Import Updates')
  end

end
