Resend.api_key = Rails.env.production? ? ENV.fetch("RESEND_API_KEY") : ENV.fetch("RESEND_API_KEY", "dummy_key")
