import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import { hooks as colocatedHooks } from "phoenix-colocated/diacritical";

const csrfToken = document
  .querySelector("meta[name='csrf-token'i]")
  .getAttribute("content");

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...colocatedHooks },
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

liveSocket.connect();
window.liveSocket = liveSocket;
export default {};
