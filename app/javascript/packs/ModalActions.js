import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

import { railsUpdate } from './nmsUtils';

export default function ModalActions(props) {
  const [anchorEl, setAnchorEl] = React.useState(null);

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
      case "win":
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
    props.resetAll(props.ip)
  }

  return (
    <div>
      <Menu
        anchorEl={props.anchor_el}
        open={Boolean(props.ip)}
        onClose={props.handleClose}
      >
        <MenuItem onClick={handleConnect}><Icon>cast</Icon> Connect</MenuItem>
        <MenuItem onClick={handleWakeUp}><Icon>notification_important</Icon> Wake Up</MenuItem>
        <MenuItem onClick={handleReset} color="red"><Icon>delete</Icon> Reset</MenuItem>
      </Menu>
    </div>
  );
}


