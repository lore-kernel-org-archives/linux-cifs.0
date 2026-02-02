Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D313D8B1
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770042608; cv=none; b=WHR/FqaZeO9NaydoHyzlSIJCxzPXACUyUwFvwONZ6L2fAKUUPvlAi4q+BeQfT7whRSXKSAPSp4vX3HypT++zCYM0K0M0ZUaRaAnOJkIOC0nm5jvPwM9eWa71jXC7t3/HAO9JPHW0OUoWCOw2luKhsGrmlZ2uzc6M3SCzIelNJhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770042608; c=relaxed/simple;
	bh=JRS5kSLqieYcOo+2YKegoiunqbIKylQ7ka9VFmm0krs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNtJCLSrpiollfL+pmNn1tSitDjhHWVx2EqLjzAq4rptEhW7jkETcpDCTK6fhLtRcXKCvIcq/+yhY/r65WFnD4CdY8xxpDMPF4kg6ItqzPDSFJHXbP53ydRY4TXYwaI8YGaPZ3zPQBh372uICO0ApnzqDxXjT939sPKCtFXdiNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GIZBm+pz; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GIZBm+pz"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-501469b598fso32849901cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 06:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770042605; x=1770647405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vwz7dsE3La2T47FXH9I0wT9lHwPBqUNLpB+Tj0Wrw9o=;
        b=GIZBm+pzB0ms29WmjE0suA6GM4JmOoWR14EmCeQp6KiIwW++168iegz1B6gJlIkNFh
         wlN+JIhx5ntcdoUrp3x8g707wBkmaBw8LOIDzPMdeW15E/dcbnfTi/EOLmj0xb/zTodo
         DqfhSFsUPCKrcMdz/JVZLpiESzGUpgzFfzcUFSWrNBFxNGhIW8jR5xCkCEG/ZdU7KlPe
         uh7KjkPRuZF9t7gCmyoQsfnvtlHGUiR/HApW0KIRjnbe1HCj+LmzQ8tvNS3Jq0zbBjch
         aQuuw/f8LXbWIRdoTN8YEKSxdvgNMvniA6+ezzohOPDIyw5+xnZ5wSgU+/rcc26HQ3uh
         qgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770042605; x=1770647405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vwz7dsE3La2T47FXH9I0wT9lHwPBqUNLpB+Tj0Wrw9o=;
        b=KECEql9OIAyt2FFsP/4yJ+FHUDFI5wzkIvJkmtUo7JfJ/wktAtOrfkDT00zb8m2cIM
         t+SsZDT8Mk7Ga3pAR7eu/LCUn7P/Hv7Dy0W4E8Er5Y2zyFfNYEZlaFjA3jAl7r4NWsTA
         nq15f+QWWsLRbNSPOBiA4RFj9d+zI2NniTu2IDf7EmIvac63DBOaW83Q69RalozafBou
         p0CXRTO3JHkF/QZ4uqH94S03NMWJBxyxuuVK2CJh4jManfHpS2Xfg/FOUlEP44o1TSUl
         ELohmxuPeN+4mqFbjh4Tg3jjKK5w92Yfa3M5CDQUNsbge7nD/avdPpEydK1rgLjL6fVW
         sgwA==
X-Forwarded-Encrypted: i=1; AJvYcCV8dc7BicQnFeK5bG1U7jA2dOM13giZvpHr9bgZ+S8rxZWdAQdxaTcBsUHlKr54bhDXek73Z6fYZ4c3@vger.kernel.org
X-Gm-Message-State: AOJu0YzPzDEC1p7S6VYPdt5g8ULMsBbgM9aQ2JvNGC6exmxcY1nPBlU7
	3kR6x0b/PLPeSqrYE9hWUs1EIqjr8ot4iVEVBUkXHJyHjPomJDC37ava
X-Gm-Gg: AZuq6aI94gYmCH+FjOfQ/mhewdtncphQamukksA9zBFnb20GTZgADRQiJcLqtk5jTJK
	xlPqAlMxBQ+NEl47eRLolt2fhsav4mkgKwCtwQDD9q8kg7bYgmUKlJVIBjZn6nfqgn4VV85EZDF
	MmWWqDGxIFYAhPooTiuk0I45hntaQmLS8imA7GvfruXZW8QGL8kTB1+npXzT7don9jTukkwxgYx
	yQlPc72NQ6Z69p8vlcUJ0CrLfJCtM8fW6JdjGdazt4QhPQnCY+6ThF6kII3XUn/E8Slja66ev/z
	MFsVVx0JkOc2+Iy4nPkWK+GSlYucjSMxHc9lGkFKbcUZ6XDSX/K94LuH+KOOWrW1A/ykxKIToOZ
	QrhI8ZMVfnPY+2LBm3HwyYlGEVBJvgu83pC063wwZURf/FvkL0yy/CxfmDRc+mxcPAK4mXosho/
	O973dUQfh1eFZjSu5xh5GMnxMFf0uH+1cqh/gVSyaHlTCh3cQ0xF0=
X-Received: by 2002:ac8:7d84:0:b0:501:4bb5:51a2 with SMTP id d75a77b69052e-505d227538dmr150236661cf.53.1770042604680;
        Mon, 02 Feb 2026 06:30:04 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337ba3981sm106865171cf.16.2026.02.02.06.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 06:30:04 -0800 (PST)
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
	Paulo Alcantara <pc@manguebit.com>,
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v9 09/15] quic: add congestion control
Date: Mon,  2 Feb 2026 09:27:35 -0500
Message-ID: <a872188a6e4d7b39d6d6d0f6fad7e5077bce4bae.1770042461.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1770042461.git.lucien.xin@gmail.com>
References: <cover.1770042461.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile |   3 +-
 net/quic/cong.c   | 307 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/cong.h   | 120 ++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   7 ++
 5 files changed, 437 insertions(+), 1 deletion(-)
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
index 000000000000..64bc90b31526
--- /dev/null
+++ b/net/quic/cong.c
@@ -0,0 +1,307 @@
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
+static int quic_cong_check_persistent_congestion(struct quic_cong *cong, u64 time)
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
+	pr_debug("%s: persistent congestion, cwnd: %u, ssthresh: %u\n",
+		 __func__, cong->window, cong->ssthresh);
+	cong->min_rtt_valid = 0;
+	cong->window = cong->min_window;
+	cong->state = QUIC_CONG_SLOW_START;
+	return 1;
+}
+
+/* NEW RENO APIs */
+static void quic_reno_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes, s64 number)
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
+static void quic_reno_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes, s64 number)
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
+		/* cong->window is never zero; it is initialized by quic_packet_route()
+		 * during connect/accept.
+		 */
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
+};
+
+/* COMMON APIs */
+void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes, s64 number)
+{
+	cong->ops->on_packet_lost(cong, time, bytes, number);
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes, s64 number)
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
+	u64 prior_time, credit, len_ns, rate = READ_ONCE(cong->pacing_rate);
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
+static void quic_cong_pace_update(struct quic_cong *cong, u32 bytes, u64 max_rate)
+{
+	u64 rate;
+
+	if (unlikely(!cong->smoothed_rtt))
+		return;
+
+	/* rate = N * congestion_window / smoothed_rtt */
+	rate = div64_ul((u64)cong->window * USEC_PER_SEC * 2, cong->smoothed_rtt);
+
+	WRITE_ONCE(cong->pacing_rate, min_t(u64, rate, max_rate));
+	pr_debug("%s: update pacing rate: %llu, max rate: %llu, srtt: %u\n",
+		 __func__, cong->pacing_rate, max_rate, cong->smoothed_rtt);
+}
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes, s64 number)
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
index 000000000000..f0f889f776d4
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
+	u32 max_ack_delay;	/* max_ack_delay from rfc9000#section-18.2 */
+	u32 smoothed_rtt;	/* Smoothed RTT */
+	u32 latest_rtt;		/* Latest RTT sample */
+	u32 min_rtt;		/* Lowest observed RTT */
+	u32 rttvar;		/* RTT variation */
+	u32 pto;		/* Probe timeout */
+
+	/* Timing & pacing */
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
+	void (*on_packet_acked)(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
+	void (*on_packet_lost)(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
+	void (*on_process_ecn)(struct quic_cong *cong);
+	void (*on_init)(struct quic_cong *cong);
+
+	/* Optional callbacks */
+	void (*on_packet_sent)(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
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
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
+void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
+void quic_cong_on_process_ecn(struct quic_cong *cong);
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes, s64 number);
+void quic_cong_on_ack_recv(struct quic_cong *cong, u32 bytes, u64 max_rate);
+void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay);
+
+void quic_cong_set_srtt(struct quic_cong *cong, u32 srtt);
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo);
+void quic_cong_init(struct quic_cong *cong);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 3427039d5416..54598044dbe4 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -43,6 +43,7 @@ static int quic_init_sock(struct sock *sk)
 
 	quic_conn_id_set_init(quic_source(sk), 1);
 	quic_conn_id_set_init(quic_dest(sk), 0);
+	quic_cong_init(quic_cong(sk));
 
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 0553caaa0237..c5684cf7378d 100644
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

