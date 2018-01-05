class Api::SessionsController < Devise::SessionsController

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create]

  respond_to :json

  def new
    super
  end

  def create
    # resource = User.find_for_database_authentication(email: params[:email])
    u_hash = { user: {} }
    u_hash[:user][:email] = params[:email]
    u_hash[:user][:password] = params[:password]
    # This is very very BAD hack. instead this pass data in {user => {email: .., password: ..}} format.
    # this is just for testing.
    request.params.merge! u_hash
    resource =  warden.authenticate!(scope: :user)
    sign_in(:user, resource)

    token = JsonWebToken.new.encode_user(resource)

    render json: {success: true, token:token, email: resource.email}
    # resource = User.find_for_database_authentication(email: params[:email])
    # token = JsonWebToken.new.encode_user(resource)
    # return invalid_login_attempt unless resource
    #
    # if resource.valid_password?(params[:password])
    #   sign_in(:user, resource)
    #   render :json=> {:success=>true, token:token, :email=>resource.email}
    # end
  end

  def destroy
    sign_out(resource_name)
  end

  protected

  def ensure_params_exist
    return unless params[:email].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end
