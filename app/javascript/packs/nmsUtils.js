const one_day = 86400000
const today   = new Date()

export const lastSeenDate = (ip) => {
  return(new Date (ip.last_seen))
}

export const lastSeenDays = (ip) => {
  const last_arp = new Date (ip.last_seen)
  return (Math.ceil((today.getTime() - lastSeenDate(ip).getTime()) / (one_day)))
}

export const lastSeenColor = (ip) => {
  if (lastSeenDays(ip) < 60) {
    return 'primary'
  } else {
    return 'secondary'
  }
}

export const systemImage = (ip) => {
  return ip.system + '.png'
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
  console.log("Called railsUpdate with:" + url + " and")
  console.log(h)
  return fetch(url, { 
    headers: railsHeaders(), 
    method: 'PUT', 
    credentials: 'same-origin',
    body: JSON.stringify(h)
  })
}

export const factString = (ip) => {
  if (ip.fact && ip.system === 'printer') {
    return (`${ip.fact['productname']}`)
  } else if (ip.fact && ip.system == 'linux') {
    return (`${ip.fact['lsbdistrelease']} ${ip.fact['lsbdistid']} - ${ip.fact['processorcount']} ${ip.fact['processor']} - ${parseInt(ip.fact['memorysize'])}GB`)
  } else {
    return ('')
  }
}

