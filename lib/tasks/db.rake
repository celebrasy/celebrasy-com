namespace :db do
  namespace :seed do
    desc 'seed all league templates'
    task :all => :environment do
      require './db/seeds_all'
    end
  end
end
