class TasksController < ApplicationController
  before_filter :prepare, :only => [ :index, :done ]

  def index
    # if params[:category_id]
    #   @category = Category.find(params[:category_id])
    #   @tasks = @category.tasks
    # else
    #   @tasks = Task
    # end
    @tasks = @tasks.undone.paginate(:page => params[:page], :per_page => 10)
  end

  def done
    # if params[:category_id]
    #   @category = Category.find(params[:category_id])
    #   @tasks = @category.tasks
    # else
    #   @tasks = Task
    # end
    @tasks = @tasks.done.paginate(:page => params[:page], :per_page => 10)
    render :index  # index.html.erb が呼ばれる
  end

  def search
    # @tasks = Task.undone
    @tasks = current_user.tasks.undone
    @tasks = @tasks.search(params[:query]) if params[:query].present?
    @tasks = @tasks.paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  def show
    # begin
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
    # rescue ActiveRecord::RecordNotFound
    #   render "errors/not_found", :status => 404
    # end
  end

  def new
    @task = Task.new
  end

  def edit
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
  end

  def create
    # @task = Task.create(params[:task])
    # redirect_to @task
    @task = Task.new(params[:task])
    @task.owner = current_user
    if @task.save
      redirect_to @task
    else
      # validation failed
      render :new
    end
  end

  def update
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
    if @task.update_attributes(params[:task])
      redirect_to @task
    else
      # validation failed
      render :edit
    end
  end

  def destroy
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to :tasks
  end

  def finish
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
    @task.update_attribute(:done, true)
    redirect_to :back
  end

  def restart
    # @task = Task.find(params[:id])
    @task = current_user.tasks.find(params[:id])
    @task.update_attribute(:done, false)
    redirect_to :back
  end

  private

  def prepare
    if params[:category_id]
      # @category = Category.find(params[:category_id])
      @category = current_user.categories.find(params[:category_id])
      @tasks = @category.tasks
    else
      # @tasks = Task
      @tasks = current_user.tasks
    end
  end

end
