class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? ENV.fetch("MAIL_FROM") : ENV.fetch("MAIL_FROM", "no-reply@example.com")
  layout "mailer"
end
