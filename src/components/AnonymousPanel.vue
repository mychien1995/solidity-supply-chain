<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h4 class="card-title">Anonymous UI</h4>
        </div>
        <div class="card-body">
          <button class="btn btn-info" @click="toggle('GetProductInfo')">
            Get Product Info
          </button>
          <button class="btn btn-info" @click="toggle('GetProductOrigin')">
            Get Product Origin
          </button>
          <button
            class="btn btn-success"
            v-on:click="toggle('GetDistributorInfo')"
          >
            Get Distributor Info
          </button>

          <button class="btn btn-info" v-on:click="toggle('GetFarmerInfo')">
            Get Farmer Info
          </button>
          <div class="mt-5 col-6 pl-0">
            <div v-if="action == 'GetProductInfo'">
              <input
                class="form-control"
                placeholder="SKU"
                v-model="bindingModel.getProductSku"
              />
              <h3 class="mt-3">
                {{ bindingModel.getProduct?.productName }} -
                {{ bindingModel.getProduct?.price }}
              </h3>
              <button class="btn btn-info" @click="getProductInfo">
                Submit
              </button>
            </div>
            <div v-if="action == 'GetProductOrigin'">
              <input
                class="form-control"
                placeholder="SKU"
                v-model="bindingModel.getProductOriginSku"
              />
              <button class="btn btn-info" @click="getProductHistory">
                Submit
              </button>
              <table class="table mt-2">
                <thead>
                  <tr>
                    <th>Transfer From</th>
                    <th>Transfer To</th>
                    <th>Action</th>
                    <th>Block</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="(item, index) in bindingModel.histories"
                    :key="index"
                  >
                    <td>{{ item.transferFrom }}</td>
                    <td>{{ item.transferTo }}</td>
                    <td>
                      {{
                        item.action == "0"
                          ? "Create Product"
                          : "Transfer Product"
                      }}
                    </td>
                    <td>{{ item.blocknumber }}</td>
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
            <div v-if="action == 'GetDistributorInfo'">
              <input
                class="form-control"
                placeholder="Distributor Address"
                v-model="bindingModel.getDistributorAddress"
              />
              <h3 class="mt-3">{{ bindingModel.getDistributorName }}</h3>
              <button class="btn btn-info" @click="getDistributor">
                Submit
              </button>
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
  name: "AnonymousPanel",
  setup() {
    let isDisplay = ref(false);
    let action = ref("");
    let bindingModel = ref({ histories: [] });
    (async () => {
      let role = await BlockchainService.checkRole();
      isDisplay = role == Role.ANONYMOUS;
    })();

    return { isDisplay, action, bindingModel };
  },
  methods: {
    toggle(panel) {
      this.bindingModel = { histories: [] };
      this.action = panel;
    },
    getProductHistory() {
      BlockchainService.getProductHistory(
        this.bindingModel.getProductOriginSku
      ).then((res) => {
        this.bindingModel.histories = res;
      });
    },
    getProductInfo() {
      BlockchainService.getProductInfo(this.bindingModel.getProductSku).then(
        (res) => {
          this.bindingModel.getProduct = res;
        }
      );
    },
    getFarmer() {
      BlockchainService.getFarmer(this.bindingModel.getFarmerAddress).then(
        (res) => {
          console.log(res);
          this.bindingModel.getFarmerName = res;
        }
      );
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
