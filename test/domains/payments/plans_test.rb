require './app/domains/payments/plans'

class PlansTest < ActiveSupport::TestCase
  include Payments

  test 'プラン生成_選択可能なプランのみが返却されるはず' do
    plans1 = Plans.selectable(0, 0)
    assert_equal 3, plans1.size
    assert_equal "ライトプラン", plans1[0].name
    assert_equal "スタンダードプラン", plans1[1].name
    assert_equal "プレミアムプラン", plans1[2].name

    # ライトプランのユーザ数を超過すると、ライトプランが外れるはず
    plans2 = Plans.selectable(8, 0)
    assert_equal 2, plans2.size
    assert_equal "スタンダードプラン", plans2[0].name
    assert_equal "プレミアムプラン", plans2[1].name

    # ライトプランのボックス数を超過すると、ライトプランが外れるはず
    plans3 = Plans.selectable(0, 6)
    assert_equal 2, plans3.size
    assert_equal "スタンダードプラン", plans3[0].name
    assert_equal "プレミアムプラン", plans3[1].name

    # すべてのプランが選択不可の場合、空配列が返却されるはず
    plans4 = Plans.selectable(1501, 1501)
    assert_equal 0, plans4.size
  end

  test 'プラン取得_レスポンス組立て_金額順にソートされているはず' do
    Plan = Struct.new(:id, :monthly_fee_total)

    # 組み合わせ１
    plans1 = [
      Plan.new('A', 200),
      Plan.new('B', 300),
      Plan.new('C', 100)
    ]
    r1 = Plans.new(plans1).sort_by_monthly_fee
    p r1[0]
    assert_equal 'C', r1[0][:id]
    assert_equal 'A', r1[1][:id]
    assert_equal 'B', r1[2][:id]

    # 組み合わせ2
    plans2 = [
      Plan.new('A', 300),
      Plan.new('B', 200),
      Plan.new('C', 100)
    ]
    r2 = Plans.new(plans2).sort_by_monthly_fee
    assert_equal 'C', r2[0][:id]
    assert_equal 'B', r2[1][:id]
    assert_equal 'A', r2[2][:id]
  end
end