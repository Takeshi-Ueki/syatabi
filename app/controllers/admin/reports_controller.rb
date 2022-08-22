class Admin::ReportsController < ApplicationController
  def index
    @reports = Report.includes(:reporter, :reported).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    @report.update(report_params)
    redirect_to admin_reports_path
  end

  private

  def report_params
    params.require(:report).permit(:status)
  end
end
