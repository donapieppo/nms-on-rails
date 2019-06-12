import React from 'react';
import { BrowserRouter as Router, Link, Route } from 'react-router-dom'

import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import ListSubheader from '@material-ui/core/ListSubheader';

import ListIcon from '@material-ui/icons/List';
import DeviceHub from '@material-ui/icons/DeviceHub';

export const MenuItems = (
  <div>
    <ListItem button>
      <ListItemIcon>
        <ListIcon />
      </ListItemIcon>
      <Link to="/nms-on-rails/">Mappa Ip</Link>
    </ListItem>
    <ListItem button>
      <ListItemIcon>
        <DeviceHub />
      </ListItemIcon>
      <a href="/nms-on-rails/networks">Networks</a>
    </ListItem>
    <ListItem button>
      <ListItemIcon>
        <DeviceHub />
      </ListItemIcon>
      <a href="/nms-on-rails/switches">Switches</a>
    </ListItem>
  </div>
);

