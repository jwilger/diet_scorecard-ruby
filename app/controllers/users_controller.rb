class UsersController < ApplicationController
  def edit
  end

  def update
    current_user.update_attributes(params.require(:user).permit(:timezone))
    if current_user.valid?
      flash[:notice] = 'Your settings have been updated'
      redirect_to root_path
    else
      flash.now[:alert] = 'Unable to save your changes'
      render action: :edit
    end
  end
end
