
#Bitmarkets

Bitmarkets is a protocol and client used to implement a p2p online marketplace client using Bitmessage for communications and Bitcoin for payments.

#compiling

After cloning the git repo, you'll need to init and pull all the submodules by running init.sh and pull.sh. Then you should be able to build and run in Xcode.

To verify/audit the build you'll need to download and compile some of the statically built executables (e.g. python and tor in BitmessageKit) seperately.

#notes

- no, we don't trust tor

#development path

- sparkle or other auto-update integration
- automated tests
- ability to choose between bid addresses
- address whitelist&blacklist, personal ratings and comments
- password client login, encrypt client data files
- ui update, image browsing view option within a category
- support stores with namecoin (a namecoin name to bitmessage address entry)
- consider alternatives to tor e.g. onion routing via bitmessage?
- consider open source multi-platform options
- user defined post filter 

#links

- website: http://voluntary.net
- twitter: https://twitter.com/voluntarynet