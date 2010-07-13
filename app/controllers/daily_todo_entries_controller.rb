class DailyTodoEntriesController < ApplicationController
  # Avoid "A copy of ApplicationController has been removed from the module tree but is still active!"
  unloadable

  def new
    @entry = DailyTodoEntry.new(:daily_todo_id => params[:daily_todo_id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] = l(:'daily_todos.entry.create_error')
      redirect_to(
        :controller => 'daily_todos',
        :action     => 'one_user',
        :user_id    => User.current.id)   
    end
  end
    
  def create
    if request.post?
      pdr = params[:daily_todo_entry]
      @entry = DailyTodoEntry.new(pdr)
      if @entry.daily_todo.user_id != User.current.id
        flash[:error] = l(:'daily_todos.entry.create_error')
        redirect_to(
          :controller => 'daily_todos',
          :action     => 'one_user',
          :user_id    => User.current.id)   
      end

      if @entry.save
        if params['commit'] == l(:'daily_todos.button_save')
          flash[:notice] = l(:'daily_todos.entry.entry_create')
          redirect_to(
            :controller => 'daily_todos',
            :action     => 'one_user',
            :user_id    => User.current.id,
            :date       => @entry.daily_todo.date)
        else
          redirect_to(:action => 'new', :daily_todo_id => @entry.daily_todo_id)
        end
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @entry = DailyTodoEntry.find(params[:id])
    if @entry.daily_todo.user_id != User.current.id
      flash[:error] =  l(:'daily_todos.entry.edit_error')
      redirect_to(
        :controller => 'daily_todos',
        :action     => 'one_user',
        :user_id    => User.current.id) 
    end  
  end
    
  def update
    if request.put?
      @entry = DailyTodoEntry.find(params[:id])
      if @entry.daily_todo.user_id != User.current.id
        flash[:error] = l(:'daily_todos.entry.edit_error')
        redirect_to(
          :controller => 'daily_todos',
          :action     => 'one_user',
          :user_id    => User.current.id)
        return
      end

      @entry.update_attributes(params[:daily_todo_entry])
      if @entry.save
        flash[:notice] = l(:'daily_todos.entry.entry_update')
        redirect_to(
          :controller => 'daily_todos',
          :action     => 'one_user',
          :user_id    => User.current.id,
          :date       => @entry.daily_todo.date)
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    if request.delete?
      entry = DailyTodoEntry.find(params[:id])
      if entry.daily_todo.user_id != User.current.id
        flash[:error] = l(:'daily_todos.entry.delete_error')
      else
        flash[:notice] = l(:'daily_todos.entry.delete')
        entry.destroy
      end
      render :js => "window.location = '" + url_for(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id) + "'"
    end
  end
end
