function icon(ip) {
  var res = "";
  if (ip.system) {
    switch(ip.system.name) {
      case "linux":
        res = "linux";
        break;
      case "macos":
        res = "apple";
        break;
      case "printer":
        res = "print";
        break;
      case "win7":
        res = "windows";
        break;
      case "xp":
        res = "ambulance";
        break;
      default:
        res = "?";
    }
  }
  return "fa fa-" + res;
}

function last_seen(ip) {
  var one_day = 86400000;
  var today   = new Date();

  var last_arp = new Date (ip.arp ? ip.arp.date : 0);
  return(Math.ceil((today.getTime()-last_arp.getTime())/(one_day)));
}

