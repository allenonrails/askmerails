class TagsController < ApplicationController
 before_action :load_tag

  def show
    @questions = @tag.questions
  end

  private

    def load_tag
      @tag = Tag.find_by!(id: params[:id])
    end
end
