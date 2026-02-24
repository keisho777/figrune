require 'rails_helper'

RSpec.describe Figure, type: :model do
  let(:figure) { build(:figure) }
  describe 'バリデーションチェック' do
    it '正常に入力しバリデーションエラーが起きないこと' do
      expect(figure).to be_valid
    end

    it '商品名が空白の場合、バリデーションエラーが発生すること' do
      figure.name = ''
      expect(figure).to be_invalid
      expect(figure.errors[:name]).to eq [ "を入力してください" ]
    end

    it '商品名が255文字以下の場合、バリデーションエラーが起きないこと' do
      figure.name = 'a' * 255
      expect(figure).to be_valid
    end

    it '商品名が256文字以上の場合、バリデーションエラーが発生すること' do
      figure.name = 'a' * 256
      expect(figure).to be_invalid
      expect(figure.errors[:name]).to eq [ "は255文字以内で入力してください" ]
    end

    it '発売月が空白の場合、バリデーションエラーが発生すること' do
      figure.release_month = ''
      expect(figure).to be_invalid
      expect(figure.errors[:release_month]).to eq [ "を入力してください" ]
    end

    it '個数が空白の場合、バリデーションエラーが発生すること' do
      figure.quantity = ''
      expect(figure).to be_invalid
      expect(figure.errors[:quantity]).to eq [ "を入力してください", "は数値で入力してください" ]
    end

    it '個数が数字以外の場合、バリデーションエラーが発生すること' do
      figure.quantity = 'e'
      expect(figure).to be_invalid
      expect(figure.errors[:quantity]).to eq [ "は数値で入力してください" ]
    end

    it '個数が0以下の場合、バリデーションエラーが発生すること' do
      figure.quantity = 0
      expect(figure).to be_invalid
      expect(figure.errors[:quantity]).to eq [ "は1以上の値にしてください" ]
    end

    it '金額が空白の場合、バリデーションエラーが発生すること' do
      figure.price = ''
      expect(figure).to be_invalid
      expect(figure.errors[:price]).to eq [ "を入力してください", "は数値で入力してください" ]
    end

    it '金額が数字以外の場合、バリデーションエラーが発生すること' do
      figure.price = 'e'
      expect(figure).to be_invalid
      expect(figure.errors[:price]).to eq [ "は数値で入力してください" ]
    end

    it '金額が0以下の場合、バリデーションエラーが発生すること' do
      figure.price = 0
      expect(figure).to be_invalid
      expect(figure.errors[:price]).to eq [ "は1以上の値にしてください" ]
    end

    it 'サイズ種別が空白でサイズ（mm）が正常に入力済みの場合、バリデーションエラーが発生すること' do
      figure.size_type = ''
      figure.size_mm = 200
      expect(figure).to be_invalid
      expect(figure.errors[:size_type]).to eq [ "を入力してください" ]
    end

    it 'サイズ（mm）が空白でサイズ種別が正常に入力済みの場合、バリデーションエラーが発生すること' do
      figure.size_type = :overall_height
      figure.size_mm = ''
      expect(figure).to be_invalid
      expect(figure.errors[:size_mm]).to eq [ "を入力してください" ]
    end

    it 'サイズ（mm）、サイズ種別が入力済みの場合、バリデーションエラーが起きないすること' do
      figure.size_type = :overall_height
      figure.size_mm = 200
      expect(figure).to be_valid
    end

    it '備考が65535文字以下の場合、バリデーションエラーが起きないこと' do
      figure.note = 'a' * 65535
      expect(figure).to be_valid
    end

    it '備考が65536文字以上の場合、バリデーションエラーが発生すること' do
      figure.note = 'a' * 65536
      expect(figure).to be_invalid
      expect(figure.errors[:note]).to eq [ "は65535文字以内で入力してください" ]
    end

    it '作品名が未登録の場合、Workテーブルに登録されること' do
      expect(Work.count).to eq(0)
      figure.assign_work_by_name("work")
      expect(Work.count).to eq(1)
    end

    it '作品名が登録済の場合、Workテーブルに登録されないこと' do
      expect(Work.count).to eq(0)
      figure.assign_work_by_name("work")
      expect(Work.count).to eq(1)
      figure.assign_work_by_name("work")
      expect(Work.count).to eq(1)
    end

    it '作品名が100文字以内の場合、バリデーションエラーが起きないこと' do
      figure.work_name = 'a' * 100
      expect(figure).to be_valid
    end

    it '作品名が101文字以上の場合、バリデーションエラーが発生すること' do
      figure.work_name = 'a' * 101
      expect(figure).to be_invalid
      expect(figure.errors[:work_name]).to eq [ "は100文字以内で入力してください" ]
    end

    it '予約/購入店舗が未登録の場合、Shopテーブルに登録されること' do
      expect(Shop.count).to eq(0)
      figure.assign_shop_by_name("shop")
      expect(Shop.count).to eq(1)
    end

    it '予約/購入店舗が登録済の場合、Shopテーブルに登録されないこと' do
      expect(Shop.count).to eq(0)
      figure.assign_shop_by_name("shop")
      expect(Shop.count).to eq(1)
      figure.assign_shop_by_name("shop")
      expect(Shop.count).to eq(1)
    end

    it '予約/購入店舗が100文字以内の場合、バリデーションエラーが起きないこと' do
      figure.shop_name = 'a' * 100
      expect(figure).to be_valid
    end

    it '予約/購入店舗が101文字以上の場合、バリデーションエラーが発生すること' do
      figure.shop_name = 'a' * 101
      expect(figure).to be_invalid
      expect(figure.errors[:shop_name]).to eq [ "は100文字以内で入力してください" ]
    end

    it 'メーカーが未登録の場合、Manufacturerテーブルに登録されること' do
      expect(Manufacturer.count).to eq(0)
      figure.assign_manufacturer_by_name("manufacturer")
      expect(Manufacturer.count).to eq(1)
    end

    it 'メーカーが登録済の場合、Manufacturerテーブルに登録されないこと' do
      expect(Manufacturer.count).to eq(0)
      figure.assign_manufacturer_by_name("manufacturer")
      expect(Manufacturer.count).to eq(1)
      figure.assign_manufacturer_by_name("manufacturer")
      expect(Manufacturer.count).to eq(1)
    end

    it 'メーカーが100文字以内の場合、バリデーションエラーが起きないこと' do
      figure.manufacturer_name = 'a' * 100
      expect(figure).to be_valid
    end

    it 'メーカーが101文字以上の場合、バリデーションエラーが発生すること' do
      figure.manufacturer_name = 'a' * 101
      expect(figure).to be_invalid
      expect(figure.errors[:manufacturer_name]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end
