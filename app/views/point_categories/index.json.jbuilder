json.array!(@point_categories) do |point_category|
  json.extract! point_category, :id, :league_id
  json.url point_category_url(point_category, format: :json)
end
