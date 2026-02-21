require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it '正常に入力しバリデーションエラーが起きないこと' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'emailがない場合にバリデーションエラーが発生すること' do
      user_without_email = build(:user, email: "")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to eq [ "を入力してください" ]
    end

    it 'emailが不正な値の場合にバリデーションエラーが発生すること' do
      user_error_email = build(:user, email: "abcde")
      expect(user_error_email).to be_invalid
      expect(user_error_email.errors[:email]).to eq [ "は不正な値です" ]
    end

    it 'emailが存在している場合にバリデーションエラーが発生すること' do
      user1 = create(:user)
      user2 = build(:user)
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to eq [ "はすでに存在します" ]
    end

    it 'passwordがない場合にバリデーションエラーが発生すること' do
      user = build(:user, password: "")
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq [ "を入力してください" ]
    end

    it 'passwordが6文字未満の場合にバリデーションエラーが発生すること' do
      user = build(:user, password: "1234")
      expect(user).to be_invalid
      expect(user.errors[:password]).to eq [ "は6文字以上で入力してください" ]
    end

    it 'passwordとpassword_confirmationが一致していない場合にバリデーションエラーが発生すること' do
      user = build(:user, password: "123456", password_confirmation: "654321")
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to eq [ "とパスワードの入力が一致しません" ]
    end
  end
end
