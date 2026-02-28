require 'rails_helper'

RSpec.describe "Homes", type: :system do
  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'ホーム画面にアクセス' do
        it 'ホーム画面へのアクセスが失敗する' do
          visit home_path
          expect(page).to have_content('ログインもしくはアカウント登録してください。')
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:user) { create(:user) }
    let!(:figure) { create(:figure, user: user) }
    before do
      login_as(user, scope: :user)
      visit home_path
    end
    describe '期間指定' do
      context '入力値が正常' do
        it '指定した期間が表示される' do
          page.execute_script("document.getElementById('from').value = '2026-01'")
          page.execute_script("document.getElementById('to').value = '2026-03'")
          click_button '表示'
          expect(page).to have_link('01月', href: /selected_month=2026-01/)
          expect(page).to have_link('02月', href: /selected_month=2026-02/)
          expect(page).to have_link('03月', href: /selected_month=2026-03/)
          expect(page).not_to have_link('04月', href: /selected_month=2026-04/)
        end
      end

      context '13か月以上を入力' do
        it '指定した期間の表示に失敗する' do
          page.execute_script("document.getElementById('from').value = '2025-01'")
          page.execute_script("document.getElementById('to').value = '2026-01'")
          click_button '表示'
          expect(page).not_to have_link('01月', href: /selected_month=2026-01/)
        end
      end

      context '開始月＞終了月で入力' do
        it '指定した期間の表示に失敗する' do
          page.execute_script("document.getElementById('from').value = '2025-12'")
          page.execute_script("document.getElementById('to').value = '2025-01'")
          click_button '表示'
          expect(page).not_to have_link('01月', href: /selected_month=2025-01/)
        end
      end
    end

    describe '月ボタンクリック' do
      context 'クリックした月に登録したフィギュアが存在する' do
        it 'フィギュアが表示される' do
          page.execute_script("document.getElementById('from').value = '2026-01'")
          page.execute_script("document.getElementById('to').value = '2026-03'")
          click_button '表示'
          click_link '02月'
          expect(page).to have_content '2026年02月 発売済み'
          expect(page).to have_content 'TEST'
          expect(page).to have_content '¥1,000 × 1個 ⇒ ¥1,000'
        end
      end

      context 'クリックした月に登録したフィギュアが存在しない' do
        it '表示するデータがない旨のメッセージが表示される' do
          page.execute_script("document.getElementById('from').value = '2026-01'")
          page.execute_script("document.getElementById('to').value = '2026-03'")
          click_button '表示'
          click_link '01月'
          expect(page).to have_content '表示できるデータはありません。'
        end
      end
    end
  end
end
