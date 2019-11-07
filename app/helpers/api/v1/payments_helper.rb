require './app/errors/application_error'

module Api::V1::PaymentsHelper

  def request_get_plans(params)
    users, boxes = params['users'], params['boxes']
    raise ApplicationError, "invalid param(users)" unless number?(users)
    raise ApplicationError, "invalid param(boxes)"  unless number?(boxes)
    return users.to_i, boxes.to_i
  end

  def response_get_plans(plans)
    plans.sort_by_monthly_fee.
      each_with_object({}) do |p,h|
        h[p.id] = {fee:p.monthly_fee_total,rank:h.size+1}
      end
  end

  def response_error(e)
    {message: e.message}
  end

  def number?(str)
    str =~ /^[0-9]+$/
  end
end
