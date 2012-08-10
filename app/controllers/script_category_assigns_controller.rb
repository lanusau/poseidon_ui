class ScriptCategoryAssignsController < ApplicationController

  set_access_level :user
  set_submenu :scripts

  # GET /scripts/:script_id/script_category_assigns
  def index
    @script = Script.find(params[:script_id])
    render :partial => "index"
  end

  # GET /scripts/:script_id/script_category_assigns/new
  def new
    @script = Script.find(params[:script_id])
    @script_categories = ScriptCategory.all(:order => "name")

    # Only leave records that are not assigned already
    @additional_categories = Array.new
    @script_categories.each do |cat|
      @additional_categories.push(cat) unless @script.script_category_assigns.detect {|a| a.script_category_id  == cat.script_category_id }
    end

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end
  
  # POST /scripts/:script_id/script_category_assigns
  def create
    @script_category_id = params[:script_category_id]
    @script = Script.find(params[:script_id])
    @script.script_category_assigns.create(
      :script_category_id => @script_category_id,
      :create_sysdate => DateTime.now(),
      :update_sysdate => DateTime.now()
    )
    # This will only be called via AJAX, so no need to render anything
    render :nothing => true

  end

  # DELETE /scripts/:script_id/script_category_assigns/:id
  def destroy
    @script_category_assign = ScriptCategoryAssign.find(params[:id])
    @script_category_assign.destroy
    @script = Script.find(params[:script_id])

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this controller' }
      format.js
    end
  end
  
end
