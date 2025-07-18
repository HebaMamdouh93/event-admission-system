class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :tickets, if: :include_tickets?

  def include_tickets?
    instance_options[:include_tickets] == true
  end
end
