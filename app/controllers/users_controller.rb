class UsersController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Gleb',
      username: '@admin',
      email: 'gleb2004@gmail.ru',
      password: '123456'
    )
  end
end
