<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h4 class="card-title">Admin UI</h4>
        </div>
        <div class="card-body">
          <button class="btn btn-info" v-on:click="getFarmers()">
            Get Farmers
          </button>
          <button class="btn btn-info" v-on:click="toggle('GetFarmerInfo')">
            Get Farmer Info
          </button>
          <button class="btn btn-info" v-on:click="toggle('AddFarmer')">
            Add Farmer
          </button>
          <button class="btn btn-success" v-on:click="getDistributors()">Get Distributors</button>
          <button class="btn btn-success" v-on:click="toggle('GetDistributorInfo')">Get Distributor Info</button>
          <button class="btn btn-success" v-on:click="toggle('AddDistributor')">Add Distributor</button>
          <div class="mt-5 col-6 pl-0">
            <div v-if="action == 'GetFarmers'">
              <table class="table">
                <thead>
                  <tr>
                    <th>Address</th>
                    <th>Name</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="(item, index) in bindingModel.farmers"
                    :key="index"
                  >
                    <td>{{ item.ownerAddress }}</td>
                    <td>{{ item.name }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div v-if="action == 'GetFarmerInfo'">
              <input
                class="form-control"
                placeholder="Farmer Address"
                v-model="bindingModel.getFarmerAddress"
              />
              <h3 class="mt-3">{{ bindingModel.getFarmerName }}</h3>
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
              <button class="btn btn-info" @click="addFarmer">Submit</button>
            </div>
            <!--Distributor-->
            <div v-if="action == 'GetDistributors'">
              <table class="table">
                <thead>
                  <tr>
                    <th>Address</th>
                    <th>Name</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="(item, index) in bindingModel.distributors"
                    :key="index"
                  >
                    <td>{{ item.ownerAddress }}</td>
                    <td>{{ item.name }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div v-if="action == 'GetDistributorInfo'">
              <input
                class="form-control"
                placeholder="Distributor Address"
                v-model="bindingModel.getDistributorAddress"
              />
              <h3 class="mt-3">{{ bindingModel.getDistributorName }}</h3>
              <button class="btn btn-info" @click="getDistributor">Submit</button>
            </div>
            <div v-if="action == 'AddDistributor'">
              <input
                class="form-control"
                placeholder="Distributor Address"
                v-model="bindingModel.addDistributorAddress"
              />
              <input
                class="form-control mt-2"
                placeholder="Name"
                v-model="bindingModel.addDistributorName"
              />
              <button class="btn btn-info" @click="addDistributor">Submit</button>
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
    let bindingModel = ref({ farmers: [] });
    (async () => {
      let role = await BlockchainService.checkRole();
      isDisplay = role == Role.ADMIN;
    })();
    return { isDisplay, action, bindingModel };
  },
  methods: {
    toggle(panel) {
      this.bindingModel = { farmers: [], distributors: [] };
      this.action = panel;
    },
    getFarmers() {
      this.bindingModel = { farmers: [], distributors: [] };
      this.action = "GetFarmers";
      BlockchainService.getFarmers().then((res) => {
        this.bindingModel.farmers = res;
      });
    },
    addFarmer() {
      const address = this.bindingModel.addFarmerAddress.trim();
      const name = this.bindingModel.addFarmerName.trim();
      (async () => await BlockchainService.addFarmer(address, name))();
    },
    getFarmer() {
      BlockchainService.getFarmer(this.bindingModel.getFarmerAddress).then(
        (res) => {
          console.log(res);
          this.bindingModel.getFarmerName = res;
        }
      );
    },
    getDistributors() {
      this.bindingModel = { distributors: [], farmers: [] };
      this.action = "GetDistributors";
      BlockchainService.getDistributors().then((res) => {
        this.bindingModel.distributors = res;
      });
    },
    addDistributor() {
      const address = this.bindingModel.addDistributorAddress.trim();
      const name = this.bindingModel.addDistributorName.trim();
      (async () => await BlockchainService.addDistributor(address, name))();
    },

    getDistributor() {
      BlockchainService.getDistributor(
        this.bindingModel.getDistributorAddress
      ).then((res) => {
        console.log(res);
        this.bindingModel.getDistributorName = res;
      });
    },
  },
};
</script>
