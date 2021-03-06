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
  
  # 渡されたユーザーがログイン済みであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    # (ユーザーIDにユーザーIDのセッションを代入した結果) ユーザーIDのセッションが存在すれば
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
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
  
  # 記憶したURL(もしくはデフォルト値)にリダイレクト
  def redirect_back_or(default)
    # ||演算子はtrueの時点で処理が終了する。sessionがあればリダイレクト。なければ
    # defaultのURLにリダイレクトする
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  
end
