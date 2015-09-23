class AddVaccinatedToPets < ActiveRecord::Migration
  def change
    add_column :pets, :vaccinated, :boolean, default: false
  end
end
