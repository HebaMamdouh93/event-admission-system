# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :confirmable, :jwt_authenticatable,
       jwt_revocation_strategy: JwtDenylist

  # Associations     
  has_many :tickets, dependent: :nullify

  # Scopes
  scope :by_email, ->(email) do
    where(email: email)
  end

  def after_confirmation
    assign_unlinked_tickets
  end

  private

  def assign_unlinked_tickets
    Ticket.where(email: email, user_id: nil).update_all(user_id: id)
  end
end
