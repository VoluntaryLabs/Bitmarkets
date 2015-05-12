
#Bitmarkets

Bitmarkets is a protocol and client used to implement a p2p online marketplace client using Bitmessage for communications and Bitcoin for payments.

#compiling

After cloning the git repo, you'll need to init and pull all the submodules by running init.sh and pull.sh. Then you should be able to build and run in Xcode.

To verify/audit the build you'll need to download and compile some of the statically built executables (e.g. python and tor in BitmessageKit) seperately.

#security notes

Bitmarkets talks to the network in three ways:
1. BitcoinJ talks to other Bitcoin nodes via Tor
2. Bitmessage talks to other Bitmessage nodes via Tor
3. plain HTTP requests to blockchain.info are periodically made to get the current Bitcoin exchange rate.


#dev path high priority

- GNUstep port to Linux and Windows
- auto-updates 
- code signed release
- app store release
- automated tests
- ability to choose between bid addresses
- encrypt all client data files and add password login
- move to https://gitian.org for deterministic builds
- https for voluntary

#dev path low priority

- option for using separate pubkey for each post
- ui update, image browsing view option within a category
- support stores with namecoin (a namecoin name to bitmessage address entry)


#links

- website: http://voluntary.net
- twitter: https://twitter.com/voluntarynet

#versions

v0.8.9: 
    - Bitcoinj now uses Tor
    - POW limited to 1 core
    - image attachments auto resized to fit in 32kb JPEG

v0.8.8
    - server launch fix
    - performance improvements 
    -- caching address valid requests
    -- coallessing node notifications
