class Post < ActiveRecord::Base
  
  # ****
  # Validations
  validates :title, :presence => true, :length => { :within => 2..64 }
  validates :keywords, :length => { :within => 2..255, :allow_blank => true }
  validates :body, :presence => true, :length => { :minimum => 10 }

  # ****
  # Mass-assignment protection
  attr_accessible :title, :keywords, :body, :image, :retained_image

  # Image attachment
  image_accessor :image
  
  # ****
  # Pagination
  paginates_per 16
  
  def to_param
    "#{id}-#{title}".parameterize
  end
  
  # ****
  # Default ordering
  default_scope :order => 'created_at DESC'
  
  # Caching
  # -------
  CACHED = 'recent_posts'
  
  after_save :clear_cache

  def self.recent
    #Rails.cache.fetch(CACHED, :expires_in => 1.day) do
      self.order(:created_at).limit(3).all
    #end
  end

  def clear_cache
    #Rails.cache.delete(CACHED)
  end

  def self.clear_cache
    #Rails.cache.delete(CACHED)
  end
  
  # ****
  # Logging
  after_create :log_create_event
  after_update :log_update_event
  
  private #----
    
    def log_create_event
      Event.create(:description => "Created post: #{title}")
    end
    
    def log_update_event
      Event.create(:description => "Changed post: #{title}")
    end
    
end