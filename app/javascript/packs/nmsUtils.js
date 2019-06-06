const one_day = 86400000
const today   = new Date()

export const osIcon = (ip) => {
  return 'print'
}

export const lastSeenDate = (ip) => {
  return(new Date (ip.last_seen))
}

export const lastSeenDays = (ip) => {
  const last_arp = new Date (ip.last_seen)
  return (Math.ceil((today.getTime() - lastSeenDate(ip).getTime()) / (one_day)))
}

export const lastSeenColor = (ip) => {
  if (lastSeenDays(ip) < 30) {
    return 'primary'
  } else {
    return 'secondary'
  }
}

const csrfToken = () => {
  return document.querySelector("meta[name='csrf-token']").getAttribute("content")
}

const railsHeaders = () => {
  return { 'Content-Type': 'application/json', 
           'Accept': 'application/json', 
           'X-CSRF-Token': csrfToken(),
           'X-Requested-With': 'XMLHttpRequest' }
}

export const railsUpdate = (url, h) => {
  return fetch(url, { 
    headers: railsHeaders(), 
    method: 'PUT', 
    credentials: 'same-origin',
    body: JSON.stringify(h)
  })
}

