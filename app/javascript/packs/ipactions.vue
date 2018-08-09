<template>
<b-dropdown :text="ip.ip" class="m-md-2" variant="link" v-on:shown="showActions" v-on:hidden="hideActions">
  <b-dropdown-item v-if="show_menu">
    <i class="fa fa-fw fa-eye"></i> Connect
  </b-dropdown-item>
  <b-dropdown-item v-if="show_menu">
    <i class="fa fa-fw fa-bell-o"></i> Wake up 
  </b-dropdown-item>
  <b-dropdown-item v-if="show_menu">
    <i class="fa fa-fw fa-clock-o"></i> Notify when online
  </b-dropdown-item>
</b-dropdown>
</template>

<script>
console.log('Hello World from IpActions');

module.exports = {
  props: ['ip'],
  data: function () {
    return {
      show_menu: false
    }
  },
  methods: {
    showActions: function () {
      this.show_menu = true
    },
    hideActions: function () {
      this.show_menu = false
    }
  }
}
</script>

<style scoped>
.b-dropdown {
  padding-top: 0 important!;
  padding-bottom: 0 important!;
  margin-top: 0 important!;
  margin-bottom: 0 important!;
}
</style>
