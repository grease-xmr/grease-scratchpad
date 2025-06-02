= Verified Secret Sharing

Note: All additions and scalar multiplication are calculated $mod L$, the order of the scalar field.

== Splitting

Given a secret, $omega$ that we which to split,

1. Choose a secret, random $a$ 
2. The shares are calculated as
$ 
sigma_1 &=  - (a + omega) \
sigma_2 &=  2 dot.c omega + a
$

Recovery of the secret, given $omega_1$ and $omega_2$ is trivial:

$ sigma_2 + sigma_1 &= 2 dot.c omega + a - omega - a \
               &= omega
$

$sigma_i$ are perfectly hiding

== Encryption

Given a share, $sigma_i$, a public key, $P_i = k_i dot.c G$, and a hash function $H$ that produces a scalar in the range $[1,L)$:

1. Pick a random nonce, $r_i$ 
2. Calculate $R_i = r_i dot.c G$
3. Calculate $m_i = H(r_i dot.c P_i )$
4. Calculate $s_i = sigma_i + m_i$
5. Share $(s_i, R_i)$, which can be public.

== Decryption

Given $(s_i, R_i)$ and $k_i$, the recipient of the encrypted secret can recover it as follows:

1. Calculate $m_i = H(k_i dot.c R_i)$
2. Calculate $sigma_i = s_i - m_i$

This follows since
$
  k_i dot.c R &equiv k_i dot.c r_i dot.c G \
              &= r_i dot.c k_i dot.c G \
              &= r_i dot.c P_i \
  therefore H(r_i dot.c P_i) &equiv m_i \
                             &= H(k_i dot.c R)
$

#emoji.hand.r
