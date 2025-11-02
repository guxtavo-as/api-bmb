class CreateTopup < ActiveRecord::Migration[7.1]
  def change
    create_table :topups do |t|
      t.string :external_id, null: false
      t.string :phone_number, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :provider_reference
      t.integer :status, null: false, default: 0
      t.jsonb :request_payload, null: false, default: {}
      t.jsonb :response_payload, null: false, default: {}
      t.text :error_message
      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_index :topups, :external_id, unique: true
    add_index :topups, :status
  end
end
