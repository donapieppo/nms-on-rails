import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

import { railsUpdate } from './nmsUtils';

export default function IpSystem(props) {
  const [anchorEl, setAnchorEl] = React.useState(null);

  function handleClick(event) {
    setAnchorEl(event.currentTarget);
  }

  function handleClose(event) {
    setAnchorEl(null);
  }

  function handleSetSystem(event) {
    setAnchorEl(null);
    const s = event.currentTarget.dataset.system
    console.log(`handleSetSystem for ${props.ip.ip} -> ${s}`)
    props.updateSystem(props.ip, s)
  }

  function systemImage() {
    return props.ip.system + '.png'
  }

  return (
    <div>
      <Button size="small" aria-controls="simple-menu" aria-haspopup="true" onClick={handleClick}>
        <img src={systemImage()} width="28" />
      </Button>
      <Menu
        id={`actions_${props.ip.id}`}
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleClose}
      >
        <MenuItem onClick={handleSetSystem} data-system="linux"><img src='linux.png' alt='linux'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="win"><img src='win.png' alt='win'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="macos"><img src='macos.png' alt='macos'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="printer"><img src='printer.png' alt='printer'/></MenuItem>
      </Menu>
    </div>
  );
}


