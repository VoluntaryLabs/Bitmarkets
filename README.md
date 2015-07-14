
![Join the chat at https://gitter.im/Voluntarynet](https://badges.gitter.im/Join%20Chat.svg)

#Bitmarkets

Bitmarkets is a protocol and client used to implement a p2p online marketplace client using Bitmessage for communications and Bitcoin for payments.

#compiling

After cloning the git repo, you'll need to init and pull all the submodules by running init.sh and pull.sh. Then you should be able to build and run in Xcode.

To verify/audit the build you'll need to download and compile some of the statically built executables (e.g. python and tor in BitmessageKit) seperately.

#security notes

Bitmarkets talks to the network in three ways:
1. BitcoinJ talks to other Bitcoin nodes via Tor
2. Bitmessage talks to other Bitmessage nodes via Tor
3. Plain HTTP requests to blockchain.info are periodically made to get the current Bitcoin exchange rate.

Client side files are not currently encrypted. We recommend at least using FileVault.


#dev path high priority

- GNUstep port to Linux and Windows
- ability to choose between bid addresses
- auto-updates 
- code signed release
- app store release
- automated tests
- encrypt all client data files and add password login
- move to https://gitian.org for deterministic builds
- https for voluntary

#dev path low priority

- use ntimelock to (among other things) avoid utx pollution for transactions that fail to reach agreement
- option for using separate pubkey for each post
- support stores with namecoin (a namecoin name to bitmessage address entry)
- ui update, image browsing view option within a category


#links

- website: http://voluntary.net
- twitter: https://twitter.com/voluntarynet


#architecture notes

On starting, the app launches three child processes: 

1) a Tor server, which is used by the Bitmessage and BitcoinJ servers use to route their communications to the Bitmessage network and Bitcoin network (respectively) through the Tor network.

2) a Bitmessage server, which is used for posting sales to a public Bitmessage channel and for sending messages between buyers and sellers to 1) place and accept bids 2) setup escrow 3) send physical delivery address to seller 4) release escrow via payment or refund

3) a BitcoinJ server, which is used as the app's' Bitcoin wallet and to construct and trackthe escrow transactions.


#versions

v0.8.9: 
- BitcoinJ now uses Tor
- POW limited to 1 core
- image attachments auto resized to fit in 32kb JPEG

v0.8.8
- server launch fix
- performance improvements 
-- caching address valid requests
-- coallessing node notifications
