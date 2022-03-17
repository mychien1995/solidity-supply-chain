import { createWebHistory, createRouter } from "vue-router";
import AdminPanel from '../components/AdminPanel.vue'
import FarmerPanel from '../components/FarmerPanel.vue'

const routes = [{
    path: "/admin",
    component: AdminPanel,
    name: 'AdminPanel'
}, {
    path: "/farmer",
    component: FarmerPanel,
    name: 'FarmerPanel'
}];
const router = createRouter({
    history: createWebHistory(),
    routes
});
export default router;