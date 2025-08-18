Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123E342C81;
	Mon, 18 Aug 2025 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526364; cv=none; b=lECcAxNTZa4HGE34s7y/K0l8rsMp3/cDLU3VuQv6zvWrrux4KNPz2falKV73AfXGqm3JmGdBrm77Ou8VsmNcqUUkH0/Q0hwTkAyFIE9srfJdIgG1tneR9K5v/5bAoxirl1wjefSPibrY8BmwNLXvshDyCUee0DrqIClcjJ4UWqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526364; c=relaxed/simple;
	bh=NMan8XJg+r0Bt/2G9rpNFiXWqHCvprPGdB5mnJD6Sog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9Otrv+RTNPGqe5k4llcwRyyaB+ZjSVg7bA1OOXUILESgMVVN0RnPjDo6Kr6PaoY8W3HJ4OQYgWfnasm/nAEiDAoScQ+Yd+2mJ8v9hRGdQFeHQOlnhD3y4+r8808L/B4z3sr7sqHMXUouLTzsfRSbzhl7/tpESN+wXh23LVxcEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbUa8ZWZ; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbUa8ZWZ"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e9345697409so1268801276.1;
        Mon, 18 Aug 2025 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526361; x=1756131161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AHrJwaKWgVH4BYzTRm1+x6VqaRHpYmczKU26yu8xn0=;
        b=lbUa8ZWZ3/npEkVKTKWmhBuI4fXZZQLfbmjLUmhKjx2+JY/UoLVBf8jMEMnuZEl5rv
         ViQxBwSuhGKM9wS740Y4LkupD0PgsSAEeOk8na7YYNLhh3FroAjVmOe1aKTCWc6FMN8K
         1DnnV0WfmW2D5r5DSnqGbkrWSFaLcx9nCyZ/dqIRrAWcHF5FV0GDwx6znDqVZtaLeWol
         anPn/53tio8QxaqqZEiVmv+gSqMKp/ZiO/exl7VmtTjqYnVSizx3vFWRF3qh+El/eQAO
         3Ncu5QGboA9NeGiFGCiAhpkFzev4ABDzPqtDdQGStw5arFFpwt92uk0EOLvOBhCqtg19
         TIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526361; x=1756131161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1AHrJwaKWgVH4BYzTRm1+x6VqaRHpYmczKU26yu8xn0=;
        b=cfv5XZkgolPmKKNrmpfW+Qp7Jr/XUhSXzEuQsbmphbwqbG3/MENef79pTvaByXeE7v
         WT5gsl7tOCgILBfIWtrcFnU6lNEVVq67bU+LqB2D2E7nQLdoFGEZc5F1IHNvncl4zTNt
         tztl6gNUUDnNpEGsqeCzPdo06hav2CJR5Uvihl7N/WDOtQvcSdr53zmD0z62MZ86shAz
         qHoOQSarKI2tLuyXnNbOiTmZYwrTKAB6mFl/KHTD4EJU/cTDvCYFgPJ46fqqBGTlAGMo
         NRWcXyp9NugbRHG4YjUgj5/lojTa6UcODhDZZn3KfUyHZgn+IvzAugvstzGqQLV/4Nlm
         KtnA==
X-Forwarded-Encrypted: i=1; AJvYcCUDpfh9kahkW6PLzf/e64f3mYmLzY4ZlUtud5gGEGeiIg6ppzqkKNT6zfSk4TaQGYsTrPae+4nKW56F@vger.kernel.org
X-Gm-Message-State: AOJu0Yynyyv5dwPVrRBAMGLuvpPe4WAh/XC3PyxbnO9rRDAUtrotPlk1
	uZvy0t4wX96ZxYX86GUHkbvFvaxbpa/7xP97Q4aFChiByx7uuZpvYpvTy1eujoCtx/c=
X-Gm-Gg: ASbGncuXXuTCksmM1vfb0FvIZW/Zqwl+dQJwMdQNDi4D4IJTWdMNBwhMAhE/5DxKUk5
	zg0MMjWm67yPzzbeoXa23vox12BqmR7VUgfT6UfsLStKUit7dcRSu8r/GH3p9az4v0+un0McBRr
	shfFFnV/a9QilnDwAJGzytgbWdIwlYbYctezhOFjQip6evG1PZOwdMfYJciN6FMbwjK8DtKVaPz
	YFBZADUFdzkuNy5EfDSi5YPnW0Q5LDekpPNmv6U4+ZeGBKhJWiZtzFKDBXrvFQV0kbuEHsHwNFE
	/1/1V7zJ3A/OCcCgO7Iw/ZuZ52kekCxwo9pE6Kk4zNML9LDuY0Uq+QfNaeo8Z7w1d4mC6ezjTZm
	ECdfTCfZvIgRHTeNvjb3F92/uO3tM0F+MtRe0++jhrolonb3nl61vyBdXqEY9U50Hqt1HNamtu/
	ON6XQiqDFs
X-Google-Smtp-Source: AGHT+IHnXKcI/ypIpDpB+QlpvF572gpL0/MU/YJ1dskjfcGEaycJITV/drAM9Sy9vVlHGPPDJ6tbow==
X-Received: by 2002:a05:6902:1087:b0:e8f:d2cb:5a13 with SMTP id 3f1490d57ef6-e93324b8d4bmr16621923276.33.1755526360243;
        Mon, 18 Aug 2025 07:12:40 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:39 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 09/15] quic: add congestion control
Date: Mon, 18 Aug 2025 10:04:32 -0400
Message-ID: <8771b86ed86e0f6f9681afedcc45b12da2e07d5f.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1755525878.git.lucien.xin@gmail.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_cong' for RTT measurement and congestion
control. The 'quic_cong_ops' is added to define the congestion
control algorithm.

It implements a congestion control state machine with slow start,
congestion avoidance, and recovery phases, and introduces the New
Reno and CUBIC algorithms.

The implementation updates RTT estimates when packets are acknowledged,
reacts to loss and ECN signals, and adjusts the congestion window
accordingly during packet transmission and acknowledgment processing.

- quic_cong_rtt_update(): Performs RTT measurement, invoked when a
  packet is acknowledged by the largest number in the ACK frame.

- quic_cong_on_packet_acked(): Invoked when a packet is acknowledged.

- quic_cong_on_packet_lost(): Invoked when a packet is marked as lost.

- quic_cong_on_process_ecn(): Invoked when an ACK_ECN frame is received.

- quic_cong_on_packet_sent(): Invoked when a packet is transmitted.

- quic_cong_on_ack_recv(): Invoked when an ACK frame is received.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile |   3 +-
 net/quic/cong.c   | 700 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/cong.h   | 120 ++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   7 +
 5 files changed, 830 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/cong.c
 create mode 100644 net/quic/cong.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 1565fb5cef9d..4d4a42c6d565 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o
+quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
+	  cong.o
diff --git a/net/quic/cong.c b/net/quic/cong.c
new file mode 100644
index 000000000000..d598cc14b15e
--- /dev/null
+++ b/net/quic/cong.c
@@ -0,0 +1,700 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/quic.h>
+#include <net/sock.h>
+
+#include "common.h"
+#include "cong.h"
+
+/* CUBIC APIs */
+struct quic_cubic {
+	/* Variables of Interest in rfc9438#section-4.1.2 */
+	u32 pending_w_add;		/* Accumulate fractional increments to W_est */
+	u32 origin_point;		/* W_max */
+	u32 epoch_start;		/* t_epoch */
+	u32 pending_add;		/* Accumulates fractional additions to W_cubic */
+	u32 w_last_max;			/* last W_max */
+	u32 w_tcp;			/* W_est */
+	u64 k;				/* K */
+
+	/* HyStart++ variables in rfc9406#section-4.2 */
+	u32 current_round_min_rtt;	/* currentRoundMinRTT */
+	u32 css_baseline_min_rtt;	/* cssBaselineMinRtt */
+	u32 last_round_min_rtt;		/* lastRoundMinRTT */
+	u16 rtt_sample_count;		/* rttSampleCount */
+	u16 css_rounds;			/* Counter for consecutive rounds showing RTT increase */
+	s64 window_end;			/* End of current CSS round (packet number) */
+};
+
+/* HyStart++ constants in rfc9406#section-4.3 */
+#define QUIC_HS_MIN_SSTHRESH		16
+#define QUIC_HS_N_RTT_SAMPLE		8
+#define QUIC_HS_MIN_ETA			4000
+#define QUIC_HS_MAX_ETA			16000
+#define QUIC_HS_MIN_RTT_DIVISOR		8
+#define QUIC_HS_CSS_GROWTH_DIVISOR	4
+#define QUIC_HS_CSS_ROUNDS		5
+
+static u64 cubic_root(u64 n)
+{
+	u64 a, d;
+
+	if (!n)
+		return 0;
+
+	d = (64 - __builtin_clzll(n)) / 3;
+	a = BIT_ULL(d + 1);
+
+	for (; a * a * a > n;) {
+		d = div64_ul(n, a * a);
+		a = div64_ul(2 * a + d, 3);
+	}
+	return a;
+}
+
+/* rfc9406#section-4: HyStart++ Algorithm */
+static void cubic_slow_start(struct quic_cong *cong, u32 bytes, s64 number)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+	u32 eta;
+
+	if (cubic->window_end <= number)
+		cubic->window_end = -1;
+
+	/* cwnd = cwnd + (min(N, L * SMSS) / CSS_GROWTH_DIVISOR) */
+	if (cubic->css_baseline_min_rtt != U32_MAX)
+		bytes = bytes / QUIC_HS_CSS_GROWTH_DIVISOR;
+	cong->window = min_t(u32, cong->window + bytes, cong->max_window);
+
+	if (cubic->css_baseline_min_rtt != U32_MAX) {
+		/* If CSS_ROUNDS rounds are complete, enter congestion avoidance. */
+		if (++cubic->css_rounds > QUIC_HS_CSS_ROUNDS) {
+			cubic->css_baseline_min_rtt = U32_MAX;
+			cubic->w_last_max = cong->window;
+			cong->ssthresh = cong->window;
+			cubic->css_rounds = 0;
+		}
+		return;
+	}
+
+	/* if ((rttSampleCount >= N_RTT_SAMPLE) AND
+	 *     (currentRoundMinRTT != infinity) AND
+	 *     (lastRoundMinRTT != infinity))
+	 *   RttThresh = max(MIN_RTT_THRESH,
+	 *     min(lastRoundMinRTT / MIN_RTT_DIVISOR, MAX_RTT_THRESH))
+	 *   if (currentRoundMinRTT >= (lastRoundMinRTT + RttThresh))
+	 *     cssBaselineMinRtt = currentRoundMinRTT
+	 *     exit slow start and enter CSS
+	 */
+	if (cubic->last_round_min_rtt != U32_MAX &&
+	    cubic->current_round_min_rtt != U32_MAX &&
+	    cong->window >= QUIC_HS_MIN_SSTHRESH * cong->mss &&
+	    cubic->rtt_sample_count >= QUIC_HS_N_RTT_SAMPLE) {
+		eta = cubic->last_round_min_rtt / QUIC_HS_MIN_RTT_DIVISOR;
+		if (eta < QUIC_HS_MIN_ETA)
+			eta = QUIC_HS_MIN_ETA;
+		else if (eta > QUIC_HS_MAX_ETA)
+			eta = QUIC_HS_MAX_ETA;
+
+		pr_debug("%s: current_round_min_rtt: %u, last_round_min_rtt: %u, eta: %u\n",
+			 __func__, cubic->current_round_min_rtt, cubic->last_round_min_rtt, eta);
+
+		/* Delay increase triggers slow start exit and enter CSS. */
+		if (cubic->current_round_min_rtt >= cubic->last_round_min_rtt + eta)
+			cubic->css_baseline_min_rtt = cubic->current_round_min_rtt;
+	}
+}
+
+/* rfc9438#section-4: CUBIC Congestion Control */
+static void cubic_cong_avoid(struct quic_cong *cong, u32 bytes)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+	u64 tx, kx, time_delta, delta, t;
+	u64 target_add, tcp_add = 0;
+	u64 target, cwnd_thres, m;
+
+	if (cubic->epoch_start == U32_MAX) {
+		cubic->epoch_start = cong->time;
+		if (cong->window < cubic->w_last_max) {
+			/*
+			 *        ┌────────────────┐
+			 *     3  │W    - cwnd
+			 *     ╲  │ max       epoch
+			 * K =  ╲ │────────────────
+			 *       ╲│       C
+			 */
+			cubic->k = cubic->w_last_max - cong->window;
+			cubic->k = cubic_root(div64_ul(cubic->k * 10, (u64)cong->mss * 4));
+			cubic->origin_point = cubic->w_last_max;
+		} else {
+			cubic->k = 0;
+			cubic->origin_point = cong->window;
+		}
+		cubic->w_tcp = cong->window;
+		cubic->pending_add = 0;
+		cubic->pending_w_add = 0;
+	}
+
+	/*
+	 * t = t        - t
+	 *      current    epoch
+	 */
+	t = cong->time - cubic->epoch_start;
+	tx = div64_ul(t << 10, USEC_PER_SEC);
+	kx = (cubic->k << 10);
+	if (tx > kx)
+		time_delta = tx - kx;
+	else
+		time_delta = kx - tx;
+	/*
+	 *                        3
+	 * W     (t) = C * (t - K)  + W
+	 *  cubic                      max
+	 */
+	delta = cong->mss * ((((time_delta * time_delta) >> 10) * time_delta) >> 10);
+	delta = div64_ul(delta * 4, 10) >> 10;
+	if (tx > kx)
+		target = cubic->origin_point + delta;
+	else
+		target = cubic->origin_point - delta;
+
+	/*
+	 * W     (t + RTT)
+	 *  cubic
+	 */
+	cwnd_thres = (div64_ul((t + cong->smoothed_rtt) << 10, USEC_PER_SEC) * target) >> 10;
+	pr_debug("%s: tgt: %llu, thres: %llu, delta: %llu, t: %llu, srtt: %u, tx: %llu, kx: %llu\n",
+		 __func__, target, cwnd_thres, delta, t, cong->smoothed_rtt, tx, kx);
+	/*
+	 *          ⎧
+	 *          ⎪cwnd            if  W     (t + RTT) < cwnd
+	 *          ⎪                     cubic
+	 *          ⎨1.5 * cwnd      if  W     (t + RTT) > 1.5 * cwnd
+	 * target = ⎪                     cubic
+	 *          ⎪W     (t + RTT) otherwise
+	 *          ⎩ cubic
+	 */
+	if (cwnd_thres < cong->window)
+		target = cong->window;
+	else if (cwnd_thres * 2 > (u64)cong->window * 3)
+		target = cong->window * 3 / 2;
+	else
+		target = cwnd_thres;
+
+	/*
+	 * target - cwnd
+	 * ─────────────
+	 *      cwnd
+	 */
+	if (target > cong->window) {
+		target_add = cubic->pending_add + cong->mss * (target - cong->window);
+		cubic->pending_add = do_div(target_add, cong->window);
+	} else {
+		target_add = cubic->pending_add + cong->mss;
+		cubic->pending_add = do_div(target_add, 100 * cong->window);
+	}
+
+	pr_debug("%s: target: %llu, window: %u, target_add: %llu\n",
+		 __func__, target, cong->window, target_add);
+
+	/*
+	 *                        segments_acked
+	 * W    = W    + α      * ──────────────
+	 *  est    est    cubic        cwnd
+	 */
+	m = cubic->pending_w_add + cong->mss * bytes;
+	cubic->pending_w_add = do_div(m, cong->window);
+	cubic->w_tcp += m;
+
+	if (cubic->w_tcp > cong->window)
+		tcp_add = div64_ul((u64)cong->mss * (cubic->w_tcp - cong->window), cong->window);
+
+	pr_debug("%s: w_tcp: %u, window: %u, tcp_add: %llu\n",
+		 __func__, cubic->w_tcp, cong->window, tcp_add);
+
+	/* W_cubic(_t_) or _W_est_, whichever is bigger. */
+	cong->window += max(tcp_add, target_add);
+}
+
+static void cubic_recovery(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	cong->recovery_time = cong->time;
+	cubic->epoch_start = U32_MAX;
+
+	/* rfc9438#section-3.4:
+	 *   CUBIC sets the multiplicative window decrease factor (β__cubic_) to 0.7,
+	 *   whereas Reno uses 0.5.
+	 *
+	 * rfc9438#section-4.6:
+	 *   ssthresh =  flight_size * β      new  ssthresh
+	 *
+	 *   Some implementations of CUBIC currently use _cwnd_ instead of _flight_size_ when
+	 *   calculating a new _ssthresh_.
+	 *
+	 * rfc9438#section-4.7:
+	 *
+	 *          ⎧       1 + β
+	 *          ⎪            cubic
+	 *          ⎪cwnd * ────────── if  cwnd < W_max and fast convergence
+	 *   W    = ⎨           2
+	 *    max   ⎪                  enabled, further reduce  W_max
+	 *          ⎪
+	 *          ⎩cwnd             otherwise, remember cwnd before reduction
+	 */
+	if (cong->window < cubic->w_last_max)
+		cubic->w_last_max = cong->window * 17 / 10 / 2;
+	else
+		cubic->w_last_max = cong->window;
+
+	cong->ssthresh = cong->window * 7 / 10;
+	cong->ssthresh = max(cong->ssthresh, cong->min_window);
+	cong->window = cong->ssthresh;
+}
+
+static int quic_cong_check_persistent_congestion(struct quic_cong *cong, u32 time)
+{
+	u32 ssthresh;
+
+	/* rfc9002#section-7.6.1:
+	 *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay) *
+	 *      kPersistentCongestionThreshold
+	 */
+	ssthresh = cong->smoothed_rtt + max(4 * cong->rttvar, QUIC_KGRANULARITY);
+	ssthresh = (ssthresh + cong->max_ack_delay) * QUIC_KPERSISTENT_CONGESTION_THRESHOLD;
+	if (cong->time - time <= ssthresh)
+		return 0;
+
+	pr_debug("%s: permanent congestion, cwnd: %u, ssthresh: %u\n",
+		 __func__, cong->window, cong->ssthresh);
+	cong->min_rtt_valid = 0;
+	cong->window = cong->min_window;
+	cong->state = QUIC_CONG_SLOW_START;
+	return 1;
+}
+
+static void quic_cubic_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	if (quic_cong_check_persistent_congestion(cong, time))
+		return;
+
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cubic_recovery(cong);
+}
+
+static void quic_cubic_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		cubic_slow_start(cong, bytes, number);
+		if (cong->window >= cong->ssthresh) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: slow_start -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		if (cong->recovery_time < time) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: recovery -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		cubic_cong_avoid(cong, bytes);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+}
+
+static void quic_cubic_on_process_ecn(struct quic_cong *cong)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cubic_recovery(cong);
+}
+
+static void quic_cubic_on_init(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	cubic->epoch_start = U32_MAX;
+	cubic->origin_point = 0;
+	cubic->w_last_max = 0;
+	cubic->w_tcp = 0;
+	cubic->k = 0;
+
+	cubic->current_round_min_rtt = U32_MAX;
+	cubic->css_baseline_min_rtt = U32_MAX;
+	cubic->last_round_min_rtt = U32_MAX;
+	cubic->rtt_sample_count = 0;
+	cubic->window_end = -1;
+	cubic->css_rounds = 0;
+}
+
+static void quic_cubic_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	if (cubic->window_end != -1)
+		return;
+
+	/* rfc9406#section-4.2:
+	 *   lastRoundMinRTT = currentRoundMinRTT
+	 *   currentRoundMinRTT = infinity
+	 *   rttSampleCount = 0
+	 */
+	cubic->window_end = number;
+	cubic->last_round_min_rtt = cubic->current_round_min_rtt;
+	cubic->current_round_min_rtt = U32_MAX;
+	cubic->rtt_sample_count = 0;
+
+	pr_debug("%s: last_round_min_rtt: %u\n", __func__, cubic->last_round_min_rtt);
+}
+
+static void quic_cubic_on_rtt_update(struct quic_cong *cong)
+{
+	struct quic_cubic *cubic = quic_cong_priv(cong);
+
+	if (cubic->window_end == -1)
+		return;
+
+	pr_debug("%s: current_round_min_rtt: %u, latest_rtt: %u\n",
+		 __func__, cubic->current_round_min_rtt, cong->latest_rtt);
+
+	/* rfc9406#section-4.2:
+	 *   currentRoundMinRTT = min(currentRoundMinRTT, currRTT)
+	 *   rttSampleCount += 1
+	 */
+	if (cubic->current_round_min_rtt > cong->latest_rtt) {
+		cubic->current_round_min_rtt = cong->latest_rtt;
+		if (cubic->current_round_min_rtt < cubic->css_baseline_min_rtt) {
+			cubic->css_baseline_min_rtt = U32_MAX;
+			cubic->css_rounds = 0;
+		}
+	}
+	cubic->rtt_sample_count++;
+}
+
+/* NEW RENO APIs */
+static void quic_reno_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	if (quic_cong_check_persistent_congestion(cong, time))
+		return;
+
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->recovery_time = cong->time;
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		cong->window = min_t(u32, cong->window + bytes, cong->max_window);
+		if (cong->window >= cong->ssthresh) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: slow_start -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		if (cong->recovery_time < time) {
+			cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+			pr_debug("%s: recovery -> cong_avoid, cwnd: %u, ssthresh: %u\n",
+				 __func__, cong->window, cong->ssthresh);
+		}
+		break;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		cong->window += cong->mss * bytes / cong->window;
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+}
+
+static void quic_reno_on_process_ecn(struct quic_cong *cong)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssthresh: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__, cong->state);
+		return;
+	}
+
+	cong->recovery_time = cong->time;
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_init(struct quic_cong *cong)
+{
+}
+
+static struct quic_cong_ops quic_congs[] = {
+	{ /* QUIC_CONG_ALG_RENO */
+		.on_packet_acked = quic_reno_on_packet_acked,
+		.on_packet_lost = quic_reno_on_packet_lost,
+		.on_process_ecn = quic_reno_on_process_ecn,
+		.on_init = quic_reno_on_init,
+	},
+	{ /* QUIC_CONG_ALG_CUBIC */
+		.on_packet_acked = quic_cubic_on_packet_acked,
+		.on_packet_lost = quic_cubic_on_packet_lost,
+		.on_process_ecn = quic_cubic_on_process_ecn,
+		.on_init = quic_cubic_on_init,
+		.on_packet_sent = quic_cubic_on_packet_sent,
+		.on_rtt_update = quic_cubic_on_rtt_update,
+	},
+};
+
+/* COMMON APIs */
+void quic_cong_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	cong->ops->on_packet_lost(cong, time, bytes, number);
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	cong->ops->on_packet_acked(cong, time, bytes, number);
+}
+
+void quic_cong_on_process_ecn(struct quic_cong *cong)
+{
+	cong->ops->on_process_ecn(cong);
+}
+
+/* Update Probe Timeout (PTO) and loss detection delay based on RTT stats. */
+static void quic_cong_pto_update(struct quic_cong *cong)
+{
+	u32 pto, loss_delay;
+
+	/* rfc9002#section-6.2.1:
+	 *   PTO = smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay
+	 */
+	pto = cong->smoothed_rtt + max(4 * cong->rttvar, QUIC_KGRANULARITY);
+	cong->pto = pto + cong->max_ack_delay;
+
+	/* rfc9002#section-6.1.2:
+	 *   max(kTimeThreshold * max(smoothed_rtt, latest_rtt), kGranularity)
+	 */
+	loss_delay = QUIC_KTIME_THRESHOLD(max(cong->smoothed_rtt, cong->latest_rtt));
+	cong->loss_delay = max(loss_delay, QUIC_KGRANULARITY);
+
+	pr_debug("%s: update pto: %u\n", __func__, pto);
+}
+
+/* Update pacing timestamp after sending 'bytes' bytes.
+ *
+ * This function tracks when the next packet is allowed to be sent based on pacing rate.
+ */
+static void quic_cong_update_pacing_time(struct quic_cong *cong, u32 bytes)
+{
+	unsigned long rate = READ_ONCE(cong->pacing_rate);
+	u64 prior_time, credit, len_ns;
+
+	if (!rate)
+		return;
+
+	prior_time = cong->pacing_time;
+	cong->pacing_time = max(cong->pacing_time, ktime_get_ns());
+	credit = cong->pacing_time - prior_time;
+
+	/* take into account OS jitter */
+	len_ns = div64_ul((u64)bytes * NSEC_PER_SEC, rate);
+	len_ns -= min_t(u64, len_ns / 2, credit);
+	cong->pacing_time += len_ns;
+}
+
+/* Compute and update the pacing rate based on congestion window and smoothed RTT. */
+static void quic_cong_pace_update(struct quic_cong *cong, u32 bytes, u32 max_rate)
+{
+	u64 rate;
+
+	/* rate = N * congestion_window / smoothed_rtt */
+	rate = (u64)cong->window * USEC_PER_SEC * 2;
+	if (likely(cong->smoothed_rtt))
+		rate = div64_ul(rate, cong->smoothed_rtt);
+
+	WRITE_ONCE(cong->pacing_rate, min_t(u64, rate, max_rate));
+	pr_debug("%s: update pacing rate: %u, max rate: %u, srtt: %u\n",
+		 __func__, cong->pacing_rate, max_rate, cong->smoothed_rtt);
+}
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_packet_sent)
+		cong->ops->on_packet_sent(cong, time, bytes, number);
+	quic_cong_update_pacing_time(cong, bytes);
+}
+
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u32 max_rate)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_ack_recv)
+		cong->ops->on_ack_recv(cong, bytes, max_rate);
+	quic_cong_pace_update(cong, bytes, max_rate);
+}
+
+/* rfc9002#section-5: Estimating the Round-Trip Time */
+void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay)
+{
+	u32 adjusted_rtt, rttvar_sample;
+
+	/* Ignore RTT sample if ACK delay is suspiciously large. */
+	if (ack_delay > cong->max_ack_delay * 2)
+		return;
+
+	/* rfc9002#section-5.1: latest_rtt = ack_time - send_time_of_largest_acked */
+	cong->latest_rtt = cong->time - time;
+
+	/* rfc9002#section-5.2: Estimating min_rtt */
+	if (!cong->min_rtt_valid) {
+		cong->min_rtt = cong->latest_rtt;
+		cong->min_rtt_valid = 1;
+	}
+	if (cong->min_rtt > cong->latest_rtt)
+		cong->min_rtt = cong->latest_rtt;
+
+	if (!cong->is_rtt_set) {
+		/* rfc9002#section-5.3:
+		 *   smoothed_rtt = latest_rtt
+		 *   rttvar = latest_rtt / 2
+		 */
+		cong->smoothed_rtt = cong->latest_rtt;
+		cong->rttvar = cong->smoothed_rtt / 2;
+		quic_cong_pto_update(cong);
+		cong->is_rtt_set = 1;
+		return;
+	}
+
+	/* rfc9002#section-5.3:
+	 *   adjusted_rtt = latest_rtt
+	 *   if (latest_rtt >= min_rtt + ack_delay):
+	 *     adjusted_rtt = latest_rtt - ack_delay
+	 *   smoothed_rtt = 7/8 * smoothed_rtt + 1/8 * adjusted_rtt
+	 *   rttvar_sample = abs(smoothed_rtt - adjusted_rtt)
+	 *   rttvar = 3/4 * rttvar + 1/4 * rttvar_sample
+	 */
+	adjusted_rtt = cong->latest_rtt;
+	if (cong->latest_rtt >= cong->min_rtt + ack_delay)
+		adjusted_rtt = cong->latest_rtt - ack_delay;
+
+	cong->smoothed_rtt = (cong->smoothed_rtt * 7 + adjusted_rtt) / 8;
+	if (cong->smoothed_rtt >= adjusted_rtt)
+		rttvar_sample = cong->smoothed_rtt - adjusted_rtt;
+	else
+		rttvar_sample = adjusted_rtt - cong->smoothed_rtt;
+	cong->rttvar = (cong->rttvar * 3 + rttvar_sample) / 4;
+	quic_cong_pto_update(cong);
+
+	if (cong->ops->on_rtt_update)
+		cong->ops->on_rtt_update(cong);
+}
+
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo)
+{
+	if (algo >= QUIC_CONG_ALG_MAX)
+		algo = QUIC_CONG_ALG_RENO;
+
+	cong->state = QUIC_CONG_SLOW_START;
+	cong->ssthresh = U32_MAX;
+	cong->ops = &quic_congs[algo];
+	cong->ops->on_init(cong);
+}
+
+void quic_cong_set_srtt(struct quic_cong *cong, u32 srtt)
+{
+	/* rfc9002#section-5.3:
+	 *   smoothed_rtt = kInitialRtt
+	 *   rttvar = kInitialRtt / 2
+	 */
+	cong->latest_rtt = srtt;
+	cong->smoothed_rtt = cong->latest_rtt;
+	cong->rttvar = cong->smoothed_rtt / 2;
+	quic_cong_pto_update(cong);
+}
+
+void quic_cong_init(struct quic_cong *cong)
+{
+	cong->max_ack_delay = QUIC_DEF_ACK_DELAY;
+	cong->max_window = S32_MAX / 2;
+	quic_cong_set_algo(cong, QUIC_CONG_ALG_RENO);
+	quic_cong_set_srtt(cong, QUIC_RTT_INIT);
+}
diff --git a/net/quic/cong.h b/net/quic/cong.h
new file mode 100644
index 000000000000..cb83c00a554f
--- /dev/null
+++ b/net/quic/cong.h
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#define QUIC_KPERSISTENT_CONGESTION_THRESHOLD	3
+#define QUIC_KPACKET_THRESHOLD			3
+#define QUIC_KTIME_THRESHOLD(rtt)		((rtt) * 9 / 8)
+#define QUIC_KGRANULARITY			1000U
+
+#define QUIC_RTT_INIT		333000U
+#define QUIC_RTT_MAX		2000000U
+#define QUIC_RTT_MIN		QUIC_KGRANULARITY
+
+/* rfc9002#section-7.3: Congestion Control States
+ *
+ *                  New path or      +------------+
+ *             persistent congestion |   Slow     |
+ *         (O)---------------------->|   Start    |
+ *                                   +------------+
+ *                                         |
+ *                                 Loss or |
+ *                         ECN-CE increase |
+ *                                         v
+ *  +------------+     Loss or       +------------+
+ *  | Congestion |  ECN-CE increase  |  Recovery  |
+ *  | Avoidance  |------------------>|   Period   |
+ *  +------------+                   +------------+
+ *            ^                            |
+ *            |                            |
+ *            +----------------------------+
+ *               Acknowledgment of packet
+ *                 sent during recovery
+ */
+enum quic_cong_state {
+	QUIC_CONG_SLOW_START,
+	QUIC_CONG_RECOVERY_PERIOD,
+	QUIC_CONG_CONGESTION_AVOIDANCE,
+};
+
+struct quic_cong {
+	/* RTT tracking */
+	u32 smoothed_rtt;	/* Smoothed RTT */
+	u32 latest_rtt;		/* Latest RTT sample */
+	u32 min_rtt;		/* Lowest observed RTT */
+	u32 rttvar;		/* RTT variation */
+	u32 loss_delay;		/* Time before marking loss */
+	u32 pto;		/* Probe timeout */
+
+	/* Timing & pacing */
+	u32 max_ack_delay;	/* max_ack_delay from rfc9000#section-18.2 */
+	u32 recovery_time;	/* Recovery period start */
+	u32 pacing_rate;	/* Packet sending speed Bytes/sec */
+	u64 pacing_time;	/* Next send time */
+	u32 time;		/* Cached time */
+
+	/* Congestion window */
+	u32 max_window;		/* Max growth cap */
+	u32 min_window;		/* Min window limit */
+	u32 ssthresh;		/* Slow start threshold */
+	u32 window;		/* Bytes in flight allowed */
+	u32 mss;		/* QUIC MSS (excl. UDP) */
+
+	/* Algorithm-specific */
+	struct quic_cong_ops *ops;
+	u64 priv[8];		/* Algo private data */
+
+	/* Flags & state */
+	u8 min_rtt_valid;	/* min_rtt initialized */
+	u8 is_rtt_set;		/* RTT samples exist */
+	u8 state;		/* State machine in rfc9002#section-7.3 */
+};
+
+/* Hooks for congestion control algorithms */
+struct quic_cong_ops {
+	void (*on_packet_acked)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_packet_lost)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_process_ecn)(struct quic_cong *cong);
+	void (*on_init)(struct quic_cong *cong);
+
+	/* Optional callbacks */
+	void (*on_packet_sent)(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+	void (*on_ack_recv)(struct quic_cong *cong, u32 bytes, u32 max_rate);
+	void (*on_rtt_update)(struct quic_cong *cong);
+};
+
+static inline void quic_cong_set_mss(struct quic_cong *cong, u32 mss)
+{
+	if (cong->mss == mss)
+		return;
+
+	/* rfc9002#section-7.2: Initial and Minimum Congestion Window */
+	cong->mss = mss;
+	cong->min_window = max(min(mss * 10, 14720U), mss * 2);
+
+	if (cong->window < cong->min_window)
+		cong->window = cong->min_window;
+}
+
+static inline void *quic_cong_priv(struct quic_cong *cong)
+{
+	return (void *)cong->priv;
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_packet_lost(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_process_ecn(struct quic_cong *cong);
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u32 time, u32 bytes, s64 number);
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u32 max_rate);
+void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay);
+
+void quic_cong_set_srtt(struct quic_cong *cong, u32 srtt);
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo);
+void quic_cong_init(struct quic_cong *cong);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index c549e76623e3..8ee4e4cd4ee3 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -44,6 +44,7 @@ static int quic_init_sock(struct sock *sk)
 
 	quic_conn_id_set_init(quic_source(sk), 1);
 	quic_conn_id_set_init(quic_dest(sk), 0);
+	quic_cong_init(quic_cong(sk));
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 3cff2a1d478a..019f8752fc87 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -16,6 +16,7 @@
 #include "stream.h"
 #include "connid.h"
 #include "path.h"
+#include "cong.h"
 
 #include "protocol.h"
 
@@ -42,6 +43,7 @@ struct quic_sock {
 	struct quic_conn_id_set		source;
 	struct quic_conn_id_set		dest;
 	struct quic_path_group		paths;
+	struct quic_cong		cong;
 };
 
 struct quic6_sock {
@@ -104,6 +106,11 @@ static inline bool quic_is_serv(const struct sock *sk)
 	return quic_paths(sk)->serv;
 }
 
+static inline struct quic_cong *quic_cong(const struct sock *sk)
+{
+	return &quic_sk(sk)->cong;
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

