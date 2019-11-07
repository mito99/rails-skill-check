module TestHelper

  def light_plan(num_of_users=0, num_of_boxs=0)
    Payments::Plan.new(
      ::Plan.find(1).attributes.merge({
        "num_of_users"      => num_of_users,
        "num_of_boxs"       => num_of_boxs
      })
    )
  end
end