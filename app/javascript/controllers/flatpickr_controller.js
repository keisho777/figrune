import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr"; // カレンダーを表示するJSライブラリ
import "flatpickr/dist/flatpickr.min.css";
import { Japanese } from "flatpickr/dist/l10n/ja.js";
import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect"; // 年月だけが選択できるようになるflatpickrプラグイン
import "flatpickr/dist/plugins/monthSelect/style.css";

export default class extends Controller {
  static targets = ["from", "to"]

  connect() {
    this.fromPicker = flatpickr(this.fromTarget, {
      disableMobile: true,
      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m",
          altFormat: "Y年m月",
        }),
      ],
      altInput: true,
      locale: Japanese,

      onChange: (selectedDates) => {
        // 選択した開始月
        const fromDate = selectedDates[0];
        // 開始月を変更する前の選択可能な終了月の最小値
        const previousMinDate = this.toPicker.config.minDate;
        // 選択した終了月
        const toDate = this.toPicker.selectedDates[0];
        const minDate = new Date(fromDate);
        const maxDate = new Date(fromDate);
        maxDate.setMonth(maxDate.getMonth() + 11);

        this.toPicker.set("maxDate", maxDate);
        this.toPicker.set("minDate", minDate);

        // 開始月を今選択されている終了月を超えて設定した、または開始月を選択されている終了月より12か月以上前に設定した場合、
        // 開始月から選択可能な最大値を終了月に設定する
        if (fromDate > toDate || toDate > maxDate) {
          this.toPicker.setDate(maxDate);
        }

        // カレンダーの選択不可のグレーアウトを即時反映させるため再生成
        this.toPicker.destroy();

        this.toPicker = flatpickr(this.toTarget, {
          disableMobile: true,
          minDate: minDate,
          maxDate: maxDate,

          plugins: [
            new monthSelectPlugin({
              shorthand: true,
              dateFormat: "Y-m",
              altFormat: "Y年m月",
            }),
          ],
          altInput: true,
          locale: Japanese
        });
        this.preventDeleteKey(this.toPicker);
      }
    });

    this.toPicker = flatpickr(this.toTarget, {
      disableMobile: true,
      minDate: this.fromTarget.value,
      maxDate: (() => {
        const maxDate = new Date(this.fromTarget.value + "-01");
        maxDate.setMonth(maxDate.getMonth() + 11);
        return maxDate;
      })(),

      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m",
          altFormat: "Y年m月",
        }),
      ],
      altInput: true,
      locale: Japanese,
    });
    this.preventDeleteKey(this.fromPicker);
    this.preventDeleteKey(this.toPicker);
  }

  // Backspace、Deleteキーを無効化
  preventDeleteKey(picker) {
    picker.altInput.addEventListener(
      "keydown",
      (e) => {
        if (e.key === "Backspace" || e.key === "Delete") {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
      },
      true
    );
  }
}