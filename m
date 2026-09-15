Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7A8456DE1;
	Tue, 15 Sep 2026 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501848; cv=none; b=LNBT6MsmWsQ7lERAsbJl3AUhuA73NaRa6vRw1hAUrenAz447TXI1tNT4IpBOuoOm9GgLiqMwokhhYkEEKglJkx6X9HDnIhnNJpZ3gKKvx+AsaRngNeDo2KfU0bmtt4QaxNGXUmzsGvx3UggqqPj/lvGcqoKtrclctwkiQYrCIvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501848; c=relaxed/simple;
	bh=kvmOlM/afqx5EFgaDLKldpaV8PgWJAvZ3M4pDWrPkpo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ns1fUb4TXz1sraTMcntGd+AS72RinrmoEhaObLnoantGOt4HoDhv09X3UmkfRJw60W91gT2Fo201AhuCzwmsQiJMOc/VDEnn9Bj99FRa2bxeFwBXPvW3NBoLIK912ubklDthpcyYkcYasEYRyunNAKAaJPtKhgKzYOeNHIcjQi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFpHtIpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFpHtIpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15521F000FF;
	Tue, 15 Sep 2026 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501846;
	bh=eU2M/+mxMfhFRzEGHYVBLHiOCSXAx6SaM+buAgj5Usc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OFpHtIpG9uiLVfSuc/006bZJDER2bm6b9x6pitt7+vX9/9KwNGnAUB5bO7AA5xzvv
	 UYBdw9EZT/wZL6bAHXsL7H2CHDNAVtW1eT7UuCFzxvCtpzr7p5BgblrLK30oqsJT7I
	 ze+gPLVMuGb358v/UdSja8/OJdUsBv86ItVf0F65oUkQLK61RPkC4H9INZrEUT+Rk2
	 EO/esqtgp3tOTvf2RFjs6j+W9teKgpyPEQ75kh8m/+w52i/wXNzglOvNmVUL8T1RPr
	 Qb/SHyo3ddxXXZHlhkZTbqM8cvddAyVjeL8A1XcLegjvUXXkpw+iY8mRfavEuZ0pCB
	 DmsTEA2NaeTCA==
Subject: Re: [PATCH net-next v15 08/15] quic: add path management
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
Date: Tue, 15 Sep 2026 19:50:44 +0000
Message-ID: <178950184430.22033.8793987707688483661@kernel.org>
In-Reply-To: =?utf-8?q?=3C375ee7fe827d9df248a27a8072c84a7c167fc50a=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C375ee7fe827d9df248a27a8072c84a7c167fc50a=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 5

- [Medium] quic_path_swap() opens a write section on a bare seqcount_t
  (paths->path_seq) with only local_bh_disable() for context protection.
- [Medium] In the explicit-port branch of quic_path_bind(), an existing
  UDP tunnel socket is reused whenever quic_cmp_sk_addr() matches.
- [Low] Commit message claims PLPMTUD/ICMP feedback is integrated, but at
  this commit quic_udp_err() is a stub returning 0 and no quic_path_pl_*…
- [Low] quic_path_pl_send()'s kernel-doc ("Called immediately after
  sending a probe packet in QUIC Path MTU Discovery") and the matching…
- [Low] The new file net/quic/path.c carries the header comment
  "Initialization/cleanup for QUIC protocol support." — verbatim…
- [Low] quic_path_pl_recv()'s documented contract ("Return: New PMTU to
  apply if search completes, or 0 if no change") disagrees with the…
- [Low] The three PLPMTUD pr_debug() statements in quic_path_pl_send(),
  quic_path_pl_recv() and quic_path_pl_toobig() print the label "dst:…

--

quic: add path management

This patch adds struct quic_path / struct quic_path_group plus the global
hash table of UDP tunnel sockets, with helpers to bind, unbind, swap and
detect alternate paths for connection migration.  It also adds the RFC 8899
PLPMTUD state machine helpers (quic_path_pl_send/recv/toobig/reset/confirm)
and a quic_wq workqueue used to release UDP tunnel sockets.

A few questions below.

> diff --git a/net/quic/path.c b/net/quic/path.c
> new file mode 100644
> index 0000000000000..a9e02fc22e609
> --- /dev/null
> +++ b/net/quic/path.c
> @@ -0,0 +1,589 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Initialization/cleanup for QUIC protocol support.

[Severity: Low]
This isn't a bug, but this one-line description is the same sentence that
net/quic/common.c already carries, while this file implements UDP tunnel
socket hashing, path bind/unbind/swap/alt-detection and the PLPMTUD state
machine.  Should it describe path management instead?

> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */

[ ... ]

> +static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
> +{
> +	return 0;
> +}

[Severity: Low]
The commit message says:

  "It also integrates basic support for Packetization Layer Path MTU
   Discovery (PLPMTUD), using PING frames and ICMP feedback to adjust path
   MTU and handle probe confirmation or resets during routing changes."

At this commit quic_udp_err() discards the ICMP information and none of the
quic_path_pl_* helpers (nor quic_path_bind()/quic_path_swap()/
quic_path_detect_alt()) has a caller yet.  The ICMP side is wired up later
in the same series, where quic_udp_err() becomes
quic_packet_rcv(sk, skb, true) and quic_packet_rcv_err_pmtu() calls
quic_path_pl_toobig().

So this looks like wording only: would it be clearer to say the helpers are
introduced here and hooked into the receive and send paths in the following
patches?

[ ... ]

> +		if (a) {
> +			if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
> +			    us->bind_ifindex == quic_get_dev_if(sk, a))
> +				return us;
> +			continue;
> +		}

[ ... ]

> +		head = quic_udp_sock_head(net, port);
> +		mutex_lock(&head->lock);
> +		us = quic_udp_sock_lookup(sk, a, port);
> +		if (us) {
> +			if (!uid_eq(sk->sk_uid, us->sk->sk_uid)) {
> +				mutex_unlock(&head->lock);
> +				return -EADDRINUSE;
> +			}
> +			/* Allow reuse of an existing UDP tunnel socket.
> +			 * However, if it is in the middle of asynchronous
> +			 * teardown (via workqueue), it is temporarily unusable.
> +			 * Return -EAGAIN (not -EADDRINUSE) to signal the caller
> +			 * to retry soon.
> +			 */
> +			if (!quic_udp_sock_get(us)) {
> +				mutex_unlock(&head->lock);
> +				return -EAGAIN;
> +			}
> +		} else {
> +			us = quic_udp_sock_create(sk, a);
> +			if (IS_ERR(us)) {
> +				mutex_unlock(&head->lock);
> +				return PTR_ERR(us);
> +			}
> +		}
> +		mutex_unlock(&head->lock);
> +		quic_path_set_udp_sk(&paths->path[path], us);
> +		return 0;
> +	}

[Severity: Medium]
Can this reuse branch bind a path to a source address the host does not own?

quic_udp_sock_lookup() calls quic_cmp_sk_addr(us->sk, &us->addr, a), so the
existing tunnel socket address is the first argument, and
net/quic/family.c:quic_v4_cmp_sk_addr() has:

	/* Match only if socket is also ANY-bound. */
	if (addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
		return a->v4.sin_addr.s_addr == htonl(INADDR_ANY);
	if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY))
		return true;

That second test means an ANY-bound tunnel socket matches a request for an
arbitrary specific address (quic_v6_cmp_sk_addr() has the same rule for
IPv6).

On that branch quic_path_bind() returns 0 without ever going through
quic_udp_sock_create() -> udp_sock_create() -> kernel_bind(), so
__inet_bind()'s address ownership check (inet_addr_type() must be
RTN_LOCAL/MULTICAST/BROADCAST unless IP_FREEBIND, ip_nonlocal_bind or
CAP_NET_ADMIN) never runs, and paths->path[path].saddr keeps the
unvalidated address:

  process A: bind 0.0.0.0:P     -> quic_udp_sock_create(), tunnel sk is ANY
  process B (same uid): bind <non-local addr>:P
                               -> quic_udp_sock_lookup() matches the ANY sk
                               -> quic_udp_sock_get(), return 0

The same request would be rejected if no wildcard tunnel socket existed for
port P, since then udp_sock_create() would do the bind and validate the
address.  Should the reuse branch validate the requested source address
before accepting it?

[ ... ]

> +void quic_path_swap(struct quic_path_group *paths)
> +{
> +	struct quic_path path = paths->path[0];
> +
> +	paths->alt_probes = 0;
> +	paths->alt_state = QUIC_PATH_ALT_SWAPPED;
> +
> +	/* Protect path[0] modifications with seqcount for RCU readers in
> +	 * quic_sock_lookup(). The seqcount allows readers to detect torn reads
> +	 * during the non-atomic structure assignment.
> +	 */
> +	local_bh_disable();
> +	write_seqcount_begin(&paths->path_seq);

[Severity: Medium]
Is local_bh_disable() enough to open a write section on a bare seqcount_t?

path_seq is declared as a plain counter in net/quic/path.h:

	seqcount_t path_seq;      /* Protects path[0] during swap */

so there is no associated write serialization lock, and
write_seqcount_begin() expands to seqprop_assert(s), which for seqcount_t is
lockdep_assert_preemption_disabled().  On PREEMPT_RT
__local_bh_disable_ip() only takes softirq_ctrl.lock and does
migrate_disable(); it does not touch preempt_count():

	kernel/softirq.c (CONFIG_PREEMPT_RT)
	void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
	{
		...
		local_lock(&softirq_ctrl.lock);
		...
	}

Does that make write_seqcount_begin() warn on every path swap with lockdep
enabled on PREEMPT_RT?

The other half of the same point: the odd-sequence window becomes
preemptible, and the reader added later in the series busy-waits on it:

	do {
		seq = read_seqcount_begin(&paths->path_seq);
		...
	} while (read_seqcount_retry(&paths->path_seq, seq));

Would preempt_disable_nested() around the write section, or declaring the
counter as a seqcount_LOCKNAME_t associated with the socket lock, be a
better fit here?

[ ... ]

> +/* Handle PLPMTUD probe failure on a QUIC path.
> + *
> + * Called immediately after sending a probe packet in QUIC Path MTU Discovery.
> + * Tracks probe count and manages state transitions based on the number of
> + * probes sent and current PLPMTUD state (BASE, SEARCH, COMPLETE, ERROR).
> + * Detects probe failures and black holes, adjusting PMTU and probe sizes
> + * accordingly.
> + *
> + * Return: New PMTU value if updated, else 0.
> + */
> +u32 quic_path_pl_send(struct quic_path_group *paths, s64 number)
> +{
> +	u32 pathmtu = 0;
> +
> +	paths->pl.number = number;
> +	if (paths->pl.probe_count < QUIC_MAX_PROBES)
> +		goto out;

[Severity: Low]
Is the documented ordering inverted here?  The body records the packet
number of the probe that is about to be built and returns the PMTU for the
caller to apply to that upcoming packet, which only works if the helper runs
before the probe is transmitted.

The commit message has the same ordering:

  "- quic_path_pl_send(): state transition and pmtu update after sending a
     probe packet."

Read as documented, the QUIC_MAX_PROBES = 3 budget looks like it only fires
after a 4th probe.  Should both the kernel-doc line and the commit message
bullet say before sending the probe packet?

> +
> +	paths->pl.probe_count = 0;

[ ... ]

> +out:
> +	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
> +		 __func__, paths, paths->pl.state, paths->pl.pmtu,
> +		 paths->pl.probe_size, paths->pl.probe_high);
> +	paths->pl.probe_count++;
> +	return pathmtu;
> +}

[Severity: Low]
This isn't a bug, but the label says dst while the argument is paths, a
struct quic_path_group * rather than a route entry.  The same "dst: %p"
label appears in quic_path_pl_recv() and quic_path_pl_toobig(); it looks
inherited from the SCTP PLPMTUD traces where the printed object was the
transport.  Would "paths: %p" read better, since these are the only traces
of the PLPMTUD state machine?

> +
> +/* Handle successful reception of a PMTU probe.
> + *
> + * Called when a probe packet is acknowledged. Updates probe size and
> + * transitions state if needed (e.g., from SEARCH to COMPLETE).  Expands PMTU
> + * using binary or linear search depending on state.
> + *
> + * Return: New PMTU to apply if search completes, or 0 if no change.
> + */
> +u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer,
> +		      bool *complete)

[Severity: Low]
Does the QUIC_PL_ERROR branch below match this return description?  It
returns a non-zero PMTU while moving ERROR -> SEARCH, that is, while the
search is explicitly not complete:

	} else if (paths->pl.state == QUIC_PL_ERROR) {
		paths->pl.state = QUIC_PL_SEARCH; /* Error -> Search */

		paths->pl.pmtu = paths->pl.probe_size;
		pathmtu = (u32)paths->pl.pmtu;

The two out-parameters that actually carry the completion and timer signals,
bool *raise_timer and bool *complete, are not described either.  Could the
comment say a non-zero return is a PMTU to apply and document the two
out-parameters?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
