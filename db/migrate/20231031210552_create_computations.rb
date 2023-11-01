class CreateComputations < ActiveRecord::Migration[7.0]
  def change
    create_table :computations do |t|
      t.integer :value
      t.integer :result
      t.integer :runtime

      t.timestamps
    end
  end
end
