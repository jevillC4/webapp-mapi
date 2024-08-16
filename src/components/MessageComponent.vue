<script setup lang="ts">
import { ref } from 'vue'
import axios from 'axios'

const props = defineProps<{ token: string | null, matrixData: number[][] }>()

const qMatrix = ref<number[][]>([])
const rMatrix = ref<number[][]>([])
const isCalculatingQR = ref(false)
const isCalculatingFinal = ref(false)

const calculationResult = ref<{
  maxValue: number,
  minValue: number,
  averageValue: number,
  totalSum: number,
  isQDiagonal: boolean,
  isRDiagonal: boolean
} | null>(null)

async function calculateQR() {
  if (!props.matrixData.length || !props.token) return

  isCalculatingQR.value = true

  try {
    const response = await axios.post(
      'http://localhost:3001/matrix',
      { data: props.matrixData },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${props.token}`
        }
      }
    )
    qMatrix.value = response.data.Q
    rMatrix.value = response.data.R
  } catch (error) {
    console.error("An error occurred while fetching matrix data:", error)
  } finally {
    isCalculatingQR.value = false
  }
}

async function calculateFinal() {
  if (!qMatrix.value.length || !rMatrix.value.length) return

  isCalculatingFinal.value = true

  try {
    const response = await axios.post(
      'http://localhost:3000/matrix',
      {
        Q: qMatrix.value,
        R: rMatrix.value
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    )
    calculationResult.value = response.data
  } catch (error) {
    console.error("An error occurred while calculating final data:", error)
  } finally {
    isCalculatingFinal.value = false
  }
}
</script>

<template>
  <div>
    <h2 v-if="props.token">Acceso concedido</h2>
    <h2 v-else>No token received.</h2>

    <div v-if="props.matrixData.length">
      <h3>Original Matrix Data:</h3>
      <ul>
        <li v-for="(row, rowIndex) in props.matrixData" :key="'row-' + rowIndex">
          [{{ row.join(', ') }}]
        </li>
      </ul>
    </div>

    <button @click="calculateQR" :disabled="isCalculatingQR">Calcular QR</button>

    <div v-if="qMatrix.length && rMatrix.length">
      <h3>Q Matrix:</h3>
      <ul>
        <li v-for="(row, rowIndex) in qMatrix" :key="'q-row-' + rowIndex">
          [{{ row.join(', ') }}]
        </li>
      </ul>

      <h3>R Matrix:</h3>
      <ul>
        <li v-for="(row, rowIndex) in rMatrix" :key="'r-row-' + rowIndex">
          [{{ row.join(', ') }}]
        </li>
      </ul>

      <!-- Show "Calcular" button only when Q and R matrices are available -->
      <button @click="calculateFinal" :disabled="isCalculatingFinal" v-if="qMatrix.length && rMatrix.length">
        Calcular
      </button>
    </div>

    <!-- Display the final calculation results -->
    <div v-if="calculationResult">
      <h3>Calculation Results:</h3>
      <ul>
        <li>Max Value: {{ calculationResult.maxValue }}</li>
        <li>Min Value: {{ calculationResult.minValue }}</li>
        <li>Average Value: {{ calculationResult.averageValue }}</li>
        <li>Total Sum: {{ calculationResult.totalSum }}</li>
        <li>Is Q Diagonal: {{ calculationResult.isQDiagonal }}</li>
        <li>Is R Diagonal: {{ calculationResult.isRDiagonal }}</li>
      </ul>
    </div>
  </div>
</template>

<style scoped>
h2 {
  color: #42b983;
}

h3 {
  margin-top: 20px;
  color: #333;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  background-color: #f4f4f4;
  margin: 5px 0;
  padding: 10px;
  border-radius: 4px;
}

button {
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #42b983;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:disabled {
  background-color: #a1d1b1;
  cursor: not-allowed;
}
</style>
