class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('just@just.pro.br', 'CityZones Web')
  layout "mailer"
end
