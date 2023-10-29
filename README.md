# DaemonExample

Simple app with daemon extension to check corner cases and possible linker issues in nested architecture:
- Framework A ( Framework B )
- SPM A ( SPM B )

Daemon and app can talk to each other using High Level XPC connection (here we can use Foundation and operate with objects)

Obligations: "as is", not guarantied ;)
License: MIT
