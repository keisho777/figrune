import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr"; // カレンダーを表示するJSライブラリ
import "flatpickr/dist/flatpickr.min.css";
import { Japanese } from "flatpickr/dist/l10n/ja.js";
import monthSelectPlugin from "flatpickr/dist/plugins/monthSelect"; // 年月だけが選択できるようになるflatpickrプラグイン
import "flatpickr/dist/plugins/monthSelect/style.css";

export default class extends Controller {
  connect() {
    this.picker = flatpickr(this.element, {
      disableMobile: true,
      plugins: [
        new monthSelectPlugin({
          shorthand: true,
          dateFormat: "Y-m-01",
          altFormat: "Y年m月",
        }),
      ],
      altInput: true,
      locale: Japanese,
    });
  }
}