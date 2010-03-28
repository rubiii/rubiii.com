class Article < ActiveRecord::Base

  belongs_to :category
  has_friendly_id :title, :use_slug => true, :strip_non_ascii => true

  named_scope :all_by_category, lambda { |category| { :include => :category, :conditions => { "categories.name" => category.to_s } } }

end
