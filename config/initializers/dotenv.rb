if %w(development test).include?(Rails.env)
  Dotenv.load(".env.#{Rails.env}.local")
  Dotenv.load(".env.#{Rails.env}")
end
