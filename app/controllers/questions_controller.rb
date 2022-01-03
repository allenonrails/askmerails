class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, except: [:create]

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:success] = "Вопрос для #{@question.user.name} успешно создан!"
      redirect_to user_path(@question.user) 
    else
      redirect_back(fallback_location: root_path)
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      flash[:success] = "#{@question.user.name}, вопрос успешно обновлён"
      redirect_to user_path(@question.user) 
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    user = @question.user
    @question.destroy

    flash[:success] = "#{user.name}, вопрос удалён"
    redirect_to user_path(user) 
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def authorize_user
      reject_user unless @question.user == current_user
    end

    def question_params
      params.require(:question).permit(:user_id, :text, :answer, :color)
    end
end
