import React from 'react'
import ReactDOM from 'react-dom'

class MyTestChild extends React.Component {
  constructor(props) {
    super(props);
    this.state = {num: props.num};
  }

  render() {
    return (
        <p>num: {this.props.num}</p>
  )};
}

class MyTest extends React.Component {
  constructor(props) {
    super(props);
    this.state = {num: props.num};
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    console.log("CIAO");
    console.log(this.state.num);
    this.setState((prevState, props) => {
      return { num: prevState.num + 1 }
    });
  }

  render() {
    return (
        <div>
<button onClick={this.handleClick}>{this.state.num}</button>
<MyTestChild num={this.state.num}/>
</div>
  )};
}

ReactDOM.render(
  <MyTest num={1} />,
  document.getElementById('test'),
);


