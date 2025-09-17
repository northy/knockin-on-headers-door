<template>
  <a href="https://northy.github.io/knockin-on-headers-door">Slides URL</a>: northy.github.io/knockin-on-headers-door

  <a href="https://northy.github.io/knockin-on-headers-door">
    <div class="mt-1 ml-[32.5%] left-0 right-0" ref="qrcodeContainer"></div>
  </a>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import QRCode from 'qrcode'

const qrcodeContainer = ref(null)

onMounted(() => {
    const container = qrcodeContainer.value
    container.innerHTML = ''

    var opts = {
        errorCorrectionLevel: 'Q',
        version: 5,
        scale: 4,
        margin: 2,
    }

    QRCode.toCanvas('https://northy.github.io/knockin-on-headers-door', opts)
        .then(canvas => {
            container.appendChild(canvas)
        })
        .catch(err => {
            console.error(err)
        })
})
</script>
