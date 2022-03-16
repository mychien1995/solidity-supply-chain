<template>
  <div id="app">
    <ApplicationLayout />
  </div>
</template>

<script>
import ApplicationLayout from "./components/Layout.vue";
export default {
  name: "App",
  components: { ApplicationLayout },
};
</script>

<style lang="css">
@import "./assets/css/bootstrap.min.css";
@import '../node_modules/vue3-date-time-picker/dist/main.css';
</style>
<style lang="scss">
@import "./assets/scss/paper-dashboard.scss";
</style>
