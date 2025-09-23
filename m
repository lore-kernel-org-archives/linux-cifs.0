Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25BC20458A
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758635753; cv=none; b=GEjbqob7UjJAlP06rZ7qHzvhivYU/Q3TLH+TY7OZH2Wi2ytU/f7Vbs3eYmWOEnytP2DvLlku7anH03BENCG0jcR91GoxKpsf/LNIFj1YM1vcXiyU4e+UAHXavqX1G7HDjRwiH0IfM8Y5rTFSyRoyXjd2CEjjsrCE7Qo9T/+HOD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758635753; c=relaxed/simple;
	bh=cnTfLJI2pHLi4V2mGZyxw2bhd/bpRm/B1dmmuW1cYhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhpN1mS/C/ZUiQLQnAtPhO6gxcaZkWwBTpn+Xa3buYbuLj1ZoyfPBxd9uyltVhsC8Xj9c3A1kGpgiF/QGxK+c8A8nwbbxVrdhZEh/ouS+zUTaHdCRp0kUUMkl4Xck1i16W4OkCU4UmeoY+tAKEOZVvYTDU6amYZCG8tARswDtns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=THFGmdxS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="THFGmdxS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758635750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dTPPsQ1FUilXUGs6h0qcZ7nsZZHyKGum6Mc+HwP8/0=;
	b=THFGmdxSQP9u8AFAQ27ZdSicb+D+p1QDAFwd/co6NfbxXZJLMeBx2TvHOLukAeQN8OgZ6J
	gjmlEk/XQxXx6FgvMePRjyhPCLWIskV4iTn9KcbOvHqx5VOTqOCDj4EAUoCPcLNHWTYE7d
	Vx7gNBL/UwpjqbC7Z0Evyp1rDb/TSmY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-Fjy0Z4JWNsmnOC2SbGWFyg-1; Tue, 23 Sep 2025 09:55:49 -0400
X-MC-Unique: Fjy0Z4JWNsmnOC2SbGWFyg-1
X-Mimecast-MFC-AGG-ID: Fjy0Z4JWNsmnOC2SbGWFyg_1758635748
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee13baf21dso5804820f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 06:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758635748; x=1759240548;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8dTPPsQ1FUilXUGs6h0qcZ7nsZZHyKGum6Mc+HwP8/0=;
        b=G+arAGuWdlMyDbSTCLOWQiiUDA1+CfUKGxvAjSvrAxWNmCWHd7tlKsYmt81Uw3FAHX
         qLe0lqpa99vsyamKQijh9HMtPoltkJRhfK4Cy6DfYtaDw3Gv0OCvPcWHMRbpr0J16Hb/
         JtLcTaFzfyW+itF9sgRs70dKFD0RGJxl3fb/MirAyRUVgwqjhLza/7mTiHpEILrbts6Y
         R9NbOzrz0VS0p7jyFw93384/2PFpwxj5rJKbmuAS9gAYa5qhTaGhsmWMsK4+pv800JqH
         CXajeaMDGMUss1yBRplbBrNZa+trMy4dxX1NQv9fRdCnt03kWPZlpc/p3a6l9V9pQ1Ff
         DB7w==
X-Forwarded-Encrypted: i=1; AJvYcCUOL1wCoxX1L1l0p3qAFt4hqdL0pKHQRquiKSnNNCAm9vJTT8HoFq1FYz9s/Q8AY7c9OJTcKZsUmUCt@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqxo+OjVbvWY1intvxxrf1xi7x9hKdiDV4E0eihUdirTdAb8/S
	/IJ1L231Oz9MA4dpqhtEvL2ET/f0hl1aA+lWjghO9ajfvZ5Pi0PpIBwhTjvoSq45eYGhve2tSy9
	nE2A8YqVrHGriCcvYhpDX1neTJY2VEHHpgOW7LQQvbZQRfGR3+Gch680QG9Y6YFQ=
X-Gm-Gg: ASbGncuw3Ep55TJu/rej9sHH/Q8QycLwRgL0UNeNppqAeDYaedztsDFCApLgUQo4u+l
	TRlofuTVJ/Lx4ZyJU2feOON5+hMGJu5akvDtwrrvA8ci6Lrdh9haHtcl18FYxquyxtQrDbaNPO+
	iDrJ/5ChCEyb5IUrU0S/68c/yW6Z3SG/fTO43DG582XHWBai4THgcMBaZcTxAuT3KuqcGo2/mDS
	Gx1ygB3yc+038rsni9sJPTStnd3LiTzQYf61p3VvP+NhYjtAH03hw4LuPIccm1GIvu0XKA++RnT
	zLv13Yxvo90nMOicRmrRq+zyL0LQePSFhLFuQ/qALmboeKYTBBQcQmdV3UJDWyZDnXSzlqfXbrn
	Bkm7PuAsCtAtj
X-Received: by 2002:a05:600c:35cc:b0:45d:f7f9:9ac7 with SMTP id 5b1f17b1804b1-46e1d9953dbmr30369565e9.6.1758635747959;
        Tue, 23 Sep 2025 06:55:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERnVs+bjgTt7HFjVD6e97zPFqfTBQN5k2Cpyw71l8HfcrwfQSxqLVGtCM/vafT4NMHtBqKZw==
X-Received: by 2002:a05:600c:35cc:b0:45d:f7f9:9ac7 with SMTP id 5b1f17b1804b1-46e1d9953dbmr30369235e9.6.1758635747482;
        Tue, 23 Sep 2025 06:55:47 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f0aac3fdsm237468995e9.1.2025.09.23.06.55.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 06:55:46 -0700 (PDT)
Message-ID: <a9427359-a798-4f3a-88ef-c10a0bf614ec@redhat.com>
Date: Tue, 23 Sep 2025 15:55:44 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 09/15] quic: add congestion control
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <3475257318dcfce0ee996131142969b1fce7ae8b.1758234904.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <3475257318dcfce0ee996131142969b1fce7ae8b.1758234904.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/19/25 12:34 AM, Xin Long wrote:
> This patch introduces 'quic_cong' for RTT measurement and congestion
> control. The 'quic_cong_ops' is added to define the congestion
> control algorithm.
> 
> It implements a congestion control state machine with slow start,
> congestion avoidance, and recovery phases, and introduces the New
> Reno and CUBIC algorithms.

To moderate the initial submission size, you could initially introduce
just one of the above.

> The implementation updates RTT estimates when packets are acknowledged,
> reacts to loss and ECN signals, and adjusts the congestion window
> accordingly during packet transmission and acknowledgment processing.
> 
> - quic_cong_rtt_update(): Performs RTT measurement, invoked when a
>   packet is acknowledged by the largest number in the ACK frame.
> 
> - quic_cong_on_packet_acked(): Invoked when a packet is acknowledged.
> 
> - quic_cong_on_packet_lost(): Invoked when a packet is marked as lost.
> 
> - quic_cong_on_process_ecn(): Invoked when an ACK_ECN frame is received.
> 
> - quic_cong_on_packet_sent(): Invoked when a packet is transmitted.
> 
> - quic_cong_on_ack_recv(): Invoked when an ACK frame is received.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/quic/Makefile |   3 +-
>  net/quic/cong.c   | 700 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/quic/cong.h   | 120 ++++++++
>  net/quic/socket.c |   1 +
>  net/quic/socket.h |   7 +
>  5 files changed, 830 insertions(+), 1 deletion(-)
>  create mode 100644 net/quic/cong.c
>  create mode 100644 net/quic/cong.h
> 
> diff --git a/net/quic/Makefile b/net/quic/Makefile
> index 1565fb5cef9d..4d4a42c6d565 100644
> --- a/net/quic/Makefile
> +++ b/net/quic/Makefile
> @@ -5,4 +5,5 @@
>  
>  obj-$(CONFIG_IP_QUIC) += quic.o
>  
> -quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o
> +quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
> +	  cong.o
> diff --git a/net/quic/cong.c b/net/quic/cong.c
> new file mode 100644
> index 000000000000..d598cc14b15e
> --- /dev/null
> +++ b/net/quic/cong.c
> @@ -0,0 +1,700 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Initialization/cleanup for QUIC protocol support.
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <linux/jiffies.h>
> +#include <linux/quic.h>
> +#include <net/sock.h>
> +
> +#include "common.h"
> +#include "cong.h"
> +
> +/* CUBIC APIs */
> +struct quic_cubic {
> +	/* Variables of Interest in rfc9438#section-4.1.2 */
> +	u32 pending_w_add;		/* Accumulate fractional increments to W_est */
> +	u32 origin_point;		/* W_max */
> +	u32 epoch_start;		/* t_epoch */
> +	u32 pending_add;		/* Accumulates fractional additions to W_cubic */
> +	u32 w_last_max;			/* last W_max */
> +	u32 w_tcp;			/* W_est */
> +	u64 k;				/* K */
> +
> +	/* HyStart++ variables in rfc9406#section-4.2 */
> +	u32 current_round_min_rtt;	/* currentRoundMinRTT */
> +	u32 css_baseline_min_rtt;	/* cssBaselineMinRtt */
> +	u32 last_round_min_rtt;		/* lastRoundMinRTT */
> +	u16 rtt_sample_count;		/* rttSampleCount */
> +	u16 css_rounds;			/* Counter for consecutive rounds showing RTT increase */
> +	s64 window_end;			/* End of current CSS round (packet number) */
> +};
> +
> +/* HyStart++ constants in rfc9406#section-4.3 */
> +#define QUIC_HS_MIN_SSTHRESH		16
> +#define QUIC_HS_N_RTT_SAMPLE		8
> +#define QUIC_HS_MIN_ETA			4000
> +#define QUIC_HS_MAX_ETA			16000
> +#define QUIC_HS_MIN_RTT_DIVISOR		8
> +#define QUIC_HS_CSS_GROWTH_DIVISOR	4
> +#define QUIC_HS_CSS_ROUNDS		5
> +
> +static u64 cubic_root(u64 n)
> +{
> +	u64 a, d;
> +
> +	if (!n)
> +		return 0;
> +
> +	d = (64 - __builtin_clzll(n)) / 3;
> +	a = BIT_ULL(d + 1);
> +
> +	for (; a * a * a > n;) {
> +		d = div64_ul(n, a * a);
> +		a = div64_ul(2 * a + d, 3);
> +	}
> +	return a;
> +}

tcp_cubic() has already an helper to compute the square root. You could
re-use that one.

> +
> +/* rfc9406#section-4: HyStart++ Algorithm */
> +static void cubic_slow_start(struct quic_cong *cong, u32 bytes, s64 number)
> +{
> +	struct quic_cubic *cubic = quic_cong_priv(cong);
> +	u32 eta;
> +
> +	if (cubic->window_end <= number)
> +		cubic->window_end = -1;
> +
> +	/* cwnd = cwnd + (min(N, L * SMSS) / CSS_GROWTH_DIVISOR) */
> +	if (cubic->css_baseline_min_rtt != U32_MAX)
> +		bytes = bytes / QUIC_HS_CSS_GROWTH_DIVISOR;
> +	cong->window = min_t(u32, cong->window + bytes, cong->max_window);
> +
> +	if (cubic->css_baseline_min_rtt != U32_MAX) {
> +		/* If CSS_ROUNDS rounds are complete, enter congestion avoidance. */
> +		if (++cubic->css_rounds > QUIC_HS_CSS_ROUNDS) {
> +			cubic->css_baseline_min_rtt = U32_MAX;
> +			cubic->w_last_max = cong->window;
> +			cong->ssthresh = cong->window;
> +			cubic->css_rounds = 0;
> +		}
> +		return;
> +	}
> +
> +	/* if ((rttSampleCount >= N_RTT_SAMPLE) AND
> +	 *     (currentRoundMinRTT != infinity) AND
> +	 *     (lastRoundMinRTT != infinity))
> +	 *   RttThresh = max(MIN_RTT_THRESH,
> +	 *     min(lastRoundMinRTT / MIN_RTT_DIVISOR, MAX_RTT_THRESH))
> +	 *   if (currentRoundMinRTT >= (lastRoundMinRTT + RttThresh))
> +	 *     cssBaselineMinRtt = currentRoundMinRTT
> +	 *     exit slow start and enter CSS
> +	 */
> +	if (cubic->last_round_min_rtt != U32_MAX &&
> +	    cubic->current_round_min_rtt != U32_MAX &&
> +	    cong->window >= QUIC_HS_MIN_SSTHRESH * cong->mss &&
> +	    cubic->rtt_sample_count >= QUIC_HS_N_RTT_SAMPLE) {
> +		eta = cubic->last_round_min_rtt / QUIC_HS_MIN_RTT_DIVISOR;
> +		if (eta < QUIC_HS_MIN_ETA)
> +			eta = QUIC_HS_MIN_ETA;
> +		else if (eta > QUIC_HS_MAX_ETA)
> +			eta = QUIC_HS_MAX_ETA;
> +
> +		pr_debug("%s: current_round_min_rtt: %u, last_round_min_rtt: %u, eta: %u\n",
> +			 __func__, cubic->current_round_min_rtt, cubic->last_round_min_rtt, eta);
> +
> +		/* Delay increase triggers slow start exit and enter CSS. */
> +		if (cubic->current_round_min_rtt >= cubic->last_round_min_rtt + eta)
> +			cubic->css_baseline_min_rtt = cubic->current_round_min_rtt;
> +	}
> +}
> +
> +/* rfc9438#section-4: CUBIC Congestion Control */
> +static void cubic_cong_avoid(struct quic_cong *cong, u32 bytes)
> +{
> +	struct quic_cubic *cubic = quic_cong_priv(cong);
> +	u64 tx, kx, time_delta, delta, t;
> +	u64 target_add, tcp_add = 0;
> +	u64 target, cwnd_thres, m;
> +
> +	if (cubic->epoch_start == U32_MAX) {
> +		cubic->epoch_start = cong->time;
> +		if (cong->window < cubic->w_last_max) {
> +			/*
> +			 *        ┌────────────────┐
> +			 *     3  │W    - cwnd
> +			 *     ╲  │ max       epoch
> +			 * K =  ╲ │────────────────
> +			 *       ╲│       C
> +			 */
> +			cubic->k = cubic->w_last_max - cong->window;
> +			cubic->k = cubic_root(div64_ul(cubic->k * 10, (u64)cong->mss * 4));

Can `mss` be 0 at this point? Why?

> +			cubic->origin_point = cubic->w_last_max;
> +		} else {
> +			cubic->k = 0;
> +			cubic->origin_point = cong->window;
> +		}
> +		cubic->w_tcp = cong->window;
> +		cubic->pending_add = 0;
> +		cubic->pending_w_add = 0;
> +	}
> +
> +	/*
> +	 * t = t        - t
> +	 *      current    epoch
> +	 */
> +	t = cong->time - cubic->epoch_start;
> +	tx = div64_ul(t << 10, USEC_PER_SEC);
> +	kx = (cubic->k << 10);
> +	if (tx > kx)
> +		time_delta = tx - kx;
> +	else
> +		time_delta = kx - tx;
> +	/*
> +	 *                        3
> +	 * W     (t) = C * (t - K)  + W
> +	 *  cubic                      max
> +	 */
> +	delta = cong->mss * ((((time_delta * time_delta) >> 10) * time_delta) >> 10);
> +	delta = div64_ul(delta * 4, 10) >> 10;
> +	if (tx > kx)
> +		target = cubic->origin_point + delta;
> +	else
> +		target = cubic->origin_point - delta;
> +
> +	/*
> +	 * W     (t + RTT)
> +	 *  cubic
> +	 */
> +	cwnd_thres = (div64_ul((t + cong->smoothed_rtt) << 10, USEC_PER_SEC) * target) >> 10;
> +	pr_debug("%s: tgt: %llu, thres: %llu, delta: %llu, t: %llu, srtt: %u, tx: %llu, kx: %llu\n",
> +		 __func__, target, cwnd_thres, delta, t, cong->smoothed_rtt, tx, kx);
> +	/*
> +	 *          ⎧
> +	 *          ⎪cwnd            if  W     (t + RTT) < cwnd
> +	 *          ⎪                     cubic
> +	 *          ⎨1.5 * cwnd      if  W     (t + RTT) > 1.5 * cwnd
> +	 * target = ⎪                     cubic
> +	 *          ⎪W     (t + RTT) otherwise
> +	 *          ⎩ cubic
> +	 */
> +	if (cwnd_thres < cong->window)
> +		target = cong->window;
> +	else if (cwnd_thres * 2 > (u64)cong->window * 3)
> +		target = cong->window * 3 / 2;
> +	else
> +		target = cwnd_thres;
> +
> +	/*
> +	 * target - cwnd
> +	 * ─────────────
> +	 *      cwnd
> +	 */
> +	if (target > cong->window) {
> +		target_add = cubic->pending_add + cong->mss * (target - cong->window);
> +		cubic->pending_add = do_div(target_add, cong->window);
> +	} else {
> +		target_add = cubic->pending_add + cong->mss;
> +		cubic->pending_add = do_div(target_add, 100 * cong->window);
> +	}

Can `window` be 0 here? why?

> +
> +	pr_debug("%s: target: %llu, window: %u, target_add: %llu\n",
> +		 __func__, target, cong->window, target_add);
> +
> +	/*
> +	 *                        segments_acked
> +	 * W    = W    + α      * ──────────────
> +	 *  est    est    cubic        cwnd
> +	 */
> +	m = cubic->pending_w_add + cong->mss * bytes;
> +	cubic->pending_w_add = do_div(m, cong->window);
> +	cubic->w_tcp += m;
> +
> +	if (cubic->w_tcp > cong->window)
> +		tcp_add = div64_ul((u64)cong->mss * (cubic->w_tcp - cong->window), cong->window);
> +
> +	pr_debug("%s: w_tcp: %u, window: %u, tcp_add: %llu\n",
> +		 __func__, cubic->w_tcp, cong->window, tcp_add);
> +
> +	/* W_cubic(_t_) or _W_est_, whichever is bigger. */
> +	cong->window += max(tcp_add, target_add);
> +}
> +
> +static void cubic_recovery(struct quic_cong *cong)
> +{
> +	struct quic_cubic *cubic = quic_cong_priv(cong);
> +
> +	cong->recovery_time = cong->time;
> +	cubic->epoch_start = U32_MAX;
> +
> +	/* rfc9438#section-3.4:
> +	 *   CUBIC sets the multiplicative window decrease factor (β__cubic_) to 0.7,
> +	 *   whereas Reno uses 0.5.
> +	 *
> +	 * rfc9438#section-4.6:
> +	 *   ssthresh =  flight_size * β      new  ssthresh
> +	 *
> +	 *   Some implementations of CUBIC currently use _cwnd_ instead of _flight_size_ when
> +	 *   calculating a new _ssthresh_.
> +	 *
> +	 * rfc9438#section-4.7:
> +	 *
> +	 *          ⎧       1 + β
> +	 *          ⎪            cubic
> +	 *          ⎪cwnd * ────────── if  cwnd < W_max and fast convergence
> +	 *   W    = ⎨           2
> +	 *    max   ⎪                  enabled, further reduce  W_max
> +	 *          ⎪
> +	 *          ⎩cwnd             otherwise, remember cwnd before reduction
> +	 */
> +	if (cong->window < cubic->w_last_max)
> +		cubic->w_last_max = cong->window * 17 / 10 / 2;
> +	else
> +		cubic->w_last_max = cong->window;
> +
> +	cong->ssthresh = cong->window * 7 / 10;

There are quite a bit of magic numbers that should be replaced by macros
and/or associated with explainatory comments.

> +
> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;
> +
> +	/* Ignore RTT sample if ACK delay is suspiciously large. */
> +	if (ack_delay > cong->max_ack_delay * 2)
> +		return;
> +
> +	/* rfc9002#section-5.1: latest_rtt = ack_time - send_time_of_largest_acked */
> +	cong->latest_rtt = cong->time - time;
> +
> +	/* rfc9002#section-5.2: Estimating min_rtt */
> +	if (!cong->min_rtt_valid) {
> +		cong->min_rtt = cong->latest_rtt;
> +		cong->min_rtt_valid = 1;
> +	}
> +	if (cong->min_rtt > cong->latest_rtt)
> +		cong->min_rtt = cong->latest_rtt;
> +
> +	if (!cong->is_rtt_set) {
> +		/* rfc9002#section-5.3:
> +		 *   smoothed_rtt = latest_rtt
> +		 *   rttvar = latest_rtt / 2
> +		 */
> +		cong->smoothed_rtt = cong->latest_rtt;
> +		cong->rttvar = cong->smoothed_rtt / 2;
> +		quic_cong_pto_update(cong);
> +		cong->is_rtt_set = 1;
> +		return;
> +	}
> +
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

Here in a few other place before you could use abs_diff()

/P

