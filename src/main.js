import { createApp } from 'vue'
import App from './App.vue'
import router from "./router";
import VueToast from 'vue-toast-notification';
import { vfmPlugin } from 'vue-final-modal';

const app = createApp(App).use(router).use(VueToast).use(vfmPlugin);
app.mount('#app');