import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

import { railsUpdate } from './nmsUtils';

export default function ModalActions(props) {
  const handleConnect = () => {
    props.handleClose();
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
    props.handleClose();
    console.log(`Wake up ${props.ip.ip}`)
    window.open(`ips/${props.ip.id}/wake.wol`)
  }

  const handleStar = () => {
    props.handleClose();
    props.starIp(props.ip)
  }

  const handleReset = () => {
    props.handleClose();
    props.resetAll(props.ip)
  }

  // str963-guest02         2c:41:38:94:97:9a    137.204.135.64 # Str963-guest02 win 10 sett 2016
  const handleDhcp = () => {
    var d = new Date();
    alert(`${props.ip.name}     xx:xx:xx:xx:xx:xx    ${props.ip.ip} # ${props.ip.comment} - ${d.toDateString()}`);
  }

  return (
    <div>
      <Menu
        keepMounted
        anchorEl={props.anchor_el}
        open={Boolean(props.ip)}
        onClose={props.handleClose}
      >
        <MenuItem onClick={handleConnect}><Icon>cast</Icon> Connect</MenuItem>
        <MenuItem onClick={handleWakeUp}><Icon>notification_important</Icon> Wake Up</MenuItem>
        <MenuItem onClick={handleStar}><Icon>star</Icon> Star</MenuItem>
        <MenuItem onClick={handleReset} color="red"><Icon>delete</Icon> Reset</MenuItem>
        <MenuItem> --- </MenuItem>
        <MenuItem onClick={handleDhcp} color="red"> Dhcp String</MenuItem>
      </Menu>
    </div>
  );
}


