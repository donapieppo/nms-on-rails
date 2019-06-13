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

import IpActions from './IpActions'
import SystemEditor from './SystemEditor'
import ModalIpEditor from './ModalIpEditor'
import { lastSeenDays, lastSeenColor, railsUpdate } from './nmsUtils'

export default function IpList(props) {
  const [ips, updateIps] = useState([])
  const [edited_ip, setEditedIp] = useState({name: '', comment: ''})
  const [edited_system_ip, setEditedSystemIp] = useState()
  const [anchor_el, setAnchorEl] = useState(document)

  useEffect(() => {
    updateIps([])
    fetch(`networks/${props.network_id}/ips.json?search_string=${props.search_string}`).then(res => {
      console.log("fetching 'ips.json'")
      return (res.json());
    }).then(res => {
      console.log('primo ip scaricato: ', res[0])
      updateIps(res)
    })
  }, [props.search_string, props.network_id])

  const updateInfo = (edited_ip, newName, newComment) => {
    return railsUpdate(`infos/${edited_ip.info_id}.json`, {name: newName, comment: newComment}) 
  }

  const resetSystem = (ip) => {
    console.log(`Reset ${ip.ip}`)
    updateIps(ips.map((_ip, i) => ( 
      ip.id === _ip.id ? { ..._ip, name: '-', comment: '-', last_seen: 0, system: 'undef' } : _ip 
    )))
    return railsUpdate(`ips/${ip.id}/reset.json`, {})
  }

  const startEditingIp = (e, ip) => {  
    console.log("EDITING: ", ip)
    setEditedIp(ip)
  }

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

  const handleCloseSystem = () => {
    setEditedSystemIp(null)
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

  function systemImage(ip) {
    return ip.system + '.png'
  }

  return (
    <React.Fragment>
      <ModalIpEditor ip={edited_ip} onSubmit={onEditingSubmit} onCancel={onEditingCancel} />
      <SystemEditor ip={edited_system_ip} anchor_el={anchor_el} updateSystem={updateSystem} handleCloseSystem={handleCloseSystem} />
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
            <TableRow key={ip.id}>
              <TableCell><img src={systemImage(ip)} width="28" onClick={e => startEditingSystem(e, ip)} /></TableCell>
              <TableCell align="right">{ip.ip}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)} style={{fontWeight: 500}}>{ip.name}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)}>{ip.comment}</TableCell>
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
                <IpActions ip={ip} resetSystem={resetSystem} />
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </React.Fragment>
  );
}
