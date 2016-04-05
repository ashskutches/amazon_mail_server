class CreateReview < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :order_id
      t.integer :rating
      t.string :asin
      t.text :content
      t.string :author_name
      t.date :date_created_on_amazon

      t.timestamps null: false
    end
  end
end
