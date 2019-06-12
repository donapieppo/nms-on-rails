import React from 'react';
import { BrowserRouter as Router, Link, Route } from 'react-router-dom'

import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import ListSubheader from '@material-ui/core/ListSubheader';

import ListIcon from '@material-ui/icons/List';
import DeviceHub from '@material-ui/icons/DeviceHub';

import Button from '@material-ui/core/Button';

export default function MenuItems(props) {
  return (
  <div>
    <ListItem>
      <Button variant="contained" color={props.network_id == 1 ? "primary" : "default"} onClick={props.handleNetworkIdChange} data-network='1'>137.204.134.</Button>
    </ListItem>
    <ListItem>
      <Button variant="contained" color={props.network_id == 2 ? "primary" : "default"} onClick={props.handleNetworkIdChange} data-network='2'>137.204.135.</Button><br/>
    </ListItem>
    <ListItem>
      <Button variant="contained" color={props.network_id == 3 ? "primary" : "default"} onClick={props.handleNetworkIdChange} data-network='3'>137.204.132.</Button>
    </ListItem>
    <ListItem button>
      <ListItemIcon>
        <DeviceHub />
      </ListItemIcon>
      <a href="networks">Networks</a>
    </ListItem>
    <ListItem button>
      <ListItemIcon>
        <DeviceHub />
      </ListItemIcon>
      <a href="switches">Switches</a>
    </ListItem>
  </div>
  )
}

