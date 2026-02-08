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
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          data: this.dataValue
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false, // ← canvas の CSS 高さに従わせる
        scales: {
         x: {
            ticks: {
            font: { size: isMobile ? 6 : 12 } // スマホなら小さく、PCは大きく
            }
        },
        y: {
            ticks: {
            font: { size: isMobile ? 8 : 14 }
            }
        }
        },
      }
    })
  }
  disconnect() {
    this.chart.destroy()
  }
}