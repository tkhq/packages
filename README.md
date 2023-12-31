# Packages

Minimalism and security first repository of reproducible and signed OCI images
of common open source software packages built from source.

These can be used as a secure supply chain for anything from obtaining local
tools, to bootstrapping a Linux distribution.

## Background

We have learned a lot of lessons about supply chain integrity over the years,
and the greatest of them may be that any system that is complex to review and
assigns trust of significant components to single human points of failure, is
doomed to have failure.

Most linux distributions rely on complex package management systems for which
only a single implementation exists. They assign package signing privileges to
individual maintainers at best. Modern popular distros often fail to even do
this, having a central machine somewhere blindly signing all unsigned
contributions from the public.

We will cover an exhaustive comparison of the supply chain strategies of other
package management solutions elsewhere, but suffice to say while many are
pursuing reproducible builds, minimalism, or signing... any one solution
delivering on all of these does not seem in the cards any time soon.

This is generally a human problem. Most solutions end up generating a lot of
custom tooling for package management, which in turn rapidly grows in
complexity to meet demands ranging from hobby desktop systems production
servers.

This complexity demands a lot of cycles to maintain, and this means in practice
lowering the barrier to entry to allow any hobbyist to contribute and maintain
packages with minimal friction and rarely a requirement of signing keys or
mandatory reproducible builds, let alone multiple signed reproduction proofs.

Suffice to say, we feel every current Linux package management solution and
container supply chain has single points of human failure, or review
complexity, that makes it undesirable for threat models that assume any single
human can be hacked or coerced.

## Goals

Not all of these goals are realized yet, but should at least help you decide
if this project is something you want to contribute to or keep an eye on for
the future.

### Integrity

* Anyone can reproduce the entire tree with tools from their current distro
* Hosted CI servers auto-sign confirmed deterministic builds
    * Like NixOS
* Maintainers sign all package additions/changes
    * Like Gentoo, Debian, Fedora, Guix
* Reviewers locally build and counter-sign all new binary packages
    * No one does this, as far as we can tell.

### Reproducibility

* Trust no single external source of binaries
    * Bootstrap from two different third party signed distros
* Never use external binaries
    * Bootstrap from 0, always, even if it means going back in time
        * Go, rust require extensive work to bootstrap all the way back to gcc
        * Guix is the only distro that does this for rust to our knowledge
* Full-Source Bootstrap from x86_64 assembly
    * Take maximum advantage of the hard won wins by the Guix team
    * Bootstrap from guile driver reproduced on multiple signed distros

### Minimalism

* Based on musl libc
    * Basis of successful minimal distros like Alpine, Adelie, Talos, Void
    * Implemented with about 1/4 the code of glibc
    * Required to produce portable static binaries in some languages
    * Less prone to buffer overflows
    * Puts being light, fast, and correct before compatibility
* Package using tools you already have
    * OCI build tool of choice (Docker, Buildah, Podman)
    * Make (for dependency management)
    * Prove hashes of bootstrap layer builds match before proceeding
* Keep package definitions lean and readable with simple CLI and no magic

## Building

### Requirements

* An OCI building runtime
    * Currently Docker supported, but will support buildah and podman
* Gnu Make

### Examples

#### Compile all packages

```
make
```

#### Compile specific package

```
make out/rust.tgz
```

#### Reproduce all changed packages

```
make reproduce
```

#### Reproduce all packages without cache

```
make clean reproduce
```

#### Sign current manifest of package hashes

```
make sign
```

## Packaging

Every package should have a minimum of 5 stages as follows

* base
    * based on busybox or bootstrap
    * Runs as unprivileged user 1000 (user)
    * Sets environment to be shared with fetch, build, and install stages
    * Imports dependencies for fetch, build, and install stages
* fetch
    * Based on "base"
    * Runs as unprivileged user 1000 (user)
    * Has internet access
    * Obtains any needed source files from the internet
    * Verifies sources against hardcoded hashes
* build
    * Based on "fetch"
    * Runs as unprivileged user 1000 (user)
    * Extract sources
    * Apply any patches as needed
    * Build any artifacts as needed
* install
    * Based on "build"
    * Elevates privileges to user 0:0 (root)
    * Installs all files in /home/user/rootfs owned by root
    * Sets all timestamps in /home/user/rootfs to @0 (Unix Epoch)
* package
    * Based on scratch
    * Copies /home/user/rootfs from "install" to /
    * Sets runtime user/perms/env as needed

## Sponsors

- Turnkey
- Distrust
- Mysten Labs
