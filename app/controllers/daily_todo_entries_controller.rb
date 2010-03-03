class DailyTodoEntriesController < ApplicationController
  # Avoid "A copy of ApplicationController has been removed from the module tree but is still active!"
  unloadable

  def new
    @entry = DailyTodoEntry.new(:daily_todo_id => params[:daily_todo_id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_create_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
    
  def create
    # Avoid mass assignment
    pdr = params[:daily_todo_entry]
    @entry = DailyTodoEntry.new(pdr)
    @entry.begin = Time.mktime( @entry.daily_todo.date.year, @entry.daily_todo.date.month, @entry.daily_todo.date.day, pdr['begin(4i)'], pdr['begin(5i)'])
    @entry.end   = Time.mktime( @entry.daily_todo.date.year, @entry.daily_todo.date.month, @entry.daily_todo.date.day, pdr['end(4i)'], pdr['end(5i)'])
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
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
    
  def update
    @entry = DailyTodoEntry.find(params[:id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry_edit_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id)
    else
      # Avoid mass assignment
      # Do not allow "date" to be updated
      pdr = params[:daily_todo_entry]
      @entry.plan    = pdr[:plan]
      @entry.begin  = Time.mktime(@entry.daily_todo.date.year, @entry.daily_todo.date.month,@entry.daily_todo.date.day, pdr['begin(4i)'], pdr['begin(5i)'])
      @entry.end    = Time.mktime(@entry.daily_todo.date.year, @entry.daily_todo.date.month,@entry.daily_todo.date.day, pdr['end(4i)'], pdr['end(5i)'])
      @entry.result        = pdr[:result]

      if @entry.save
        redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id, :date => @entry.daily_todo.date)
      else
        render :action => 'edit'
      end
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
