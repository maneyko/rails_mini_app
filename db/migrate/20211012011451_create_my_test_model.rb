class CreateMyTestModel < ActiveRecord::Migration[6.1]
  def change
    create_table :my_test_models do |t|
      t.string  :a
      t.boolean :b
      t.integer :c
      t.decimal :d
      t.decimal :e
      t.float   :f
    end
  end
end
