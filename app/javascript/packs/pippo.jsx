import React from 'react'
import ReactDOM from 'react-dom'
//import Clock from './clock'
//import MyForm from './my_form'

function formatName(user) {
  // return `${user.firstName} ${user.lastName}`;
  return "ciao";
}

function Welcome(props) {
  return (
    <div>
    <h1>Welcome {props.name}!</h1>
    <MyForm />
    </div>
  )
}

class IpItem extends React.Component {
  constructor(props) {
    super(props)
  }

  ciao = () => {
    console.log("CIAO")
    console.log(this.props.ip)
  }

  render() {
    return (
      <li onDoubleClick={this.props.ciao}>
      ciao {this.props.ip}
      </li>
    )
  }
}

class MyList extends React.Component {
  constructor(props) {
    super(props)
    this.state = {ips: [1,2,3,4], ciao: ciao}
  }
 
  ciao = () => {
    console.log("CIAO dal PADRE")
  }

  render() {
    return (
      <ul>
      { this.state.ips.map(ip => (
          <IpItem key={ip} ip={ip} ciao={this.state.ciao} />
      ))}
      </ul>
    )
  }
}

// const element = <div><Welcome name="Pietro" /><Clock /></div>
const element = <div><MyList /></div>

  ReactDOM.render(element, document.getElementById('pippo'));

