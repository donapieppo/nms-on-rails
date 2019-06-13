import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

import { railsUpdate } from './nmsUtils';

export default function SystemEditor(props) {

  function handleSetSystem(event) {
    const s = event.currentTarget.dataset.system
    console.log(`handleSetSystem for ${props.ip.ip} -> ${s}`)
    props.updateSystem(props.ip, s)
  }

  return (
    <div>
      <Menu
        keepMounted={true}
        anchorEl={props.anchor_el}
        open={Boolean(props.ip)}
        onClose={props.handleCloseSystem}
      >
        <MenuItem onClick={handleSetSystem} data-system="linux"><img src='linux.png' alt='linux'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="win"><img src='win.png' alt='win'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="macos"><img src='macos.png' alt='macos'/></MenuItem>
        <MenuItem onClick={handleSetSystem} data-system="printer"><img src='printer.png' alt='printer'/></MenuItem>
      </Menu>
    </div>
  );
}



