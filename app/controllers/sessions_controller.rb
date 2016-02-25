class SessionsController < ApplicationController
  def new
    @log_in_form = LogInForm.new
  end

  def create
    log_in_params = params.require(:session)
                          .permit(:email, :password)

    @log_in_form = LogInForm.new(log_in_params)

    if @log_in_form.invalid?
      render(:new, status: :unprocessable_entity) && return
    end

    user = User.find_by(email: params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render :new, status: :not_found
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
