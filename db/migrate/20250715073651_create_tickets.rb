class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.integer :tito_ticket_id
      t.string :tito_ticket_slug
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :state
      t.datetime :tito_created_at
      t.jsonb :tito_info

      t.timestamps
    end
  end
end
