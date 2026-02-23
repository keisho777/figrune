require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  describe 'ログイン前' do
    before { visit root_path }
    context 'ヘッダー' do
      it 'ロゴクリックでTOPページに遷移する' do
        click_link 'Figrune'
        expect(page).to have_current_path(root_path)
      end

      it '新規登録クリックで新規登録画面に遷移する' do
        click_link '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
      end

      it 'ログインクリックでログイン画面に遷移する' do
        # header要素の中にある「ログイン」をクリック
        find('header').click_link 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'フッター' do
      it '利用規約画面に遷移する' do
        click_link '利用規約'
        expect(page).to have_current_path(terms_of_service_path)
      end

      it 'プライバシーポリシー画面に遷移する' do
        click_link 'プライバシーポリシー'
        expect(page).to have_current_path(privacy_policy_path)
      end

      it 'お問い合わせ画面に遷移する' do
        click_link 'お問い合わせ'
        expect(page).to have_current_path(contact_path)
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user, scope: :user)
      visit home_path
    end
    context 'ヘッダー' do
      it 'ロゴクリックでホーム画面に遷移する' do
        click_link 'Figrune'
        expect(page).to have_current_path(home_path)
      end

      it 'アカウント設定クリックでアカウント設定画面に遷移する' do
        click_link 'アカウント設定'
        expect(page).to have_current_path(account_setting_path)
      end

      it 'ホームクリックでホーム画面に遷移する' do
        click_link 'ホーム'
        expect(page).to have_current_path(home_path)
      end

      it '登録クリックで登録画面に遷移する' do
        click_link '登録'
        expect(page).to have_current_path(new_figure_path)
      end

      it '一覧クリックで一覧画面に遷移する' do
        click_link '一覧'
        expect(page).to have_current_path(figures_path)
      end
    end

    context 'フッター' do
      it '利用規約画面に遷移する' do
        click_link '利用規約'
        expect(page).to have_current_path(terms_of_service_path)
      end

      it 'プライバシーポリシー画面に遷移する' do
        click_link 'プライバシーポリシー'
        expect(page).to have_current_path(privacy_policy_path)
      end

      it 'お問い合わせ画面に遷移する' do
        click_link 'お問い合わせ'
        expect(page).to have_current_path(contact_path)
      end
    end
  end
end
