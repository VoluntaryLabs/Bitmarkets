
#Bitmarkets

Bitmarkets is a protocol and client used to implement a p2p online marketplace client using Bitmessage for communications and Bitcoin for payments.

#compiling

After cloning the git repo, you'll need to init and pull all the submodules by running init.sh and pull.sh. Then you should be able to build and run in Xcode.

To verify/audit the build you'll need to download and compile some of the statically built executables (e.g. python and tor in BitmessageKit) seperately.

#development path high priority

- auto-updates 
- code signed release
- app store release
- automated tests
- ability to choose between bid addresses
- encrypt all client data files and add password login
- move to https://gitian.org for deterministic builds
- https for voluntary

#development path low priority

- option for using separate pubkey for each post
- ui update, image browsing view option within a category
- support stores with namecoin (a namecoin name to bitmessage address entry)
- consider open source multi-platform options
- user defined post filter 

#links

- website: http://voluntary.net
- twitter: https://twitter.com/voluntarynet

#notes

- no, we don't trust tor