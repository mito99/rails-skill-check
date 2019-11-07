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
        request_get_plans({'users'=>'a', 'boxes'=>'1'})
      end
      assert_equal 'invalid param(users)', e1.message

      # ユーザ数に負数を指定してみる
      e2 = assert_raises ApplicationError do
        request_get_plans({'users'=>'-1', 'boxes'=>'1'})
      end
      assert_equal 'invalid param(users)', e2.message

      # ユーザ数0を入力してみる
      e3 = assert_raises ApplicationError do
        request_get_plans({'users'=>'0', 'boxes'=>'1'})
      end
      assert_equal 'invalid param(users)', e3.message

      # ユーザ数1000は、誤りではない！
      r1 = request_get_plans({'users'=>'1000', 'boxes'=>'1'})
      assert_equal [1000, 1], r1
    end

    test 'プラン取得_リクエスト組立て_ボックス数の誤りを検出できるか？' do
      # ボックス数に文字を指定してみる
      e1 = assert_raises ApplicationError do
        request_get_plans({'users'=>'1', 'boxes'=>'a'})
      end
      assert_equal 'invalid param(boxes)', e1.message

      # ボックス数に負数を指定してみる
      e2 = assert_raises ApplicationError do
        request_get_plans({'users'=>'1', 'boxes'=>'-1'})
      end
      assert_equal 'invalid param(boxes)', e2.message

      # ボックス数に0を指定してみる
      e3 = assert_raises ApplicationError do
        request_get_plans({'users'=>'1', 'boxes'=>'0'})
      end
      assert_equal 'invalid param(boxes)', e3.message

      # ボックス数1000は、誤りではない！
      r1 = request_get_plans({'users'=>'1', 'boxes'=>'1000'})
      assert_equal [1, 1000], r1
    end
 
    test 'プラン取得_レスポンス組立て_金額順にソートされているはず' do
      Plan = Struct.new(:id, :monthly_fee_total)

      # 組み合わせ１
      plans1 = ::Payments::Plans.new([
        Plan.new(1, 200),
        Plan.new(2, 300),
        Plan.new(3, 100)
      ])
      r1 = response_get_plans(plans1)
      assert_equal "{:fee=>200, :rank=>2}", r1[1].to_s
      assert_equal "{:fee=>300, :rank=>3}", r1[2].to_s
      assert_equal "{:fee=>100, :rank=>1}", r1[3].to_s

      # 組み合わせ2
      plans2 = ::Payments::Plans.new([
        Plan.new(1, 300),
        Plan.new(2, 200),
        Plan.new(3, 100)
      ])
      r2 = response_get_plans(plans2)
      assert_equal "{:fee=>300, :rank=>3}", r2[1].to_s
      assert_equal "{:fee=>200, :rank=>2}", r2[2].to_s
      assert_equal "{:fee=>100, :rank=>1}", r2[3].to_s
    end
  end
end