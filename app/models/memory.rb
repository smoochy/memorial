class Memory < ActiveRecord::Base
  belongs_to :user
  has_many :eulogies
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :description, :presence => true
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def lived
    "#{date_of_birth.year} - #{date_of_death.year}"
  end
  
  # class method for getting search results. Matches the user's name for now.
  def self.search(query)
    if !query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      find_by_sql(["select m.* from memories AS m WHERE #{ (["(lower(m.first_name) like ? or lower(m.last_name) like ?)"] * tokens.size).join(" and ") } ORDER BY m.created_at DESC", *(tokens * 2).sort])
    else
      []
    end
  end
end
