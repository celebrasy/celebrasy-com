require Rails.root.join("db/seeds")

Seeds.delete_everything
Seeds::BadCelebs.seed!
Seeds::Bachelorette.seed!
#Seeds::PresidentialDebates.seed!
