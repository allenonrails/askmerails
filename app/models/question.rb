class Question < ApplicationRecord
  COLORS = {
    :white => '#FCFCFD',
    :red =>  '#FE504F',
    :blue => '#31B9CC',
    :yellow => '#FED86B'
  }

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :text, presence: true, length: { maximum: 255 }
  validates :color, on: :create, inclusion: {in: COLORS.values } 

  after_save_commit :update_tags, on: %i[create update]

  def self.colors
    COLORS.map {|color_name, hex| [color_name, hex]}
  end

  private

    def update_tags
      self.tags =
        "#{text} #{answer}".downcase.scan(Tag::TAG_REGEX).uniq.map do |tag|
          Tag.find_or_create_by(title: tag)
        end
    end
end
