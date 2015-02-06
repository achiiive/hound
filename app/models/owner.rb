class Owner < ActiveRecord::Base
  has_many :repos

  def self.upsert(github_id:, github_login:)
    owner = find_or_initialize_by(github_id: github_id)
    owner.github_login = github_login
    owner.save
    owner
  end
end
