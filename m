Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC9049CF59;
	Tue, 15 Sep 2026 19:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501853; cv=none; b=oTXlLqH4O46eAYg8fxakt+R9khjBGV4zyvkO1P64GnNhTViK1DfAEvMgyBIHMAQmBoqOuobRhK/Vmg4DoJb82M9EmvoN+37VbVcqU6n4Vjp3iXEF/ephLMGDb09CzGZyVk3Q2hfimXSqKWmjlB3rashs3uEYRwSchmfDbc4riNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501853; c=relaxed/simple;
	bh=E6De9mMCTyXqWKKYZ1GQRsh5Hl2j20Uh/GgeEvspdmg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iulNDpKSKcmA7rsuh+nvPJl/941XnR6UA2v9sc7lnteYCztefbcgcDUBCA0m7btFRVcFN/uwjIUamjGUh9M/+e2k30RLQWtOYNzBDEJyZ1gb+vN8nKETAkPuLE4MaBAYHmTet1Zbhm2m17yBW884zxNym0brF4cCRhnoPBof5pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISeRPfrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISeRPfrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEC61F000FF;
	Tue, 15 Sep 2026 19:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501851;
	bh=aq4/vWXHr+CFe434eqFCbhJ1hPfQyTz27y1EOb1SvBw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ISeRPfrJtZsDASUPiNyP0PWTbNXGTb6DIsjXjiSqyGdlw6XEBNZPEWhfnEVOzhqmm
	 aNrxnN0tU+xPVXOWaSaxtQt24GCBnG2D0nkociz2q9RFE8k+H3Ol21bHaWLCdsKP6U
	 LDSbtDZNdEOzoaZcYJjn7SvXCxv0M/FX8j/px9z0v/6gRaBeuUz2a/J3xPR8DEPIee
	 7Ka0/JwrksLWhtUw4uYQ09GkXxuRpfLN+etFfWVzEaBDvQXhHejcaO9IFff5d1VUD/
	 kN/1CNB2O2JorrUxReL/KwcSifOrr2+SRMuy1OekG+FF5I9N/xz4CDG+JJoIVnrNC1
	 W3ESZvGGzp9xg==
Subject: Re: [PATCH net-next v15 10/15] quic: add packet number space
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:48 +0000
Message-ID: <178950184892.22033.12966498591440423948@kernel.org>
In-Reply-To: =?utf-8?q?=3C9907f08c0834c76d2592ed990d235a4a7c5d413b=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C9907f08c0834c76d2592ed990d235a4a7c5d413b=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 4

- [Low] Commit message does not describe the ECN accounting/validation
  API that the patch introduces.
- [Low] Kernel-doc of `quic_pnspace_num_gabs()` (net/quic/pnspace.c line
  228) claims that on overflow "the oldest gaps are merged into a single…
- [Low] The field comment for `struct quic_pnspace::min_pn_seen`
  (net/quic/pnspace.h line 73) says "Smallest PN received", but…
- [Low] The pn_map layout comment in net/quic/pnspace.h documents the
  packet-count advance trigger as "(max_pn_seen - last_max_pn_seen) >…

--

quic: add packet number space

This patch adds struct quic_pnspace to track per packet number space state,
including the next packet number to send, bytes in flight, loss timing and
largest acknowledged packet number. It also adds the received packet number
bitmap plus quic_pnspace_check(), quic_pnspace_mark() and
quic_pnspace_num_gabs() for ACK frame generation.

A few questions about the new code and its comments below.

> diff --git a/net/quic/pnspace.c b/net/quic/pnspace.c
> new file mode 100644
> index 0000000000000..c7c4d0be2d980
> --- /dev/null
> +++ b/net/quic/pnspace.c
> @@ -0,0 +1,273 @@

[ ... ]

> +int quic_pnspace_mark(struct quic_pnspace *space, s64 pn, gfp_t gfp)
> +{

[ ... ]

> +	/* Check if enough time has elapsed or enough packets have been
> +	 * received to update tracking.
> +	 */
> +	last_max_pn_seen = min_t(s64, space->last_max_pn_seen, space->base_pn);
> +	last_max_pn_time = space->last_max_pn_time;
> +	if (space->max_pn_time < last_max_pn_time + space->max_time_limit &&
> +	    space->max_pn_seen <= last_max_pn_seen + QUIC_PN_MAP_LIMIT)
> +		return 0;

[Severity: Low]
Does the advance condition documented in the pn_map layout comment in
net/quic/pnspace.h match what quic_pnspace_mark() actually evaluates?

The header says:

 * Conditions to Advance pn_map:
 *   - (max_pn_time - last_max_pn_time) >= max_time_limit, or
 *   - (max_pn_seen - last_max_pn_seen) > QUIC_PN_MAP_LIMIT

but the code clamps the reference point to base_pn first:

	last_max_pn_seen = min_t(s64, space->last_max_pn_seen, space->base_pn);

So whenever base_pn is below space->last_max_pn_seen, the effective packet
count threshold is base_pn + QUIC_PN_MAP_LIMIT rather than the documented
last_max_pn_seen + QUIC_PN_MAP_LIMIT, and the map advances earlier than the
comment states.

base_pn below last_max_pn_seen is easy for a peer to arrange: receive
packet numbers 0..10 and 12, giving base_pn = 11 and max_pn_seen = 12; after
a time based advance last_max_pn_seen becomes 12 while base_pn stays 11.

Could the comment be updated to mention the base_pn clamp?

> +
> +	/* Advance base_pn if last_max_pn_seen is ahead of current base_pn.
> +	 * This is needed because QUIC doesn't retransmit packets;
> +	 * retransmitted frames are carried in new packets, so we move forward.
> +	 */
> +	if (space->last_max_pn_seen + 1 > space->base_pn)
> +		quic_pnspace_move(space, space->last_max_pn_seen);
> +
> +	space->min_pn_seen = space->last_max_pn_seen;
> +	space->last_max_pn_seen = space->max_pn_seen;
> +	space->last_max_pn_time = space->max_pn_time;
> +	return 0;
> +}

[ ... ]

> +/* Generate gap acknowledgment blocks (GABs). GABs describe ranges of
> + * unacknowledged packets between received ones, and are used in ACK frames.
> + *
> + * This function uses a sliding window approach to ensure the most recent gaps
> + * are preserved when the total number exceeds QUIC_PN_MAP_MAX_GABS. If there
> + * are more gaps than the limit, the oldest gaps are merged into a single gap,
> + * and the newest (QUIC_PN_MAP_MAX_GABS) gaps are preserved individually.
> + *
> + * Returns: Number of generated GABs (up to QUIC_PN_MAP_MAX_GABS).
> + */

[Severity: Low]
Is this description of quic_pnspace_num_gabs() consistent with itself and
with the code?  It says one merged gap plus QUIC_PN_MAP_MAX_GABS individual
gaps are produced, which is QUIC_PN_MAP_MAX_GABS + 1 blocks, while the next
line says the return value is at most QUIC_PN_MAP_MAX_GABS.

The ring loop never stores more than QUIC_PN_MAP_MAX_GABS entries:

	if (ngaps < QUIC_PN_MAP_MAX_GABS) {
		...
		ngaps++;
		continue;
	}
	gabs[i].start = start;
	gabs[i].end = end;
	i = (i + 1) % QUIC_PN_MAP_MAX_GABS;

and the merged range reuses the slot of the oldest surviving gap, so only
QUIC_PN_MAP_MAX_GABS - 1 newest gaps stay individual.

For 33 gaps, gaps 0..31 fill gabs[0..31] with mstart = gap0.start, gap 32
overwrites gabs[0] and i becomes 1; then gabs[1].start = mstart turns the
gap at index 1 into the merged block covering gap 0 and gap 1, and the
rotation returns 32 blocks of which 31 are individual.

Should the wording say QUIC_PN_MAP_MAX_GABS - 1 newest gaps are preserved
individually, with the merged gap occupying the remaining slot?

> +u16 quic_pnspace_num_gabs(struct quic_pnspace *space,
> +			  struct quic_gap_ack_block *gabs)
> +{

[ ... ]

> +	/* Overflow occurred: merge all discarded gaps with the gap at
> +	 * position i (which hasn't been overwritten yet) into one.
> +	 */
> +	gabs[i].start = mstart;
> +	memcpy(tmp, gabs, ngaps * sizeof(*gabs));
> +	memcpy(gabs, &tmp[i], (ngaps - i) * sizeof(*gabs));
> +	memcpy(gabs + (ngaps - i), tmp, i * sizeof(*gabs));
> +
> +	return ngaps;
> +}
> diff --git a/net/quic/pnspace.h b/net/quic/pnspace.h
> new file mode 100644
> index 0000000000000..15ce6d2ef7269
> --- /dev/null
> +++ b/net/quic/pnspace.h
> @@ -0,0 +1,201 @@

[ ... ]

> +enum {
> +	QUIC_ECN_ECT1,
> +	QUIC_ECN_ECT0,
> +	QUIC_ECN_CE,
> +	QUIC_ECN_MAX
> +};
> +
> +enum {
> +	QUIC_ECN_LOCAL, /* ECN bits from incoming IP headers */
> +	QUIC_ECN_PEER,  /* ECN bits reported by peer in ACK frames */
> +	QUIC_ECN_ACKED, /* ECN bits from packets newly ACKed */
> +	QUIC_ECN_DIR_MAX
> +};

[Severity: Low]
Could the commit message mention the ECN accounting and validation added
here?  The changelog body describes only the packet number bookkeeping and
the three ACK map helpers:

    "To support ACK frame generation, quic_pnspace includes a packet number
    acknowledgment map (pn_ack_map) that tracks received packet numbers.
    Supporting functions are provided to validate and mark received packet
    numbers and compute the number of gap blocks needed during ACK frame
    construction."

but the patch also adds the ecn_count matrix, the QUIC_ECN_* enums above,
and six inline helpers: quic_pnspace_inc_ecn_acked(),
quic_pnspace_reset_ecn_acked(), quic_pnspace_inc_ecn_local(),
quic_pnspace_has_ecn_local(), quic_pnspace_validate_ecn() and
quic_pnspace_set_ecn_peer(), the last two encoding the RFC 9000 section
13.4.2.1 validation policy.  The need_sack, sack_path and sack_pending
fields are also new and unmentioned.

The ECN work is described only in the v12 changelog below the --- line,
which is dropped when the patch is applied.

Also worth noting in the message: QUIC_ECN_ECT1 deliberately precedes
QUIC_ECN_ECT0 so that ecn - 1 indexes correctly from the IP header ECN
bits, while the ecn_count arrays passed in by callers are indexed with the
same enum.  A follow-up populating that array in RFC wire order (ECT0,
ECT1, CE) would silently swap the two counters.

[ ... ]

> +/* Packet Number Map (pn_map) Layout:
> + *
> + *     min_pn_seen -->++-----------------------+---------------------+---
> + *         base_pn -----^   last_max_pn_seen --^       max_pn_seen --^
> + *
> + * Map Advancement Logic:
> + *   - min_pn_seen = last_max_pn_seen;
> + *   - base_pn = first zero bit after last_max_pn_seen;
> + *   - last_max_pn_seen = max_pn_seen;
> + *   - last_max_pn_time = current time;

[ ... ]

> +	s64 last_max_pn_seen; /* Largest PN seen before pn_map advance */
> +	u64 last_max_pn_time; /* Timestamp last_max_pn_seen was received */
> +	s64 min_pn_seen;      /* Smallest PN received */

[Severity: Low]
Is "Smallest PN received" the right description for min_pn_seen?

quic_pnspace_mark() raises it to a former maximum on every window advance:

	space->min_pn_seen = space->last_max_pn_seen;
	space->last_max_pn_seen = space->max_pn_seen;

so after the first advance it is a monotonically growing lower bound of the
still trackable window, not the smallest packet number ever received.

The layout comment above ("min_pn_seen = last_max_pn_seen") and the
quic_pnspace_check() kernel-doc ("too old to track (below min_pn_seen)")
both describe the window meaning, so this field comment looks like the
outlier.  Would something like "Lower bound of the trackable PN window" be
more accurate?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
