<template>
<div id="iplist">
  <b-modal id="ipeditor" ref="ipeditor" title="Edit me" @ok="handleOk">
    <b-form v-if="editedIp" @submit.stop.prevent="handleSubmit">
      <b-form-input    type="text" v-model="editedIp.info.name" label="Name"></b-form-input>
      <b-form-textarea type="text" v-model="editedIp.info.comment" label="Description"></b-form-textarea>
    </b-form>
  </b-modal>
  <table class="table-striped table-condensed">
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
      <tr v-for="ip in ips" :key="ip.id">
        <td>{{ ip.ip }}</td>
        <td><i v-bind:class="system_icon(ip)"></i></td>
        <td @dblclick="startEdit(ip)">{{ip.info.name}}</td>
        <td @dblclick="startEdit(ip)">{{ ip.info.comment}}</td>
        <td>{{ last_seen(ip) }}</td>
        <td>{{ ip.info.dnsname }}</td>
        <td>{{ ip.arp.mac }}</td>
        <td>{{ ip.info.dhcp && 'dhcp' }}</td>
        <td><i class="fa fa-info" ng-if="ip.fact.id" ng-click="show_facts(ip)"></i></td>
      </tr>
    </tbody>
  </table>
</div>
</template>

<script>
export default {
  data: function () {
    return {
      editedIp: null, 
      editedValue: "",
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
    },
    startEdit: function(ip) {
      console.log("show edit modal")
      this.editedIp = ip
      this.editedValue = ip.info.name
      this.$refs.ipeditor.show()
      console.log(ip.info.name)
    }, 
    doneEdit: function(ip) {
      this.editedIp = null
    },
    handleOk(e) {
      e.cancel();
      this.handleSubmit()
    },
    handleSubmit() {
      this.$refs.ipeditor.hide()
      console.log("SUBMIT")
    }
  }
}
</script>

<style scoped>
table {
  width: 100%;
}
</style>
