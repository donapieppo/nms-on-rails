import React from 'react';
import InputBase from '@material-ui/core/InputBase';
import SearchIcon from '@material-ui/icons/Search';
import { fade, makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(theme => ({
	search: {
		position: 'relative',
		borderRadius: theme.shape.borderRadius,
		backgroundColor: fade(theme.palette.common.white, 0.15),
		'&:hover': {
			backgroundColor: fade(theme.palette.common.white, 0.25),
		},
		marginLeft: 0,
		width: '100%',
		[theme.breakpoints.up('sm')]: {
			marginLeft: theme.spacing(1),
			width: 'auto',
		},
	},
	searchIcon: {
		width: theme.spacing(7),
		height: '100%',
		position: 'absolute',
		pointerEvents: 'none',
		display: 'flex',
		alignItems: 'center',
		justifyContent: 'center',
	},
	inputRoot: {
		color: 'inherit',
	},
	inputInput: {
		padding: theme.spacing(1, 1, 1, 7),
		transition: theme.transitions.create('width'),
		width: '100%',
		[theme.breakpoints.up('sm')]: {
			width: 120,
			'&:focus': {
				width: 200,
			},
		},
	},
}));

export default function IpSearch(props) {
  const classes = useStyles();

  const handleInputChange = (e) => {
    var search_string = e.target.value
    console.log(search_string)
    if (search_string.length == 0) {
      props.handleSearchStringChange('')
    } else if (search_string.length > 1) {
      props.handleSearchStringChange(search_string)
    }
  }

 	return (
    <div className={classes.search}>
      <div className={classes.searchIcon}>
        <SearchIcon />
      </div>
    <InputBase
      placeholder="Search…"
      classes={{ root: classes.inputRoot, input: classes.inputInput }}
      inputProps={{ 'aria-label': 'Search' }}
      onChange={handleInputChange}
    />
    </div>
  )
}

