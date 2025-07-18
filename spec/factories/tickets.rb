# == Schema Information
#
# Table name: tickets
#
#  id               :bigint           not null, primary key
#  email            :string
#  name             :string
#  phone_number     :string
#  state            :string
#  tito_created_at  :datetime
#  tito_info        :jsonb
#  tito_ticket_slug :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tito_ticket_id   :integer
#  user_id          :bigint
#
# Indexes
#
#  index_tickets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :ticket do
    tito_ticket_id { Faker::Number.number(digits: 6) }
    tito_ticket_slug { Faker::Lorem.word }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    state { "complete" }
    tito_created_at { Faker::Time.backward(days: 365) }
    tito_info { {} }
  end
end
