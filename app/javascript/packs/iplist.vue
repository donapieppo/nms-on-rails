<template>
<div id="iplist">
  <ip-editor :ip="editedIp" :modalShow="modalShow" v-on:handleSubmit="handleSubmit" ></ip-editor>
  <table class="table table-sm table-striped">
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
      <tr v-for="ip in ips" v-bind:key="ip.id">
        <td><ip-actions v-bind:ip="ip"></ip-actions></td>
        <td><i v-bind:class="system_icon(ip)"></i></td>
        <td v-bind:class="ip.error_ok" @dblclick="startEdit(ip)">{{ip.info.name}}</td>
        <td v-bind:class="ip.error_ok" @dblclick="startEdit(ip)">{{ip.info.comment}}</td>
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
import IpActions from './ipactions.vue'
import IpEditor  from './ipeditor.vue'

const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

export default {
  components: {
    IpActions, IpEditor
  },
  data: function () {
    return {
      editedIp: null, 
      ips: [],
      modalShow: false
    }
  },
  created: function() {
    this.fetchIpsList();
  },
  methods: {
    fetchIpsList: function() {
      this.$http.get('/nms-on-rails/ips.json').then(response => {
        this.ips = response.body
      }, response => {})
    },
    startEdit: function(ip) {
      console.log("show edit modal")
      this.modalShow = true
      this.editedIp = ip
      console.log(ip.info.name)
    }, 
    handleSubmit: function() {
      console.log('iplist: handle submit')
      this.modalShow = false
      var info = this.editedIp.info

      this.$http.put('/nms-on-rails/infos/' + info.id, 
                     { name: info.name, comment: info.comment }, 
                     { headers: {'X-CSRF-Token': csrf_token} })
                .then(response => {
                  console.log("OK on " + this.editedIp.ip )
                  this.editedIp.error_ok = 'alert alert-success'
                }, response => {
                  console.log("ERRO on " + this.editedIp.ip )
                  this.editedIp.error_ok = 'alert alert-danger'
                })
    },
  }
}
</script>

<style scoped>
table {
  width: 100%;
}
</style>
