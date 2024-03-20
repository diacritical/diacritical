import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let cspToken = document
  .querySelector('meta[name="csp-token"]')
  .getAttribute("content");

let csrfToken = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csp_token: cspToken, _csrf_token: csrfToken },
});

window.liveSocket = liveSocket;
liveSocket.connect();
