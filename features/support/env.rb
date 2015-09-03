require "capybara/poltergeist"
require "cucumber/rails"
require Rails.root.join("db/seeds")
include Capybara::Select2

ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation
Cucumber::Rails::Database.javascript_strategy = :truncation

headless = (ENV["HEADLESS"] == "true")
if headless
  Capybara.register_driver(:poltergeist) do |app|
    Capybara::Poltergeist::Driver.new(app, { debug: false, extensions: ["vendor/poltergeist/bind.js"] })
  end
else
  Capybara.register_driver(:browser) do |app|
    Capybara::Selenium::Driver.new(app, { browser: :chrome })
  end
end

Capybara.default_driver = Capybara.javascript_driver = (headless ? :poltergeist : :browser)

Before do
  Seeds::BadCelebs.seed!
end
