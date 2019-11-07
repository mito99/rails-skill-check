class SimulationsController < ApplicationController

  def show
    @plans = Payments::Plans.all
    @max_counts = @plans.max_counts
  end
end
