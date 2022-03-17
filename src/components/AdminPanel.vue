<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h4 class="card-title">Admin UI</h4>
        </div>
        <div class="card-body">
          <button class="btn btn-info" v-on:click="action = 'GetFarmerInfo'">
            Get Farmer Info
          </button>
          <button class="btn btn-info" v-on:click="action = 'AddFarmer'">
            Add Farmer
          </button>
          <button class="btn btn-info">Get Distributor Info</button>
          <button class="btn btn-info">Add Distributor</button>
          <div class="mt-5 col-6 pl-0">
            <div v-if="action == 'GetFarmerInfo'">
              <input
                class="form-control"
                placeholder="Farmer Address"
                v-model="bindingModel.getFarmerAddress"
              />
              <button class="btn btn-info" @click="getFarmer">Submit</button>
            </div>
            <div v-if="action == 'AddFarmer'">
              <input
                class="form-control"
                placeholder="Farmer Address"
                v-model="bindingModel.addFarmerAddress"
              />
              <input
                class="form-control mt-2"
                placeholder="Name"
                v-model="bindingModel.addFarmerName"
              />
              <button class="btn btn-info"  @click="addFarmer">Submit</button>
            </div>
          </div>
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
  name: "AdminPanel",
  setup() {
    let isDisplay = ref(false);
    let action = ref("");
    let bindingModel = ref({});
    (async () => {
      let role = await BlockchainService.checkRole();
      isDisplay = role == Role.ADMIN;
    })();
    return { isDisplay, action, bindingModel };
  },
  methods: {
    toggle(panel) {
      this.action = panel;
    },
    addFarmer() {
      const address = this.bindingModel.addFarmerAddress;
      const name = this.bindingModel.addFarmerName;
      console.log(address + name);
      (async () => await BlockchainService.addFarmer(address, name))();
    },
    getFarmer() {
      this.bindingModel.getFarmerName = "";
      BlockchainService.getFarmer(this.bindingModel.getFarmerAddress).then(
        (res) => {
          this.bindingModel.getFarmerName = res;
        }
      );
    },
  },
};
</script>
