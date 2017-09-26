import Vue          from 'vue'
import VueResource  from 'vue-resource'

import Popper       from 'popper.js'
import BootstrapVue from 'bootstrap-vue'

import Menu      from './menu.vue'
import IpLilst   from './iplist.vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

console.log('Hello from NMS on Rails')

Vue.use(BootstrapVue)
Vue.use(VueResource)

Vue.prototype.last_seen = function(ip) {
  const one_day = 86400000
  const today   = new Date()

  var last_arp = new Date (ip.arp.date)
  return(Math.ceil((today.getTime()-last_arp.getTime())/(one_day)))
}

Vue.prototype.system_icon = function(ip) { 
  switch(ip.system.name) {
    case "linux":
      return ("fa fa-linux")
    case "macos":
      return ("fa fa-apple")
    case "printer":
      return("fa fa-print")
    case "win7":
      return("fa fa-windows")
    case "xp":
      return("fa fa-ambulance")
  }
}

const menu      = new Vue(Menu).$mount('#menu')
const iplist    = new Vue(IpLilst).$mount('#iplist')

