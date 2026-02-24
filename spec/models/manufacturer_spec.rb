require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  let(:manufacturer) { build(:manufacturer) }
  describe 'バリデーションチェック' do
    it 'メーカーが100文字以下の場合、バリデーションエラーが起きないこと' do
      manufacturer.name = 'a' * 100
      expect(manufacturer).to be_valid
    end

    it 'メーカーが101文字以上の場合、バリデーションエラーが発生すること' do
      manufacturer.name = 'a' * 101
      expect(manufacturer).to be_invalid
      expect(manufacturer.errors[:name]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end
