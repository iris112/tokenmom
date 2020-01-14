require 'digest/md5'
require 'digest/sha1'
class UserSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:user_login]
  def user_login
    if params[:login_type] == 'META_MASK'
      wallet_address = params[:wallet_address]
      nick_name = params[:nick_name]
      refer_id = params[:refer_id]
      @user = User.find_by wallet_address: wallet_address
      if @user
        @user.nick_name = nick_name
      else

        referral_id = mk_referral_id(wallet_address)
        @user = User.new(params.permit(:wallet_address, :nick_name))
        if refer_id != nil && refer_id != ""
          @user.recommended_id = refer_id
        end
        @user.referral_id = referral_id
      end
      @user.save
      set_current_user(@user)
    elsif params[:login_type] == 'LEDGER'

    elsif params[:login_type] == 'TOKENMOM'
      wallet_address = params[:wallet_address]
      nick_name = params[:nick_name]
      refer_id = params[:refer_id]
      @user = User.find_by wallet_address: wallet_address
      if @user
        @user.nick_name = nick_name
      else
        referral_id = mk_referral_id(wallet_address)
        @user = User.new(params.permit(:wallet_address, :nick_name))
        if refer_id != nil && refer_id != ""
          @user.recommended_id = refer_id
        end
        @user.referral_id = referral_id
      end
      @user.save
      set_current_user(@user)
    elsif params[:login_type] == 'PRIVATE_KEY'
      wallet_address = params[:wallet_address]
      nick_name = params[:nick_name]
      refer_id = params[:refer_id]
      @user = User.find_by wallet_address: wallet_address
      if @user
        @user.nick_name = nick_name
      else
        referral_id = mk_referral_id(wallet_address)
        @user = User.new(params.permit(:wallet_address, :nick_name))
        if refer_id != nil && refer_id != ""
          @user.recommended_id = refer_id
        end
        @user.referral_id = referral_id
      end
      @user.save
      set_current_user(@user)
    elsif params[:login_type] == 'JSON'
      wallet_address = params[:wallet_address]
      nick_name = params[:nick_name]
      refer_id = params[:refer_id]
      @user = User.find_by wallet_address: wallet_address
      if @user
        @user.nick_name = nick_name
      else
        referral_id = mk_referral_id(wallet_address)
        @user = User.new(params.permit(:wallet_address, :nick_name))
        if refer_id != nil && refer_id != ""
          @user.recommended_id = refer_id
        end
        @user.referral_id = referral_id
      end
      @user.save
      set_current_user(@user)
    end
    render :json => @user
  end

  def get_user
    @user = User.find_by wallet_address: params[:wallet_address]
    render :json => @user
  end

  def user_logout
    set_current_user(nil)
  end

  def mk_referral_id(address)
    md5 = Digest::MD5.new.hexdigest address
    md5_str = md5.to_s
    referral_id = md5_str.to_s[0,5].to_s +  + md5_str.to_s[-4..-1].to_s
    # return sha2
    return referral_id
  end


end
