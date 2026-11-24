Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483281;
	b=svjrlYz85EK8L7hq0SIsVZq/PgV5lEBQJEc5wX4JGOFL1ETtjRFFB31nCUEgKoGl2PtO
	 BXrVRL3cq3OloAygZmdV5jj1ImtesG2cPV21wZAHf4GAQ4FmaUEGySIX/4zqfQDAcUIq1
	 MFPJPSSILvo3qMWDcwaU+OhIqY2RAyZJIPxFDJWGjzYpjoiP+W5dGwKuGm7hRkQnVVImc
	 F5r1lKXej4H0MNDY0LdMT1+sy6OlY+kYRFaTQgz+FIa3x1P4xA3iq2zY5AKKfFz8G6Twm
	 2tKRC4L9sH2Vb8LxU0aP63V69XTFK/BqU1Nwh6vHrNEbBlE792TEXUrTmBi+OfD2tWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483281;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=WZwDpOMAGe1JJovwAreJRvj62LQnJZ5Y3eTHJLCsFx8=;
	b=4Dg0OcOUuVHfJABObR3BpmzIkfgKDYLZUM2FpDbSFiN8jT24S8y22fEJ9aNos95/T1V1
	 QeHAmFmgzUkdsRgjisAxRroY+Y5wEWy7TZg+1uGZZKynA4E9SzVhHeYOQzA/nF5yzWdxA
	 jq47HUZi45lRrAWJYDNQU9mZldedhgWFC10wIF5siToli6SrJjiNdzp7igY92rHTtlmiG
	 XFOa5UqM1uEvggkQGuQSyfGz/LnaLJ8US6PR4zOsdyjbaMfRuOBOpD7fhW6aGXLJ+ti4X
	 1GdbBgYGScEQ1aWYviz4GwujQDbrfPsZ5tQe4ZNi9zXbo4LcUxQU5764OJMN8TVWwrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9dJh3gZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E4606A322;
	Tue, 24 Nov 2026 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9dJh3gZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104B41F000CA;
	Tue, 24 Nov 2026 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483280;
	bh=WZwDpOMAGe1JJovwAreJRvj62LQnJZ5Y3eTHJLCsFx8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=d9dJh3gZDukMh5XSYkHjAKzOSiyV5ppoKkMZY+GrYXbta0eGmKnrEk5ozrr9b2d0K
	 IUXyjjdOh+dZ+G7KCnMIng6gi/DaX71ZaE+H+vzirTZH+6KQQs+p0nK3Buk51CCmjk
	 8/5DAEZZmx9SgWoBf0wGvBz7wHzM0MuCWmiiDknmyoKuBKf3d3IpLweUgTYGFmH1ad
	 LSe2Khg6v2/of15H+gLuVIwX824f5b0Dk2KVq0bezcUx50mob4KtuZ5gWgr8u6oTbn
	 UMzT8LRYiVyRTxKERODJ/1pCnyzMid/ISdUVki0qFwZYrZ2PGRrtIhsPv0qvk5M7pC
	 s6naJ54Fo7kMw==
Subject: Re: [PATCH net-next v19 09/15] quic: add congestion control
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:18 +0000
Message-ID: <179548327865.3135.16261562840994895440@kernel.org>
In-Reply-To: <b69a2cad6c2faeab9ee1e90ad11c4b64168c8235.1795393691.git.lucien.xin@gmail.com>
References: <b69a2cad6c2faeab9ee1e90ad11c4b64168c8235.1795393691.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_cong_rtt_update() in net/quic/cong.c begins with `if
  (ack_delay > cong->max_ack_delay * 2) return;`.

--

quic: add congestion control

This patch adds struct quic_cong for RTT measurement and congestion
control, along with struct quic_cong_ops for congestion control
algorithms. It implements a slow start, congestion avoidance and
recovery state machine, and currently provides New Reno only.

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 0000000000000..99fe8045d0170
> --- /dev/null
> +++ b/net/quic/cong.c

[ ... ]

> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;
> +	u64 raw_rtt;
> +
> +	/* Ignore RTT sample if ACK delay is suspiciously large. */
> +	if (ack_delay > cong->max_ack_delay * 2)
> +		return;

[Severity: Medium]
Should this early return be here? When it fires, quic_cong_rtt_update()
skips every update. latest_rtt, min_rtt/min_rtt_valid, smoothed_rtt,
rttvar and first_rtt_time stay as they are, and quic_cong_pto_update()
is never called.

RFC 9002 section 5.1 generates an RTT sample whenever the largest
acknowledged packet is newly acked and at least one newly acked packet
was ack-eliciting. It has no rule for rejecting a sample because of its
ack_delay.

RFC 9002 section 5.3 also says the endpoint SHOULD ignore the peer's
max_ack_delay until the handshake is confirmed. During the handshake,
peers can legitimately report delays larger than max_ack_delay (RFC 9000
sections 13.2.1 and 13.2.5). One example is a peer that buffers
undecryptable packets until keys arrive.

The changelog says callers will cap ack_delay to max_ack_delay after
handshake confirmation. If so, this check can only fire before
confirmation, which is the phase where the RFC says to ignore
max_ack_delay.

With the default from quic_cong_init():

	cong->max_ack_delay = QUIC_DEF_ACK_DELAY;

any handshake-phase sample with ack_delay above 50ms would be dropped. A
peer that advertises max_ack_delay of 0, which is a legal value, would
cause every pre-confirmation sample with a non-zero ack_delay to be
dropped.

In that case smoothed_rtt and rttvar would stay at the QUIC_RTT_INIT
values set by quic_cong_set_srtt(), so pto and loss_delay would not match
the real path. first_rtt_time would also stay 0. That keeps
quic_cong_on_packet_lost() from ever setting pc_start_time.

The RFC already handles a large ack_delay safely further down in this
function:

> +	adjusted_rtt = cong->latest_rtt;
> +	if (cong->latest_rtt >= cong->min_rtt + ack_delay)
> +		adjusted_rtt = cong->latest_rtt - ack_delay;

Is the drop-the-sample heuristic needed on top of this?

The commit message describes quic_cong_rtt_update() as "Performs RTT
measurement" and does not mention this deviation from RFC 9002.

This patch has no caller of quic_cong_rtt_update(), so whether this
triggers depends on the ACK processing code in the later patchset.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
