class NotificationMailer < ApplicationMailer
  default from: ENV["GMAIL_USER_NAME"]

  def import_file_upload_email(hash)
    @results = hash
    @user = User.current_user #TODO need to ask
    mail(to: @user.email, subject: 'File Import Updates')
  end

end
