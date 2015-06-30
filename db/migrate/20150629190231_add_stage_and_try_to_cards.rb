class AddStageAndTryToCards < ActiveRecord::Migration
  def change
    add_column :cards, :stage, :integer, default: 1, null: false
    add_column :cards, :try, :integer, default: 1, null: false
  end
end
