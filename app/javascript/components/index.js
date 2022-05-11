import React from 'react';
import { createRoot } from 'react-dom/client';

import Dashboard from './Dashboard'

const root = createRoot(document.getElementById('dashboard'));
root.render(<Dashboard />);

