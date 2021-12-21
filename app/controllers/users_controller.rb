class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]

  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.last(8)
  end

  def new
    if current_user.present?
      flash[:success] = "#{current_user.name}, вы уже залогинены"
      redirect_to user_path(current_user.id)
    end

    @user = User.new
  end

  def create
    if current_user.present?
      flash[:success] = "#{current_user.name}, вы уже залогинены"
      redirect_to user_path(current_user.id)
    end

    @user = User.new(user_params)

    if @user.save
      flash[:success] = "#{@user.name}, ваш аккаунт успешно создан!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit  
    @user = User.find params[:id]
  end

  def update 
    if @user.update(user_params)
      flash[:success] = "#{@user.name}, изменения сохранены :)"
      redirect_to action: 'show'
    else
      render 'show'
    end
  end

  def show
    @questions = @user.questions.order(created_at: :desc)
    
    @new_question = @user.questions.build
  end

  private

  def authorize_user
    reject_user unless @user == current_user
  end

  def load_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :avatar_url, :description)
  end
end
