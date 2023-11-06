class PasswordRecoveryMailer < ApplicationMailer

  def recovery_mail
    @user = params[:user]
    @recovery = params[:recovery]
    mail(to: email_address_with_name(@user.email, @user.name), subject: 'CityZones password recovery')
  end

end
