/* eslint-disable no-script-url */
import React, { useState, useEffect } from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Table from '@material-ui/core/Table'
import TableBody from '@material-ui/core/TableBody'
import TableCell from '@material-ui/core/TableCell'
import TableHead from '@material-ui/core/TableHead'
import TableRow from '@material-ui/core/TableRow'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import Button from '@material-ui/core/Button';

import ModalActions from './ModalActions'
import ModalSystemEditor from './ModalSystemEditor'
import ModalIpEditor from './ModalIpEditor'
import { lastSeenDays, lastSeenColor, railsUpdate, systemImage } from './nmsUtils'

export default function IpList(props) {
  const [ips, updateIps] = useState([])
  const [edited_ip, setEditedIp] = useState({name: '', comment: ''})
  const [edited_system_ip, setEditedSystemIp] = useState()
  const [actions_ip, setActionsIp] = useState()
  const [anchor_el, setAnchorEl] = useState(document)

  useEffect(() => {
    updateIps([])
    fetch(`networks/${props.network_id}/ips.json?search_string=${props.search_string}`).then(res => {
      console.log(`fetching networks/${props.network_id}/ips.json?search_string=${props.search_string}`)
      return (res.json());
    }).then(res => {
      console.log('primo ip scaricato: ', res[0])
      updateIps(res)
    })
  }, [props.search_string, props.network_id])

  const updateInfo = (edited_ip, newName, newComment) => {
    return railsUpdate(`infos/${edited_ip.info_id}.json`, {name: newName, comment: newComment}) 
  }

  // EDITING 
  const startEditingIp = (e, ip) => {  
    console.log("EDITING: ", ip)
    setEditedIp(ip)
  }

  const onEditingSubmit = (ipName, ipComment) => {
    console.log(`SUBMITTED ipName=${ipName} ipComment=${ipComment}`)
    setEditedIp({ name: '', comment: '' })
    updateIps(ips.map((_ip, i) => ( 
      edited_ip.id === _ip.id ? { ..._ip, name: ipName, comment: ipComment } : _ip 
    )))
    updateInfo(edited_ip, ipName, ipComment)
  }

  const onEditingCancel = () => {
    setEditedIp({ name: '', comment: '' })
  }

  // ACTIONS
  const openActions = (e, ip) => {
    console.log("Open Actions for ", ip)
    setAnchorEl(e.currentTarget)
    setActionsIp(ip)
  }

  const resetAll = (ip) => {
    setActionsIp(null)
    console.log(`Reset ${ip.ip}`)
    updateIps(ips.map((_ip, i) => ( 
      ip.id === _ip.id ? { ..._ip, name: '-', comment: '-', last_seen: 0, system: 'undef' } : _ip 
    )))
    return railsUpdate(`ips/${ip.id}/reset.json`, {})
  }

  const starIp = (ip) => {
    setActionsIp(null)
    console.log(`Star ${ip.ip}`)
    updateIps(ips.map((_ip, i) => ( 
      ip.id === _ip.id ? { ..._ip, starred: ! _ip.starred } : _ip 
    )))
    return railsUpdate(`ips/${ip.id}/star.json`, {})
  }


  // SYSTEM
  const startEditingSystem = (e, ip) => {  
    console.log("System EDITING: ", ip)
    setAnchorEl(e.currentTarget)
    setEditedSystemIp(ip)
  }

  const updateSystem = (ip, s) => {
    setEditedSystemIp(null)
    console.log("Update system -> " + s)
    updateIps(ips.map((_ip, i) => ( 
      ip.id === _ip.id ? { ..._ip, system: s } : _ip 
    )))
    return railsUpdate(`ips/${ip.id}.json`, { system: s})
  }

  // FACTS
  // const openFacts = (e, ip) => {
  //   console.log("Open Facts for ", ip)
  //   setAnchorEl(e.currentTarget)
  //   setFactsIp(ip)
  // }

  // COMMON TO ALL MODAL 
  const handleModalClose = () => {
    setActionsIp(null)
    setEditedSystemIp(null)
    // setFactsIp(null)
  }

  return (
    <React.Fragment>
      <ModalIpEditor ip={edited_ip} onSubmit={onEditingSubmit} onCancel={onEditingCancel} />
      <ModalSystemEditor ip={edited_system_ip} anchor_el={anchor_el} updateSystem={updateSystem} handleClose={handleModalClose} />
      <ModalActions ip={actions_ip} anchor_el={anchor_el} starIp={starIp} resetAll={resetAll} handleClose={handleModalClose} />
      <h2>Ips</h2>
      <Table size="small">
        <TableHead>
          <TableRow>
            <TableCell></TableCell>
            <TableCell align="right">Ip</TableCell>
            <TableCell>Nome</TableCell>
            <TableCell>Descrizione</TableCell>
            <TableCell align="right">DNS</TableCell>
            <TableCell align="right">MAC</TableCell>
            <TableCell align="right">Giorni</TableCell>
            <TableCell align="right">Azioni</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {ips.map(ip => (
            <TableRow key={ip.id} style={{borderLeft: ip.starred ? '2px solid red' : ''}}>
              <TableCell>
                <Button aria-controls="simple-menu" aria-haspopup="true" onClick={e => startEditingSystem(e, ip)}>
                  <img src={systemImage(ip)} width="28"/>
                </Button>
              </TableCell>
              <TableCell align="right">{ip.ip}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)} style={{fontWeight: 500}}>{ip.name}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)}>
                {ip.comment}<br/>
                <small>{ ip.fact ? `${ip.fact['lsbdistrelease']} ${ip.fact['lsbdistid']} - ${ip.fact['processorcount']} ${ip.fact['processor']} - ${parseInt(ip.fact['memorysize'])}GB` : '' }</small>
              </TableCell>
              <TableCell align="right">
                <small>{ip.dnsname}</small>
              </TableCell>
              <TableCell align="right">
                <small>{ip.arp ? ip.arp : '-'}</small>
              </TableCell>
              <TableCell align="right">
                <Chip size="small" variant="outlined" color={lastSeenColor(ip)} label={lastSeenDays(ip)} />
              </TableCell>
              <TableCell align="right">
                <Button aria-controls="simple-menu" aria-haspopup="true" onClick={e => openActions(e, ip)}>
                  <Icon size="small">settings</Icon>
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </React.Fragment>
  );
}
