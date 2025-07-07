# friendlyMOTD

A simple, colorful terminal MOTD script. Shows ASCII art, a message, and time-based greetings (morning, afternoon, evening). Displays once per time period per day.

## Features

- Time-based greetings
- ASCII art (camel, wolf, cat)
- Optional time and borders
- One-time daily display (log-based)

## Install

Copy to `/usr/local/bin`:

```bash
sudo cp friendlymotd.sh /usr/local/bin/friendlymotd
sudo chmod +x /usr/local/bin/friendlymotd
```

Add to `~/.bashrc` or `~/.profile`:

```bash
if [ -n "$SSH_CONNECTION" ]; then
  /usr/local/bin/friendlymotd
fi
```

## Manual Usage

```bash
friendlymotd [-m <msg>] [-a <ascii>] [-t true|false] [-b true|false]
```

Flags:
- `-m` Set message
- `-a` ASCII art (camel, wolf, cat)
- `-t` Show time (`true` or `false`)
- `-b` Show border (`true` or `false`)
- `-r` Reset daily log
- `-h` Help

## Example

```bash
friendlymotd -m "welcome back $USER" -a camel -t true -b false
```
