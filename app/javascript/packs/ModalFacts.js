import React, { useState } from 'react'
import Button from '@material-ui/core/Button';

import Menu from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import Divider from '@material-ui/core/Divider';
import Icon from '@material-ui/core/Icon';

export default function ModalFacts(props) {
  return (
    <div>
      <Menu
        keepMounted
        anchorEl={props.anchor_el}
        open={Boolean(props.ip)}
        onClose={props.handleClose}
      >
    { 
      props.ip && props.ip.fact && (
        <div>
      <MenuItem><strong>{props.ip.fact['host']}</strong></MenuItem> 
      <MenuItem>Mem: {props.ip.fact['memorysize']} Mb</MenuItem> 
      <MenuItem>Cpu: {props.ip.fact['processor']}</MenuItem> 
      <MenuItem>Cpu count: {props.ip.fact['processorcount']}</MenuItem> 
      <MenuItem>Debian: {props.ip.fact['lsbdistid']}</MenuItem> 
        </div>
      )
    }
      </Menu>
    </div>
  );
}


