class DailyTodoCommentsController < ApplicationController
  unloadable
  
  def new
    if User.current
      @comment = DailyTodoComment.new(:daily_todo_id => params[:daily_todo_id])
    else
      flash[:notice] = l(:'daily_todos.login_notice')
      redirect_to(signin_path)
    end
  end
  
  def create
    if request.post?
      if User.current
        @comment = DailyTodoComment.new(params[:daily_todo_comment])
        @comment.user_id = User.current.id
        if @comment.save
          flash[:notice] = l(:'daily_todos.comment.comment_create')
          redirect_to(
            :controller => 'daily_todos',
            :action     => 'one_user',
            :user_id    => @comment.daily_todo.user_id)
        else
          render :action => 'new'
        end
      else
        flash[:notice] = l(:'daily_todos.login_notice')
        redirect_to(signin_path)
      end 
    end   
  end
  
  def edit
    @comment = DailyTodoComment.find(params[:id])
    if @comment.user_id != User.current.id
      flash[:error] = l(:'daily_todos.comment.edit_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
  
  def update
    if request.put?
      @comment = DailyTodoComment.find(params[:id])
      if @comment.user_id != User.current.id
        flash[:error] = l(:'daily_todos.comment.edit_error')
        redirect_to(:action => 'one_user', :user_id => User.current.id)   
      else
        phr = params[:daily_todo_comment]  
        @comment.body = phr[:body]
        if @comment.save
           flash[:notice] = l(:'daily_todos.comment.comment_update')
          redirect_to(
            :controller => 'daily_todos',
            :action     => 'one_user',
            :user_id    => @comment.daily_todo.user_id)
        else
          render :action => 'new'
        end
      end
    end
  end
  
  def destroy
    if request.delete?
      comment = DailyTodoComment.find(params[:id])
      if comment.user_id != User.current.id
        flash[:error] = l(:'daily_todos.comment.delete_error')
      else
        flash[:notice] = l(:'daily_todos.comment.delete')
        comment.destroy
      end
      render :js => "window.location = '" + url_for(:controller => 'daily_todos', :action => 'one_user', :user_id => comment.daily_todo.user_id) + "'"
    end
  end
end
