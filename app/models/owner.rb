class Owner < ActiveRecord::Base
  has_many :repos, dependent: :destroy

  def self.upsert(github_id:, github_name:)
    owner = find_or_initialize_by(github_id: github_id)
    owner.github_name = github_name
    owner.save
    owner
  end
end
