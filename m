Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F2D455610;
	Tue, 15 Sep 2026 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501850; cv=none; b=qlbWunfpki8H3ARORW8UyBOzyI+0SnV7Bt0g8FN9zgNusAdYAdKP8GPY4HYPj/Rm1cGV6tLlOanoo4KqDJg6qtqL6FBO3aj4eFac/ou6o6HTmP+lpdy4DpmQRwPpUc4M6qvAW8TG30mPixh0uyiHBjkyd4CUwpbrjM9XLM8NWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501850; c=relaxed/simple;
	bh=quksUoBa27HSccnn9Yx/2346YgiY2PNjOz7a/Mz15i4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OcuwyLPbJuH1MGzLL2WLwsm6wSQZmLK8n5nZgXt4C7pXQ7or9nN8EmF6fl92LM/Ey7wSDVmbuNogUC+BMbUfJ6++iLjRHqY7egduoD2SiQe9Y4ts2GU/yrZksh6RzLUVqXvYRmE+k2sEkBWxn7pmXmJv4gDbzsteafglcVL+fyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEd+eAO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEd+eAO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5841F00893;
	Tue, 15 Sep 2026 19:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501848;
	bh=aFM03JIpI2MY7KtA/blE/wRR7nbFnrLUML9ywdAZZyk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=KEd+eAO+UrQTSlYankZQwGzdnew8qIn/oesTu0Xq34Sch3M4wX81foLFc9kk0Y3NC
	 WkHpg4tJhoW3EZZcCFCIhHybeNS6P5Zb/IGVyVwqAURyKywrgSnKLfHyRypEDxYyDk
	 9cpVq4405C0sNDqxLdBLhso4Da/M5igWuc+Cm6qznZbyC5vUZ7twZM2ACODhXHcD4/
	 9kzXPp6F9yjUWQrfJ4GtuKLwhYrgJFUK5UawDKOS5xMDiNrqy1g1vQq6H1p9+R9WWb
	 ag5weDKRAbTWDolXf5nzJEhffUxZXc/aue28D/mdRIMQTn9mghXIGx3mfjU14I91Ft
	 rUs/ULqyFfSBw==
Subject: Re: [PATCH net-next v15 09/15] quic: add congestion control
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
Date: Tue, 15 Sep 2026 19:50:46 +0000
Message-ID: <178950184662.22033.5889968066649167674@kernel.org>
In-Reply-To: =?utf-8?q?=3Cede5ba63212b87ddfa14acf70426b81d87501e44=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cede5ba63212b87ddfa14acf70426b81d87501e44=2E17893937?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 1

- [Medium] Spurious persistent-congestion detection:
  quic_cong_on_packet_lost() (net/quic/cong.c:125-140) is the ONLY place…
- [Low] Commit message vs. what the patch actually enables: the message
  says the implementation 'adjusts the congestion window accordingly…

--

quic: add congestion control

This adds net/quic/cong.c and net/quic/cong.h with RTT estimation, a
congestion control state machine (slow start, recovery, congestion
avoidance), pacing helpers and the New Reno algorithm behind a
quic_cong_ops indirection.  quic_init_sock() now calls quic_cong_init().

A couple of questions below.

> This patch introduces 'quic_cong' for RTT measurement and congestion
> control. The 'quic_cong_ops' is added to define the congestion
> control algorithm.
[ ... ]
> The implementation updates RTT estimates when packets are acknowledged,
> reacts to loss and ECN signals, and adjusts the congestion window
> accordingly during packet transmission and acknowledgment processing.

[Severity: Low]
This isn't a bug, but does the description match what this patch alone
does?

None of the six documented entry points has a caller at this commit, and
quic_cong_on_packet_sent() only advances cong->pacing_time because New
Reno registers no on_packet_sent hook:

	if (cong->ops->on_packet_sent)
		cong->ops->on_packet_sent(cong, time, bytes, number);
	quic_cong_update_pacing_time(cong, bytes);

Similarly quic_cong_set_mss() in net/quic/cong.h, the only initializer of
cong->mss, cong->min_window and cong->window, has no caller yet, and
cong->time is never assigned here.  The comment in
quic_reno_on_packet_acked() also refers to quic_packet_route(), which is
only introduced by the later "quic: add packet builder base" patch:

		/* cong->window is never zero; it is initialized by
		 * quic_packet_route() during connect/accept.
		 */

Would something like "the congestion control infrastructure is added here
and wired up in <later patch>" describe this patch more accurately?

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 0000000000000..78f28bbdfb374
> --- /dev/null
> +++ b/net/quic/cong.c
> @@ -0,0 +1,340 @@

[ ... ]

> +static bool quic_cong_check_persistent_congestion(struct quic_cong *cong,
> +						  u64 time)
> +{
> +	u32 ssthresh;
> +
> +	time -= cong->pc_start_time;
> +
> +	/* rfc9002#section-7.6.1:
> +	 *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay) *
> +	 *      kPersistentCongestionThreshold
> +	 */
> +	ssthresh = cong->smoothed_rtt +
> +		   max(4 * cong->rttvar, QUIC_KGRANULARITY);
> +	ssthresh = (ssthresh + cong->max_ack_delay) *
> +		   QUIC_KPERSISTENT_CONGESTION_THRESHOLD;
> +
> +	return time > ssthresh;
> +}
> +
> +/* COMMON APIs */
> +void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes,
> +			      s64 number)
> +{
> +	if (cong->pc_start_time && time > cong->pc_start_time &&
> +	    quic_cong_check_persistent_congestion(cong, time)) {
> +		cong->pc_start_time = 0;
> +		cong->min_rtt_valid = 0;
> +		cong->window = cong->min_window;
> +		cong->state = QUIC_CONG_SLOW_START;
> +		return;
> +	}
> +
> +	if (!cong->pc_start_time && cong->is_rtt_set)
> +		cong->pc_start_time = time;
                ^^^^

[Severity: Medium]
Can persistent congestion be declared here even though a packet sent
inside the interval was acknowledged?

quic_cong_on_packet_lost() is the only place that establishes
cong->pc_start_time, and quic_cong_on_packet_acked() can only clear an
interval that already exists, so an acknowledgment processed before the
first loss callback leaves no state behind.

With srtt = 100ms the duration threshold is roughly 400ms.  Consider
packet A sent at t=0, B sent at t=100ms, C sent at t=500ms, and B
acknowledged first (ACK processing precedes loss detection):

quic_cong_on_packet_acked(time=100ms)
	/* pc_start_time == 0, so this guard is false */
	if (cong->pc_start_time && time > cong->pc_start_time &&
	    !quic_cong_check_persistent_congestion(cong, time))
		cong->pc_start_time = 0;

quic_cong_on_packet_lost(time=0ms)      /* A declared lost */
	if (!cong->pc_start_time && cong->is_rtt_set)
		cong->pc_start_time = time;     /* pc_start_time = 0ms */

quic_cong_on_packet_lost(time=500ms)    /* C declared lost */
	/* 500ms - 0ms > 400ms */
	quic_cong_check_persistent_congestion() == true
		cong->window = cong->min_window;
		cong->state = QUIC_CONG_SLOW_START;
		cong->min_rtt_valid = 0;

B was sent at 100ms, i.e. between the send times of A and C, and it was
acknowledged, which rfc9002#section-7.6.2 says should disqualify the
interval.  Since neither the acknowledgment timestamp nor the packet
number is retained (the number argument is unused in both callbacks), is
there a way to reject this interval, for example by recording the send
time or packet number of the most recently acknowledged packet?

> +
> +	cong->ops->on_packet_lost(cong, time, bytes, number);
> +}
> +
> +void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
> +			       s64 number)
> +{
[ ... ]
> +	if (cong->pc_start_time && time > cong->pc_start_time &&
> +	    !quic_cong_check_persistent_congestion(cong, time))
> +		cong->pc_start_time = 0;
> +
> +	cong->ops->on_packet_acked(cong, time, bytes, number);
> +}

[ ... ]

> +void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes,
> +			      s64 number)
> +{
> +	if (!bytes)
> +		return;
> +	if (cong->ops->on_packet_sent)
> +		cong->ops->on_packet_sent(cong, time, bytes, number);
> +	quic_cong_update_pacing_time(cong, bytes);
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
