# == Schema Information
#
# Table name: tickets
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
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
#  index_tickets_on_deleted_at  (deleted_at)
#  index_tickets_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TicketSerializer < ActiveModel::Serializer

  attributes :id, :name, :email, :phone_number, :state, :tito_ticket_id, :tito_ticket_slug
end
