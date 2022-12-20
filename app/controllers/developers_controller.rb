# frozen_string_literal: true

class DevelopersController < ApplicationController
  before_action :set_developer, except: %i[index create new]

  def show; end

  def new
    @developer = User.new
    authorize @developer
  end

  def edit
  end

  def create
    @developer = User.new(user_params)
    authorize @developer
    if @developer.save
      current_user.subordinates << @developer

      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @developer.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @developer.destroy
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream
      end
    else
      redirect_to projects_path, flash: { failure: 'Unable to delete user' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :user_name, :role)
  end

  def set_developer
    @developer = User.find_by(id: params[:id])
    authorize @developer
  end
end
