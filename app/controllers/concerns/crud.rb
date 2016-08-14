module Crud
  extend ActiveSupport::Concern

  included do
    helper_method :current_set
    helper_method :current_object
  end

  def index
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @current_object = klass.new
  end

  def create
    @current_object = klass.new(safe_params)

    if current_object.save
      redirect_to(
        index_path,
        notice: notice('Successfully created!')
      )
    else
      render :new, alert: 'There was an error'
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      ActiveRecord::Base.delay_touching do
        if current_object.update(safe_params)
          format.json do
            render json: {
              object: current_object.name, success: true }, status: :ok
            }
          end
          format.html {
            redirect_to(index_path, notice: notice("Successfully updated#{name}!") )
          }
        else
          format.json {
            render json: {
              error: "could not update #{current_object.name}"
            },
            status: :unprocessable_entity
          }
          format.html {
            render :edit, alert: 'There was an error'
          }
        end
      end
    end
  end

  def destroy
    if current_object.destroy
      redirect_to(
        index_path,
        notice: "Successfully deleted#{name}!"
      )
    else
      redirect_to :back, alert: current_object.errors.full_messages.join(', ')
    end
  end

  private

  def index_path
    { action: :index }
  end

  def current_set
    @current_set ||= (
      klass.all
    )
  end

  def current_object
    @current_object ||= klass.find(params[:id])
  end
end
