class Player < ActiveRecord::Base
  belongs_to :league_template
  belongs_to :position
end
