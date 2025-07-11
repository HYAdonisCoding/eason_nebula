// server.js
const WebSocket = require("ws");

const wss = new WebSocket.Server({ port: 8080 }, () => {
  console.log("✅ WebSocket server started on ws://localhost:8080");
});

wss.on("connection", function connection(ws) {
  console.log("🔌 New client connected");

  ws.on("message", function message(data) {
    console.log("📨 Received:", data.toString());
    ws.send(`Echo: ${data}`); // 回显消息
  });

  ws.on("close", () => {
    console.log("❌ Client disconnected");
  });
});

console.log("🚀 Server started on http://localhost:8080");