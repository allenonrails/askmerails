class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    flash[:error] = "Вы не авторизованы или к данному ресурсу у вас нет доступа :("
    redirect_to root_url 
  end
end
