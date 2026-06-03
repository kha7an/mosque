class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Сброс пароля: #{user.login}", to: ENV.fetch("ADMIN_MAIL_TO")
  end
end
