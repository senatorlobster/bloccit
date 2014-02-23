# spec/support/database_cleaner.rb

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    # DatabaseCleaner[:active_record].strategy = :truncation
    # DatabaseCleaner[:redis].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
