from i3ipc.aio import Connection
from i3ipc import Event

import asyncio
import logging
logging.basicConfig(level=logging.DEBUG)
async def main():
    def on_window(self, e):
        print(e)

    c = await Connection(auto_reconnect=True).connect()

    workspaces = await c.get_workspaces()

    c.on(Event.WINDOW, on_window)

    await c.command("workspace 7")
    await c.command("exec termite -e cmatrix")
    await c.command("exec pcmanfm")
    await c.command("split v")
    await c.command("exec termite -e bpytop")

    await c.main()

asyncio.get_event_loop().run_until_complete(main())
