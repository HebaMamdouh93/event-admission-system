class TicketSerializer < ActiveModel::Serializer

  attributes :id, :name, :email, :phone_number, :state, :tito_ticket_id, :tito_ticket_slug
end
