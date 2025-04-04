module Authorization
  extend ActiveSupport::Concern

  def require_admin
    unless current_user&.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
