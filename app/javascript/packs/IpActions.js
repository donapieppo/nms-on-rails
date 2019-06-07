import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

import { railsUpdate } from './nmsUtils';

export default function IpActions(props) {
  const [anchorEl, setAnchorEl] = React.useState(null);

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  }

  const handleClose = (event) => {
    setAnchorEl(null);
  }

  const handleConnect = () => {
    setAnchorEl(null);
    var proto
    switch (props.ip.system) {
      case "linux":
        proto = "ssh"; break;
      case "macos":
        proto = "ssh"; break;
      case "printer":
        proto = "html"; break;
      case "win7":
        proto = "rdp"; break;
      default:
        proto = "html"
    }
    console.log(`Connect to ${props.ip.ip} with proto ${proto}`)
    window.open(`ips/${props.ip.id}/connect.${proto}`, 'new')
  }

  const handleWakeUp = () => {
    setAnchorEl(null);
    console.log(`Wake up ${props.ip.ip}`)
    window.open(`ips/${props.ip.id}/wake.wol`)
  }

  const handleReset = () => {
    setAnchorEl(null);
    props.resetSystem(props.ip)
  }

  return (
    <div>
      <Button aria-controls="simple-menu" aria-haspopup="true" onClick={handleClick}>
        <Icon>settings</Icon>
      </Button>
      <Menu
        id={`actions_${props.ip.id}`}
        anchorEl={anchorEl}
        keepMounted
        open={Boolean(anchorEl)}
        onClose={handleClose}
      >
        <MenuItem onClick={handleConnect}><Icon>cast</Icon> Connect</MenuItem>
        <MenuItem onClick={handleWakeUp}><Icon>notification_important</Icon> Wake Up</MenuItem>
        <MenuItem onClick={handleReset} color="red"><Icon>delete</Icon> Reset</MenuItem>
      </Menu>
    </div>
  );
}


