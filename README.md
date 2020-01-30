# Cmus Control

Control [cmus](https://cmus.github.io/) with Media Keys :rewind: :arrow_forward: :fast_forward: under [macOS](https://en.wikipedia.org/wiki/MacOS).

## Project Outlines

The project outlines as described in my blog post about [Open Source Software Collaboration](https://blog.fox21.at/2019/02/21/open-source-software-collaboration.html).

- The main purpose of this software is to provide a support for cmus under macOS. Cmus can be controlled by the Media Keys of your Apple Keyboard.
- The feature-set is restricted because this software already provides the features what it was made of. But still, feel free to request features.

## Requirements

- At least **macOS 10.8**.
- `cmake` to build it.
- Since Cmus Control doesn't have the behavior of changing any foreign processes it's highly recommended to [deactivate the *Remote Control Daemon*](https://blog.fox21.at/2015/11/20/control-cmus-with-media-keys.html).
- [cmus](https://cmus.github.io/) installed. ;)

## Install

You can either install Cmus Control via [Homebrew](#homebrew-installation) or [manually](#manually-installation). The preferred method of installation is via Homebrew.

### Homebrew installation

1. Add the [`thefox/brewery`](https://github.com/TheFox/homebrew-brewery) tap to brew.
	
	```bash
	$ brew tap thefox/brewery
	```

2. Actual installation
	
	```bash
	$ brew install cmus-control
	```

3. After a successful installation follow the Caveats output, start the service:
	
	```bash
	$ brew services start thefox/brewery/cmus-control
	```
	
	Or, if you don't want/need a background service you can just run
	
	```bash
	$ cmuscontrold
	```

### Manual installation

1. You need to install cmake: `brew install cmake`
2. Run `make install` to compile *Cmus Control Daemon* and install `cmuscontrold` under `/usr/local/bin` path.
	A [launchd.plist](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html) file named `at.fox21.cmuscontrold.plist` will be created under `~/Library/LaunchAgents` to start *Cmus Control Daemon* automatically on login.

If you just want to compile *Cmus Control Daemon* without installing run `make`. The binary will be created at `build/release/bin/cmuscontrold`.

#### Uninstall

Just run `make uninstall`. Doing so

- `cmuscontrold` will be unloaded via [`launchctl`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html);
- `~/Library/LaunchAgents/at.fox21.cmuscontrold.plist` will be removed;
- `/usr/local/bin/cmuscontrold` will be removed.

#### Load/Unload

After a successful manual installation the `cmuscontrold` is loaded/started automatically with `launchctl`. You can unload the daemon manually:

```bash
$ make unload
```

Or load it manually:

```bash
$ make load
```

#### Re-build

After changing the source code you might want to re-build the binary and re-install it.

```bash
make unload
make -C build/release
make install
```
