---
name: adb-startup
description: Get adb working on this tablet, usually after a restart. Use when Jack asks to start or fix adb, or when `adb` shows no device or refuses the connection.
---

Bring up adbd's TCP mode with Jack's help. Android resets it on restart, and only he can turn on Wireless Debugging.

1. Run `adb-tcp-up`. It can take a minute because it scans for the Wireless Debugging port.
2. Act on the exit code:
   - **0:** adb is ready at `127.0.0.1:5555`. Stop here.
   - **3:** Wireless Debugging is off. Ask Jack to turn it on in Settings > System > Developer options > Wireless debugging, then rerun step 1.
   - **4:** this tablet isn't paired with itself. Ask Jack to tap "Pair device with pairing code" there and send you the port and six-digit code. A split-screen or floating Settings window keeps the dialog open. Run `adb pair 127.0.0.1:<port> <code>`, then rerun step 1.
   - **5:** adbd didn't return on 5555. Show Jack the output and rerun once.
3. If adb shows `unauthorized`, ask Jack to approve the prompt on screen, ticking "Always allow".

Only run this when adb is needed. Being asked to start adb doesn't remove the rule about asking before using it for anything else.
