require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

Selenium::WebDriver::Chrome::Service.driver_path = "/usr/local/bin/chromedriver"

Capybara.register_driver :selenium_chrome_headless do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--headless')
  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--no-sandbox')
  chrome_options.add_argument('--disable-dev-shm-usage')
  chrome_options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: chrome_options
  )
end

Capybara.javascript_driver = :selenium_chrome_headless
