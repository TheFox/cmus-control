# Cmus Control

Control [cmus](https://cmus.github.io/) with Media Keys :rewind: :arrow_forward: :fast_forward: under [OS X](https://en.wikipedia.org/wiki/OS_X).

## Install

Since Cmus Control doesn't have the behavior of changing any foreign processes it's highly recommended to [deactivate the *Remote Control Daemon*](http://blog.fox21.at/2015/11/20/control-cmus-with-media-keys.html).

1. You need to install cmake: `brew install cmake`
2. Run `make` to compile *Cmus Control Daemon*.
3. Run `make install` to install `cmuscontrold` under `/usr/local/bin` path.
	A [launchd.plist](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html) file named `at.fox21.cmuscontrold.plist` will be created under `/Library/LaunchAgents` to start *Cmus Control Daemon* automatically on login.

## Uninstall

Just run `make uninstall`. Doing so

- `cmuscontrold` will be unloaded via [`launchctl`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html);
- `/Library/LaunchAgents/at.fox21.cmuscontrold.plist` will be removed;
- `/usr/local/bin/cmuscontrold` will be removed.

## Load/Unload

After a successful installation the `cmuscontrold` is loaded/started automatically with `launchctl`. You can unload the daemon manually:

	make controld_unload
	
Or load it manually:

	make controld_load

## Re-build

After changing the source code you might want to re-build the binary and re-install it.

1. `make controld_unload`
2. `make -C build/release/target_10.11`
	**Note**: `10.11` means OS X 10.11 target. For example, on OS X 10.9 you need to use `build/release/target_10.9` and so on.
3. `make install`

## Build under various versions of OS X

You can either edit the `Makefile` file or set the environment variable to a different version of OS X.

### Build under OS X 10.8 (Mountain Lion)

	TARGET=10.8 make
	TARGET=10.8 make install

### Build under OS X 10.9 (Mavericks)

	TARGET=10.9 make
	TARGET=10.9 make install

### Build under OS X 10.10 (Yosemite)

	TARGET=10.10 make
	TARGET=10.10 make install

### Build under OS X 10.11 (El Capitan)

	TARGET=10.11 make
	TARGET=10.11 make install

## License
Copyright (C) 2015 Christian Mayer <http://fox21.at>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
