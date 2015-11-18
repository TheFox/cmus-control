# Cmus Control

Control [cmus](https://cmus.github.io/) with Media Keys under [OS X](https://en.wikipedia.org/wiki/OS_X).

## Install

It's recommended to deactivate *Remote Control Daemon* to use *Cmus Control Daemon*.

1. Run `make` to compile *Cmus Control Daemon*.
2. Run `make install` to install `cmuscontrold` under `/usr/local/bin` path.
	A [launchd.plist](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html) file named `at.fox21.cmuscontrold.plist` will be created under `/Library/LaunchAgents` to start *Cmus Control Daemon* on login.

## Uninstall

Just run `make uninstall`. Doing so

- `cmuscontrold` will be unloaded via [`launchctl`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html);
- `/Library/LaunchAgents/at.fox21.cmuscontrold.plist` will be removed;
- `/usr/local/bin/cmuscontrold` will be removed.

## License
Copyright (C) 2015 Christian Mayer <http://fox21.at>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
