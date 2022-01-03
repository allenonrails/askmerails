class Tag < ApplicationRecord
  TAG_REGEX = /#[[:lower:]+_]+/

  has_many :question_tags, dependent: :destroy
  has_many :questions, through: :question_tags

  scope :with_questions, -> { joins(:questions).distinct }

  before_validation { title&.downcase! }

  validates :title, presence: true

  before_save :delete_hashtag

  private

    def delete_hashtag
      self.title.delete!("#")
    end
end
