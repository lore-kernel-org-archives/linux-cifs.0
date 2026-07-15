Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12653C4172
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147539; cv=none; b=eNtY0O49dqLz7zX356UFgMo1UF/YY3SNvaw4AZE/0+Nt/l2L1Pd/6Ehh+jR3mJ+VfoExXi0sMmtq43K9DIFtB9wn6JYkoDERBzKHHzCdWrMdpcn2chcWI7H7lv5klgBhthDmg64wwV1N5/s1uHG2prRnu48X1S9B7rNNU8L1VtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147539; c=relaxed/simple;
	bh=xBGgn8uTpldb4qQ8gJHBxdYl5+JXBHEUJWvbL2U7/eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzWX+LLYx5iYajH3SKd9MwZSPoqGEeEHQ3vWXW5nKsXlV4Br5Mh0eC3A185bF537RBku89YiCL7pd+mpbQY1GnXeXXBOndD/oA4zFsXHrGAAt5wZQh1POGFPpzt6cHokRCUPJ1IdkyQoufvDud+O1Jp8c+A7xXPnsnl7S+PLY8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=brArOuP+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="brArOuP+"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so53637696d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147535; x=1784752335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FP4hthMJa3Rmn+LrO0FwrzvLqUcoOOPoKptiMC8h+HY=;
        b=brArOuP+e3704qwmyG9ieKRTxnyQcJZiQnJi7rdbknDr9Tc0IIVdXj0zmN9RMi4pW1
         VnA63GqmdgMsvEfCXS2nCH/FLUf8Yk+yfktdlqcmkk6BjlsfmtmUtn8MlERUC6KJAuNx
         5wLvVHXg19MUU6qSyBFsCwMlV/Gjk0+t+v8tAx1nNHQyxyK/yDjCE678UiHrbao2UxI9
         vP8dFfUFYVGtfnT/RQNE6kv+Jqpemx6I5X5IURIXhv37MdzoYaqRCL1da92CZzV9nkQZ
         9jmGyGrXHFLCVMSyCKvmHMBHaJn2bHPBDXleCemHqrddRkgv2VUb7+gzVF7L2d90I/kx
         ty2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147535; x=1784752335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FP4hthMJa3Rmn+LrO0FwrzvLqUcoOOPoKptiMC8h+HY=;
        b=DvHeqWQKeHiv6Glo1P8thLou5zw2JFIDS7F+P6r0PH60BuWJcFHxa9GjFV+sQRhhRu
         2EEDpUrxfywwqNhV3S929FVqsQc24DWiANVPd3A+2FMySazGKT+D5LVVuyNx5CYh13PU
         aQaDJAi0Vn6jJRo9ScftvQxfVN9Uf0/gMynZe1s2YURO6zd+Mcjgp2ukUKCShREBBzD1
         YlyA22deGR5+MVTpnrqvFdFzmBEhGHvNdJkDJZvLoQ0Tfjs6hX+NstKt1e9DJcQtzpTx
         YzUoAcdJihRE253wadLTglr16EH7cUM2Njg+GAbyNcGb0ZpAY8SetQdZanZtyuIZHM0f
         4Q8A==
X-Forwarded-Encrypted: i=1; AHgh+RpP/rAOuW1f0Lv5s7Pk7t10nFrWQe/iQnccNEpOtapdz3DQiQG2CzHo2o1+cm3Jz40WVfKZEK/IorS3@vger.kernel.org
X-Gm-Message-State: AOJu0YwHgs52I9+kBeqOvNknN9TlwxmLAnpz+aqKIPm8InNYwH9Tx72w
	lA2zfH93oWLuSx2twquuBIWUNA6NGzIL1PMIJqr9NodkGAJPkQVbl3rr
X-Gm-Gg: AfdE7cnwMljB4uQGCt9cD/gc527FjpNVv+iQwDO8cXM5HxCTZHuc2aRkm5lde1E/ptt
	E2/zkivw8Nkbub2YidszhanQhsncsaZNPRXyTsiVBiRDP4g2rN3RXm/SHjR2PPUBGRFa0/Bp+W5
	qRgFmT7CcM/QjMKYyUK0lUQeHXyH5AGfMl2Y1NA0T/6qrMDPuN0qMmlff7pOw8IyZBAT4d0hUlD
	F1E8dAgN+i6lPeniWZ0vGRRSn513mZI6CEyijXKYpPfYHgsoUrCC3ymR5DzHGZsZL3shZ+6+ton
	ZqEumove17yhKr+lewckFc+MvEjdrsk3Zox4UZ+YiyY0sMdJdMAlVsJCUz2aYeMztm6XIuYFKDq
	5uHFr/mRBT+3gPV3+8lh08hL3BisoDRnDjp7VofDMUEHMk7w+JGnhjnjNcbTL7DAbZuEN46JTDo
	NXZ6ERJ4ShQzKIK7rtGM+iApeopNM5/gkmv7HW2JRArsF0tZ1jRpaijDcz8qWhJE3oG18AU39Ut
	hEBhCGbOpWwH9F5IxD53h1EqyE23xuR78ULxtob2f5h+1UaRBGAFc0=
X-Received: by 2002:a05:6214:3210:b0:8ef:31b6:74e8 with SMTP id 6a1803df08f44-90758cd5f41mr49519936d6.10.1784147535416;
        Wed, 15 Jul 2026 13:32:15 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:14 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org
Subject: [PATCH net-next v14 09/15] quic: add congestion control
Date: Wed, 15 Jul 2026 16:27:12 -0400
Message-ID: <ee79bfe6f1db2fa99014c153f8fbe605b7c3b9f6.1784147238.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
References: <cover.1784147238.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces 'quic_cong' for RTT measurement and congestion
control. The 'quic_cong_ops' is added to define the congestion
control algorithm.

It implements a congestion control state machine with slow start,
congestion avoidance, and recovery phases, and currently introduces
the New Reno algorithm only.

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
v4:
  - Remove the CUBIC congestion algorithm support for this version
    (suggested by Paolo).
v5:
  - Do not update the pacing rate when !cong->smoothed_rtt in
    quic_cong_pace_update() (suggested by Paolo).
  - Change timestamp variables from u32 to u64, as RTT is measured in
    microseconds and u64 provides sufficient precision for timestamps
    in microsecond.
v8:
  - Add a comment in quic_reno_on_packet_acked() clarifying cong->window
    is never zero (noted by AI review).
v9:
  - Use abs_diff() to simplify RTT variance calculation (noted by AI
    review).
  - Fix a small typo in the comment for struct quic_cong::time (noted
    by AI review).
  - Fix another small typo in quic_cong_check_persistent_congestion().
v10:
  - Note for AI reviews: cong->time will always be set before processing
    the packet on the RX path in the future patch series.
  - Add initial_srtt and algo to struct quic_cong to store the initial
    smoothed RTT and congestion control algorithm, previously kept in
    quic_sock.config.
v11:
  - Note for AI reviews: later patches guarantee cong->time is set
    before any quic_cong function uses it.
  - Note for AI reviews: RFC 9002 section 5.3 does NOT specify that
    rttvar_sample must use the previous smoothed_rtt value.
  - Set maximum line length to 80 characters.
  - Change return type of quic_cong_check_persistent_congestion() to bool.
  - Add a check for algo in quic_cong_set_algo().
  - Extract quic_reno_handle_packet_lost() from quic_reno_on_packet_lost()
    and quic_reno_on_process_ecn() (noted by AI review).
v12:
  - Delete the unnecessary WRITE_ONCE() and READ_ONCE() for
    cong->pacing_rate, as it's always used under sock lock.
  - Set cong->max_window to S32_MAX / 4 instead of S32_MAX / 2.
  - Add pc_start_time in struct quic_cong to track persistent congestion
    start time more precisely and improve persistent congestion detection;
    move its handling into quic_cong_on_packet_lost() and
    quic_cong_on_packet_acked().
v14:
  - Constify the ops member in struct quic_cong and quic_congs[].
  - Increase QUIC_RTT_MAX from 2s to 6s, and check cong->time - time
    against it to avoid latest_rtt overflow in quic_cong_rtt_update().
  - Introduce a u64 new_window variable in quic_reno_on_packet_acked()
    to avoid cong->window overflow (noted by Sashiko AI review).
---
 net/quic/Makefile |   3 +-
 net/quic/cong.c   | 338 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/cong.h   | 130 ++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   7 +
 5 files changed, 478 insertions(+), 1 deletion(-)
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
index 000000000000..dc04bde55c60
--- /dev/null
+++ b/net/quic/cong.c
@@ -0,0 +1,338 @@
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
+#include <linux/quic.h>
+
+#include "common.h"
+#include "cong.h"
+
+/* NEW RENO APIs */
+static void quic_reno_handle_packet_lost(struct quic_cong *cong)
+{
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		pr_debug("%s: slow_start -> recovery, cwnd: %u, ssth: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		return;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		pr_debug("%s: cong_avoid -> recovery, cwnd: %u, ssth: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__,
+			 cong->state);
+		return;
+	}
+
+	cong->recovery_time = cong->time;
+	cong->state = QUIC_CONG_RECOVERY_PERIOD;
+	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_packet_lost(struct quic_cong *cong, u64 time,
+				     u32 bytes, s64 number)
+{
+	quic_reno_handle_packet_lost(cong);
+}
+
+static void quic_reno_on_packet_acked(struct quic_cong *cong, u64 time,
+				      u32 bytes, s64 number)
+{
+	u64 new_window;
+
+	switch (cong->state) {
+	case QUIC_CONG_SLOW_START:
+		new_window = (u64)cong->window + bytes;
+		cong->window = min_t(u64, new_window, cong->max_window);
+		if (cong->window < cong->ssthresh)
+			break;
+		cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+		pr_debug("%s: slow_start -> cong_avoid, cwnd: %u, ssth: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_RECOVERY_PERIOD:
+		if (cong->recovery_time >= time)
+			break;
+		cong->state = QUIC_CONG_CONGESTION_AVOIDANCE;
+		pr_debug("%s: recovery -> cong_avoid, cwnd: %u, ssth: %u\n",
+			 __func__, cong->window, cong->ssthresh);
+		break;
+	case QUIC_CONG_CONGESTION_AVOIDANCE:
+		/* cong->window is never zero; it is initialized by
+		 * quic_packet_route() during connect/accept.
+		 */
+		new_window = div64_ul((u64)cong->mss * bytes, cong->window) +
+			     cong->window;
+		cong->window = min_t(u64, new_window, cong->max_window);
+		break;
+	default:
+		pr_debug("%s: wrong congestion state: %d\n", __func__,
+			 cong->state);
+		return;
+	}
+}
+
+static void quic_reno_on_process_ecn(struct quic_cong *cong)
+{
+	quic_reno_handle_packet_lost(cong);
+}
+
+static void quic_reno_on_init(struct quic_cong *cong)
+{
+}
+
+static const struct quic_cong_ops quic_congs[] = {
+	{ /* QUIC_CONG_ALG_RENO */
+		.on_packet_acked = quic_reno_on_packet_acked,
+		.on_packet_lost = quic_reno_on_packet_lost,
+		.on_process_ecn = quic_reno_on_process_ecn,
+		.on_init = quic_reno_on_init,
+	},
+};
+
+static bool quic_cong_check_persistent_congestion(struct quic_cong *cong,
+						  u64 time)
+{
+	u32 ssthresh;
+
+	time -= cong->pc_start_time;
+
+	/* rfc9002#section-7.6.1:
+	 *   (smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay) *
+	 *      kPersistentCongestionThreshold
+	 */
+	ssthresh = cong->smoothed_rtt +
+		   max(4 * cong->rttvar, QUIC_KGRANULARITY);
+	ssthresh = (ssthresh + cong->max_ack_delay) *
+		   QUIC_KPERSISTENT_CONGESTION_THRESHOLD;
+
+	return time > ssthresh;
+}
+
+/* COMMON APIs */
+void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number)
+{
+	if (cong->pc_start_time && time > cong->pc_start_time &&
+	    quic_cong_check_persistent_congestion(cong, time)) {
+		cong->pc_start_time = 0;
+		cong->min_rtt_valid = 0;
+		cong->window = cong->min_window;
+		cong->state = QUIC_CONG_SLOW_START;
+		return;
+	}
+
+	if (!cong->pc_start_time && cong->is_rtt_set)
+		cong->pc_start_time = time;
+
+	cong->ops->on_packet_lost(cong, time, bytes, number);
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number)
+{
+	/* When a packet is acked, if time - cong->pc_start_time <= duration
+	 * threshold, it means the acked packet was sent within the persistent
+	 * congestion window.
+	 *
+	 * This breaks the condition in rfc9002#section-7.6.2:
+	 *
+	 * - across all packet number spaces, none of the packets sent between
+	 *   the send times of these two packets are acknowledged;
+	 *
+	 * so pc_start_time is reset to 0.
+	 */
+	if (cong->pc_start_time && time > cong->pc_start_time &&
+	    !quic_cong_check_persistent_congestion(cong, time))
+		cong->pc_start_time = 0;
+
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
+	loss_delay = QUIC_KTIME_THRESHOLD(max(cong->smoothed_rtt,
+					      cong->latest_rtt));
+	cong->loss_delay = max(loss_delay, QUIC_KGRANULARITY);
+
+	pr_debug("%s: update pto: %u\n", __func__, pto);
+}
+
+/* Update pacing timestamp after sending 'bytes' bytes.
+ *
+ * This function tracks when the next packet is allowed to be sent based on
+ * pacing rate.
+ */
+static void quic_cong_update_pacing_time(struct quic_cong *cong, u32 bytes)
+{
+	u64 prior_time, credit, len_ns, rate = cong->pacing_rate;
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
+/* Compute and update the pacing rate based on congestion window and smoothed
+ * RTT.
+ */
+static void quic_cong_pace_update(struct quic_cong *cong, u32 bytes,
+				  u64 max_rate)
+{
+	u64 rate;
+
+	if (unlikely(!cong->smoothed_rtt))
+		return;
+
+	/* rate = N * congestion_window / smoothed_rtt */
+	rate = div64_ul((u64)cong->window * USEC_PER_SEC * 2,
+			cong->smoothed_rtt);
+
+	cong->pacing_rate = min_t(u64, rate, max_rate);
+	pr_debug("%s: update pacing rate: %llu, max rate: %llu, srtt: %u\n",
+		 __func__, cong->pacing_rate, max_rate, cong->smoothed_rtt);
+}
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_packet_sent)
+		cong->ops->on_packet_sent(cong, time, bytes, number);
+	quic_cong_update_pacing_time(cong, bytes);
+}
+
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u64 max_rate)
+{
+	if (!bytes)
+		return;
+	if (cong->ops->on_ack_recv)
+		cong->ops->on_ack_recv(cong, bytes, max_rate);
+	quic_cong_pace_update(cong, bytes, max_rate);
+}
+
+/* rfc9002#section-5: Estimating the Round-Trip Time */
+void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
+{
+	u32 adjusted_rtt, rttvar_sample;
+
+	/* Ignore RTT sample if ACK delay is suspiciously large. */
+	if (ack_delay > cong->max_ack_delay * 2 ||
+	    cong->time - time > QUIC_RTT_MAX)
+		return;
+
+	/* rfc9002#section-5.1:
+	 *   latest_rtt = ack_time - send_time_of_largest_acked
+	 */
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
+	rttvar_sample = abs_diff(cong->smoothed_rtt, adjusted_rtt);
+	cong->rttvar = (cong->rttvar * 3 + rttvar_sample) / 4;
+	quic_cong_pto_update(cong);
+
+	if (cong->ops->on_rtt_update)
+		cong->ops->on_rtt_update(cong);
+}
+
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo)
+{
+	/* The caller must ensure algo < QUIC_CONG_ALG_MAX. */
+	if (WARN_ON_ONCE(algo >= QUIC_CONG_ALG_MAX))
+		return;
+	cong->algo = algo;
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
+	cong->initial_srtt = srtt;
+	cong->latest_rtt = srtt;
+	cong->smoothed_rtt = cong->latest_rtt;
+	cong->rttvar = cong->smoothed_rtt / 2;
+	quic_cong_pto_update(cong);
+}
+
+void quic_cong_init(struct quic_cong *cong)
+{
+	cong->max_ack_delay = QUIC_DEF_ACK_DELAY;
+	cong->max_window = S32_MAX / 4;
+	quic_cong_set_algo(cong, QUIC_CONG_ALG_RENO);
+	quic_cong_set_srtt(cong, QUIC_RTT_INIT);
+}
diff --git a/net/quic/cong.h b/net/quic/cong.h
new file mode 100644
index 000000000000..a9cd5e93ec00
--- /dev/null
+++ b/net/quic/cong.h
@@ -0,0 +1,130 @@
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
+#define QUIC_RTT_MAX		6000000U
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
+	u32 max_ack_delay;	/* max_ack_delay from rfc9000#section-18.2 */
+	u32 smoothed_rtt;	/* Smoothed RTT */
+	u32 latest_rtt;		/* Latest RTT sample */
+	u32 min_rtt;		/* Lowest observed RTT */
+	u32 rttvar;		/* RTT variation */
+	u32 pto;		/* Probe timeout */
+
+	/* Timing & pacing */
+	u64 pc_start_time;      /* Persistent congestion tracking timestamp */
+	u64 recovery_time;	/* Recovery period start timestamp */
+	u64 pacing_rate;	/* Packet sending speed Bytes/sec */
+	u64 pacing_time;	/* Next scheduled send timestamp (ns) */
+	u64 time;		/* Cached current timestamp */
+
+	/* Congestion window */
+	u32 max_window;		/* Max growth cap */
+	u32 min_window;		/* Min window limit */
+	u32 loss_delay;		/* Time before marking loss */
+	u32 ssthresh;		/* Slow start threshold */
+	u32 window;		/* Bytes in flight allowed */
+	u32 mss;		/* QUIC MSS (excl. UDP) */
+
+	/* Algorithm-specific */
+	const struct quic_cong_ops *ops;
+	u64 priv[8];		/* Algo private data */
+
+	u32 initial_srtt;	/* Initial smoothed RTT */
+	u8 algo;		/* Congestion control algorithm */
+
+	/* Flags & state */
+	u8 min_rtt_valid;	/* min_rtt initialized */
+	u8 is_rtt_set;		/* RTT samples exist */
+	u8 state;		/* State machine in rfc9002#section-7.3 */
+};
+
+/* Hooks for congestion control algorithms */
+struct quic_cong_ops {
+	void (*on_packet_acked)(struct quic_cong *cong, u64 time, u32 bytes,
+				s64 number);
+	void (*on_packet_lost)(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number);
+	void (*on_process_ecn)(struct quic_cong *cong);
+	void (*on_init)(struct quic_cong *cong);
+
+	/* Optional callbacks */
+	void (*on_packet_sent)(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number);
+	void (*on_ack_recv)(struct quic_cong *cong, u32 bytes, u64 max_rate);
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
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number);
+void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number);
+void quic_cong_on_process_ecn(struct quic_cong *cong);
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number);
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u64 max_rate);
+void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay);
+
+void quic_cong_set_srtt(struct quic_cong *cong, u32 srtt);
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo);
+void quic_cong_init(struct quic_cong *cong);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 0e5595d14b88..04cfbddc0304 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -51,6 +51,7 @@ static int quic_init_sock(struct sock *sk)
 
 	quic_conn_id_set_init(quic_source(sk), true);
 	quic_conn_id_set_init(quic_dest(sk), false);
+	quic_cong_init(quic_cong(sk));
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 91338601905e..9201ca3edad0 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -16,6 +16,7 @@
 #include "stream.h"
 #include "connid.h"
 #include "path.h"
+#include "cong.h"
 
 #include "protocol.h"
 
@@ -41,6 +42,7 @@ struct quic_sock {
 	struct quic_conn_id_set		source;
 	struct quic_conn_id_set		dest;
 	struct quic_path_group		paths;
+	struct quic_cong		cong;
 };
 
 struct quic6_sock {
@@ -98,6 +100,11 @@ static inline bool quic_is_serv(const struct sock *sk)
 	return !!sk->sk_max_ack_backlog;
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

