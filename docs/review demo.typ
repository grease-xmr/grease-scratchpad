#import "@preview/drafting:0.2.2"
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

#set par(
  first-line-indent: 1em,
  justify: true,
)
#set page(
    paper: "a4",
    margin: (x: 4cm, top: 3cm, bottom: 3cm),
    numbering: "1"
)
#set text(
  size: 12pt
)
#show heading: set block(below: 1.5em, above: 2em)
#set par(
    leading: 0.6em,
    spacing: 1.25em,
    justify: true
)
#show link: set text(blue)


#drafting.set-page-properties(margin-left: 4cm, margin-right: 4cm)

#let CJc = drafting.margin-note.with(stroke: blue)
#let SMc = drafting.margin-note.with(stroke: green)

= Heading 1
#lorem(50)

#diagram(cell-size: 15mm, $
	G edge(f, ->) edge("d", pi, ->>) & im(f) \
	G slash ker(f) edge("ur", tilde(f), "hook-->")
$)

#lorem(100)

== Heading 2

#lorem(20)
#drafting.margin-note[test2]
#lorem(50)
#CJc(side:left)[CJ's comment here.]
#lorem(25)
#SMc[SM's comment here]
#lorem(75)

```pintora
sequenceDiagram
    participant C as Customer
    participant M as Merchant
    participant L1 as Monero blockchain
    participant L2 as ZK chain

    M ->> C: Initiate New Channel Request<br/>{amt_p, pubkey_M, channel_id_M, vk_M, nonce_M}
    C ->> M: Accept Channel Request<br/>{pubkey_C, channel_id, S0_C, vk_C, nonce_C}   //, tf_c, tc_c0, dk_0
    M ->> C: Accept Channel Request<br/>{S0_M}
    par KES creation
        M ->> L2: Reserve KES<br/>{amt_l2}
        L2 ->> M: KES Reserved<br/>{instance_kes, P_kes[]}
        M ->> C: Send Secret Share & KES Public Info (M)<br/>{vssproof_M, vss_enc_M[], instance_kes, P_kes[]}
        C ->> M: Send Secret Share (C)<br/>{vssproof_C, vss_enc_C[]}
        C -->>+ L2: Watch for KES creation (optional)
        M ->> L2: Establish KES<br/>{instance_kes, amt_l2, timer_kes, channel_id, pubkey_M, pubkey_C, vss_enc_M[], vss_enc_C[]}
        L2 ->> M: KES Created<br/>{}
        L2 -->>- C: KES Created<br/>{}
        C ->> C: Verify KES
        M ->> M: Verify KES
    and Open channel
        C ->> M: Partially Signed Funding Transaction (C)<br/>{R_C ... z0_C}
        M ->> C: Partially Signed Funding Transaction (M)<br/>{R_M ... z0_M}
        C ->> M: Create Funding Transaction (C)<br/>{σ_vk_C}
        M ->> M: Create Funding Transaction (M)<br/>{T_x_f}
        M ->>+ L1: Fund Channel<br/>{amt, pubkey, channel_id}
        L1 ->>- L1: Tx confirmed<br/>{}
        M -->> C: Channel Opened<br/>{}
    end
    
```