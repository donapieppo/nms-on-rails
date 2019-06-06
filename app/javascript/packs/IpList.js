/* eslint-disable no-script-url */
import React, { useState, useEffect } from 'react';
import Link from '@material-ui/core/Link';
import { makeStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import Icon from '@material-ui/core/Icon';
import Chip from '@material-ui/core/Chip';
import Title from './Title';

import ModalIpEdit from './ModalEdit'
import { osIcon, lastSeenDays, lastSeenColor, railsUpdate } from './nmsUtils'

const useStyles = makeStyles(theme => ({
  seeMore: {
    marginTop: theme.spacing(3),
  },
}));

export default function IpList2() {
  const [ips, updateIps] = useState([])
  const [edited_ip, setEditedIp] = useState({name: '', comment: ''})

  const classes = useStyles()

  useEffect(() => {
    fetch('ips.json').then(res => {
      console.log("fetching 'ips.json'")
      return (res.json());
    }).then(res => {
      console.log('primo ip scaricato: ', res[0])
      updateIps(res)
    })
  }, [])

  const updateInfo = (newName, newComment) => {
    return railsUpdate('/nms-on-rails/infos/1', {name: newName, comment: newComment}) 
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
    updateInfo(ipName, ipComment)
  }

  const onCancelEditing = () => {
    setEditedIp({ name: '', comment: '' })
  }

  return (
    <React.Fragment>
      <ModalIpEdit edited_ip={edited_ip} onSubmit={onSubmit} onCancelEditing={onCancelEditing} />
      <Title>Recent Orders</Title>
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
          </TableRow>
        </TableHead>
        <TableBody>
          {ips.map(ip => (
            <TableRow key={ip.id} onDoubleClick={e => startEditingIp(e, ip)}>
              <TableCell><Icon>{osIcon(ip)}</Icon></TableCell>
              <TableCell align="right">{ip.ip}</TableCell>
              <TableCell>{ip.name}</TableCell>
              <TableCell>{ip.comment}</TableCell>
              <TableCell align="right">
                <small>{ip.dnsname}</small>
              </TableCell>
              <TableCell align="right">
                <small>{ip.arp ? ip.arp : '-'}</small>
              </TableCell>
              <TableCell align="right">
                <Chip variant="outlined" color={lastSeenColor(ip)} label={lastSeenDays(ip)} />
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
      <div className={classes.seeMore}>
        <Link color="primary" href="javascript:;">
          See more orders
        </Link>
      </div>
    </React.Fragment>
  );
}
