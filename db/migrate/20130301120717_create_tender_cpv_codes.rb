class CreateTenderCpvCodes < ActiveRecord::Migration
  def change
    create_table :tender_cpv_codes do |t|
      t.integer :tender_id
      t.integer :cpv_code
      t.string  :description
      t.string  :english_description
      t.timestamps
    end
  end
end
