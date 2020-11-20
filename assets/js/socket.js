import { Socket } from "phoenix";
import { v4 as uuidv4 } from "uuid";

export const userId = uuidv4();
const socket = new Socket("/socket", { params: { userId } });

socket.connect();

export const publicChannel = socket.channel("lobby");

publicChannel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined public channel successfully", resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join public channel", resp);
  });

publicChannel.on("message", (message) => {
  const el = document.createElement("p");
  el.textContent = `got public message on public channel: ${JSON.stringify(message)}`;
  document.getElementById("socket-messages").appendChild(el);
});

publicChannel.on("private_message", (message) => {
  const el = document.createElement("p");
  el.textContent = `got private message on public channel: ${JSON.stringify(message)}`;
  document.getElementById("socket-messages").appendChild(el);
});

const privateChannel = socket.channel(`private:${userId}`);
privateChannel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined private channel successfully", resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join private channel", resp);
  });

privateChannel.on("message", (message) => {
  const el = document.createElement("p");
  el.textContent = `got private message on private channel: ${JSON.stringify(message)}`;
  document.getElementById("socket-messages").appendChild(el);
});

socket.onClose(() => {
  console.log("socket disconnected... clearing messages.");
  document.getElementById("socket-messages").textContent = "";
});

export default socket;
