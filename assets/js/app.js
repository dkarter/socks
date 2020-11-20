// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "phoenix_html";

import socket from "./socket";
import "../css/app.scss";

socket.onOpen(() => console.log("socket open"));
