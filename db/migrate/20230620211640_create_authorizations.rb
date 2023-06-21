class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations do |t|
      t.string :provider, null: false
      t.string :uid, null: false

      t.belongs_to :user, foreign_key: true
      t.timestamps

      t.index %i[provider uid], unique: true
    end
  end
end
