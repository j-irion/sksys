import { createApp } from "vue";
import App from "./App.vue";

import fetch from "fetch";

import "bootstrap/dist/css/bootstrap.css";

const app = createApp(App);

app.use(fetch);

app.mount("#app");
