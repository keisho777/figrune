import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
export default class extends Controller {
  static values = {
    labels: Array,
    data: Array
  }
  connect() {
    const isMobile = window.innerWidth < 768
    this.chart = new Chart(this.element, {
      // 棒グラフの指定
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: '未払いの合計',
          data: this.dataValue
        }]
      },
      options: {
        // canvasのCSSの高さに従わせる
        maintainAspectRatio: false, 
        scales: {
         x: {
            ticks: {
            font: { size: isMobile ? 8 : 12 }
            }
        },
        y: {
            ticks: {
            font: { size: isMobile ? 8 : 12 }
            }
        }
        }
      }
    })
  }
  // disconnect() {
  //   this.chart.destroy()
  // }
}