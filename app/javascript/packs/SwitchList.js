import React, { useState, useEffect } from 'react'

export default function SwitchList() {
  const [switches, updateSwitches] = useState([])

  useEffect(() => {
    fetch('switches.json').then(res => {
      console.log("fetching 'switches.json'")
      return (res.json());
    }).then(res => {
      console.log('primo ip scaricato: ', res[0])
      updateSwitches(res)
    })
  }, [])

  return (
    <React.Fragment>
      <h2>Switches</h2>
      <div>
        {switches.map(s => (
          <div key={s.id}>
          {s.ip} - {s.name}
          </div>
        ))}
      </div>
    </React.Fragment>
  )
}
