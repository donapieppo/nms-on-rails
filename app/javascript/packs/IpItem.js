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

const lastSeenDate = (ip) => {
  return(new Date (ip.last_seen))
}

const lastSeenDays = (ip) => {
  const last_arp = new Date (ip.last_seen)
  return (Math.ceil((today.getTime() - lastSeenDate(ip).getTime()) / (one_day)))
}

const lastSeenColor = (ip) => {
  if (lastSeenDays(ip) < 30) {
    return 'primary'
  } else {
    return 'secondary'
  }
}

export default function IpItem(props) {
  return (
    <Box dense="true" display="flex" flexDirection="row" onDoubleClick={e => props.startEditingIp(e, props.ip)}>
      <Box style={{width: '30%'}}>
        <Icon>{icon(props.ip.os)}</Icon>
        <Chip label={props.ip.ip} />
        {props.ip.name.toUpperCase()}
      </Box>
      <Box flexGrow={1}>
        {props.ip.comment}
      </Box>
      <Box>
        <small>
         {props.ip.dnsname} 
         {props.ip.arp ? props.ip.arp : '-'}
        </small>
        <Chip size="small" color={lastSeenColor(props.ip)} label={lastSeenDays(props.ip)}/>
      </Box>
    </Box>
  )
}

