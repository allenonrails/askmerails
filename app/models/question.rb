class Question < ApplicationRecord
  COLORS = {
    :white => '#FCFCFD',
    :red =>  '#FE504F',
    :blue => '#31B9CC',
    :yellow => '#FED86B'
  }

  belongs_to :user
  validates :text, presence: true, length: { maximum: 255 }
  validates :color, on: :create, inclusion: {in: COLORS.values } 

  def self.colors
    COLORS.map {|color_name, hex| [color_name, hex]}
  end
end
