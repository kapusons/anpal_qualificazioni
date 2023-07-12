class AddItaliaToRegions < ActiveRecord::Migration[7.0]
  def up
    Region.create(name: 'Italia')
  end

  def down
    Region.find_by(name: 'Italia').try(:destroy)
  end
end
