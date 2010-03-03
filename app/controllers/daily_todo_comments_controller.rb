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
    if User.current
      @comment = DailyTodoComment.new(params[:daily_todo_comment])
      @comment.user_id = User.current.id
      if @comment.save    
        redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => @comment.daily_todo.user_id)
      else
        render :action => 'new'
      end
    else
      flash[:notice] = l(:'daily_todos.login_notice')
      redirect_to(signin_path)
    end    
  end
  
  def edit
    @comment = DailyTodoComment.find(params[:id])
    if @comment.user_id != User.current.id
      flash[:error] = l(:'daily_todos.comment_edit_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    end
  end
  
  def update
    @comment = DailyTodoComment.find(params[:id])
    if @comment.user_id != User.current.id
      flash[:error] = l(:'daily_todos.comment_edit_error')
      redirect_to(:action => 'one_user', :user_id => User.current.id)   
    else
      phr = params[:daily_todo_comment]  
      @comment.body = phr[:body]
      if @comment.save
        redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => User.current.id)
      else
        render :action => 'new'
      end
    end
  end
  
  def delete
    comment = DailyTodoComment.find(params[:id])
    if comment.user_id != User.current.id
      flash[:error] = l(:'daily_todos.comment_delete_error')
    else
      flash[:notice] = l(:'daily_todos.comment_delete')
      comment.destroy
    end
    redirect_to(:controller => 'daily_todos', :action => 'one_user', :user_id => comment.daily_todo.user_id)
  end
end

