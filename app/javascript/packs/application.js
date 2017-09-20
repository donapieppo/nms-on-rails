import Vue     from 'vue'
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import App     from './app.vue'
import IpLilst from './iplist.vue'

Vue.use(BootstrapVue);

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

console.log('Hello World from Webpacker')
console.log('Hello World from Webpacker and Pietro 4c')

Vue.use(VueResource);

Vue.http.interceptors.push({
  request: function (request) {
    Vue.http.headers.common['X-CSRF-Token'] = $('[name="csrf-token"]').attr('content');
    return request;
  },
  response: function (response) {
    return response;
  }
});

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

const app = new Vue(App).$mount('#app')
const iplist = new Vue(IpLilst).$mount('#iplist')

