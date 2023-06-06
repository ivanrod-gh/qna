class CreateRewardAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_achievements do |t|
      t.belongs_to :reward, foreign_key: true, index: {unique: true}
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
