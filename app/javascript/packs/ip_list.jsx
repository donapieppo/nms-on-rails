// setState(updater[, callback])
// updater function with the signature: (prevState, props) => stateChange
import React from 'react'
import ReactDOM from 'react-dom'

import CssBaseline from '@material-ui/core/CssBaseline';
import List from '@material-ui/core/List';

import IpItem from './ip_item'
import ModalIpEdit from './modal_edit'

class IpList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      ips: [],
      edited_ip: { name: '', comment: '' },
    };
    this.startEditingIp = this.startEditingIp.bind(this)
    this.onSubmit  = this.onSubmit.bind(this)
    this.onCancelEditing  = this.onCancelEditing.bind(this)
  }

  startEditingIp(e, ip) {  
    console.log("EDITING: ", ip)
    this.setState({edited_ip: ip})
  }

  componentDidMount() {
    fetch('ips.json').then(res => {
      console.log("fetching 'ips.json'")
      return (res.json());
    }).then(res => {
      console.log('primo ip scaricato: ', res[0])
      this.setState({ ips: res })
    })
  }

  update_info(newName, newComment) {
    const token = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    return fetch('/nms-on-rails/infos/1', { 
      headers: {'Content-Type': 'application/json', 
                'Accept': 'application/json', 
                'X-CSRF-Token': token,
                'X-Requested-With': 'XMLHttpRequest'}, 
      method: 'PUT', 
      credentials: 'same-origin',
      body: JSON.stringify({name: newName, comment: newComment}) 
    })
  }

  onSubmit(ipName, ipComment) {
    console.log(`SUBMITTED ipName=${ipName} ipComment=${ipComment}`)
    this.setState({edited_ip: { name: '', comment: '' }})
    this.setState({ips: 
      this.state.ips.map((_ip, i) => ( 
        this.state.edited_ip.id === _ip.id ? { ..._ip, name: ipName, comment: ipComment } : _ip 
      ))
    })
    this.update_info(ipName, ipComment)
  }

  onCancelEditing() {
    this.setState({edited_ip: { name: '', comment: '' }})
  }

  render() {
    return (
      <React.Fragment>
        <CssBaseline />
      <ModalIpEdit edited_ip={this.state.edited_ip} onSubmit={this.onSubmit} onCancelEditing={this.onCancelEditing} />
      <div>
        {this.state.ips.map(ip => <IpItem key={ip.id} ip={ip} startEditingIp={this.startEditingIp} /> )}
      </div>
      </React.Fragment>
    );
  };
};

ReactDOM.render(
  <IpList />,
  document.getElementById('iplist'),
);

