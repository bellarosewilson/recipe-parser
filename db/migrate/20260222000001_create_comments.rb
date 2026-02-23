# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :commentable, polymorphic: true, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_index :comments, %i[commentable_type commentable_id]
  end
end
