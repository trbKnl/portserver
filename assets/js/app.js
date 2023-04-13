// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"
//
import "../css/app.css";

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import { Port } from "./port";

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {
  Port
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: {
    _csrf_token: csrfToken,
    viewport: {
      width: window.innerWidth,
      height: window.innerHeight,
    },
  },
  hooks: Hooks,
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

window.addEventListener("phx:js-exec", ({detail}) => {
    document.querySelectorAll(detail.to).forEach(el => {
        liveSocket.execJS(el, el.getAttribute(detail.attr))
    })
  })

window.addEventListener(`phx:download`, (event) => {
  event.detail.uris.forEach((uri) => {
    let a = document.createElement("a");
    a.setAttribute("href", uri);
    //a.setAttribute('download', uri);
    a.setAttribute('download', '');
    a.setAttribute('target', '_blank');
    //a.style.visibility = 'hidden';
    //a.style.display = 'none';
    document.body.appendChild(a);
    a.click()
    document.body.removeChild(a);
  });
})
