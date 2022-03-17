<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h4 class="card-title">Farmer UI - {{ farmerName }}</h4>
        </div>
        <div class="card-body">
          <button class="btn btn-info" v-on:click="getFarmers()">
            Get Products
          </button>
          <button class="btn btn-info" v-on:click="toggle('GetFarmerInfo')">
            Create Product
          </button>
          <button class="btn btn-info" v-on:click="toggle('AddFarmer')">
            Set Product For Sale
          </button>
          <button class="btn btn-info" v-on:click="getDistributors()">
            Transfer Product
          </button>
          <div class="mt-5 col-6 pl-0"></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { Role } from "../constants";
import { ref } from "vue";
import BlockchainService from "../services/blockchain.service";
export default {
  name: "FarmerPanel",
  setup() {
    let isDisplay = ref(false);
    let action = ref("");
    let farmerName = ref("");
    let bindingModel = ref({ farmers: [] });
    (async () => {
      let role = await BlockchainService.checkRole();
      isDisplay = role == Role.FARMER;
    })();

    (async () => {
      let name = await BlockchainService.getFarmer(
        BlockchainService.getCurrentAddress()
      );
      farmerName.value = name;
    })();
    return { isDisplay, action, bindingModel, farmerName };
  },
  methods: {
    toggle(panel) {
      this.bindingModel = { products: [] };
      this.action = panel;
    },
  },
};
</script>
