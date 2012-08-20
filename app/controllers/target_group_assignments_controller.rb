class TargetGroupAssignmentsController < ApplicationController

  set_access_level :user
  set_submenu :targets

  # GET    /targets/:target_id/target_group_assignments
  # GET    /target_groups/:target_group_id/target_group_assignments
  def index
    # This can get called 2 ways - from /targets or from /target_groups
    # If it came from /target_groups then call another method
    return index_for_group if params[:target_group_id].present?
    @target = Target.find(params[:target_id])
    @target_groups = TargetGroup.all
  end

  # GET    /target_groups/:target_group_id/target_group_assignments
  def index_for_group
    TargetGroupAssignmentsController.set_submenu :target_groups
    
    @target_group = TargetGroup.find(params[:target_group_id])
    @available_targets = find_available_targets(@target_group)

    render :action => "index_for_group"
  end

  #  GET    /targets/:target_id/target_group_assignments/toggle
  def toggle
    @target = Target.find(params[:target_id])
    @target_group = TargetGroup.find(params[:target_group_id])
    if target_group_assignment = @target.target_group_assignments.detect{|a| a.target_group_id == @target_group.id}
      @target.target_group_assignments.delete(target_group_assignment)
    else
      target_group_assignment = TargetGroupAssignment.new
      target_group_assignment.target_group = @target_group
      target_group_assignment.status_code = 'A'
      target_group_assignment.create_sysdate = DateTime.now()
      target_group_assignment.update_sysdate = DateTime.now()
      @target.target_group_assignments<<target_group_assignment
    end

    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this action' }
      format.js
    end
  end

  # POST   /target_groups/:target_group_id/target_group_assignments/:id/activate
  def activate
    @target_group_assignment = TargetGroupAssignment.find(params[:id])
    @target_group_assignment.status_code = 'A'
    @target_group_assignment.save

    # Only render JS template
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this action' }
      format.js
    end
  end

  # POST   /target_groups/:target_group_id/target_group_assignments/:id/inactivate
  def inactivate
    @target_group_assignment = TargetGroupAssignment.find(params[:id])
    hours = params[:hours].to_i
    hours = 24 if hours.nil?

    @target_group_assignment.status_code = 'I'
    @target_group_assignment.inactive_until = DateTime.now().advance :hours => hours
    @target_group_assignment.save

    # Only render JS template
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this action' }
      format.js {render "activate"}
    end
  end

  # DELETE /target_groups/:target_group_id/target_group_assignments/:id
  def destroy
    @target_group_assignment = TargetGroupAssignment.find(params[:id])
    @target_group_assignment.destroy

    @target_group = TargetGroup.find(params[:target_group_id])
    @available_targets = find_available_targets(@target_group)
    
    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this action' }
      format.js
    end

  end

  # POST   /target_groups/:target_group_id/target_group_assignments?target_id=:target_id
  def create
    
    @target_group = TargetGroup.find(params[:target_group_id])
    @target = Target.find(params[:target_id])

    if target_group_assignment = @target_group.target_group_assignments.detect{|a| a.target_id == @target.id}
      @error = "Already assigned"
    else
      target_group_assignment = TargetGroupAssignment.new
      target_group_assignment.target = @target
      target_group_assignment.status_code = 'A'
      target_group_assignment.create_sysdate = DateTime.now()
      target_group_assignment.update_sysdate = DateTime.now()
      @target_group.target_group_assignments<<target_group_assignment
    end
    
    # Only JS format is supported, since this is AJAX call
    respond_to do |format|
      format.html { raise 'HTML request is not supported in this action' }
      format.js
    end

  end

private

    # Find all targets that are not assigned to particular group
    def find_available_targets(target_group)
      targets = Target.find(:all,:order => "server_id,name")
      available_targets = Array.new
      targets.each do |target|
        available_targets.push(target) unless target_group.target_group_assignments.detect {|a| a.target_id == target.target_id }
      end
      return available_targets
    end

end
