#import "frontmatter.typ":format, CJc, SMc
#import "@preview/pintorita:0.1.4"

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

The responder updates its internal state with the new $omega_i$ derived from the proofs as follows:

$
  C = H_"blake2s" ("HEADER" || omega_(i-1)) \
  omega_i = C mod L_"BabyJubjub" \
  T_i = omega_i dot.c G_"BabyJubjub" \
  S_i = omega_i dot.c G_"Ed25519" \
$

This is equivalent to the MoNet protocol step 11:

$
"2P-CLRAS"."NewSW()" => (S^i,(S^i_X, omega^i_X),P^i_X)
$

== Third Step

The initiator receives the `ChannelUpdate` in the response from the responder and verifies the provided proofs.

This is equivalent to the MoNet protocol step 12:

$
"2P-CLRAS"."CVrfy"((S^(i-1)_X, S^i_X),P^i_X)
$

#CJc["I feel like there needs to be another step here where the outputs of the proofs get combined or something."

The above step 2 and 3 are MoNet steps 11 and 12 exactly. But we need to sequence step 13 which performs the unadapted signature generation and is interactive so requires 2 actual steps.]

The initiator next calculates the new $omega_i$ in the same manner as the responder.

== Fourth Step

...

This is equivalent to the MoNet protocol step 11:

$
"2P-CLRAS"."PSign()" => hat(sigma)^i_"sk"_X
$


== Fifth Step

...

= Sequence diagram


```pintora
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

