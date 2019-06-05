import React from 'react'
import ReactDOM from 'react-dom'

class MyForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = { value: "ciao" }
  }

  handleSubmit = (e) => {
    e.preventDefault();
  }

  handleChange = (e) => {
    console.log("in handel change")
    console.log(this)
    console.log(e)
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input type="text" onChange={this.handleChange} />
        <input type="submit" value="Submit" />
      </form>
    )
  }
}

export default MyForm

