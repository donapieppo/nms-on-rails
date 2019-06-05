import React from 'react'
import ReactDOM from 'react-dom'

class Clock extends React.Component {
  constructor(props) {
    super(props)
    this.state = {date: new Date()}
  }

  // constructor(), componentWillMount(), render(), componentDidMount()
  // after the component output has been rendered to the DOM. 
  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      1000
    );
  }

  // At some point our components will be removed from the DOM again.
  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  tick() {
    this.setState({ date: new Date() });
  }

  render() {
    return (
      <p>It is {this.state.date.toLocaleTimeString()}</p>
    )
  }
}

export default Clock

