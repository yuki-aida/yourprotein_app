module SessionsHelper
  
  # 渡されたユーザーでログインする
  # sessionメソッドを実行するとユーザーのブラウザ内に一時cookiesが作成される
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # (ユーザーIDにユーザーIDのセッションを代入した結果) ユーザーIDのセッションが存在すれば
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        # セッションメソッドの実行
        log_in user
        @current_user = user
      end
    end
  end
  
  # ユーザーがログインしていればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
end
