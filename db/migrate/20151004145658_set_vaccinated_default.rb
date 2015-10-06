class SetVaccinatedDefault < ActiveRecord::Migration
  def change
    change_column_null :pets, :vaccinated, true
    change_column_default :pets, :vaccinated, false
  end
end
