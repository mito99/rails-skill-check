require './app/domains/payments/plans'
require './app/errors/application_error'

class Api::V1::PaymentsController < ApplicationController

  rescue_from ApplicationError, with: :resque_api_app_error

  def get_plans
    num_of_users,num_of_boxes = view_context.request_get_plans(params)
    plans = Payments::Plans.selectable(num_of_users, num_of_boxes)
    render json: view_context.response_get_plans(plans)
  end

  private
  def resque_api_app_error(e)
    render json: view_context.response_error(e)
  end
end