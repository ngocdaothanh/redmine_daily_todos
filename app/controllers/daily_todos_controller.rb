class DailyTodosController < ApplicationController
  ONE_MONTH = 31

  unloadable

  before_filter :require_login

  def all_users
    @date = (params[:date])? Date.parse(params[:date]) : Date.today
    @todos = DailyTodo.all(:conditions => {:date => @date}, :order => 'user_id DESC')
    
    # Check if the current user has written todo for this date
    @reported = @todos.any? { |todo| todo.user_id == User.current.id }
  end

  def one_user
    @user = User.find(params[:user_id])
    @date = (params[:date])? Date.parse(params[:date]) : Date.today
    todos = DailyTodo.all(
      :conditions => ["user_id = ? AND (date <= ? AND date >= ?)", params[:user_id], @date, @date - ONE_MONTH],
      :order      => 'date ASC'  # ASC because "range" below is increasing
    )

    range = (@date - ONE_MONTH)..@date
      @todos = if todos.empty?
      range.map do |date|
        DailyTodo.new(:user_id => @user.id, :date => date)
      end
    else
      i = 0
      range.map do |date|
        if  i >= todos.size || date < todos[i].date
          DailyTodo.new(:user_id => @user.id, :date => date)
        else
          i += 1
          todos[i - 1]
        end
      end
    end
    
    @todos.reverse!
  end

  def new
    date = (params[:date])? Date.parse(params[:date]) : Date.today
    reported = (DailyTodo.find(:first, :conditions => {:user_id => User.current.id, :date => date}) != nil)
    if reported
      flash[:error] = 'You have written todo for this date'
      redirect_to(:action => 'one_user', :user_id => User.current.id, :date => date)
    else
      @todo = DailyTodo.new(:date => date) unless @reported
    end
  end
  
  def create
    # Avoid mass assignment
    pdr = params[:daily_todo]
    @todo = DailyTodo.new(pdr)

    reported = (DailyTodo.find(:first, :conditions => {:user_id => User.current.id, :date => @todo.date}) != nil)
    if reported
      flash[:error] = 'You have written todo for this date'
      redirect_to(:action => 'one_user', :user_id => User.current.id, :date => @todo.date)
    else
      @todo.user_id     = User.current.id
      @todo.lunch  = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      @todo.begin = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      @todo.end   = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      if @todo.save
        redirect_to(:action => 'one_user', :user_id => User.current.id, :date => @todo.date)
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @todo = DailyTodo.find(params[:id])
    if @todo.user_id != User.current.id
      flash[:error] = "You cannot edit other's todo"
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
  
  def update
    @todo = DailyTodo.find(params[:id])
    if @todo.user_id != User.current.id
      flash[:error] = "You cannot update other's todo"
      redirect_to(:action => 'one_user', :user_id => User.current.id)
    else
      # Avoid mass assignment
      # Do not allow "date" to be updated
      pdr = params[:daily_todo]
      @todo.plan        = pdr[:plan]
      @todo.lunch = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      @todo.begin = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      @todo.end   = Time.mktime(@todo.date.year, @todo.date.month, @todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
      @todo.result     = pdr[:result]

      if @todo.save
        redirect_to(:action => 'one_user', :user_id => User.current.id, :date => @todo.date)
      else
        render :action => 'edit'
      end
    end
  end
  
  def delete
    todo = DailyTodo.find(params[:id])
    if todo.user_id != User.current.id
      flash[:error] = "You cannot delete other's todo"
    else
      flash[:notice] = 'todo deleted'
      todo.destroy
    end
    redirect_to(:action => 'one_user', :user_id => User.current.id)
  end
end
