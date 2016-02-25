class SessionsController < ApplicationController
  def new
    @log_in_form = LogInForm.new
  end

  def create
    log_in_params = params.require(:session)
                          .permit(:email, :password, :remember_me)

    @log_in_form = LogInForm.new(log_in_params)

    if @log_in_form.invalid?
      render(:new, status: :unprocessable_entity) && return
    end

    user = User.find_by(email: log_in_params[:email])

    if user && user.authenticate(log_in_params[:password])
      log_in user
      (log_in_params[:remember_me] == '1') ? remember(user) : forget(user)
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render :new, status: :not_found
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
