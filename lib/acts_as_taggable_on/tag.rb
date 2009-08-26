class Tag < ActiveRecord::Base
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end
  
  # used to get counts for all tags across all owners. useful for tag clouds
  # grouping tags across many kinds of objects
  # should probably be expanded to take a context
  def self.counts
    find_by_sql("SELECT tags.name, tags.id, count(*) AS count FROM taggings LEFT JOIN tags ON tags.id=taggings.tag_id GROUP BY taggings.tag_id")
  end
end
