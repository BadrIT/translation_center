class AddVoteScope < ActiveRecord::Migration
  def up
    add_column :votes, :vote_scope, :string
  end

  def down
  end
end
