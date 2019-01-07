json.extract! time_card, :id, :in_at, :out_at, :date, :created_at, :updated_at
json.url time_card_url(time_card, format: :json)
