module Payments
  class Plans
    include Enumerable

    delegate :each, to: :@plan_list
    delegate :size, to: :@plan_list
    delegate :[],   to: :@plan_list
    
    def initialize(plan_list)
      @plan_list = plan_list
    end
    
    def self.all
      plan_list = ::Plan.all.map do |v|
        Payments::Plan.new(v.attributes)
      end
      Plans.new(plan_list) 
    end
    
    def self.selectable(num_of_users, num_of_boxs)
      plan_list = ::Plan.all.map do |v|
        Payments::Plan.new(
          v.attributes.merge({
            "num_of_users"=> num_of_users, 
            "num_of_boxs" => num_of_boxs})
        )
      end.filter{|v|v.selectable?}
      Plans.new(plan_list)
    end

    def sort_by_monthly_fee
      plan_list = @plan_list.
        sort{|v1, v2|v1.monthly_fee_total<=>v2.monthly_fee_total}
      Plans.new plan_list 
    end

    def max_counts
      @plan_list.each_with_object({user:0, box:0}) do |p,h|
        h[:user] = [h[:user], p.user_cnt_max].max
        h[:box]  = [h[:box],  p.box_cnt_max].max
      end
    end
  end
end