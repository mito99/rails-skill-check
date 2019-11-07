require 'test_helper'
require './app/domains/payments/plan'

class PlanTest < ActiveSupport::TestCase
  include TestHelper

  test 'ライトプラン_選択可能判定_選択可能な範囲でTRUEが返却されるはず' do
    # ユーザ数、ボックス数ともに0 選択可能
    plan1 = light_plan(0, 0)
    assert plan1.selectable?

    # ユーザ数、ボックス数ともに上限 選択可能
    plan2 = light_plan(7, 5)
    assert plan2.selectable?

    # ユーザ数上限超過(+1) 選択不可
    plan3 = light_plan(8, 5)
    assert_not plan3.selectable?

    # ボックス数上限超過(+1) 選択不可
    plan4 = light_plan(7, 6)
    assert_not plan4.selectable?
  end

  test 'ライタプラン_追加料金計算_ユーザ数' do
    plan1 = light_plan(0)
    assert_equal 0, plan1.send(:_calc_surcharge_user_fee)

    plan2 = light_plan(3)
    assert_equal 0, plan2.send(:_calc_surcharge_user_fee)

    plan3 = light_plan(4)
    assert_equal 2_000, plan3.send(:_calc_surcharge_user_fee)

    plan4 = light_plan(7)
    assert_equal 8_000, plan4.send(:_calc_surcharge_user_fee)
  end

  test 'ライトプラン_追加料金計算_メールボックス数' do
    plan1 = light_plan(0, 0)
    assert_equal 0, plan1.send(:_calc_surcharge_box_fee)

    plan2 = light_plan(0, 2)
    assert_equal 0, plan2.send(:_calc_surcharge_box_fee)

    plan3 = light_plan(0, 3)
    assert_equal 1_500, plan3.send(:_calc_surcharge_box_fee)

    plan4 = light_plan(0, 5)
    assert_equal 4_500, plan4.send(:_calc_surcharge_box_fee)
  end

  test 'ライトプラン_月額料金' do
    plan1 = light_plan(0, 0)
    assert_equal 12_800, plan1.monthly_fee_total

    plan2 = light_plan(3, 2)
    assert_equal 12_800, plan2.monthly_fee_total

    plan3 = light_plan(4, 3)
    assert_equal 16_300, plan3.monthly_fee_total

    plan4 = light_plan(7, 5)
    assert_equal 25_300, plan4.monthly_fee_total
  end

end