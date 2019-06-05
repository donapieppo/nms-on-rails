import React from 'react'
import Chip from '@material-ui/core/Chip';
import ListItem from '@material-ui/core/ListItem';
import Icon from '@material-ui/core/Icon';
import Box from '@material-ui/core/Box';

const icon = (os) => {
  return 'print'
}

const one_day = 86400000
const today   = new Date()

const last_seen = (ip) => {
  const last_arp = new Date (ip.last_seen)
  return (Math.ceil((today.getTime() - last_arp.getTime()) / (one_day)))
}

function IpItem(props) {
  return (
    <Box dense="true" display="flex" flexDirection="row" p={1} m={1} onDoubleClick={e => props.startEditingIp(e, props.ip)}>
      <Box style={{width: '30%'}}>
        <Icon>{icon(props.ip.os)}</Icon>
        <Chip label={props.ip.ip} />
        {props.ip.name.toUpperCase()}
      </Box>
      <Box flexGrow={1}>
        {props.ip.comment}
      </Box>
      <Box>
        {props.ip.dnsname} -
        {props.ip.arp ? props.ip.arp.mac : '-'}
        <Chip size="small" color="primary" label={last_seen(props.ip)}/>
      </Box>
    </Box>
  )
}

export default IpItem
