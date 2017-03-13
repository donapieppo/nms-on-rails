    // <tr ng-repeat="ip in ips" ng-dblclick="edit_ip(ip)" >
    //   <td>
    //     <show_ip_actions localip="ip"></show_ip_menu>
    //   </td>
    //   <td><i class="fa fa-{{ nmssystem.icon() }}"></i></td>
    //   <td ng-init="nmsinfo = ip.nmsinfo(); nmsarp = ip.nmsarp(); nmssystem = ip.nmssystem()">{{ nmsinfo.name }}</td>
    //   <td>{{ nmsinfo.comment}}</td>
    //   <td>{{ nmsarp.last_seen() }} </td>
    //   <td>{{ nmsinfo.dnsname }} </td>
    //   <td><a href="{{BASEURL + '/macs/' + nmsarp.mac}}">{{ nmsarp.mac }}</a></td>
    //   <td>{{ nmsinfo.dhcp && 'dhcp' }}</td>
    //   <td><i class="fa fa-info" ng-if="ip.fact.id" ng-click="show_facts(ip)"></i></td>
    // </tr>
