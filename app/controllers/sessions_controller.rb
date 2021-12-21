class SessionsController < ApplicationController
  def new
    if current_user.present?
      flash[:success] = "#{current_user.name}, вы уже залогинены"
      redirect_to user_path(current_user.id)
    end
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
  
    if @user.present?
      session[:user_id] = @user.id
      flash[:success] = "#{@user.name}, добро пожаловать в систему"
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Неверный email или пароль"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Выход из аккаунта выполнен успешно!"
    redirect_to root_url
  end
end
