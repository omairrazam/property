class AddPodDaysToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :pod_days, :integer
  end
end
