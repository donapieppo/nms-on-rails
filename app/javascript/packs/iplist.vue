<template>
  <b-container>
    <ip-editor :ip="editedIp" :modalShow="modalShow" v-on:handleSubmit="handleSubmit"></ip-editor>
    <b-row v-for="ip in ips" v-bind:key="ip.id">
      <b-col cols="3">
        <ip-actions v-bind:ip="ip"></ip-actions>
        <span v-html="systemIcon(ip)"></span>
      </b-col>
      <b-col cols="6" v-bind:class="ip.result_status_class" @dblclick="startEdit(ip)">
        {{ip.info.name}} /
        {{ip.info.comment}} 
        <span>last_seen(ip)</span>
      </b-col>
      <b-col cols="3">
        {{ ip.info && ip.info.dnsname }}
        {{ ip.arp && ip.arp.mac }}
        {{ ip.info && ip.info.dhcp && 'dhcp' }}
        <i class="fa fa-info" ng-if="ip.fact.id" ng-click="show_facts(ip)"></i>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import IpActions from './ipactions.vue'
import IpEditor  from './ipeditor.vue'

console.log('Hello World from IpList');

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
      this.$http.get('/ips.json').then(response => {
        this.ips = response.body
      }, response => {})
    },
    startEdit: function(ip) {
      console.log("show edit modal")
      this.modalShow = true
      this.editedIp = ip
    }, 
    handleSubmit: function() {
      console.log('iplist: handle submit')
      this.modalShow = false
      var info = this.editedIp.info

      this.$http.put('/infos/' + info.id, 
                     { name: info.name, comment: info.comment }, 
                     { headers: {'X-CSRF-Token': csrf_token} })
                .then(response => {
                  console.log("OK on " + this.editedIp.ip )
                  this.editedIp.result_status_class = 'alert alert-success'
                }, response => {
                  console.log("ERRO on " + this.editedIp.ip )
                  this.editedIp.result_status_class = 'alert alert-danger'
                })
    },
    systemIcon: function(ip) {
      return('<i class="fab fa-linux"></i>')
    },
  }
}

</script>

<style scoped>
table {
  width: 100%;
}
</style>
