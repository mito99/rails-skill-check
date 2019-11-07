class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :user_cnt_default
      t.integer :user_cnt_max
      t.integer :box_cnt_default
      t.integer :box_cnt_max
      t.integer :monthly_fee
      t.integer :surcharge_user_fee
      t.integer :surcharge_box_fee
      t.timestamps
    end
  end
end
