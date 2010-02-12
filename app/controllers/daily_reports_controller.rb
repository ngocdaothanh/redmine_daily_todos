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
      :order      => 'date ASC'  # ASC because "range" below is increasing
    )

    range = (@date - ONE_MONTH)..@date
    @reports = if reports.empty?
      range.map do |date|
        DailyReport.new(:user_id => @user.id, :date => date)
      end
    else
      i = 0
      range.map do |date|
        if i >= reports.size || date > reports[i].date
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
    date = (params[:date])? Date.parse(params[:date]) : Date.today
    @report = DailyReport.new(:date => date)
  end
  
  def create
    # Avoid mass assignment
    pdr = params[:daily_report]
    @report = DailyReport.new(pdr)
    @report.user_id     = User.current.id
    @report.lunch_begin = Time.mktime(@report.date.year, @report.date.month, @report.date.day, pdr['lunch_begin(4i)'], pdr['lunch_begin(5i)'])
    @report.lunch_end   = Time.mktime(@report.date.year, @report.date.month, @report.date.day, pdr['lunch_end(4i)'], pdr['lunch_end(5i)'])

    if @report.save
      redirect_to(:action => 'one_user', :user_id => User.current.id, :date => @report.date)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @report = DailyReport.find(params[:id])
    if @report.user_id != User.current.id
      flash[:error] = "You cannot edit other's report"
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
  
  def update
    @report = DailyReport.find(params[:id])
    if @report.user_id != User.current.id
      flash[:error] = "You cannot update other's report"
      redirect_to(:action => 'one_user', :user_id => User.current.id)
    else
      # Avoid mass assignment
      # Do not allow "date" to be updated
      pdr = params[:daily_report]
      @report.plan        = pdr[:plan]
      @report.lunch_begin = Time.mktime(@report.date.year, @report.date.month, @report.date.day, pdr['lunch_begin(4i)'], pdr['lunch_begin(5i)'])
      @report.lunch_end   = Time.mktime(@report.date.year, @report.date.month, @report.date.day, pdr['lunch_end(4i)'], pdr['lunch_end(5i)'])
      @report.reality     = pdr[:reality]
      @report.next_plan   = pdr[:next_plan]

      if @report.save
        redirect_to(:action => 'one_user', :user_id => User.current.id, :date => @report.date)
      else
        render :action => 'edit'
      end
    end
  end
  
  def delete
    report = DailyReport.find(params[:id])
    if report.user_id != User.current.id
      flash[:error] = "You cannot delete other's report"
    else
      flash[:notice] = 'Report deleted'
      report.destroy
    end
    redirect_to(:action => 'one_user', :user_id => User.current.id)
  end
end
