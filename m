Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445404;
	b=HUrh3EVRMh3c+Qlznq0UwQvyoJjw18cnXI6Ib/3FOwXlphPcTLfhMyjxcBCSWm1rzvuy
	 J3mDGGr0hvi5IcjJlP32VMAGW4f97ZPX6fx4XMqcUXKDeTwCY3D5CetNnuVfFratqXutB
	 J6Nh/Dhuh/TR2MhWJrzRiarjy51d+rVRARf2/k88A9+CAxyr9td0EPeGqobYVVTV8kVa5
	 USAqkAYUrpjAY17g+1TFQaG9EwcIj3pyV6lL7k4KlvScLI+uQ7lMiPGLktZ6EKuiaZRzs
	 3ENDsk7h2JKyS7EMUpI2CIfP7e7SiU87ndgA1mAiDTrUXFhwsKucor7++62y4GGBtyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445404;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=uHUMsq2KI9y0hFfNoOWys1j9L9M/UkbWorvw/tQ4h+U=;
	b=MRRwgcx3Ebi9awwm+5EilXlFkKyXUVFZOtuw90dk81auS8pzY1n29e7HWWflUi/aGY8Y
	 NRJlm3x3/zfMHd0MHwLePRoyHC3HPp8C/T7vVTlznAg8J+gUSpPG3JagsAIHS9NfnlXxM
	 3ec2QwRyIAHB6pX56/5bfYXPOc3lRktTx6PnVkM0NqUqYwbt3PaZkhPVgB5a04SZ45GaP
	 K/fQVrebeEOEYoHIlzMHXb2gNIxTG8na1rZdGSX7WspjQAA0BPa+YsVqdXiSo1OSABbnb
	 vfpQAFZpSEWLLFtLVvxf6CU3p1VFVeKaSRHpzUpifwJo2mwcL47A2bhvBZ0HpXylisA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HObmAAfq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B11606A32C;
	Mon, 19 Oct 2026 21:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HObmAAfq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8F51F000C4;
	Mon, 19 Oct 2026 21:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445404;
	bh=uHUMsq2KI9y0hFfNoOWys1j9L9M/UkbWorvw/tQ4h+U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HObmAAfq5ED79ei/i0VeS2FeVUSE5A7IFBunT+1DZP+CwOpdyZt4tVSUgR4m76/ss
	 ovUPAbvc8/E1v3IsUoe1t3VOQETHQgcvpw/5Nm/kFE2cnoVWbyQaw34T0Ru5q/TYEM
	 I4UVm4fw1EqRvqbPUrkMPd+WFdHwF1f5AT6RoLd5KT0wEEjkR1ScDoCuSUg7sRXo7J
	 KL7YxYaiV7ii2hWpwENrf6I5M58vL4zstIOldDND29Oe+a+NLGNzVvCCquIl/r5YAG
	 Ghh+9MYh4O1yIgrl4JyZm55NwNZjPGIJxpcC57kHLr8LCaSQLW5cK1D3YuWbyQROo6
	 5HsH8fubzIWhg==
Subject: Re: [PATCH net-next v17 09/15] quic: add congestion control
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
Date: Mon, 19 Oct 2026 21:30:01 +0000
Message-ID: <179244540161.3135.791644548439735124@kernel.org>
In-Reply-To: =?utf-8?q?=3C9e1c586f76943aa9fcd96cecedec805c66fc6e07=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C9e1c586f76943aa9fcd96cecedec805c66fc6e07=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When quic_cong_on_packet_lost() (net/quic/cong.c:94-99)
  declares persistent congestion, it sets cong->window =…
- [Low] The commit message says the implementation "adjusts the
  congestion window accordingly during packet transmission and…
- [Low] quic_cong_rtt_update() (net/quic/cong.c:207-209) throws away the
  whole RTT sample when the raw send-to-ACK interval (cong->time - time)…

--

quic: add congestion control

This patch adds struct quic_cong and struct quic_cong_ops to the QUIC
stack. They cover RTT measurement, loss and ECN handling, and pacing.
New Reno is the only algorithm so far, and quic_init_sock() sets it up
through quic_cong_init().

> The implementation updates RTT estimates when packets are acknowledged,
> reacts to loss and ECN signals, and adjusts the congestion window
> accordingly during packet transmission and acknowledgment processing.

[Severity: Low]
Is this accurate for the transmit path? quic_cong_on_packet_sent() never
touches cong->window:

    if (cong->ops->on_packet_sent)
        cong->ops->on_packet_sent(cong, time, bytes, number);
    quic_cong_update_pacing_time(cong, bytes);

The New Reno entry in quic_congs[] has no .on_packet_sent, so on transmit
only cong->pacing_time changes.

The commit message body also doesn't mention pacing. That covers the
pacing_rate and pacing_time fields, the 2 * window / smoothed_rtt rate in
quic_cong_pace_update(), and quic_cong_update_pacing_time(). Pacing only
shows up in the version changelog notes.

Could the commit message describe pacing, and drop the part about
adjusting the window during transmission?

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 0000000000000..765f50660f0e4
> --- /dev/null
> +++ b/net/quic/cong.c
> @@ -0,0 +1,287 @@

[ ... ]

> +/* NEW RENO APIs */
> +static void reno_recovery(struct quic_cong *cong)
> +{
> +	cong->recovery_time = cong->time;
> +	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
> +	cong->window = cong->ssthresh;
> +}

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
> +		return;
> +	}

[Severity: Medium]
Should this branch also reset cong->recovery_time?

The recovery state comes only from quic_cong_in_recovery():

    return time <= cong->recovery_time;

The only place that writes recovery_time is reno_recovery(), which sets
it to cong->time (now).

Take a single loss-detection pass after a link outage:

  P1 lost (pc_start_time is 0, first_rtt_time is set, not in recovery)
    quic_cong_on_packet_lost()
      cong->pc_start_time = time of P1
      quic_reno_on_packet_lost()
        reno_recovery()
          cong->recovery_time = cong->time;    /* now */

  P2 lost, sent more than the persistent congestion duration after P1
    quic_cong_on_packet_lost()
      quic_cong_check_persistent_congestion() returns true
      cong->window = cong->min_window;

Every packet still in flight was sent before now, so the ACK for each of
them returns early here:

    quic_cong_on_packet_acked()
        if (quic_cong_in_recovery(cong, time))
            return;

In that case ops->on_packet_acked() is never called. Would the window
then stay at min_window for at least one more RTT, until a packet sent
after recovery_time is acked?

RFC 9002 Appendix B.8 sets congestion_recovery_start_time to 0 on
persistent congestion, so these ACKs grow the window in slow start. The
state diagram in cong.h shows the same transition:

 *             persistent congestion |   Slow     |
 *         (O)---------------------->|   Start    |

Here, though, the derived state ends up as Recovery Period, not Slow
Start.

Nothing in this patch calls the quic_cong_on_packet_* hooks yet. This
would show up once the outqueue changes start calling them.

[ ... ]

> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;
> +
> +	/* Ignore RTT sample if ACK delay is suspiciously large. */
> +	if (ack_delay > cong->max_ack_delay * 2 ||
> +	    cong->time - time > QUIC_RTT_MAX)
> +		return;

[Severity: Low]
Is the 6 second QUIC_RTT_MAX cutoff too tight here?

cong->time - time is the raw interval from send to ACK, so it includes
the peer's ACK delay. RFC 9000 allows max_ack_delay up to 2^14 ms, which
matches common.h:

    #define QUIC_MAX_ACK_DELAY	(16384 * 1000)

For example, take a peer max_ack_delay of 8s, an ack_delay of 7s and a
measured interval of 7.1s. The sample passes the ack_delay check but is
still thrown away. The same happens on any path whose RTT stays above
6s.

The early return comes before anything is updated. smoothed_rtt and
rttvar stay at their initial 333ms and 166ms, and those feed into pto,
loss_delay and the pacing rate.

first_rtt_time also stays 0, so this condition in
quic_cong_on_packet_lost() is never true:

    if (!cong->pc_start_time && cong->first_rtt_time &&
        time > cong->first_rtt_time)
        cong->pc_start_time = time;

As a result, persistent congestion tracking never starts.

The v14 changelog says the cap prevents latest_rtt overflow. latest_rtt
is a u32 in microseconds, though, so it doesn't overflow until about
4295 seconds.

Could the limit be raised, or could ack_delay be subtracted before the
check? Nothing in this patch calls quic_cong_rtt_update() yet, so this
only matters once later patches call it.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
