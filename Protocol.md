
#Bitmarkets

Bitmarkets is a protocol and client used to implement a p2p online marketplace client using Bitmessage for communications and Bitcoin for payments.

##Protocol Specification

###Message format

All messages are sent as JSON dictionaries in a Bitmessage message set to use the "SIMPLE" encoding with the JSON in the body section of the message. The Bitmessage message's subject field is ignored by the protocol.

###Message types
