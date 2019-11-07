module Payments

  class Plan
    attr_reader :id, :name, :user_cnt_default, :box_cnt_default,
      :monthly_fee, :surcharge_user_fee, :surcharge_box_fee,
      :user_cnt_max, :box_cnt_max

    def initialize(attributes)
      @id                   = attributes["id"]
      @name                 = attributes["name"]
      @user_cnt_default     = attributes["user_cnt_default"]
      @box_cnt_default      = attributes["box_cnt_default"]
      @monthly_fee          = attributes["monthly_fee"]
      @surcharge_user_fee   = attributes["surcharge_user_fee"]
      @surcharge_box_fee    = attributes["surcharge_box_fee"]
      @user_cnt_max         = attributes["user_cnt_max"]
      @box_cnt_max          = attributes["box_cnt_max"]
      @num_of_users         =(attributes["num_of_users"]||1)
      @num_of_boxes         =(attributes["num_of_boxes"] ||1)
    end

    def selectable?
      return false if @num_of_users > @user_cnt_max
      return false if @num_of_boxes  > @box_cnt_max
      true
    end

    def monthly_fee_total
      @monthly_fee_total ||= _calc_monthly_fee_total
      @monthly_fee_total
    end

    private
    def _calc_monthly_fee_total
      return nil unless self.selectable?
      @monthly_fee + _calc_surcharge_user_fee + _calc_surcharge_box_fee
    end

    private
    def _calc_surcharge_user_fee
      defalut_range = (0..@user_cnt_default)
      surcharge_range = (@user_cnt_default+1..@user_cnt_max)
      _calc_surcharge_fee defalut_range, surcharge_range,
        @num_of_users, @surcharge_user_fee
    end

    private
    def _calc_surcharge_box_fee
      defalut_range = (0..@box_cnt_default)
      surcharge_range = (@box_cnt_default+1..@box_cnt_max)
      _calc_surcharge_fee defalut_range, surcharge_range,
        @num_of_boxes, @surcharge_box_fee
    end

    private
    def _calc_surcharge_fee(defalut_range , surcharge_range, num, fee)
      if defalut_range.member? num
        return 0
      end

      if surcharge_range.member? num
        over =  num - defalut_range.max
        return over * fee
      end
      raise "Illegal Statement"
    end
  end
end