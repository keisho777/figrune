require 'rails_helper'

RSpec.describe "Figures", type: :system do
  let!(:user) { create(:user) }
  let(:figure) { create(:figure, user: user) }
  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'フィギュアの登録ページにアクセス' do
        it '登録ページへのアクセスが失敗する' do
          visit new_figure_path
          expect(page).to have_content('ログインもしくはアカウント登録してください。')
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'フィギュアの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_figure_path(figure)
          expect(page).to have_content('ログインもしくはアカウント登録してください。')
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'フィギュアの詳細ページにアクセス' do
        it '詳細ページへのアクセスが失敗する' do
          visit figure_path(figure)
          expect(page).to have_content('ログインもしくはアカウント登録してください。')
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'フィギュアの一覧ページにアクセス' do
        it '一覧ページへのアクセスが失敗する' do
          visit figures_path
          expect(page).to have_content('ログインもしくはアカウント登録してください。')
          expect(current_path).to eq new_user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user, scope: :user)
      visit home_path
    end

    describe 'フィギュア登録' do
      context '入力値が正常' do
        context '必須項目のみ入力' do
          it 'フィギュアの登録が成功する' do
            visit new_figure_path
            fill_in '商品名', with: 'figure_name'
            # JSで直接 value をセット
            page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
            fill_in '個数', with: '1'
            fill_in '金額（1個あたり）', with: '1000'
            select '未払い', from: '支払いステータス'
            click_button '登録する'
            expect(page).to have_content 'figure_name'
            expect(page).to have_content '2026年02月'
            expect(page).to have_content '1,000'
            expect(page).to have_content '登録しました'
            expect(current_path).to eq figures_path
          end
        end

        context '全項目入力' do
          it 'フィギュアの登録が成功する' do
            visit new_figure_path
            fill_in '商品名', with: 'figure_name'
            # JSで直接 value をセット
            page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
            fill_in '個数', with: '1'
            fill_in '金額（1個あたり）', with: '1000'
            select '未払い', from: '支払いステータス'
            find('summary', text: '詳細情報を入力（任意）').click
            select '全高', from: 'サイズ種別'
            fill_in 'サイズ（mm）', with: '200'
            fill_in '作品名', with: 'work_name'
            fill_in '予約/購入店舗', with: 'shop_name'
            fill_in 'メーカー', with: 'manufacturer_name'
            fill_in '備考', with: 'note'
            click_button '登録する'
            expect(page).to have_content 'figure_name'
            expect(page).to have_content '2026年02月'
            expect(page).to have_content '1,000'
            expect(page).to have_content '登録しました'
            expect(current_path).to eq figures_path
          end
        end
      end

      context '商品名が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: ''
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content '商品名を入力してください'
          expect(current_path).to eq new_figure_path
        end
      end

      context '発売月が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = ''")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content '発売月を入力してください'
          expect(current_path).to eq new_figure_path
        end
      end

      context '個数が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: ''
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content '個数を入力してください'
          expect(page).to have_content '個数は数値で入力してください'
          expect(current_path).to eq new_figure_path
        end
      end

      context '金額が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: ''
          select '未払い', from: '支払いステータス'
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content '金額（1個あたり）を入力してください'
          expect(page).to have_content '金額（1個あたり）は数値で入力してください'
          expect(current_path).to eq new_figure_path
        end
      end

      context 'サイズ種別が入力済み、サイズ（mm）が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          find('summary', text: '詳細情報を入力（任意）').click
          select '全高', from: 'サイズ種別'
          fill_in 'サイズ（mm）', with: ''
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content 'サイズ（mm）を入力してください'
          expect(current_path).to eq new_figure_path
        end
      end

      context 'サイズ（mm）が入力済み、サイズ種別が未入力' do
        it 'フィギュアの登録が失敗する' do
          visit new_figure_path
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          find('summary', text: '詳細情報を入力（任意）').click
          select '選択してください', from: 'サイズ種別'
          fill_in 'サイズ（mm）', with: '200'
          click_button '登録する'
          expect(page).to have_content '登録できませんでした'
          expect(page).to have_content 'サイズ種別を入力してください'
          expect(current_path).to eq new_figure_path
        end
      end
    end

    describe 'フィギュア詳細' do
      let!(:figure) { create(:figure, user: user) }
      before { visit figures_path }

      it 'フィギュアの詳細が表示される' do
        click_link figure.name
        expect(page).to have_content 'TEST'
        expect(page).to have_content '未払い'
        expect(page).to have_content '2026年02月'
        expect(page).to have_content '1'
        expect(page).to have_content '¥1,000'
        expect(page).to have_content '¥1,000'
        expect(current_path).to eq figure_path(figure)
      end
    end

    describe 'フィギュア編集' do
      let!(:figure) { create(:figure, user: user) }
      before { visit edit_figure_path(figure) }

      context '入力値が正常' do
        it 'フィギュアの編集が成功する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2027-02'")
          fill_in '個数', with: '2'
          fill_in '金額（1個あたり）', with: '2000'
          select '支払い済み', from: '支払いステータス'
          click_button '更新する'
          expect(page).to have_content 'figure_name'
          expect(page).to have_content '支払い済み'
          expect(page).to have_content '2027年02月'
          expect(page).to have_content '2'
          expect(page).to have_content '¥2,000'
          expect(page).to have_content '¥4,000'
          expect(page).to have_content '更新しました'
          expect(current_path).to eq figure_path(figure)
        end
      end

      context '商品名が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: ''
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content '商品名を入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end

      context '発売月が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = ''")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content '発売月を入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end

      context '個数が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: ''
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content '個数を入力してください'
          expect(page).to have_content '個数は数値で入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end

      context '金額が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: ''
          select '未払い', from: '支払いステータス'
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content '金額（1個あたり）を入力してください'
          expect(page).to have_content '金額（1個あたり）は数値で入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end

      context 'サイズ種別が入力済み、サイズ（mm）が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          find('summary', text: '詳細情報を入力（任意）').click
          select '全高', from: 'サイズ種別'
          fill_in 'サイズ（mm）', with: ''
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content 'サイズ（mm）を入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end

      context 'サイズ（mm）が入力済み、サイズ種別が未入力' do
        it 'フィギュアの編集が失敗する' do
          fill_in '商品名', with: 'figure_name'
          # JSで直接 value をセット
          page.execute_script("document.getElementById('figure_release_month').value = '2026-02'")
          fill_in '個数', with: '1'
          fill_in '金額（1個あたり）', with: '1000'
          select '未払い', from: '支払いステータス'
          find('summary', text: '詳細情報を入力（任意）').click
          select '選択してください', from: 'サイズ種別'
          fill_in 'サイズ（mm）', with: '200'
          click_button '更新する'
          expect(page).to have_content '更新できませんでした'
          expect(page).to have_content 'サイズ種別を入力してください'
          expect(current_path).to eq edit_figure_path(figure)
        end
      end
    end

    describe 'フィギュア削除' do
      let!(:figure) { create(:figure, user: user) }
      before { visit edit_figure_path(figure) }

      it 'タスクの削除が成功する' do
        click_link '削除する'
        expect(page.accept_confirm).to eq '本当に削除してよろしいですか？'
        expect(page).to have_content '削除しました'
        expect(current_path).to eq figures_path
        expect(page).not_to have_content figure.name
      end
    end

    describe 'フィギュア一覧' do
      context 'フィギュアを1件も登録していない' do
        before { visit figures_path }
        it '表示できるデータがない旨のメッセージが表示される' do
          expect(page).to have_content '表示できるデータはありません。'
          expect(page).not_to have_content '並び替え'
        end
      end
      context '検索' do
        let!(:figure) { create(:figure, user: user) }
        let!(:figure1) { create(:figure, user: user, name: 'abcd', release_month: '2027-02', quantity: 2, price: 2000) }
        let!(:figure2) { create(:figure, user: user, name: '1234', release_month: '2028-02', quantity: 3, price: 3000) }
        before { visit figures_path }

        it '商品名で検索ができる' do
          page.save_screenshot('final_check.png')
          fill_in 'q_name_cont', with: 'a'
          click_button '検索'
          expect(page).to have_content 'abcd'
          expect(page).not_to have_content '1234'
        end
      end

      context '並び替え' do
        let!(:figure) { create(:figure, user: user) }
        let!(:figure1) { create(:figure, user: user, name: 'abcd', release_month: '2027-02', quantity: 2, price: 2000) }
        let!(:figure2) { create(:figure, user: user, name: '1234', release_month: '2028-02', quantity: 3, price: 3000) }
        before { visit figures_path }

        it '登録日（新しい順）' do
          select '登録日（新しい順）', from: 'q_s'
          expect(page.text).to match %r{#{figure2.name}.*#{figure1.name}.*#{figure.name}}
        end

        it '登録日（古い順）' do
          select '登録日（古い順）', from: 'q_s'
          expect(page.text).to match %r{#{figure.name}.*#{figure1.name}.*#{figure2.name}}
        end

        it '発売月（早い順）' do
          select '発売月（早い順）', from: 'q_s'
          expect(page.text).to match %r{#{figure.name}.*#{figure1.name}.*#{figure2.name}}
        end

        it '発売月（遅い順）' do
          select '発売月（遅い順）', from: 'q_s'
          expect(page.text).to match %r{#{figure2.name}.*#{figure1.name}.*#{figure.name}}
        end

        it '合計金額（安い順）' do
          select '合計金額（安い順）', from: 'q_s'
          expect(page.text).to match %r{#{figure.name}.*#{figure1.name}.*#{figure2.name}}
        end

        it '合計金額（高い順）' do
          select '合計金額（高い順）', from: 'q_s'
          expect(page.text).to match %r{#{figure2.name}.*#{figure1.name}.*#{figure.name}}
        end
      end

      context 'ページネーション' do
        context '10件以下' do
          let!(:figures) { create_list(:figure, 10, user: user) }

          it 'ページネーションが表示されないこと' do
            visit figures_path
            expect(page).not_to have_selector('.pagination')
          end
        end

        context '11件以上' do
          let!(:figures) { create_list(:figure, 11, user: user) }

          it 'ページネーションが表示されること' do
            visit figures_path
            expect(page).to have_selector('.pagination')
          end
        end
      end
    end
  end
end
