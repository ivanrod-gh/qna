class AddRewardNameToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :reward_name, :string
  end
end
