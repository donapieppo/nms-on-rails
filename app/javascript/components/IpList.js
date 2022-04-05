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

const useStyles = makeStyles(theme => ({
  onDhcp: {
    backgroundColor: '#fee',
  }
}))

export default function IpList(props) {
  const classes = useStyles();

  const [ips, updateIps] = useState([])
  const [edited_ip, setEditedIp] = useState({name: null, comment: null})
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
      const res_hash = res.reduce((r, ip) => {
        r[ip.id] = ip
        return r
      }, {})
      updateIps(res_hash)
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
    setEditedIp({ name: null, comment: null })
    ips[edited_ip.id]['name'] = ipName
    ips[edited_ip.id]['comment'] = ipComment 
    updateIps(ips)
    updateInfo(edited_ip, ipName, ipComment)
  }

  const onEditingCancel = () => {
    setEditedIp({ name: null, comment: null })
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
    ips[ip.id] = { ...ip, name: '-', comment: '-', last_seen: 0, system: 'undef' }
    updateIps(ips)
    return railsUpdate(`ips/${ip.id}/reset.json`, {})
  }

  const starIp = (ip) => {
    setActionsIp(null)
    console.log(`Star ${ip.ip}`)
    ips[ip.id]['starred'] = ! ip.starred 
    updateIps(ips)
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
    ips[ip.id]['system'] = s 
    updateIps(ips)
    return railsUpdate(`ips/${ip.id}.json`, { system: s})
  }

  // COMMON TO ALL MODAL 
  const handleModalClose = () => {
    setActionsIp(null)
    setEditedSystemIp(null)
  }

  const factString = (ip) => {
    if (ip.fact && ip.system === 'printer') {
      return (`${ip.fact['productname']}`)
    } else if (ip.fact && ip.system == 'linux') {
      return (`${ip.fact['lsbdistrelease']} ${ip.fact['lsbdistid']} - ${ip.fact['processorcount']} ${ip.fact['processor']} - ${parseInt(ip.fact['memorysize'])}GB`)
    } else {
      return ('')
    }
  }

  var ip

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
          {Object.keys(ips).map( (k) => (
            <TableRow key={k} style={{borderLeft: ips[k].starred ? '4px solid red' : ''}}>
              <TableCell>
                <Button aria-controls="simple-menu" aria-haspopup="true" onClick={e => startEditingSystem(e, ips[k])}>
                  <img src={systemImage(ips[k])} width="28"/>
                </Button>
              </TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ips[k])} align="right">
                {ips[k].ip}
              </TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ips[k])} style={{fontWeight: 500}}>
                {ips[k].name}
              </TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ips[k])}>
                {ips[k].comment}<br/>
                <small>{ factString(ips[k]) }</small>
              </TableCell>
              <TableCell align="right" size="small">
                <small>{ips[k].dnsname}</small>
              </TableCell>
              <TableCell align="right" className={ips[k].dhcp ? classes.onDhcp : ''} size="small">
                <small>{ips[k].arp ? ips[k].arp : '-'}</small>
              </TableCell>
              <TableCell align="right">
                <Chip size="small" variant="outlined" color={lastSeenColor(ips[k])} label={lastSeenDays(ips[k])} />
              </TableCell>
              <TableCell align="right">
                <Button aria-controls="simple-menu" aria-haspopup="true" onClick={e => openActions(e, ips[k])}>
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
