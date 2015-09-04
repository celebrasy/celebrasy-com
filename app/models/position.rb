class Position < ActiveRecord::Base
  belongs_to :league_template

  def attrs_for_league_position
    {
      position: self,
      title: self.title,
      count: self.suggested_count,
      strict: self.strict
    }
  end
end
