class DailyTodosController < ApplicationController
  # Avoid "A copy of ApplicationController has been removed from the module tree but is still active!"
  unloadable

  ONE_WEEK = 7

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
      :conditions => ["user_id = ? AND (date <= ? AND date >= ?)", params[:user_id], @date, @date - ONE_WEEK],
      :order      => 'date ASC'  # ASC because "range" below is increasing
    )

    range = (@date - ONE_WEEK)..@date
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

  def create_todo
    date = (params[:date])? Date.parse(params[:date]) : Date.today
    time = Time.now
    reported = (DailyTodo.find(:first, :conditions => {:user_id => User.current.id, :date => date}) != nil)
    if reported
      flash[:error] = l(:'daily_todos.todo_create_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id, :date => date)
    else
      todo = DailyTodo.new(:date => date, :lunch => time, :user_id => User.current.id ) unless @reported
      todo.save
      redirect_to(:action => 'one_user', :user_id => User.current.id, :date => date)
    end
  end
  
  def update
    @todo = DailyTodo.find(params[:id])
    pdr = params[:daily_todo]
    @todo.lunch  = Time.mktime(@todo.date.year, @todo.date.month,@todo.date.day, pdr['lunch(4i)'], pdr['lunch(5i)'])
    @todo.save
    redirect_to(:action => 'one_user', :user_id => User.current.id)
  end
  
  def delete
    todo = DailyTodo.find(params[:id])
    if todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.todo_delete_error')
    else
      flash[:notice] = l(:'daily_todos.todo_delete')
      todo.destroy
    end
    redirect_to(:action => 'one_user', :user_id => User.current.id)
  end
end

