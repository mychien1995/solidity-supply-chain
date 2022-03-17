import { createWebHistory, createRouter } from "vue-router";
import AdminPanel from '../components/AdminPanel.vue'

const routes = [{
    path: "/admin",
    component: AdminPanel,
    name: 'AdminPanel'
}];
const router = createRouter({
    history: createWebHistory(),
    routes
});
export default router;