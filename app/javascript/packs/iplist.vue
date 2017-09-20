<template>
<table class="table-striped table-condensed" id="iplist">
  <thead>
    <tr>
      <th>ip</th>
      <th>sys</th>
      <th>nome</th>
      <th>descrizione</th>
      <th>days</th>
      <th>dns</th>
      <th>mac</th>
      <th>dhcp</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr v-for="ip in ips">
      <td>{{ ip.ip }}</td>
      <td><i v-bind:class="system_icon(ip)"></i></td>
      <td>{{ ip.info.name }}</td>
      <td>{{ ip.info.comment}}</td>
      <td>{{ last_seen(ip) }}</td>
      <td>{{ ip.info.dnsname }}</td>
      <td>{{ ip.arp.mac }}</td>
      <td>{{ ip.info.dhcp && 'dhcp' }}</td>
      <td><i class="fa fa-info" ng-if="ip.fact.id" ng-click="show_facts(ip)"></i></td>
    </tr>
  </tbody>
</table>
</template>

<script>
export default {
  data: function () {
    return {
      ips: []
    }
  },
  created: function() {
    this.fetchIpsList();
  },
  methods: {
    fetchIpsList: function() {
      this.$http.get('/nms-on-rails/ips.json').then(response => {
        this.ips = response.body
      }, response => 
      {
      })
    }
  }
}
</script>

<style scoped>
table {
  width: 100%;
}
</style>
