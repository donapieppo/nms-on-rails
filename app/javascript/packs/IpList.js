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
import IpActions from './IpActions'
import IpSystem from './IpSystem'

import ModalIpEditor from './ModalIpEditor'
import { lastSeenDays, lastSeenColor, railsUpdate } from './nmsUtils'

const useStyles = makeStyles(theme => ({
  seeMore: {
    marginTop: theme.spacing(3),
  },
}));

export default function IpList(props) {
  const [ips, updateIps] = useState([])
  const [edited_ip, setEditedIp] = useState({name: '', comment: ''})

  const classes = useStyles()

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

  const updateSystem = (ip, s) => {
    console.log("Update system -> " + s)
    updateIps(ips.map((_ip, i) => ( 
      ip.id === _ip.id ? { ..._ip, system: s } : _ip 
    )))
    return railsUpdate(`ips/${ip.id}.json`, { system: s})
  }

  const startEditingIp = (e, ip) => {  
    console.log("EDITING: ", ip)
    setEditedIp(ip)
  }

  const onSubmit = (ipName, ipComment) => {
    console.log(`SUBMITTED ipName=${ipName} ipComment=${ipComment}`)
    setEditedIp({ name: '', comment: '' })
    updateIps(ips.map((_ip, i) => ( 
      edited_ip.id === _ip.id ? { ..._ip, name: ipName, comment: ipComment } : _ip 
    )))
    updateInfo(edited_ip, ipName, ipComment)
  }

  const onCancelEditing = () => {
    setEditedIp({ name: '', comment: '' })
  }

  return (
    <React.Fragment>
      <ModalIpEditor edited_ip={edited_ip} onSubmit={onSubmit} onCancelEditing={onCancelEditing} />
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
              <TableCell><IpSystem ip={ip} updateSystem={updateSystem} /></TableCell>
              <TableCell align="right">{ip.ip}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)}>{ip.name ? ip.name.toUpperCase() : '-'}</TableCell>
              <TableCell onDoubleClick={e => startEditingIp(e, ip)}>{ip.comment}</TableCell>
              <TableCell align="right">
                <small>{ip.dnsname}</small>
              </TableCell>
              <TableCell align="right">
                <small>{ip.arp ? ip.arp : '-'}</small>
              </TableCell>
              <TableCell align="right">
                <Chip variant="outlined" color={lastSeenColor(ip)} label={lastSeenDays(ip)} />
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
