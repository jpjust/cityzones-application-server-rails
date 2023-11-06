class PasswordRecoveryController < ApplicationController

  def new
    @password_recovery = PasswordRecovery.new
  end

  def create
    user = User.find_by(email: password_recovery_params[:email].try(:downcase))

    if user.present?
      recovery = PasswordRecovery.create({
        user_id: user.id,
        token: SecureRandom.hex(32),
        expires_at: Time.now + 15.minutes
      })
      PasswordRecoveryMailer.with({ :user => user, :recovery => recovery }).recovery_mail.deliver_later
    end

    flash[:message] = 'A recovery link was sent to the registered e-mail.'
    redirect_to session_index_url
  end

  def edit
    @recovery = PasswordRecovery.find_by(token: params[:id])

    if @recovery.nil? || Time.now > @recovery.expires_at
      flash[:notice] = 'Recovery link is invalid or expired.'
      redirect_to session_index_url
      return
    end
  end

  def update
    @recovery = PasswordRecovery.find_by(token: params[:id])

    if @recovery.nil? || Time.now > @recovery.expires_at
      flash[:notice] = 'Recovery link is invalid or expired.'
      redirect_to session_index_url
      return
    end

    @recovery.user.password = password_recovery_params[:password]
    @recovery.user.password_confirmation = password_recovery_params[:password_confirmation]
    
    if @recovery.user.save
      @recovery.destroy
      flash[:message] = 'Password changed.'
      redirect_to session_index_url
    else
      flash[:notice] = 'Passwords do not match.'
      render :edit, :status => :unprocessable_entity
    end
  end

  private

  def password_recovery_params
    params.require(:password_recovery).permit(:email, :password, :password_confirmation)
  end

end
