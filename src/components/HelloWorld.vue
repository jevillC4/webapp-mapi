<script setup lang="ts">
import { ref } from 'vue'
import axios from 'axios'
import MessageComponent from '../components/MessageComponent.vue'

defineProps<{ msg: string }>()

const count = ref(0)
const showMessage = ref(false)
const token = ref<string | null>(null)
const matrixData = ref<number[][]>([
  [12, -51, 4],
  [6, 167, -68],
  [-4, 24, -41]
])

async function handleClick() {
  count.value++
  try {
    const response = await axios.post('http://localhost:3001/auth')
    token.value = response.data.token
    showMessage.value = true
  } catch (error) {
    console.error("An error occurred:", error)
    token.value = "Failed to retrieve token."
    showMessage.value = true
  }
}
</script>

<template>
  <h1>{{ msg }}</h1>

  <div class="card">
    <button type="button" @click="handleClick">Entrar</button>
  </div>

  <div v-if="showMessage">
    <MessageComponent :token="token" :matrixData="matrixData" />
  </div>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
