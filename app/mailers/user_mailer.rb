class UserMailer < ApplicationMailer  
  default to: ENV["SYSTEM_MAIL_TO"]
  def contact_mail(name,email,contents)
    @name = name
    @contents = contents
    mail from: email, subject: "Contact to Tokenmom Exchange"
  end
end
