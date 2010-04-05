class DailyTodoEntriesController < ApplicationController
  # Avoid "A copy of ApplicationController has been removed from the module tree but is still active!"
  unloadable

  def new
    @entry = DailyTodoEntry.new(:daily_todo_id => params[:daily_todo_id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_create_error')
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)   
    end
  end
    
  def create
    pdr = params[:daily_todo_entry]
    @entry = DailyTodoEntry.new(pdr)
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_create_error')
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)   
    end

    if @entry.save
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id, :date => @entry.daily_todo.date)
    else
      render :action => 'new'
    end

  end
  
  def edit
    @entry = DailyTodoEntry.find(params[:id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] =  l(:'daily_todos.entry_edit_error')
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)   
    end
  end
    
  def update
    @entry = DailyTodoEntry.find(params[:id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_edit_error')
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)
      return
    end

    @entry.update_attributes(params[:daily_todo_entry])
    if @entry.save
      redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id, :date => @entry.daily_todo.date)
    else
      render :action => 'edit'
    end
  end
  
  def delete
    entry = DailyTodoEntry.find(params[:id])
    if entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_delete_error')
    else
      flash[:notice] = l(:'daily_todos.entry_delete')
      entry.destroy
    end
    redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)
  end
end
