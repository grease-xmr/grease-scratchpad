#import "frontmatter.typ":format
#show: format

= Grease ZKP operations

The Grease protocol requires the creation and sharing of a series of Zero Knowledge proofs (ZKPs) as part of the lifetime of a payment channel. Most are Non-Interactive Zero Knowledge (NIZK) proofs in the form Turing-complete circuits created using newly-established Plonky-based proving protocols. The others are classical interactive protocols with verification.

The Grease protocol operates in four stages: initialization, update, closure and dispute. The ZKPs are used only in the initialization and update stage, as the closure and dispute do not need further verification to complete.

== Stages

=== Initialization

==== Motivation

...

==== Preliminary

For the initialization stage to begin, the peers must agree upon a small amount of information:

#table(
  columns: 2,
  table.cell(colspan: 2, [*Before Initialization*]),
  [*Resource*], [],
  [Channel ID], [The identifier of the private communications channel. This will include the public key identifier of the peers and information about the means of communications between them.],
  [Locked Amount], [The two values in XMR (with either but not both allowed as zero) that the peers will lock into the channel during its lifetime.],
)

==== MoNet: Before

The *MoNet* protocol specifies that the peers must agree upon the following using the defined classical interactive protocols with verification:

#table(
  columns: 2,
  table.cell(colspan: 2, [*Before Initialization*]),
  [*Resource*], [],
  [Monero Funding Wallet], [Each peer must have a source wallet with its private spend key. This wallet will need to have at least the *Locked Amount* available.],
  [Monero Refund Wallet], [Each peer must have a destination wallet with its public key. This wallet will store the refunded XMR value after the channel is closed. The peer must have the private view key of this wallet, but does not need to have the private spend key.],
)

...

==== Grease: Before

At the start of the initialization stage the peers provide each other with the following resources and information:

#table(
  columns: 3,
  table.cell(colspan: 3, [*Before Initialization*]),
  [*Resource*], [*Visibility*], [],
  [$Pi_"peer"$], [Public], [The public key/curve point on Baby Jubjub for the peer],
  [$Pi_"KES"$], [Public], [The public key/curve point on Baby Jubjub for the KES],
  [$nu_"peer"$], [Public], [Random 251 bit value, provided by the peer (`nonce_peer`)],
)

...

==== Grease: During

...

==== Inputs:
#table(
  columns: 3,
  table.cell(colspan: 3, [*During Initialization*]),
  [*Input*], [*Visibility*], [],
  [$nu_omega_0$], [Private], [Random 251 bit value (`blinding`)],
  [$a_1$], [Private], [Random 251 bit value],
  [$nu_1$], [Private], [Random 251 bit value (`r_1`)],
  [$nu_2$], [Private], [Random 251 bit value (`r_2`)],
  [$nu_"DLEQ"$], [Private], [Random 251 bit value (`blinding_DLEQ`)],
)

...

==== Outputs:
#table(
  columns: 3,
  table.cell(colspan: 3, [*During Initialization*]),
  [*Output*], [*Visibility*], [],
  [$T_0$], [Public], [The public key/curve point on Baby Jubjub for $omega_0$],
  [$omega_0$], [Private], [The root private key protecting access to the user's locked value (`witness_0`)],
  [$c_1$], [Public], [`Feldman commitment 1` (used in tandem with `Feldman commitment 0` $=T_0$), which is a public key/curve point on Baby Jubjub],
  [$sigma_1$], [Private], [The split of $omega_0$ shared with the peer (`share_1`)],
  [$Phi_1$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation to the peer (`fi_1`)],
  [$chi_1$], [Public], [The encrypted value of $sigma_1$ (`enc_1`)],
  [$sigma_2$], [Private], [The split of $omega_0$ shared with the KES (`share_2`)],
  [$Phi_2$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation to the KES (`fi_2`)],
  [$chi_2$], [Public], [The encrypted value of $sigma_2$ (`enc_2`)],
  [$S_0$], [Public], [The public key/curve point on Ed25519 for $omega_0$],
  [C], [Public], [The Fiat–Shamir heuristic challenge (`challenge_bytes`)],
  [$Delta_"BabyJubjub"$], [Private], [Optimization parameter (`response_div_BabyJubjub`)],
  [$rho_"BabyJubjub"$], [Public], [The Fiat–Shamir heuristic challenge response on the Baby Jubjub curve (`response_BabyJubJub`)],
  [$Delta_"Ed25519"$], [Private], [Optimization parameter (`response_div_BabyJubJub`)],
  [$rho_"Ed25519"$], [Public], [The Fiat–Shamir heuristic challenge response on the Ed25519 curve (`response_div_ed25519`)],
)

...

The following ZKP operations are performed during initialization:

- *VerifyWitness0*
- *VerifyWitnessSharing*
- *VerifyEquivalentModulo*
- *VerifyDLEQ*

...

==== MoNet: After

Once the Grease ZKP operations are complete, the *MoNet* protocol continues and produces the following outputs:

...

==== Outputs:
#table(
  columns: 3,
  table.cell(colspan: 3, [*After Initialization*]),
  [*Output*], [*Visibility*], [],
  [$T_x_f$], [Public], [...],
  [$s_f$], [Public], [...],
  [$s_f_"peer"$], [Public], [...],
  [$T_x_c$], [Public], [...The unsigned Monero transaction for closing the channel. This can be completed only by the full knowledge of $sigma_c$ and $sigma_c_"peer"$...],
  [$hat(sigma)_c$], [Public], [...The unadapted signature for $sigma_c$ and hence $T_x_c$...],
  [$S_0$], [Public], [The public key/curve point on Ed25519 for $omega_0$. This is used to prove that $hat(sigma)_"c"$ is a valid unadapted signature for $sigma_"c"$ and hence $T_x_c$.],
  [$sigma_c$], [Private], [...The adapted signature for $sigma_c$ and hence $T_x_c$...],
  [$hat(sigma)_c_"peer"$], [Public], [...The unadapted signature for $sigma_c_"peer"$ and hence $T_x_c_"peer"$...],
  [$S_0_"peer"$], [Public], [The public key/curve point on Ed25519 for the other peer's $omega_0$. This is used to prove that $hat(sigma)_c_"peer"$ is a valid unadapted signature for $sigma_c_"peer"$ and hence $T_x_c_"peer"$.],
  [$sigma_c_"peer"$], [Private], [...The adapted signature for $sigma_c_"peer"$ and hence $T_x_c_"peer"$...],
)

With these outputs the the initialization stage is complete and the channel is open. The peers can now transact and update the channel state or close the channel and receive the locked XMR value in the *Monero Refund Wallet*.

=== Update

During the update stage, the following operations are performed:

- *VerifyCOF*
- *VerifyEquivalentModulo*
- *VerifyDLEQ*

...

== Operations

=== VerifyWitness0

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$nu_"peer"$], [Public], [Random 251 bit value, provided by the peer (`nonce_peer`)],
  [$nu_omega_0$], [Private], [Random 251 bit value (`blinding`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$T_0$], [Public], [The public key/curve point on Baby Jubjub for $omega_0$],
  [$omega_0$], [Private], [The root private key protecting access to the user's locked value (`witness_0`)],
)

==== Summary

The *VerifyWitness0* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It receives the provided random entropy inputs and produces the deterministic outputs. The circuit is ZK across the inputs, so no information is gained about the private inputs even with knowledge of the private output. The $T_0$ output is used for the further *VerifyEquivalentModulo* and *VerifyDLEQ* operations.

The operation uses the *blake2s* hashing function for its one-way random oracle simulation.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

==== Methods

$
  C = H_"blake2s" ("HEADER" || nu_"peer" || nu_omega_0) \
  omega_0 = C mod L_"BabyJubjub" \
  T_0 = omega_0 dot.c G_"BabyJubjub"
$

=== FeldmanSecretShare_2_of_2

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$omega_0$], [Private], [The root private key protecting access to the user's locked value (`secret`)],
  [$a_1$], [Private], [Random 251 bit value],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$T_0$], [Public], [Feldman commitment 0, which is the public key/curve point on Baby Jubjub for $omega_0$],
  [$c_1$], [Public], [Feldman commitment 1, which is a public key/curve point on Baby Jubjub],
  [$sigma_1$], [Private], [The split of $omega_0$ shared with the peer (`share_1`)],
  [$sigma_2$], [Private], [The split of $omega_0$ shared with the KES (`share_2`)],
)

==== Summary

The *FeldmanSecretShare_2_of_2* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It receives the provided secret data and random entropy inputs. The output are the two perfectly binding Feldman commitments and the two encoded split shares to send to the destinations. The circuit is not ZK across the inputs so so that full knowledge of the private outputs can reconstruct the private inputs.

The outputs are used for the further *VerifyEncryptMessage*, *VerifyFeldmanSecretShare_peer*, *VerifyFeldmanSecretShare_KES*, and *ReconstructFeldmanSecretShare_2_of_2* operations.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

Note that for the peer to verify the validity of the secret sharing protocol, the calculation is:
$
  "VerifyFeldmanSecretShare_peer"(T_0, c_1, sigma_1)
$


Note that for the KES to verify the validity of the secret sharing protocol, the calculation is:
$
  "VerifyFeldmanSecretShare_KES"(T_0, c_1, sigma_2)
$

Note that for reconstructing the secret input $omega_0$, the calculation is:
$
  omega_0 = "ReconstructFeldmanSecretShare_2_of_2"(sigma_1, sigma_2)
$

==== Methods

$
  c_1 = a_1 dot.c G_"BabyJubjub" \
  sigma_1 = -(omega_0 + a_1) mod L_"BabyJubjub" \
  sigma_2 = 2*omega_0 + a_1 mod L_"BabyJubjub"
$


=== ReconstructFeldmanSecretShare_2_of_2

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$sigma_1$], [Private], [The split of $omega_0$ shared with the peer (`share_1`)],
  [$sigma_2$], [Private], [The split of $omega_0$ shared with the KES (`share_2`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$omega_0$], [Private], [The root private key protecting access to the user's locked value (`secret`)],
)

==== Summary

The *ReconstructFeldmanSecretShare_2_of_2* operation is a reconstruction protocol and is language independent. It receives the two split shares as inputs and outputs the original $omega_0$ secret.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

==== Methods

$
  omega_0 = sigma_1 + sigma_2 mod L_"BabyJubjub"
$

=== VerifyFeldmanSecretShare_peer

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$T_0$], [Public], [Feldman commitment 0, which is the public key/curve point on Baby Jubjub for $omega_0$],
  [$c_1$], [Public], [Feldman commitment 1, which is a public key/curve point on Baby Jubjub],
  [$sigma_1$], [Private], [The split of $omega_0$ shared with the peer (`share_1`)],
)

==== Outputs:

There are no outputs.

==== Summary

The *VerifyFeldmanSecretShare_peer* operation is a verification protocol and is language independent. This operation is redundant, in that the successful verification of the previous *FeldmanSecretShare_2_of_2* operation with the same publicly visible parameters implies that this operation will succeed.

==== Methods

$
  "assert"(sigma_1 dot.c G_"BabyJubjub" == -(T_0 + c_1))
$

=== VerifyFeldmanSecretShare_KES

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$T_0$], [Public], [Feldman commitment 0, which is the public key/curve point on Baby Jubjub for $omega_0$],
  [$c_1$], [Public], [Feldman commitment 1, which is a public key/curve point on Baby Jubjub],
  [$sigma_2$], [Private], [The split of $omega_0$ shared with the KES (`share_2`)],
)

==== Outputs:

There are no outputs.

==== Summary

The *VerifyFeldmanSecretShare_peer* operation is a verification protocol and is language independent. This operation is not redundant, in that the successful verification of the previous *FeldmanSecretShare_2_of_2* operation with the same publicly visible parameters implies that this operation will succeed, but the conditions are different.

This operation will be implemented by the KES in its own native implementation language where the successful verification of the previous *FeldmanSecretShare_2_of_2* operation cannot be assumed. As such, this operation will exist and can called independently of any other operations.

==== Methods

$
  "assert"(sigma_2 dot.c G_"BabyJubjub" == 2 dot.c T_0 + c_1)
$

=== VerifyEncryptMessage

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$sigma$], [Private], [The secret 251 bit message (`message`)],
  [$nu$], [Private], [Random 251 bit value (`r`)],
  [$Pi$], [Public], [The public key/curve point on Baby Jubjub for the destination],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$Phi$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation (`fi`)],
  [$chi$], [Public], [The encrypted value of $sigma$ (`enc`)],
)

==== Summary

The *VerifyEncryptMessage* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It receives the provided secret data and random entropy inputs. The output are the perfectly binding public key commitment and the perfectly hiding encrypted scaler value to send to the destinations. The circuit is ZK across the inputs since the outputs are publicly visible.

The method of encryption is the ECDH (Elliptic-curve Diffie–Hellman) key agreement protocol. The operation uses the *blake2s* hashing function for its shared secret commitment simulation. Note that the unpacked form of the ephemeral key is used for hashing, instead of the standard $"PACKED"()$ function.

Note that for reconstructing the secret input $sigma$ given the private key $kappa$ where $Pi = kappa dot.c G_"BabyJubjub"$, the calculation is:

$
  (Pi, sigma) = "DecryptMessage"(kappa, Phi, chi) \
$

Note that this operation does not call for the use of HMAC or other message verification protocol due to the simplicity of the interactive steps and their resistance to message tampering. A more complicated or distributed protocol would requires this attack prevention.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

==== Methods

$
  Phi = nu dot.c G_"BabyJubjub" \
  nu_Pi = nu dot.c Pi \
  C = H_"blake2s" (nu_Pi."x" || nu_Pi."y") \
  s = C mod L_"BabyJubjub" \
  chi = sigma + s mod L_"BabyJubjub" \
$

=== DecryptMessage

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$kappa$], [Private], [The private key for the public key $Pi$],
  [$Phi$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation (`fi`)],
  [$chi$], [Public], [The encrypted value of $sigma$ (`enc`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$Pi$], [Public], [The public key/curve point on Baby Jubjub for the destination],
  [$sigma$], [Private], [The secret 251 bit message (`message`)],
)

==== Summary

The *DecryptMessage* operation is a verification protocol and is language independent.

The method of decryption is the ECDH (Elliptic-curve Diffie–Hellman) key agreement protocol. The operation uses the *blake2s* hashing function for its shared secret commitment simulation. Note that the unpacked form of the ephemeral key is used for hashing, instead of the standard $"PACKED"()$ function.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

==== Methods

$
  Pi = kappa dot.c G_"BabyJubjub" \
  kappa_Phi = kappa dot.c Phi \
  C = H_"blake2s" (kappa_Phi."x" || kappa_Phi."y") \
  s = C mod L_"BabyJubjub" \
  sigma = chi - s mod L_"BabyJubjub" \
$

=== VerifyWitnessSharing

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$omega_0$], [Private], [The root private key protecting access to the user's locked value (`witness_0`)],
  [$a_1$], [Private], [Random 251 bit value],
  [$nu_1$], [Private], [Random 251 bit value (`r_1`)],
  [$Pi_"peer"$], [Public], [The public key/curve point on Baby Jubjub for the peer],
  [$nu_2$], [Private], [Random 251 bit value (`r_2`)],
  [$Pi_"KES"$], [Public], [The public key/curve point on Baby Jubjub for the KES],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$c_1$], [Public], [`Feldman commitment 1` (used in tandem with `Feldman commitment 0` $=T_0$), which is a public key/curve point on Baby Jubjub],
  [$sigma_1$], [Private], [The split of $omega_0$ shared with the peer (`share_1`)],
  [$Phi_1$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation to the peer (`fi_1`)],
  [$chi_1$], [Public], [The encrypted value of $sigma_1$ (`enc_1`)],
  [$sigma_2$], [Private], [The split of $omega_0$ shared with the KES (`share_2`)],
  [$Phi_2$], [Public], [The ephemeral public key/curve point on Baby Jubjub for message transportation to the KES (`fi_2`)],
  [$chi_2$], [Public], [The encrypted value of $sigma_2$ (`enc_2`)],
)

==== Summary

The *VerifyWitnessSharing* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It passes through the the provided inputs and calls the *FeldmanSecretShare_2_of_2* and *VerifyEncryptMessage* operations.

==== Methods

$
  (c_1,sigma_1,sigma_2) = "FeldmanSecretShare_2_of_2"(omega_0,a_1) \
  (Phi_1,chi_1) = "VerifyEncryptMessage"(sigma_1,nu_1,Pi_"peer") \
  (Phi_2,chi_2) = "VerifyEncryptMessage"(sigma_2,nu_2,Pi_"KES") \
$

=== VerifyCOF


==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$omega_(i-1)$], [Private], [The current private key protecting access to close the payment channel (`witness_im1`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$T_(i-1)$], [Public], [The public key/curve point on Baby Jubjub for $omega_(i-1)$],
  [$T_i$], [Public], [The public key/curve point on Baby Jubjub for $omega_i$],
  [$omega_i$], [Private], [The next private private key protecting access to close the payment channel (`witness_i`)],
)

==== Summary

The *VerifyCOF* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It receives the provided deterministic input and produces the deterministic outputs. The circuit is ZK across the inputs, so no information is gained about the private input even with knowledge of the private output. The $T_i$ output is used for the further *VerifyEquivalentModulo* and *VerifyDLEQ* operations.

The operation uses the *blake2s* hashing function for its one-way random oracle simulation.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$.

==== Methods

$
  T_(i-1) = omega_(i-1) dot.c G_"BabyJubjub" \
  C = H_"blake2s" ("HEADER" || omega_(i-1)) \
  omega_i = C mod L_"BabyJubjub" \
  T_i = omega_i dot.c G_"BabyJubjub" \
$

=== VerifyEquivalentModulo

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$omega_i$], [Private], [The current private key protecting access to close the payment channel (`witness_i`)],
  [$nu_"DLEQ"$], [Private], [Random 251 bit value (`blinding_DLEQ`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$T_i$], [Public], [The public key/curve point on Baby Jubjub for $omega_i$],
  [$S_i$], [Public], [The public key/curve point on Ed25519 for $omega_i$],
  [C], [Public], [The Fiat–Shamir heuristic challenge (`challenge_bytes`)],
  [$Delta_"BabyJubjub"$], [Private], [Optimization parameter (`response_div_BabyJubjub`)],
  [$rho_"BabyJubjub"$], [Public], [The Fiat–Shamir heuristic challenge response on the Baby Jubjub curve (`response_BabyJubJub`)],
  [$Delta_"Ed25519"$], [Private], [Optimization parameter (`response_div_BabyJubJub`)],
  [$rho_"Ed25519"$], [Public], [The Fiat–Shamir heuristic challenge response on the Ed25519 curve (`response_div_ed25519`)],
)

==== Summary

The *VerifyEquivalentModulo* operation is a Noir ZK circuit using the UltraHonk prover/verifier. It receives the provided deterministic and random entropy inputs and produces the random outputs. The circuit is not ZK across the inputs since part of the private outputs can be used to reveal information about the private input. The $T_i$, $S_i$, $rho_"BabyJubjub"$, and $rho_"Ed25519"$ outputs are used for the further *VerifyDLEQ* operation.


This operation proves that the two separate ephemeral $rho$ outputs are both modulo equivalent values determined from the same root value. This ensures that there is no need to compress the embedded size of secret data values transported across the different group orders of the Baby Jubjub and Ed25519 curves, and also avoids the need for the random abort process as specified here: https://eprint.iacr.org/2022/1593.pdf

Note that the $Delta_"BabyJubjub"$ and $Delta_"Ed25519"$ outputs are used only for optimization of the Noir ZK circuit and may be removed as part of information leakage prevention.

The operation uses the *blake2s* hashing function for its Fiat–Shamir heuristic random oracle model simulation.

The scalar order of the Baby Jubjub curve is represented here by $L_"BabyJubjub"$. The scalar order of the Ed25519 curve is represented here by $L_"Ed25519"$. 

==== Methods

$
  T_i = omega_i dot.c G_"BabyJubjub" \
  S_i = omega_i dot.c G_"Ed25519" \
  C = H_"blake2s" ("HEADER" || "PACKED"(T_i) || "PACKED"(S_i)) \
  rho = omega_i * C - nu_"DLEQ" \
  rho_"BabyJubjub" = rho mod L_"BabyJubjub" \
  Delta_"BabyJubjub" = (rho - rho_"BabyJubjub") / L_"BabyJubjub" \
  rho_"Ed25519" = rho mod L_"Ed25519" \
  Delta_"Ed25519" = (rho - rho_"Ed25519") / L_"Ed25519" \
$

=== VerifyDLEQ

==== Inputs:
#table(
  columns: 3,
  [*Input*], [*Visibility*], [],
  [$T_i$], [Public], [The public key/curve point on Baby Jubjub for $omega_i$],
  [$rho_"BabyJubjub"$], [Public], [The Fiat–Shamir heuristic challenge response on the Baby Jubjub curve (`response_BabyJubJub`)],
  [$S_i$], [Public], [The public key/curve point on Ed25519 for $omega_i$],
  [$rho_"Ed25519"$], [Public], [The Fiat–Shamir heuristic challenge response on the Ed25519 curve (`response_div_ed25519`)],
)

==== Outputs:
#table(
  columns: 3,
  [*Output*], [*Visibility*], [],
  [$C$], [Public], [The Fiat–Shamir heuristic challenge (`challenge_bytes`)],
  [$R_"BabyJubjub"$], [Public], [DLEQ commitment 1, which is a public key/curve point on Baby Jubjub (`R_1`)],
  [$R_"Ed25519"$], [Public], [DLEQ commitment 2, which is a public key/curve point on Ed25519 (`R_2`)],
)

==== Summary

The *VerifyDLEQ* operation is a verification protocol and is language independent. This operation is not redundant, in that the successful verification of the previous *VerifyEquivalentModulo* operation with the same publicly visible parameters implies that this operation will succeed, but the conditions are different.

This operation will be implemented by the peers outside of a ZK circuit in its own native implementation language where the successful verification of the previous *VerifyEquivalentModulo* operation cannot be assumed complete. As such, this operation will exist and can called independently of any other operations.

This operation proves that the $T_i$ and $S_i$ public key/curve points were generated by the same secret key $omega_i$. Given that the two separate ephemeral $rho$ output values are both modulo equivalent values determined from the same root value, the reconstruction of the two separate $R$ commitments proves this statement. The use of two separate ephemeral $rho$ output values ensures that there is no need to compress the embedded size of the secret data $omega_i$ transported across the different group orders of the Baby Jubjub and Ed25519 curves, and also avoids the need for the random abort process as specified here: https://eprint.iacr.org/2022/1593.pdf

The operation uses the *blake2s* hashing function for its Fiat–Shamir heuristic random oracle model simulation.

==== Methods

$
  C = H_"blake2s" ("HEADER" || "PACKED"(T_i) || "PACKED"(S_i)) \
  Rho_"BabyJubjub" = rho_"BabyJubjub" dot.c G_"BabyJubjub" \
  C_T_i = C dot.c G_"BabyJubjub" \
  R_"BabyJubjub" = C_T_i - Rho_"BabyJubjub" \
  Rho_"Ed25519" = rho_"Ed25519" dot.c G_"Ed25519" \
  C_S_i = C dot.c G_"Ed25519" \
  R_"Ed25519" = C_S_i - Rho_"Ed25519" \
$
