class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :code, :limit => 8
      t.string :organization_url
      t.string :name
      t.string :country
      t.string :org_type
      t.boolean :is_bidder, :default => false
      t.boolean :is_procurer, :default => false
      t.string :city
      t.string :address
      t.string :phone_number
      t.string :fax_number
      t.string :email
      t.string :webpage

      t.timestamps
    end

    add_index :organizations, [:organization_url, :name]
  end
end
