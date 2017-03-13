// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Ip React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'

var FormCsrfInput = React.createClass({
  render() {
    const token = $('meta[name="csrf-token"]').attr('content');

    return (
      <input type="hidden" name="authenticity_token" value={token} readOnly={true} />
    )
  }
});

class ModalEditor extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  };

  handleSubmit(event) {
    alert('A name was submitted: ');
    event.preventDefault();
  }

  handleInputChange(event) {
    const target = event.target;
    const name = target.name;
    this.setState({
      [name]: value
    });
  }

  render() {
    return (
<div id="modaleditor" className="modal fade" role="dialog">
<div className="modal-dialog" role="document">
<div className="modal-content">
  <div className="modal-header">
    <a className="close" data-dismiss="modal">&times;</a>
    <h3>Modifica { this.props.ip ? this.props.ip.ip : 'undef' }</h3>
  </div>
  <div className="modal-body">
    <div id="ip-form">
      <form onSubmit={this.handleSubmit} key={this.props.ip}>
        <FormCsrfInput />
        <div>
          <label>Nome</label>
          <input type="text" name="name" onChange={this.handleInputChange} value={this.props.ip ? this.props.ip.info.name : ''}/>
        </div>
        <div>
          <label>Descrizione</label>
          <textarea id="info-comment" name="comment" onChange={this.handleInputChange} value={this.props.ip ? this.props.ip.info.comment : ''}></textarea>
        </div>
        <div>
          <div className="input">
            <input type="submit" className="btn primary" value="invia"/>
          </div>
        </div>
      </form>
    </div>
  </div>
  <div className="modal-footer">
    Ultima volta visto attivo { this.props.ip ? last_seen(this.props.ip) : '' } giorni fa. <br/>
    Dns: "{ this.props.ip ? this.props.ip.info.dnsname : '' }". <br/>
    Switch: alldata.last_port.switch.name : alldata.last_port.port"
  </div>
</div>
</div>
</div>
)};
}

class IpTr extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      ip: props.ip,
      callbackFromParent: props.callbackFromParent,
    };

    this._openModal = this._openModal.bind(this);
  }

  _openModal() {  
    this.state.callbackFromParent(this.state.ip);
  }

  render() {
    return (
    <tr onClick={this._openModal}>
      <td>{this.state.ip.ip}</td>
      <td><i className={icon(this.state.ip)}></i></td>
      <td>{this.state.ip.info.name}</td>
      <td>{this.state.ip.info.comment}</td>
      <td>{last_seen(this.state.ip)}</td>
      <td>{this.state.ip.info.dnsname}</td>
      <td>{this.state.ip.arp ? this.state.ip.arp.mac : '-'}</td>
    </tr>
    );
  };
}

class IpTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      ips: [],
      edited_ip: null,
    };
    this._openModal = this._openModal.bind(this);
  }

  _openModal(ip) {  
    console.log("IpTable OPEN MODAL for:");
    this.setState({edited_ip: ip});
    $('#modaleditor').modal('show');
  }

  componentDidMount() {
    fetch('ips.json').then(res => {
      return (res.json());
    }).then(res => {
      console.log("FETCHING data");
      console.log(res);
      this.setState({ ips: res });
    });
  }

  render() {
    return (
<div>
<ModalEditor ip={this.state.edited_ip}/>
<table className="table-striped table-condensed" id="main">
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
        { this.state.ips.map(ip => (
<IpTr key={ip.id} ip={ip} callbackFromParent={this._openModal} />
        ))}
  </tbody>
</table>
</div>
    );
  };
};

ReactDOM.render(
  <IpTable />,
  document.getElementById('iptable'),
);

