class Task < ActiveRecord::Base
  # attr_accessible :description, :done, :due_date, :name
  attr_accessible :description, :done, :due_date, :name, :category_id
  belongs_to :category
  belongs_to :owner, :class_name => "User"

  scope :done, where(:done => true).order("due_date")
  scope :undone, where(:done => false).order("due_date DESC")
  scope :search, lambda { |query|
    where([ "name LIKE ?", "%#{query}%" ])
  }

  validates :name, :presence => true, :length => {:maximum => 20}
  validates :description, :length => {:maximum => 200}
  validate :check_association

  private

  def check_association
    if category_id && !owner.categories.where(:id => category_id).exists?
      errors.add(:base, :missing_category)
      self.category_id = nil
    end
  end
end
