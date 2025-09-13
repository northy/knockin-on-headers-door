<template>
    <div id="chart-dependency-managers-frustration-outcome" class="w-[60%] h-[70%] center m-auto"></div>
</template>

<script setup>
import { onMounted } from 'vue'
import { onSlideEnter } from '@slidev/client'
import Plotly from 'plotly.js-dist-min'

let container

onMounted(() => {
    container = document.getElementById('chart-dependency-managers-frustration-outcome')

    const x = Array.from({ length: 100 }, (_, i) => i / 10)
    const shift = 2
    const y = x.map(v => Math.exp(v - shift))

    const trace = {
        x,
        y,
        type: 'scatter',
        mode: 'lines',
        line: { color: 'black', width: 3 },
    }

    const option1LineY = y[80]
    const option1 = {
        x: [x[0], x[99]],
        y: [option1LineY, option1LineY],
        type: 'scatter',
        mode: 'lines',
        line: { color: 'black', dash: 'dot', width: 2 },
        name: 'results',
        showlegend: false,
    }

    const option2LineY = y[91]
    const option2 = {
        x: [x[0], x[99]],
        y: [option2LineY, option2LineY],
        type: 'scatter',
        mode: 'lines',
        line: { color: 'black', dash: 'dot', width: 2 },
        name: 'results',
        showlegend: false,
    }

    const option3LineY = y[99]
    const option3 = {
        x: [x[0], x[99]],
        y: [option3LineY, option3LineY],
        type: 'scatter',
        mode: 'lines',
        line: { color: 'black', dash: 'dot', width: 2 },
        name: 'results',
        showlegend: false,
    }

    const layout = {
        margin: { t: 10, r: 10, b: 35, l: 35 },
        xaxis: {
            showgrid: false,
            showticklabels: false,
            title: { text: 'frustration', standoff: 15 },
        },
        yaxis: {
            showgrid: false,
            showticklabels: false,
            title: { text: 'outcome', standoff: 10 },
            rangemode: 'tozero',
        },
        annotations: [
            {
                x: x[99],
                y: option1LineY,
                xanchor: 'left',
                yanchor: 'bottom',
                text: 'option 1',
                showarrow: false,
                font: { color: 'black', size: 14 }
            },
            {
                x: x[99],
                y: option2LineY,
                xanchor: 'left',
                yanchor: 'bottom',
                text: 'option 2',
                showarrow: false,
                font: { color: 'black', size: 14 }
            },
            {
                x: x[99],
                y: option3LineY,
                xanchor: 'left',
                yanchor: 'bottom',
                text: 'option 3',
                showarrow: false,
                font: { color: 'black', size: 14 }
            },
        ],
        showlegend: false
    }

    Plotly.newPlot(container, [trace, option1, option2, option3], layout, { staticPlot: true })
    onSlideEnter(() => {
        if (container) Plotly.Plots.resize(container)
    })
})
</script>
