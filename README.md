# :boom: docker-bitcoin-core :boom:
A set of scripts to run a bitcoin-core binary within a docker container.

There is much concern about running a bitcoin core node from other docker containers as one is not truly certain if the code that has been compiled is not tampered with.

This is an attempt to compile the bitcoin-core binaries from [source code](https://github.com/bitcoin/bitcoin) and have them run within a docker container to make it more portable and easier to upgrade between versions.

For more information on how to work with these scripts, refer to this blog [post](https://nolanrumble.com/security/?p=176)
