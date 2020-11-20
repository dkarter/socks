// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "phoenix_html";

import { userId, publicChannel } from "./socket";
import "../css/app.scss";

document.querySelector("input[name='my-user-id']").value = userId;

document.querySelector("button#broadcast-public").addEventListener("click", () => {
  const message = document.querySelector("input[name='message-text']").value;
  publicChannel.push("send_public_message", { message });
});

document.querySelector("button#broadcast-public-relay").addEventListener("click", () => {
  const message = document.querySelector("input[name='message-text']").value;
  const recipientId = document.querySelector("input[name='recipient-user-id']").value;
  publicChannel.push("send_private_message_on_public_channel", { recipientId, message });
});

document.querySelector("button#broadcast-private").addEventListener("click", () => {
  const message = document.querySelector("input[name='message-text']").value;
  const recipientId = document.querySelector("input[name='recipient-user-id']").value;
  publicChannel.push("send_private_message", { recipientId, message });
});

