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
#
class Ticket < ApplicationRecord
end
