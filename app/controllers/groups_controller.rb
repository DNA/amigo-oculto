class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :login, :authenticate, :generate_draw, :participant, :select_participant, :participant_auth, :authenticate_participant, :reveal, :reset_person_password ]
  before_action :require_authentication, only: [ :show, :generate_draw, :reset_person_password ]
  before_action :require_participant_authentication, only: [ :reveal ]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      # Automatically authenticate the creator
      session[:authenticated_group_id] = @group.id
      redirect_to group_path(@group), notice: "Group '#{@group.name}' created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def login
    # Show login form
  end

  def authenticate
    if @group.authenticate(params[:password])
      session[:authenticated_group_id] = @group.id
      redirect_to group_path(@group), notice: "Successfully authenticated!"
    else
      flash.now[:alert] = "Invalid password"
      render :login, status: :unprocessable_entity
    end
  end

  def show
    # Group is already set and authenticated by before_action
  end

  def generate_draw
    if @group.generate_draw!
      redirect_to group_path(@group), notice: "Secret Santa draw generated successfully!"
    else
      redirect_to group_path(@group), alert: @group.errors.full_messages.join(", ")
    end
  end

  def participant
    # If already authenticated, go directly to reveal
    if session[:authenticated_person_id].present?
      redirect_to reveal_group_path(@group)
      return
    end

    # Only show people without parents (children can't select themselves)
    @people = @group.people.where(parent_id: nil).order(:name)
  end

  def select_participant
    @person = @group.people.find(params[:person_id])
    session[:selected_person_id] = @person.id

    redirect_to participant_auth_group_path(@group)
  end

  def participant_auth
    @person = @group.people.find(session[:selected_person_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to participant_group_path(@group), alert: "Please select a participant"
  end

  def authenticate_participant
    @person = @group.people.find(session[:selected_person_id])

    if @person.has_password?
      # Existing user - verify password
      if @person.authenticate(params[:password])
        session[:authenticated_person_id] = @person.id
        redirect_to reveal_group_path(@group), notice: "Welcome back, #{@person.name}!"
      else
        flash.now[:alert] = "Invalid password"
        render :participant_auth, status: :unprocessable_entity
      end
    else
      # New user - set password
      if params[:password].present? && params[:password] == params[:password_confirmation]
        @person.password = params[:password]
        @person.password_confirmation = params[:password_confirmation]
        if @person.save
          session[:authenticated_person_id] = @person.id
          redirect_to reveal_group_path(@group), notice: "Password created! Welcome, #{@person.name}!"
        else
          flash.now[:alert] = "Failed to create password"
          render :participant_auth, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Passwords don't match or are blank"
        render :participant_auth, status: :unprocessable_entity
      end
    end
  end

  def reveal
    @person = @group.people.find(session[:authenticated_person_id])
    @draw = @person.my_draw
    @children_draws = @person.child.includes(draws_as_giver: :receiver).map(&:my_draw).compact

    unless @draw
      redirect_to participant_group_path(@group), alert: "Draw hasn't been generated yet"
    end
  end

  def reset_person_password
    @person = @group.people.find(params[:person_id])

    @person.password_digest = nil
    if @person.save(validate: false)
      redirect_to group_path(@group), notice: "Password reset for #{@person.name}. They can create a new one on their next login."
    else
      redirect_to group_path(@group), alert: "Failed to reset password for #{@person.name}"
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def require_authentication
    unless session[:authenticated_group_id] == @group.id
      redirect_to login_group_path(@group)
    end
  end

  def require_participant_authentication
    unless session[:authenticated_person_id].present?
      redirect_to participant_group_path(@group), alert: "Please authenticate first"
    end
  end

  def group_params
    params.require(:group).permit(:name, :password, :password_confirmation)
  end
end
