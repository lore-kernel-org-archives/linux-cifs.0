Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64C3B8D79;
	Thu,  5 Feb 2026 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770292542; cv=none; b=uQz77c4fDANkL0gXQUH7kv0Rn68o8SNDXChf9SgtjLjHi3Cb58GsBwt6F6AOEHE4iB7/Vl0Rp/ScHpo+VZHsHn3DXoqFDrqW48JKIUfZHrY7rJuOjSGSvD4WOHGOjssKu3BCdxpfGYltrv9D6unBLr7ga9Cl4hq5scsg8uVcrbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770292542; c=relaxed/simple;
	bh=AgETDbq2Iqyu2H053F/M5EL3LNFz3ZVYlAiOaoe0lzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIoJh/D15xwTyjTiQwI/J+SiUuDqJZGOuf3RK6PMhAWA5HEZ2/WKk8TKUdlYYNI4drNh5aGw3ww+8pkORbSKx6+noFMJHley4SVgxfFtt82U9J7tl4S6bHuXgjYHCZ/U8MVwXwHAscTk0KuGIv3H1v2kUwkelHDqmHcUDj2gGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpyqQuXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpyqQuXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA7C4CEF7;
	Thu,  5 Feb 2026 11:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292542;
	bh=AgETDbq2Iqyu2H053F/M5EL3LNFz3ZVYlAiOaoe0lzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpyqQuXpRAGpH3+vH/n98zu5gbmOz+58cl6EViCqzubX76p792fijE6oA9RM7b1IP
	 OPVLLOUp20A983sG1YD5RjfDrNviTSjm2I7SU/9SQbtGJQlL5eYqQPAD/ei7LySiSo
	 WeW8bh+m9ffWyxO7aqbKtEwLrn8gZWoBuJnGL+QKiYMOTuXzKknE3DWh1zeXRoKVbx
	 T3BGvW5EXZAMZwcRPwrnO/GEbpXl5YqbgnnYm7l7ZeIuZAq2kjDlEA5ZE+lXZOdABa
	 LtM8OkdT8V9VSH99DM/TW8uM1L+8b/hWS2sG3g3SSSQ5jCRqC63a3suSoy3Q7tyxNR
	 CmrYGIbQBjN6A==
From: Simon Horman <horms@kernel.org>
To: lucien.xin@gmail.com
Cc: Simon Horman <horms@kernel.org>,
	steved@redhat.com,
	marcelo.leitner@gmail.com,
	aahringo@redhat.com,
	alibuda@linux.alibaba.com,
	jbaron@akamai.com,
	hare@suse.de,
	kuba@kernel.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	daniel@haxx.se,
	quic@lists.linux.dev,
	jlayton@kernel.org,
	tfanelli@redhat.com,
	dhowells@redhat.com,
	linkinjeon@kernel.org,
	hepengtao@xiaomi.com,
	pc@manguebit.com,
	kernel-tls-handshake@lists.linux.dev,
	illiliti@protonmail.com,
	xiyou.wangcong@gmail.com,
	andrew.gospodarek@broadcom.com,
	mail@johnericson.me,
	edumazet@google.com,
	pabeni@redhat.com,
	matttbe@kernel.org,
	netdev@vger.kernel.org,
	smfrench@gmail.com,
	metze@samba.org,
	mbuhl@openbsd.org,
	chuck.lever@oracle.com,
	dreibh@simula.no,
	davem@davemloft.net,
	sd@queasysnail.net
Subject: Re: [net-next,v9,09/15] quic: add congestion control
Date: Thu,  5 Feb 2026 11:55:32 +0000
Message-ID: <20260205115532.2195345-1-horms@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a872188a6e4d7b39d6d6d0f6fad7e5077bce4bae.1770042461.git.lucien.xin@gmail.com>
References: <a872188a6e4d7b39d6d6d0f6fad7e5077bce4bae.1770042461.git.lucien.xin@gmail.com>
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

This patch introduces quic_cong for RTT measurement and congestion control,
implementing a state machine with slow start, congestion avoidance, and
recovery phases using the New Reno algorithm.

> diff --git a/net/quic/cong.c b/net/quic/cong.c
> --- /dev/null
> +++ b/net/quic/cong.c

[ ... ]

> +static int quic_cong_check_persistent_congestion(struct quic_cong *cong, u64 time)
> +{
> +	u32 ssthresh;
> +
> +	/* rfc9002#section-7.6.1:
> +	 *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay) *
> +	 *      kPersistentCongestionThreshold
> +	 */
> +	ssthresh = cong->smoothed_rtt + max(4 * cong->rttvar, QUIC_KGRANULARITY);
> +	ssthresh = (ssthresh + cong->max_ack_delay) * QUIC_KPERSISTENT_CONGESTION_THRESHOLD;
> +	if (cong->time - time <= ssthresh)
> +		return 0;

[ ... ]

> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;
> +
> +	/* Ignore RTT sample if ACK delay is suspiciously large. */
> +	if (ack_delay > cong->max_ack_delay * 2)
> +		return;
> +
> +	/* rfc9002#section-5.1: latest_rtt = ack_time - send_time_of_largest_acked */
> +	cong->latest_rtt = cong->time - time;

The field cong->time is described as "Cached current timestamp" in struct
quic_cong, but where is it written? The socket struct is zero-initialized,
so cong->time will always be 0.

When computing RTT with a positive packet send timestamp in the time
parameter, does this cause unsigned integer underflow? For example, if the
packet was sent at time 12345, computing 0 - 12345 wraps to a very large
value.

The same issue appears in quic_cong_check_persistent_congestion() where
cong->time - time is compared against ssthresh, and in quic_reno_on_packet_lost()
and quic_reno_on_process_ecn() where recovery_time is set to cong->time.
