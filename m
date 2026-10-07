Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD83233126;
	Wed,  7 Oct 2026 01:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335120; cv=none; b=ulAYMWVEoxypH1NyM0jRh1G2e9ugiHsjr2pRZ8G/ILot2g9uraWf3wR8DCV/nNpXo2x0B68WIfIeZSyLAum7k6o2pzqQu+BOZ8U/VALpJy0tXWyYKB1aO5ygO/eCqdTDIZ+7CnqLhL9KMqTTS2WyN4Bvxd/5cafDnbJd+vE3w58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335120; c=relaxed/simple;
	bh=IlcdGItBE5BGvJOnlkwp/zAtfdRbwRFDbH24ULEcGas=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jhp5c9zJycyVeXYtRwWSjPabKjOhz/6/mi9Zd9+Rsa4UeO1Woudfj197ij3hhrduad6dOG94gnMO25TNbj/ZJMT+VT7JXxFXd7wplPjqeZFSQJPwcd8x3BgT6mFDbHl8jL4GviKcJwgTB0Fhe0N7XU7ROyZR+772d78/fIjEN0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9ZeyQ68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9ZeyQ68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E8C1F0089B;
	Wed,  7 Oct 2026 01:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335118;
	bh=Itm+P1q4Y9pRrKcqnHOUXvbvTlp1oy5Ct+Ob8pfw+0Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=M9ZeyQ68mf6a2nEKgO+wjRmsLdbUmNZJilBGt/Bn7TewOrLi+sawcCH1sCcALaMCa
	 Lvy8bDYNLvaldkXlEnOj0N5MrLqKmtGtN9Qa0GwDPgKoOMKK30/s+40W+NNZZMjz4u
	 KBD+6d0JdVuhq4lUSdEhkoagiSa0TQMvH807VqI5e5G/V92BZInz2WUVEst/JyZnKd
	 C6Vb+PTF5DERLFlkgsW9c39QUg9rubwsoj25E2dXt3RQJBmClsfngTuw9NWc6xih6n
	 oOoF5+ul87ZqIoOOm3zcr8Pi5PJOLE06ugdxZkopgUwlqltSXo7z4ByH+fdhVhVdzm
	 zQfsSJn/MKpkw==
Subject: Re: [PATCH net-next v16 09/15] quic: add congestion control
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
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Wed, 07 Oct 2026 01:05:16 +0000
Message-ID: <179133511607.434549.17774997950314089010@kernel.org>
In-Reply-To: =?utf-8?q?=3C04d71cfc6acd9df9eb52e4f998c35eee568c4319=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C04d71cfc6acd9df9eb52e4f998c35eee568c4319=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_cong_on_packet_lost() (net/quic/cong.c) lets a packet
  that was sent before the first RTT sample start the persistent-…
- [Medium] The New Reno handlers in net/quic/cong.c decide whether to
  react to loss or ECN using only cong->state.

--

quic: add congestion control

This patch adds struct quic_cong for RTT measurement and congestion
control, and a quic_cong_ops interface for congestion control
algorithms. It implements the RFC 9002 state machine (slow start,
congestion avoidance, recovery) with New Reno as the only algorithm. It
also adds persistent congestion detection and pacing.

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 0000000000000..4779ffe90a3f2
> --- /dev/null
> +++ b/net/quic/cong.c
> @@ -0,0 +1,319 @@

[ ... ]

> +/* NEW RENO APIs */
> +static void quic_reno_handle_packet_lost(struct quic_cong *cong)
> +{
> +	switch (cong->state) {
> +	case QUIC_CONG_SLOW_START:
> +		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssth: %u\n",
> +			 __func__, cong->window, cong->ssthresh);
> +		break;
> +	case QUIC_CONG_RECOVERY_PERIOD:
> +		return;
> +	case QUIC_CONG_CONGESTION_AVOIDANCE:

[ ... ]

> +	cong->recovery_time = cong->time;
> +	cong->state = QUIC_CONG_RECOVERY_PERIOD;
> +	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
> +	cong->window = cong->ssthresh;
> +}
> +
> +static void quic_reno_on_packet_lost(struct quic_cong *cong, u64 time,
> +				     u32 bytes, s64 number)
> +{
> +	quic_reno_handle_packet_lost(cong);
> +}

[Severity: Medium]
Can one congestion event halve the window twice here?
quic_reno_on_packet_lost() gets the lost packet's send time in time, but
never uses it. quic_reno_handle_packet_lost() skips the reduction only
when cong->state is QUIC_CONG_RECOVERY_PERIOD.

In quic_reno_on_packet_acked(), the state leaves recovery as soon as one
packet sent after recovery_time is acked:

	case QUIC_CONG_RECOVERY_PERIOD:
		if (cong->recovery_time >= time)
			break;
		cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
		...
		fallthrough;

Here is one sequence:

  - A loss at time T starts recovery.
  - P20 was sent just before T and is lost in the network.
  - An ACK of P21, sent after T, ends recovery.

Later, P20 is declared lost, either by packet threshold on a later ACK
or by the time-threshold loss timer. At that point the state is
QUIC_CONG_CONGESTION_AVOIDANCE. A new recovery period starts and both
ssthresh and window are halved again.

In RFC 9002 Appendix B.6, OnCongestionEvent(sent_time) returns early
when sent_time <= congestion_recovery_start_time. B.7 applies the same
rule to ECN-CE.

Should quic_reno_on_packet_lost() compare time against
cong->recovery_time instead of relying only on cong->state?
quic_reno_on_process_ecn() gets no send time at all, so this check can't
be done there either.

The ACK side has a similar gap. In B.5, acked packets sent before the
recovery start don't grow cwnd. In QUIC_CONG_CONGESTION_AVOIDANCE,
quic_reno_on_packet_acked() grows the window for every acked packet,
whatever its send time.

[ ... ]

> +/* COMMON APIs */
> +void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes,
> +			      s64 number)
> +{
> +	if (cong->pc_detected)
> +		return;
> +
> +	if (cong->pc_start_time && time > cong->pc_start_time &&
> +	    quic_cong_check_persistent_congestion(cong, time)) {
> +		cong->pc_detected = 1;
> +		cong->min_rtt_valid = 0;
> +		cong->window = cong->min_window;
> +		cong->state = QUIC_CONG_SLOW_START;
> +		return;
> +	}
> +
> +	if (!cong->pc_start_time && cong->is_rtt_set)
> +		cong->pc_start_time = time;

[Severity: Medium]
Can a packet sent before the first RTT sample start the persistent
congestion period here? time is the lost packet's send time. is_rtt_set
shows the state when the loss is detected, not when the packet was sent.

RFC 9002 section 7.6.2 says the persistent congestion period should not
start until there is at least one RTT sample. Appendix B.8 only looks at
lost packets with lost.time_sent > first_rtt_sample.

struct quic_cong has no field for the time of the first RTT sample.
quic_cong_rtt_update() sets cong->is_rtt_set = 1 but doesn't record
when.

Here is an example:

  - A client sends Initial PN0 at T0.
  - It sends a PTO probe PN1 at about T0 + 1s. The PTO from
    QUIC_RTT_INIT is about 999ms.
  - Both packets are lost.
  - A later probe, PN2, is acked and gives a first RTT sample of 50ms.

Loss detection on that ACK marks PN0 lost. is_rtt_set is now 1, so
PN0's send time becomes pc_start_time.

PN1 is then marked lost. The gap of about 1s is larger than
(50 + max(4 * 25, 1) + 25) * 3 = 525ms. So the persistent congestion
branch above runs, cwnd drops to 2 * mss, and min_rtt_valid is cleared,
right after the handshake.

Should quic_cong_rtt_update() record the time of the first RTT sample?
quic_cong_on_packet_lost() could then use only lost packets sent after
that time.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
