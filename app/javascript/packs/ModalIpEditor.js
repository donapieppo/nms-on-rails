import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Typography from '@material-ui/core/Typography';
import Modal from '@material-ui/core/Modal';
import Button from '@material-ui/core/Button';
import FormControl from '@material-ui/core/FormControl';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';

const FormCsrfInput = () => {
  const token = document.querySelector("meta[name='csrf-token']").getAttribute("content")
  return (
    <input type="hidden" name="authenticity_token" value={token} readOnly={true} />
  )
}

export default function ModalIpEditor(props) {
  const [ipName, setIpName] = useState()
  const [ipComment, setIpComment] = useState()

  const handleIpNameChange = (e) => {
    setIpName(e.target.value)
  }

  const handleIpCommentChange = (e) => {
    setIpComment(e.target.value)
  }

  const onSubmit = (e) => {
    const newName    = ipName || props.edited_ip.name
    const newComment = ipComment || props.edited_ip.comment
    props.onSubmit(newName, newComment)
  }

  return (
    <div>
      <Dialog open={props.edited_ip.name !== ''} onClose={props.onCancelEditing} aria-labelledby="form-dialog-title">
        <DialogTitle id="form-dialog-title">Modifica dati ip {props.edited_ip.ip}</DialogTitle>
        <DialogContent>
          <DialogContentText>
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            label="Name"
            name="name"
            defaultValue={props.edited_ip.name}
            onChange={handleIpNameChange}
            fullWidth
          />
          <TextField
            margin="dense"
            label="Comment"
            name="comment"
            defaultValue={props.edited_ip.comment}
            onChange={handleIpCommentChange}
            fullWidth
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={props.onCancelEditing}>Cancel</Button>
          <Button onClick={onSubmit} color="primary">Save</Button>
        </DialogActions>
      </Dialog>
    </div>
  )
}

