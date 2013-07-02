namespace :procurement do
  desc "Processes Json data retrived from a full web scrape and inputs results into a database"
  task:full_scrape => :environment do
    require "scraper_file"
    ScraperFile.processFullScrape
  end
  
  desc "Processes Json data retrived from a partial web scrape and inputs results into a database"
  task:incremental_scrape => :environment do
    require "scraper_file"
    ScraperFile.processIncrementalScrape
  end

  desc "Process meta data and store results in db"
  task:buildMetaData=> :environment do
    require "scraper_file"
    ScraperFile.buildUserDataOnly
  end


  desc "do debug tasks"
  task:test_code => :environment do
    require "test_code"
    TestFile.run
  end

  desc "save user data"
  task:export_users => :environment do
    require "user_migrator"
    UserMigrator.createMigrationFile
  end
  
  desc "import user data"
  task:import_users => :environment do
    require "user_migrator"
    UserMigrator.migrate
  end

end
