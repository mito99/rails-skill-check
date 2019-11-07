module Api::V1

  class PaymentsHelperTest < ActiveSupport::TestCase
    include PaymentsHelper
    
    test 'エラーレスポンスの組み立てを確認する' do
      # メッセージが与えられた場合・・・
      res1 = response_error(ApplicationError.new("aiueo"))
      assert_equal({message:'aiueo'}, res1)

      # メッセージが与えられなかった場合は・・・
      res2 = response_error(ApplicationError.new)
      assert_equal({message:''}, res2)
    end

    test 'プラン取得_リクエスト組立て_ユーザ数の誤りを検出できるか？' do
      # ユーザ数に文字を指定してみる
      e1 = assert_raises ApplicationError do
        request_get_plans({'users'=>'a', 'boxs'=>'1'})
      end
      assert_equal 'invalid param(users)', e1.message

      # ユーザ数に負数を指定してみる
      e2 = assert_raises ApplicationError do
        request_get_plans({'users'=>'-1', 'boxs'=>'1'})
      end
      assert_equal 'invalid param(users)', e2.message

      # ユーザ数0は、誤りではない！
      r1 = request_get_plans({'users'=>'0', 'boxs'=>'1'})
      assert_equal [0, 1], r1

      # ユーザ数1000は、誤りではない！
      r2 = request_get_plans({'users'=>'1000', 'boxs'=>'1'})
      assert_equal [1000, 1], r2
    end

    test 'プラン取得_リクエスト組立て_ボックス数の誤りを検出できるか？' do
      # ボックス数に文字を指定してみる
      e1 = assert_raises ApplicationError do
        request_get_plans({'users'=>'1', 'boxs'=>'a'})
      end
      assert_equal 'invalid param(boxs)', e1.message

      # ボックス数に負数を指定してみる
      e2 = assert_raises ApplicationError do
        request_get_plans({'users'=>'1', 'boxs'=>'-1'})
      end
      assert_equal 'invalid param(boxs)', e2.message

      # ボックス数0は、誤りではない！
      r1 = request_get_plans({'users'=>'1', 'boxs'=>'0'})
      assert_equal [1, 0], r1

      # ボックス数1000は、誤りではない！
      r2 = request_get_plans({'users'=>'1', 'boxs'=>'1000'})
      assert_equal [1, 1000], r2
    end
 
    test 'プラン取得_レスポンス組立て_金額順にソートされているはず' do
      Plan = Struct.new(:label, :calc_monthly_fee)

      # 組み合わせ１
      plans1 = [
        Plan.new('A', 200),
        Plan.new('B', 300),
        Plan.new('C', 100)
      ]
      r1 = response_get_plans(plans1)
      assert_equal 'C', r1[0][:label]
      assert_equal 'A', r1[1][:label]
      assert_equal 'B', r1[2][:label]

      # 組み合わせ2
      plans2 = [
        Plan.new('A', 300),
        Plan.new('B', 200),
        Plan.new('C', 100)
      ]
      r2 = response_get_plans(plans2)
      assert_equal 'C', r2[0][:label]
      assert_equal 'B', r2[1][:label]
      assert_equal 'A', r2[2][:label]
    end
  end
end