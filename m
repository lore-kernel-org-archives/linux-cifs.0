Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349785;
	b=u5iOw8SoeZ5mcRejo+DaoKcP9ZZNa1CEy98/tQNc+BVDhNEEJEB1LB0gKZGNL/d95fhu
	 nRtsTmhehib8/L5bj8pUQBbwLVd5pI7eZKZKQ72tzcNuRqbdYDVFFXEy5MHXZkFbz+Tbo
	 3wE5uQQJAZkTVo+GgfuQEEJtpvOEgxayuKHzsx3RTmuMPQMmPq/u0Uf5h97kHtI9HlNdw
	 PpMImtpi6pKI0lXdSwvbUHKpxkafsqwFj/4BU38dzjW/8DvDv2rNEhih7ug7vDbz9WaCn
	 mwhQvSmICJ8/R9HgSuAtVLzzBGvglQmeeUut9A8CpsdzPP8UbIIj5VHl0TdQFh01Hpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349785;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=2RM5L0J9ASXfxGtNkAy/ZUMRHcMdMwZoeqzGABMR650=;
	b=p/rtwQKwxbGRI5TP6ljuDvcJySR9ghbLmDnxkNEiRWH+VY7GPeZxZHg+C2bRymjsK3u7
	 GLYsDO1Guv3QIxbhZ4j+j9kHwCVGvnQWBuouWDVeeIkvSDHHR0nBktJi8PS3QSx8hTjOT
	 iInYEcfFOTUjVagPn+ZzcFhmazhpJOoHuUNW29Q/UL0YDbKKfsEQX1T1eNBlmoYl8MLQc
	 AYpFmQZgPWLIA4+Nnb9YGK3JHGoNxyQ6/7g54Mnal8fg3PcOog2MF96jcFFnyKgbz5Be6
	 kZgyfncGCDfZBfZmukKV2lRwqgPO/6LzpYpcS7qOODRHpnVjROMxSy7aBivoOIwei+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjIblDlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F1606A326;
	Tue, 10 Nov 2026 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjIblDlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A431F008A4;
	Tue, 10 Nov 2026 22:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349785;
	bh=2RM5L0J9ASXfxGtNkAy/ZUMRHcMdMwZoeqzGABMR650=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DjIblDlgguUKBNPv0H7mn9/gbpxwz77YUzwfCwRn1q5DWWQQIOXnczVChGmtX3iga
	 Q6RtW/gF7AhYHo87ODkBM0vyz+z/WTVTRg/z4e7tuQIaOtsDbtuPGncv4/kLM7eCcp
	 zBPQoeMWNO73zsqL+8m5OTUKzVuslqEDiT1bfemZ5UzevFIRrflMaZKWdS7AeWJFNQ
	 38KDasCZsrP7L04Su37SbdkKxIP6W1htvvou7/V2ELzdvC05wRaPxfBhahHNrJK+80
	 UoGrPTPSpKurQ3kBG4eDNJ+AaGDGHVq7RrPpVAhm/JdJ2s1bxPt8HwxysFBVH62znm
	 k7toFJ/glbY8g==
Subject: Re: [PATCH net-next v18 09/15] quic: add congestion control
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 cel@kernel.org, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Tue, 10 Nov 2026 22:29:43 +0000
Message-ID: <179434978300.994134.8100379458297117131@kernel.org>
In-Reply-To: <059c6b92785dcc2983956ff2dcd441285362aa03.1794241656.git.lucien.xin@gmail.com>
References: <059c6b92785dcc2983956ff2dcd441285362aa03.1794241656.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_reno_on_packet_acked() (net/quic/cong.c) grows
  cong->window on every acknowledged packet, in slow start and in…
- [Low] The commit message does not describe the pacing logic this patch
  adds, and it overstates what happens on transmit.

--

quic: add congestion control

This commit adds struct quic_cong for RTT measurement and congestion
control, with struct quic_cong_ops as the hook interface for
congestion control algorithms. Only New Reno is implemented. The
patch also adds pacing rate and pacing time helpers.

> The implementation updates RTT estimates when packets are acknowledged,
> reacts to loss and ECN signals, and adjusts the congestion window
> accordingly during packet transmission or acknowledgment processing.

[Severity: Low]
Is this accurate for the transmit side? quic_cong_on_packet_sent() never
changes cong->window. New Reno leaves ops->on_packet_sent as NULL, so the
transmit path only calls quic_cong_update_pacing_time().

The commit body also leaves out the pacing logic this patch adds:

  - quic_cong_pace_update() sets pacing_rate = 2 * window / smoothed_rtt,
    capped at max_rate.
  - quic_cong_update_pacing_time() schedules the next send in nanoseconds
    using ktime_get_ns(), with a jitter credit of up to len_ns / 2.
    The other timestamps in struct quic_cong are in microseconds.

The function list also leaves out quic_cong_pace_update(),
quic_cong_set_srtt() and quic_cong_set_algo(). Pacing is only mentioned
in the v5/v16 changelog notes, and those are dropped when the patch is
applied.

Could the commit message describe the pacing behavior, and drop the
claim that the window is adjusted on transmit?

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 0000000000000..b829755e8ac9e
> --- /dev/null
> +++ b/net/quic/cong.c
> @@ -0,0 +1,292 @@

[ ... ]

> +static void quic_reno_on_packet_acked(struct quic_cong *cong, u64 time,
> +				      u32 bytes, s64 number)
> +{
> +	u64 new_window;
> +
> +	if (quic_cong_in_slow_start(cong)) { /* Slow start */
> +		new_window = (u64)cong->window + bytes;
> +		cong->window = min_t(u64, new_window, cong->max_window);
> +		return;
> +	}
> +	/* Congestion avoidance - cong->window is never zero; it is initialized
> +	 * by quic_packet_route() during connect/accept.
> +	 */
> +	new_window = div64_ul((u64)cong->mss * bytes, cong->window) +
> +		     cong->window;
> +	cong->window = min_t(u64, new_window, cong->max_window);
> +}

[ ... ]

> +void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
> +			       s64 number)
> +{
> +	if (quic_cong_in_recovery(cong, time))
> +		return;
> +	cong->ops->on_packet_acked(cong, time, bytes, number);
> +}

[Severity: Medium]
Can cong->window keep growing while the sender is application-limited
or flow-control-limited?

RFC 9002 section 7.8 says the window should not grow when it is
underused. The OnPacketAcked() pseudocode in Appendix B.5 has:

    if (IsAppOrFlowControlLimited())
      return

quic_cong_on_packet_acked() only checks quic_cong_in_recovery() before
it calls ops->on_packet_acked(). struct quic_cong has no bytes-in-flight
field, and the hooks never receive one, so neither the wrapper nor
quic_reno_on_packet_acked() can apply this check.

In slow start the window grows by bytes on every ACK. A long-lived
connection that sends small request/response traffic could push
cong->window up by roughly the total bytes ever acked, toward
max_window (S32_MAX / 4, about 512MB).

quic_cong_pace_update() then computes the pacing rate from that window:

    rate = div64_ul((u64)cong->window * USEC_PER_SEC * 2,
                    cong->smoothed_rtt);

When bulk data arrives, would the burst then be limited only by the
caller's max_rate?

Nothing in this series calls quic_cong_on_packet_acked() yet, so a later
caller could skip the call when app-limited. If that is the plan, could
the requirement be documented here? For comparison, TCP does this check
inside the algorithm: tcp_reno_cong_avoid() checks
tcp_is_cwnd_limited().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
