<template>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <div class="card-header">
          <h4 class="card-title">Distributor UI - {{ distributorName }}</h4>
        </div>
        <div class="card-body">
          <button class="btn btn-info" @click="getProducts">
            Get Products
          </button>
          <button class="btn btn-info" @click="toggle('GetProductInfo')">
            Get Product Info
          </button>
          <button class="btn btn-info" @click="getTransferProductView">
            Transfer Product
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
            <div v-if="action == 'GetProducts'">
              <table class="table">
                <thead>
                  <tr>
                    <th>Address</th>
                    <th>Name</th>
                  </tr>
                </thead>
                <tbody>
                  <tr
                    v-for="(item, index) in bindingModel.products"
                    :key="index"
                  >
                    <td>{{ item.sku }}</td>
                    <td>{{ item.productName }}</td>
                    <td>{{ item.price }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div v-if="action == 'GetTransferProductView'">
              <input
                class="form-control"
                placeholder="SKU"
                v-model="bindingModel.transferSku"
              />
              <select
                class="form-control mt-2"
                v-model="bindingModel.transferDistributor"
              >
                <option
                  v-for="(item, index) in bindingModel.distributors"
                  :key="index"
                  :value="item.ownerAddress"
                >
                  {{ item.name }}
                </option>
              </select>
              <button class="btn btn-info" @click="transferProduct">
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
  name: "DistributorPanel",
  setup() {
    let isDisplay = ref(false);
    let action = ref("");
    let distributorName = ref("");
    let bindingModel = ref({ products: [], distributors: [] });
    (async () => {
      let role = await BlockchainService.checkRole();
      isDisplay = role == Role.DISTRIBUTOR;
      BlockchainService.getDistributor(BlockchainService.getCurrentAddress()).then(
        (res) => {
          distributorName.value = res;
        }
      );
    })();

    return { isDisplay, action, bindingModel, distributorName };
  },
  methods: {
    toggle(panel) {
      this.bindingModel = { products: [], distributors: [] };
      this.action = panel;
    },

    getProductInfo() {
      BlockchainService.getProductInfo(this.bindingModel.getProductSku).then(
        (res) => {
          this.bindingModel.getProduct = res;
          console.log(res);
        }
      );
    },

    getProducts() {
      this.toggle("GetProducts");
      BlockchainService.getProducts().then((res) => {
        this.bindingModel.products = res;
      });
    },

    getTransferProductView() {
      this.toggle("GetTransferProductView");
      BlockchainService.getDistributors().then((res) => {
        console.log(res);
        this.bindingModel.distributors = res;
      });
    },
    
    transferProduct() {
      const sku = this.bindingModel.transferSku.trim();
      const distributor = this.bindingModel.transferDistributor;
      (async () => await BlockchainService.transferProduct(sku, distributor))();
    },
  },
};
</script>
