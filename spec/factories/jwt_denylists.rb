# == Schema Information
#
# Table name: jwt_denylists
#
#  id         :bigint           not null, primary key
#  exp        :datetime
#  jti        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_jwt_denylists_on_jti  (jti)
#
FactoryBot.define do
  factory :jwt_denylist do
    jti { Faker::Alphanumeric.alpha(number: 32) }
    exp { Faker::Time.forward(days: 30) }
  end
end
