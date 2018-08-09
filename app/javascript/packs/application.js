/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker')

import Vue    from 'vue'
import VueResource from  'vue-resource'
import BootstrapVue from 'bootstrap-vue'

import IpList from './iplist.vue'
import Menu from './menu.vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(VueResource);
Vue.use(BootstrapVue);

const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content') 

document.addEventListener('DOMContentLoaded', () => {
  const app2 = new Vue({
    el: '#menu',
    render: h => h(Menu)
  })

  const app1 = new Vue({
    el: '#menulist',
    render: h => h(IpList)
  })
})
