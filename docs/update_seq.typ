#import "frontmatter.typ":format, CJc, SMc
#import "@preview/pintorita:0.1.4"
#import "nomenclature.typ": *

#show: format
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

= Channel Updates

== First step

The initiator (usually the merchant) will send an `UpdateBalance` request to the responder (usually the customer). The request contains a `ChannelUpdate` record holding the data necessary to start the update process, including:

 - Some metadata about the update, including the update count and the post-update balances, 
 - The change (`delta`) in the merchant's balance,
 - The proofs attesting to the VCOF, modulo equivalence and DL equivalence.
 

```rust
pub struct ChannelUpdate {
    /// The update counter for the channel. This is incremented every time a new update is sent. 
    /// The initial balance represents update 0.
    pub update_count: u64,
    /// The balances after applying the delta to the current balances
    pub new_balances: Balances,
    /// The change in the *Merchant's* balance
    pub delta: MoneroDelta,
    /// The proof that consecutive one-way function has been applied correctly
    pub vcof_proof: Vec<u8>,
    /// The proof that a secret value is modulo two different values.
    pub mod_eq_proof: Vec<u8>,
    /// The proof that two public keys on different curves come from the equivalent secret key.
    pub dleq_proof: Vec<u8>,
}
```

== Second step

The responder, receives the `ChannelUpdate` record and then

- Checks that `update_count` equals its own update count + 1,
- Asserts that `new_balances` are as expected, after applying `delta` to its own balance.
- Verifies the three proofs. If the proofs fail, the responder returns a `Rejected` response.

The responder then generates its own set of three proofs and responds with its own version of `ChannelUpdate`.

The responder updates its internal state with the new $witness_i$ derived from the proofs as follows:

$
  C = H_"blake2s" ("HEADER" || witness_(i-1)) \
  witness_i = C mod Lbjj \
  T_i = witness_i dot.c Gbjj \
  S_i = witness_i dot.c Ged \
$

This is equivalent to the MoNet protocol step 11:

$
"2P-CLRAS"."NewSW()" => (S^i,(S^i_"Responder", witness^i_"Responder"),P^i_"Responder")
$

== Third Step

The initiator receives the `ChannelUpdate` in the response from the responder and verifies the provided proofs.

This is equivalent to the MoNet protocol step 12:

$
"2P-CLRAS"."CVrfy"((S^(i-1)_"Responder", S^i_"Responder"),P^i_"Responder")
$

The initiator next calculates the new $witness_i$ in the same manner as the responder.

== Fourth Step

The responder

...

This is equivalent to the MoNet protocol step 12:

$
"2P-CLRAS"."CVrfy"((S^(i-1)_"Initiator", S^i_"Initiator"),P^i_"Initiator")
$

...

This is equivalent to the MoNet protocol step 13:

$
"2P-CLRAS"."PSign()" => hat(sigma)^i_"sk"_"Initiator"
$

...


== Fifth Step

...

This is equivalent to the MoNet protocol step 13:

$
"2P-CLRAS"."PSign()" => hat(sigma)^i_"sk"_"Responder"
$

...

= Nomenclature

#nomenclature

= Sequence diagram


```//pintora - slows down rendering. remove later
sequenceDiagram
   participant I as Initiator
   participant R as Responder
   I->>I: Create proofsI
   I->>R: UpdateChannel(proofsI)
   R->>R: Verify Proofs
   alt verification fails
      R->>I: Rejected
   else verification passes
     R->>R: Create proofsR
     R->>I: UpdateChannel(ProofsR)
  end
  I->>R: anything else??
```

