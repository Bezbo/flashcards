class RenameTryToAttemptInCards < ActiveRecord::Migration
  def change
    rename_column :cards, :try, :attempt
  end
end
