class Public::ReportsController < ApplicationController
  def new
    @report = Report.new
    @user = User.find(params[:user_id])
  end

  def create
    @report = Report.new(report_params)
    @user = User.find(params[:user_id])
    @report.reporter_id = current_user.id
    @report.reprted_id = @user.id
    if @report.save
      redirect_to user_path(@user), notice: "通報を受け付けました。"
    else
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:reason, :url)
  end
end
