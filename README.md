# QDS challenge

## Vue web app

# deploy dev mode

* clone repository
* `cd /webapp-mapi`
* `npm install`
* `npm run dev`

- local `http://localhost:5173`

- the web app require that `go-mapi` and `node-api` are alive

* go-mapi `http://localhost:3001`
* node-mapi `http://localhost:3000`

<hr/>

# deploy with docker
* `docker build -t my-vue-app .`
* `docker run -d -p 3003:3000 my-vue-app`

<hr/>

# STEPS AND SCHRENSHOTS

### inicio de la aplicación
![alt text](./images/image1.png)!

### Cuando presione el boton Entrar
![alt text](./images/image2.png)!

### Cuando presione el boton Calcular QR
![alt text](./images/image3.png)!

### Cuando presione el boton Calcular
![alt text](./images/image4.png)!

