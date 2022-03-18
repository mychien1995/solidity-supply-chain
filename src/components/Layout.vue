<template>
  <div class="main-panel" style="width: 100%">
    <nav
      class="navbar navbar-expand-lg navbar-absolute fixed-top navbar-transparent"
    >
      <div class="container-fluid">
        <div class="navbar-wrapper">
          <div class="navbar-toggle">
            <button type="button" class="navbar-toggler">
              <span class="navbar-toggler-bar bar1"></span>
              <span class="navbar-toggler-bar bar2"></span>
              <span class="navbar-toggler-bar bar3"></span>
            </button>
          </div>
          <a class="navbar-brand" href="javascript:;">Supply Chain</a>
        </div>
      </div>
    </nav>
    <!-- End Navbar -->
    <div class="content">
      <router-view></router-view>
    </div>
  </div>
</template>
<script>
import { Role } from "../constants";
import { useRouter } from "vue-router";

import BlockchainService from "../services/blockchain.service";
export default {
  name: "ApplicationLayout",
  setup() {
    const router = useRouter();
    console.log(router);
    (async () => {
      await BlockchainService.init();
      const role = await BlockchainService.checkRole();
      console.log(role);
      switch (role) {
        case Role.ADMIN:
          router.push({ path: "/admin" });
          break;
        case Role.FARMER:
          router.push({ path: "/farmer" });
          break;
        case Role.DISTRIBUTOR:
          router.push({ path: "/distributor" });
          break;
        case Role.ANONYMOUS:
          router.push({ path: "/anonymous" });
          break;
        default:
          break;
      }
    })();
  },
};
</script>
