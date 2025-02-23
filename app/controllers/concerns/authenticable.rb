module Authenticable
  def current_user
    return @current_user if defined?(@current_user)

    token = request.headers["Authorization"]
    return nil if token.blank?

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end
end
