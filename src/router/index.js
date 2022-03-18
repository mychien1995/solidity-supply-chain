import { createWebHistory, createRouter } from "vue-router";
import AdminPanel from "../components/AdminPanel.vue";
import FarmerPanel from "../components/FarmerPanel.vue";
import DistributorPanel from "../components/DistributorPanel.vue";
import AnonymousPanel from "../components/AnonymousPanel.vue";

const routes = [
  {
    path: "/admin",
    component: AdminPanel,
    name: "AdminPanel",
  },
  {
    path: "/farmer",
    component: FarmerPanel,
    name: "FarmerPanel",
  },
  {
    path: "/distributor",
    component: DistributorPanel,
    name: "DistributorPanel",
  },
  {
    path: "/anonymous",
    component: AnonymousPanel,
    name: "AnonymousPanel",
  },
];
const router = createRouter({
  history: createWebHistory(),
  routes,
});
export default router;
