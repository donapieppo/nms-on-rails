import React from 'react'
import ReactDOM from 'react-dom'

class ModalEditor extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit      = this.handleSubmit.bind(this);
    this.handleInputChange = this.handleInputChange.bind(this);
  };

  handleSubmit(event, infoid) {
    const token = $('meta[name="csrf-token"]').attr('content');
    var formData = {
      name:    ReactDOM.findDOMNode(this.refs.editableName).value,
      comment: ReactDOM.findDOMNode(this.refs.editableComment).value
    };

    var updateIp = this.props.updateIp;
    fetch('/nms-on-rails/infos/' + this.props.edited_ip.info.id , 
          { headers: {'Content-Type': 'application/json', 
                      'Accept': 'application/json', 
                      'X-CSRF-Token': token,
                      'X-Requested-With': 'XMLHttpRequest'}, 
            method: 'PUT', 
            credentials: 'same-origin',
            body: JSON.stringify(formData) })
         .then(function(res){ return res.json(); })
         .then(function(data){ console.log( JSON.stringify(data) ) ; return(data); })
         .then(function(data){ updateIp(data) });

    //this.props.edited_ip.info.name    = formData['name'];
    //this.props.edited_ip.info.comment = formData['comment'];
    //this.props.updateIp();

    // $('#modaleditor').modal('hide');
    event.preventDefault();
  }

  handleInputChange(event) {
    const target = event.target;
    const name = target.name;
    this.setState({
      [name]: target.value
    });
  }

  render() {
    return (
<div id="modaleditor" className="modal fade" role="dialog">
<div className="modal-dialog" role="document">
<div className="modal-content">
  <div className="modal-header">
    <a className="close" data-dismiss="modal">&times;</a>
    <h3>Modifica { this.props.edited_ip ? this.props.edited_ip.ip : 'undef' }</h3>
  </div>
  <div className="modal-body">
    <div id="ip-form">
      <form onSubmit={this.handleSubmit}>
        <FormCsrfInput />
        <input type="hidden" name="info_id" ref="info_id" 
               value={(this.props.edited_ip && this.props.edited_ip.info) ? this.props.edited_ip.info.id : 'undef'} />
        <div>
          <label htmlFor="name">Nome</label>
          <input type="text" id="editableName" name="editableName" ref="editableName" />
        </div>
        <div>
          <label htmlFor="comment">Descrizione</label>
          <textarea id="editableComment" name="editableComment" ref="editableComment"></textarea>
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
    Ultima volta visto attivo { this.props.edited_ip ? last_seen(this.props.edited_ip) : '' } giorni fa. <br/>
    Dns: "{ this.props.edited_ip ? this.props.edited_ip.info.dnsname : '' }". <br/>
    Switch: alldata.last_port.switch.name : alldata.last_port.port"
  </div>
</div>
</div>
</div>
)};
}

