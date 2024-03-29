class ErrorsController < ApplicationController
  skip_before_filter :authenticate_user, :reject_unverified_user

  def not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end
end
