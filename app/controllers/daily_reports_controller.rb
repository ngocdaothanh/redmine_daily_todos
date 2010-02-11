class DailyReportsController < ApplicationController
  ONE_MONTH = 31

  unloadable

  before_filter :require_login

  def all_users
    @date = (params[:date])? Date.parse(params[:date]) : Date.today
    @reports = DailyReport.all(:conditions => {:date => @date}, :order => 'user_id DESC')
  end

  def one_user
    @user = User.find(params[:user_id])
    @date = (params[:date])? Date.parse(params[:date]) : Date.today
    reports = DailyReport.all(
      :conditions => ["user_id = ? AND (date <= ? AND date >= ?)", params[:user_id], @date, @date - ONE_MONTH],
      :order      => 'date DESC'
    )

    @reports = if reports.empty?
      ((@date - ONE_MONTH)..@date).map do |date|
        DailyReport.new(:user_id => @user.id, :date => date)
      end
    else
      i = 0
      ((@date - ONE_MONTH)..@date).map do |date|
        if i >= reports.size || date < reports[i].date
          DailyReport.new(:user_id => @user.id, :date => date)
        else
          i += 1
          reports[i - 1]
        end
      end
    end
    
    @reports.reverse!
  end

  def new
    @date = (params[:date])? Date.parse(params[:date]) : Date.today
    @report = Report.new(:date => date)
  end
  
  def create
    @report = Report.new(params[:report])
    @report.user_id
    if @report.save
      redirect_to(:action => 'one_user', :date => @report.date)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @report = Report.find(params[:id])
    if @report.user_id != User.current.id
      flash[:error] = "You cannot edit other's report"
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
  
  def update
    @report = Report.find(params[:id])
    if @report.user_id != User.current.id
      flash[:error] = "You cannot update other's report"
      redirect_to(:action => 'one_user', :user_id => User.current.id)
    else
      # Avoid mass assignment
      @report.date        = params[:report][:date]
      @report.plan        = params[:report][:plan]
      @report.lunch_begin = params[:report][:lunch_begin]
      @report.lunch_end   = params[:report][:lunch_end]
      @report.reality     = params[:report][:reality]
      @report.next_plan   = params[:report][:next_plan]

      if @report.save
        redirect_to(:action => 'one_user', :date => @report.date)
      else
        render :action => 'edit'
      end
    end
  end
  
  def delete
    report = Report.find(params[:id])
    if report.user_id != User.current.id
      flash[:error] = "You cannot delete other's report"
    else
      flash[:notice] = 'Report deleted'
      report.destroy
    end
    redirect_to(:action => 'one_user', :user_id => User.current.id)
  end
end
