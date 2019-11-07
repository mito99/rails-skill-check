# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Plan.create(
  name:               'ライトプラン',
  user_cnt_default:   3,
  user_cnt_max:       7,
  box_cnt_default:    2,
  box_cnt_max:        5,
  monthly_fee:        12_800,
  surcharge_user_fee: 2_000,
  surcharge_box_fee:  1_500,
)

Plan.create(
  name:               'スタンダードプラン',
  user_cnt_default:   10,
  user_cnt_max:       1000,
  box_cnt_default:    11,
  box_cnt_max:        1000,
  monthly_fee:        29_800,
  surcharge_user_fee: 1_280,
  surcharge_box_fee:  1_000,
)

Plan.create(
  name:               'プレミアムプラン',
  user_cnt_default:   50,
  user_cnt_max:       1500,
  box_cnt_default:    51,
  box_cnt_max:        1500,
  monthly_fee:        76_800,
  surcharge_user_fee: 980,
  surcharge_box_fee:  500,
)