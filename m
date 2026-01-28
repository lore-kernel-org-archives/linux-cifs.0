Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94F2417C6;
	Wed, 28 Jan 2026 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616923; cv=none; b=O8CWeL4TYTxIRDCuorUuekbwS2P5F43c0dBOGAaC+A9u6HJNgmaaqwilIVW4k77HKTFPryJiMxMFO7hM5qrdU2jl03veQz37IEPfjJM//RnI/Cp9femCBzL/NmkbqjoF8zUfP7rcdzsIBoWMCF7zJris9j6IAM4frtI8HjD9ZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616923; c=relaxed/simple;
	bh=Cjp6fHoBhnMDcePkROGGnHq4Wn2CQ9LSGEwmcqZ8qV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oadEre7nLGWMNmgH/uQAlXzG5RJlbdixGmXJWM9hsgagTL24QwxWVJm7l6xzH14CLYKCmop759VjlQQ3g31iN1qdOgkzTF8+a8VRe7oFcNgfeuwgOjjw14mkjSpGEyJL4QX8MfTa2oTx06U4qtXXbQ3UsPv/cq4oW7AG3X1UClA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tA3d4Q4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tA3d4Q4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921E3C4CEF1;
	Wed, 28 Jan 2026 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769616923;
	bh=Cjp6fHoBhnMDcePkROGGnHq4Wn2CQ9LSGEwmcqZ8qV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tA3d4Q4FezjXYt2zqUvVouhzKRhYWY2Yqo3HuDGCT02xUwrKvUUuzd9Gb3U/eJi0l
	 qM8buwgTsOXnVb+HgJsf+czlt6oUJTSYHJFZcebEOKsEBvG+JosubQ3w4LIGT7+Rqa
	 P967cSl81WTSdd1qgvk9P03urIkt6J7xYUbPbzaYj7NMaugGqxGPpq4LdY18UPh2nl
	 +/auhpiDZqedcd1aSLgB43KwbNvCYpXoXSUHDd6B5mzTmi4bXrd1BWltFRePRfAsS4
	 Z1s/wXAVwVITdtXyRwiwe5LuBxsed8qkQSR87HfQmXCQYFl8MhAHNzbvSN2jHHihXF
	 JF2TWq77N1Xbw==
From: Simon Horman <horms@kernel.org>
To: lucien.xin@gmail.com
Cc: Simon Horman <horms@kernel.org>,
	jlayton@kernel.org,
	davem@davemloft.net,
	daniel@haxx.se,
	kuba@kernel.org,
	dhowells@redhat.com,
	chuck.lever@oracle.com,
	andrew.gospodarek@broadcom.com,
	matttbe@kernel.org,
	tfanelli@redhat.com,
	metze@samba.org,
	marcelo.leitner@gmail.com,
	edumazet@google.com,
	linkinjeon@kernel.org,
	hepengtao@xiaomi.com,
	illiliti@protonmail.com,
	quic@lists.linux.dev,
	mail@johnericson.me,
	jbaron@akamai.com,
	alibuda@linux.alibaba.com,
	tom@talpey.com,
	steved@redhat.com,
	sd@queasysnail.net,
	pc@manguebit.com,
	smfrench@gmail.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	dreibh@simula.no,
	kernel-tls-handshake@lists.linux.dev,
	mbuhl@openbsd.org,
	aahringo@redhat.com,
	hare@suse.de
Subject: Re: [net-next,v8,09/15] quic: add congestion control
Date: Wed, 28 Jan 2026 16:15:05 +0000
Message-ID: <20260128161505.1454974-1-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9b38b4291e2b1b47ee17f7247c4c66f5bcdccffe.1769439073.git.lucien.xin@gmail.com>
References: <9b38b4291e2b1b47ee17f7247c4c66f5bcdccffe.1769439073.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
quic: add congestion control

This patch introduces quic_cong for RTT measurement and congestion
control. It implements a congestion control state machine with slow
start, congestion avoidance, and recovery phases using New Reno.

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 000000000000..1a8b7f8db977
> --- /dev/null
> +++ b/net/quic/cong.c

[ ... ]

> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;

[ ... ]

> +	/* rfc9002#section-5.3:
> +	 *   adjusted_rtt = latest_rtt
> +	 *   if (latest_rtt >= min_rtt + ack_delay):
> +	 *     adjusted_rtt = latest_rtt - ack_delay
> +	 *   smoothed_rtt = 7/8 * smoothed_rtt + 1/8 * adjusted_rtt
> +	 *   rttvar_sample = abs(smoothed_rtt - adjusted_rtt)
> +	 *   rttvar = 3/4 * rttvar + 1/4 * rttvar_sample
> +	 */
> +	adjusted_rtt = cong->latest_rtt;
> +	if (cong->latest_rtt >= cong->min_rtt + ack_delay)
> +		adjusted_rtt = cong->latest_rtt - ack_delay;
> +
> +	cong->smoothed_rtt = (cong->smoothed_rtt * 7 + adjusted_rtt) / 8;
> +	if (cong->smoothed_rtt >= adjusted_rtt)
> +		rttvar_sample = cong->smoothed_rtt - adjusted_rtt;
> +	else
> +		rttvar_sample = adjusted_rtt - cong->smoothed_rtt;

The comment above references abs(smoothed_rtt - adjusted_rtt). Paolo Abeni
suggested using abs_diff() from linux/math.h for this calculation in v3
review, and it was acknowledged. Could abs_diff() be used here instead of
the manual if-else?

https://lore.kernel.org/netdev/a9427359-a798-4f3a-88ef-c10a0bf614ec@redhat.com/

[ ... ]

> diff --git a/net/quic/cong.h b/net/quic/cong.h
> new file mode 100644
> index 000000000000..e6cfb0fa1b6c
> --- /dev/null
> +++ b/net/quic/cong.h

[ ... ]

> +struct quic_cong {
> +	/* RTT tracking */
> +	u32 max_ack_delay;	/* max_ack_delay from rfc9000#section-18.2 */
> +	u32 smoothed_rtt;	/* Smoothed RTT */
> +	u32 latest_rtt;		/* Latest RTT sample */
> +	u32 min_rtt;		/* Lowest observed RTT */
> +	u32 rttvar;		/* RTT variation */
> +	u32 pto;		/* Probe timeout */
> +
> +	/* Timing & pacing */
> +	u64 recovery_time;	/* Recovery period start timestamp */
> +	u64 pacing_rate;	/* Packet sending speed Bytes/sec */
> +	u64 pacing_time;	/* Next scheduled send timestamp (ns) */
> +	u64 time;		/* Cachedached current timestamp */
                                   ^^^^^^^^^^

There appears to be a typo here - "Cachedached" should be "Cached".
