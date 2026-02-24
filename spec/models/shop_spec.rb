require 'rails_helper'

RSpec.describe Shop, type: :model do
  let(:shop) { build(:shop) }
  describe 'バリデーションチェック' do
    it '予約/購入店舗が100文字以下の場合、バリデーションエラーが起きないこと' do
      shop.name = 'a' * 100
      expect(shop).to be_valid
    end

    it '予約/購入店舗が101文字以上の場合、バリデーションエラーが発生すること' do
      shop.name = 'a' * 101
      expect(shop).to be_invalid
      expect(shop.errors[:name]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end
