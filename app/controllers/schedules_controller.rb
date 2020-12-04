class SchedulesController < ApplicationController
  before_action :find_user

  def index
    @schedules = Schedule.where(user_id: params[:user_id]).all
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user_id = current_user.id
    if @schedule.save
        redirect_to user_schedules_path
    else
      flash.now[:danger] = "L'horaire n'a pas pu être créé"
      render :new
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def schedule_params
    params.require(:schedule).permit(:start_time)
  end

end
