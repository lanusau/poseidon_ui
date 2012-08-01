class ScriptCategoriesController < ApplicationController

  set_access_level :user
  set_submenu :script_categories

  # GET /script_category
  def index
    @script_categories = ScriptCategory.all
  end

  # GET /script_category/new
  def new
    @script_category = ScriptCategory.new
  end

  # GET /script_category/1/edit
  def edit
    @script_category = ScriptCategory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to script_categories_path
  end

  # POST /script_category
  def create

    # Return to list if Cancel button is pressed
    redirect_to script_categories_path and return if params[:commit] == "Cancel"

    @script_category = ScriptCategory.new(params[:script_category])

    @script_category.create_sysdate = DateTime.now()
    @script_category.update_sysdate = DateTime.now()


    if @script_category.save
      redirect_to script_categories_path, :notice => 'Record created successfully'
    else
      render :action=>"new"
    end
  end

  # PUT /script_category/1
  def update

    # Return to list if Cancel button is pressed
    redirect_to script_categories_path and return if params[:commit] == "Cancel"

    @script_category = ScriptCategory.find(params[:id])
    @script_category.attributes = params[:script_category]
    @script_category.update_sysdate = DateTime.now()


    if @script_category.save
      redirect_to script_categories_path, :notice => 'Update successfull'
    else
      render :action=>"edit"
    end

  rescue ActiveRecord::RecordNotFound
    redirect_to script_categories_path
  end

  # DELETE /script_category/1
  def destroy
    @script_category = ScriptCategory.find(params[:id])
    @script_category.destroy

    redirect_to script_categories_path, :notice => 'Delete successfull'

  rescue ActiveRecord::RecordNotFound
    redirect_to script_categories_path
  end

end
