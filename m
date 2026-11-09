Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241763;
	b=n7iwZbtYuayQy23l+G3kvEwU77pGTzK8zMOxzPpIF1VtBuzHhXdFDKJgGPFXyvor20z8
	 GWh8qK/bExvkpOMF6cGJV4q/7M9UBs0c+fegjIOOXrEl9X9jhyGMAqblJ9CzrjKv0vFOh
	 VP8Ajr99pYSxepNYyw8xoflmPda+KNmMOjMc38GmMEDwQK+IsN0eDU/b9BeiR+jn3YYYV
	 io5mCoiX/v/EMmWH8VrvhKChQ9tMk5Y2R9Uu8J9rp1yNbiJR6FhDjoAllHxopchptLlH1
	 0zemCstL0i+h/f9uyQyEjbXzjd4p+imRZI0gvXWlPiEr08gys8EEYGYE/N5p6RXXIeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241763;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0eLwyaM0WKHdAVFEKKqlpjlRws7HRtfua31wqD9WpI=;
	b=cmvtYWUCELLELieyPVc3xnt5wzpo1fRf/+XjRE9wvieUTMHJugtWiEPlEPIwwfPdgJIZ
	 5WmOuFZAV1VdWwWU6UaRMbFz1f6JqpEHfXCEE3WVU7xbDDFLY2A6lQeVqD+myksVOXvRm
	 XQ5y45AB+hMoDYIL39phsefL0nZA4wVB9tWdiE4ktk+pTa58c//ERf3NrD9w6RkmEUG4Q
	 TzlTL9W8GH3+JW4Cx9f8qo1/DbHtM90NzdIpqcGmp4QdK67XNFYRQNw3OUEJfo9nfMD/y
	 yaTe92tm6mdvAF794bSbe90kmRFo5rkK800m6H+b9BvbYYmovvG9aUY1HRv/Ja6Lcaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zc+Y6rqz;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4D606A339
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 16:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EB4D606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zc+Y6rqz
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93cbc3ab2fdso54336385a.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 08:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794241762; x=1794846562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O0eLwyaM0WKHdAVFEKKqlpjlRws7HRtfua31wqD9WpI=;
        b=Zc+Y6rqzShF/uNz9uqhzVJfDlGBv7gwIzVwuSVtalZ11NE1u/SnMhtC6lKpPsysJJC
         EIJqwA13FD6kLPKixls3VF9LCTkB/XVwkYhVzLIDJOkrbFRTR9pA6imnhBOlq3tZy986
         Y5zyctKqNLhru7UwSSIrc7JQ7/Ml+jZpGJc3hh71DVicAs/+gFEPaLR6WGdox6BmHPiY
         Yd2s2HXJ88+wLemXAPwFu7X7FRhyr9iUaBQLwoYHQaYP5g97uXkP5D6t5DF0uxTf2PdP
         dHkn0tmx/V97pJ/xTfolkJ2SkBTDGwqlw/aQEAeYzrhqqd6rxNLZe/oqQwjmb7bXqQMU
         ygcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241762; x=1794846562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O0eLwyaM0WKHdAVFEKKqlpjlRws7HRtfua31wqD9WpI=;
        b=eUxrJd04/UKJFYOukTPleHdt+bwLqUsGi9yxEWLkKl6odfIJTeP1c3GB5KzEQYErus
         I3V5kMfhARS/6Tfyqb3pTwFJqEefxkJT+la8OPjELwYhwxDuhhUL1zm6z3VTwwSf3gaw
         j4DeyPJm89RVgGueB5hu8pNpHszSVliJiPSnnmXAvHqqVgYTgvvtgOu5uap6tLLU3v7s
         F+Ms2oNxXmGencpDDq0vbZ/sf7MtGRmpw3gLsKQr+EHPV52Fhqz31K+3dxeioaZh0NtD
         YuJt186xJBhxlV/klDolkrz3hLZW7ut2f7bOHDJZwxW6KTLE0jCGb7Dvw6W9pwMRMh2Y
         /4gA==
X-Forwarded-Encrypted: i=1; AL+hErG1h1aOBRH9afz3Hner6HXzgHKbLb0NNFVHHnQ82dmOvvtCXt6D6kjqLjiorb6QC2UvfuQuiQN6UddH@vger.kernel.org
X-Gm-Message-State: APuU4Z8X52b0heRcr8NfCC7Ezp7NmoUgSCvDD4ob6yfHS+Ca620B3Euh
	c9lprZ/NX91lUyN0sxn1O9qd+fEXmaqBk/OOhaKYaf8ZrtPQPpL528g+
X-Gm-Gg: AYBFou1eFNRnKTnFsjHZ925pGST5YGJZbOIFckcuQo9u791OX/6zzXLpG5RPuTvhJBD
	zL+DxZx64Mz6GlQVq3SeorkB8jPh/cj8AD6tisF75bXIPAkrQ4ofJGWpejVkpoYyZRbRvxqVl8m
	dI0nSlEvmGFWa+K1zFgJNhEvQeQPYBsaqsVUOhu2UOLBirqXNREdsWOaSL0E7XdiUP/Zr3UE7iD
	ggCUfQjK3tp7yxnRQOcBhm4b3rIOZ+1VtPs0VwHA1qUXYbgmKRfTscecTYc6/2XYe3b0lq76onM
	Jfs1BSkZd+4TIPTVQHrIlAX5v2qyHeFUg/4sjw5jOliD321tGURT0kq7dmd/6ICNYWckxAJn7oD
	PkgEbgJFCC8IEdogNwakpYb7KmsCCoOn16rERHB2YEPlyN4GZ9haSGk9dmEyxs/5OHBsdCWTKeV
	VNKLtdp7m68ramW8wjGhNECrMorFtArvDYqPYNA27KqGrA3EySRZSSviTC7KMpP23ZyxM96w/Zz
	prfG6ClOLpooRZP6VbkvxuARh4/PvlqPSwI8I+iObgstDwWCSipjfofeGN/KJD8Q5N92t1I+G23
	/gtnUtCUgp4C2BGL7fV7jCh/KC308IFR6A7DiwVFsH5fpZpq3WjnNNdVcfxdidBv1UXgLgz/RK0
	QuPnPGAbTe/yitMSNuycV7z0NM+rYcZWdNFuhE8VARdJ0Cga1mkvUMkle1CmQ+Z4nzPB6upw=
X-Received: by 2002:a05:620a:4087:b0:93e:f9ba:68fc with SMTP id af79cd13be357-947841eb005mr714838285a.21.1794241761970;
        Mon, 09 Nov 2026 08:29:21 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7915e2sm9102985a.23.2026.11.09.08.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:29:21 -0800 (PST)
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
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
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
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v18 09/15] quic: add congestion control
Date: Mon,  9 Nov 2026 11:27:30 -0500
Message-ID: <059c6b92785dcc2983956ff2dcd441285362aa03.1794241656.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794241654.git.lucien.xin@gmail.com>
References: <cover.1794241654.git.lucien.xin@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
accordingly during packet transmission or acknowledgment processing.

- quic_cong_rtt_update(): Performs RTT measurement, invoked when a
  packet is acknowledged by the largest number in the ACK frame.

- quic_cong_on_packet_acked(): Invoked when a packet is acknowledged.

- quic_cong_on_packet_lost(): Invoked when a packet is marked as lost.

- quic_cong_on_process_ecn(): Invoked when an ACK_ECN frame is received.

- quic_cong_on_packet_sent(): Invoked when a packet is transmitted.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential divide-by-zero in quic_reno_on_packet_acked().
    cong->window is guaranteed to be non-zero before entering congestion
    avoidance. The loss handling path never reduces the congestion window
    below the minimum window, and quic_packet_route() initializes the
    initial congestion window before this function can be reached.

  - Ignore potential stale pc_start_time in quic_cong_on_packet_acked().
    The check is intentional. Only an ACK for a packet sent within the
    candidate persistent congestion interval invalidates the interval and
    clears pc_start_time. ACKs for packets sent after the persistent
    congestion duration do not invalidate the interval and therefore must
    not reset pc_start_time.

  - Ignore the concern about ssthresh not being reset on persistent
    congestion. RFC 9002 requires the congestion window to be reduced to
    min_window, but does not require resetting ssthresh.

  - Ignore the concern about lost packets during the recovery period being
    unconditionally ignored. RFC 9002 section 7.3.2 explicitly requires a
    sender already in recovery to remain there, and new losses during
    recovery must not further reduce the congestion window or start a
    new recovery period.

  - Ignore the concern about using QUIC_CONG_ALG_MAX for the bounds check.
    The quic_congs array is kept consistent with QUIC_CONG_ALG_MAX when
    building the kernel, so the bounds check is safe.

  - Ignore the concern about the integer division causing the congestion
    window to permanently stall. RFC 9002 explicitly notes that integer
    implementations need to handle this division carefully, but the current
    calculation is not by itself a correctness issue because
    congestion-window growth is bounded and the implementation may process
    ACKed bytes in batches.

  - Ignore the concern about capping ack_delay to max_ack_delay in
    quic_cong_rtt_update(). The ack_delay passed to quic_cong_rtt_update()
    is already capped to max_ack_delay by the caller after handshake
    confirmation in the next patchset, as required by RFC 9002 Section 5.3.
    Therefore, no additional cap is needed here before calculating
    adjusted_rtt.

  - Ignore the concern about calculating rttvar_sample using the newly
    updated smoothed_rtt in quic_cong_rtt_update(). RFC 9002 Section 5.3
    explicitly defines rttvar_sample as abs(smoothed_rtt - adjusted_rtt)
    using the updated smoothed_rtt, so the implementation follows the RFC
    as written.

  - Ignore the concern about using > instead of >= when comparing time with
    cong->pc_start_time in quic_cong_on_packet_acked(). RFC 9002 section
    7.6.2 refers to packets sent between the send times of the two packets,
    so packets with the same send timestamp do not break the persistent
    congestion condition. The strict comparison is therefore intentional.

  - Ignore the concern about leaking the socket counters in
    quic_init_sock(). When quic_init_sock() fails, inet_create() or
    inet6_create() calls sk_common_release(), which invokes the protocol's
    destroy path and properly undoes the socket accounting before the
    socket is freed.

  - Ignore the concern about pc_start_time incorrectly covering an
    acknowledged packet in quic_cong_on_packet_lost(). The concern assumes
    that an earlier packet has a send time of 0, a later packet is lost
    after the persistent-congestion threshold, and a packet sent between
    them is acknowledged before loss detection. However, packet send times
    come from quic_ktime_get_us(), which cannot return 0 on a running
    system. Therefore, the proposed sequence cannot occur as described.

  - Ignore the concern about pc_detected permanently suppressing subsequent
    packet loss processing in quic_cong_on_packet_lost(). pc_detected is
    intentionally cleared at the beginning of loss detection in outqueue in
    the next patch, so it only records persistent congestion for the
    current loss-detection pass. Therefore, subsequent loss-detection
    passes can detect and process new persistent congestion events.

  - Ignore the concern about periodically expiring min_rtt. RFC 9002
    Section 5.2 does not require min_rtt to be periodically expired. The
    implementation also clears min_rtt_valid when persistent congestion is
    detected, allowing min_rtt to be re-estimated after such an event.

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
v15:
  - Fall through to the CONGESTION_AVOIDANCE process instead of breaking
    when transitioning the congestion state from RECOVERY_PERIOD to
    CONGESTION_AVOIDANCE in quic_reno_on_packet_acked().
  - Set min_window to mss * 2 and initialize the congestion window to
    min(mss * 10, 14720U) to better align with RFC 9002.
  - Remove the unused parameter from quic_cong_pace_update().
  - Do not add max_ack_delay to cong->pto in quic_cong_pto_update(); add
    it only when needed in the next patchset.
v16:
  - Align struct member comments in quic_cong using spaces instead of tabs
    for consistent formatting.
  - Remove .on_ack_recv from struct quic_cong_ops; pacing will be updated
    directly by quic_cong_pace_update() after ACK processing in the next
    patchset.
  - Add pc_detected to struct quic_cong to preserve persistent congestion
    state across loss events in the same loss-detection round.
  - Remove pc_start_time check and reset from quic_cong_on_packet_acked(),
    as the gap will be tracked from the sent packet list and pc_start_time
    reset when gaps are found in outqueue in the next patchset.
  - Improve cong.c file description.
  - Use u64 for threshold variable in
    quic_cong_check_persistent_congestion() to avoid the AI false warning.
  - Include the minimum of 2 * MSS and 14720 bytes when calculating the
    initial congestion window in quic_cong_set_mss().
v17:
  - Remove the state field from struct quic_cong and derive the state from
    quic_cong_in_slow_start() and quic_cong_in_recovery().
  - Check quic_cong_in_recovery() before calling .on_packet_lost(),
    .on_packet_acked(), and .on_process_ecn() (noted by Sashiko AI review).
  - Record the time of the first RTT sample and use it to prevent packets
    sent before that sample from starting persistent congestion detection
    (noted by Sashiko AI review).
v18:
  - Reset recovery time on persistent congestion as specified in RFC
    9002 Appendix B.8 (noted by Sashiko AI review).
  - Calculate the raw RTT first and apply the limit after accounting for
    the ACK delay (noted by Sashiko AI review).
---
 net/quic/Makefile |   3 +-
 net/quic/cong.c   | 292 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/cong.h   | 143 +++++++++++++++++++++++
 net/quic/socket.c |   1 +
 net/quic/socket.h |   7 ++
 5 files changed, 445 insertions(+), 1 deletion(-)
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
index 000000000000..b829755e8ac9
--- /dev/null
+++ b/net/quic/cong.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Congestion control algorithms.
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
+static void reno_recovery(struct quic_cong *cong)
+{
+	cong->recovery_time = cong->time;
+	cong->ssthresh = max(cong->window >> 1U, cong->min_window);
+	cong->window = cong->ssthresh;
+}
+
+static void quic_reno_on_packet_lost(struct quic_cong *cong, u64 time,
+				     u32 bytes, s64 number)
+{
+	reno_recovery(cong);
+}
+
+static void quic_reno_on_packet_acked(struct quic_cong *cong, u64 time,
+				      u32 bytes, s64 number)
+{
+	u64 new_window;
+
+	if (quic_cong_in_slow_start(cong)) { /* Slow start */
+		new_window = (u64)cong->window + bytes;
+		cong->window = min_t(u64, new_window, cong->max_window);
+		return;
+	}
+	/* Congestion avoidance - cong->window is never zero; it is initialized
+	 * by quic_packet_route() during connect/accept.
+	 */
+	new_window = div64_ul((u64)cong->mss * bytes, cong->window) +
+		     cong->window;
+	cong->window = min_t(u64, new_window, cong->max_window);
+}
+
+static void quic_reno_on_process_ecn(struct quic_cong *cong)
+{
+	reno_recovery(cong);
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
+	u64 ssthresh;
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
+	if (cong->pc_detected)
+		return;
+
+	if (cong->pc_start_time && time > cong->pc_start_time &&
+	    quic_cong_check_persistent_congestion(cong, time)) {
+		cong->pc_detected = 1;
+		cong->min_rtt_valid = 0;
+		cong->window = cong->min_window;
+		cong->recovery_time = 0;
+		return;
+	}
+
+	if (!cong->pc_start_time && cong->first_rtt_time &&
+	    time > cong->first_rtt_time)
+		cong->pc_start_time = time;
+
+	if (quic_cong_in_recovery(cong, time))
+		return;
+	cong->ops->on_packet_lost(cong, time, bytes, number);
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number)
+{
+	if (quic_cong_in_recovery(cong, time))
+		return;
+	cong->ops->on_packet_acked(cong, time, bytes, number);
+}
+
+void quic_cong_on_process_ecn(struct quic_cong *cong, u64 time)
+{
+	if (quic_cong_in_recovery(cong, time))
+		return;
+	cong->ops->on_process_ecn(cong);
+}
+
+/* Update Probe Timeout (PTO) and loss detection delay based on RTT stats. */
+static void quic_cong_pto_update(struct quic_cong *cong)
+{
+	u32 loss_delay;
+
+	/* rfc9002#section-6.2.1:
+	 *   PTO = smoothed_rtt + max(4*rttvar, kGranularity) + max_ack_delay
+	 *
+	 * Calculate the base PTO here, excluding max_ack_delay. max_ack_delay
+	 * is added when calculating the PTO for the App packet number space.
+	 */
+	cong->pto = cong->smoothed_rtt +
+		    max(4 * cong->rttvar, QUIC_KGRANULARITY);
+
+	/* rfc9002#section-6.1.2:
+	 *   max(kTimeThreshold * max(smoothed_rtt, latest_rtt), kGranularity)
+	 */
+	loss_delay = QUIC_KTIME_THRESHOLD(max(cong->smoothed_rtt,
+					      cong->latest_rtt));
+	cong->loss_delay = max(loss_delay, QUIC_KGRANULARITY);
+
+	pr_debug("%s: update pto: %u\n", __func__, cong->pto);
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
+	len_ns = div64_u64((u64)bytes * NSEC_PER_SEC, rate);
+	len_ns -= min_t(u64, len_ns / 2, credit);
+	cong->pacing_time += len_ns;
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
+/* Compute and update the pacing rate based on congestion window and smoothed
+ * RTT.
+ */
+void quic_cong_pace_update(struct quic_cong *cong, u64 max_rate)
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
+/* rfc9002#section-5: Estimating the Round-Trip Time */
+void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay)
+{
+	u32 adjusted_rtt, rttvar_sample;
+	u64 raw_rtt;
+
+	/* Ignore RTT sample if ACK delay is suspiciously large. */
+	if (ack_delay > cong->max_ack_delay * 2)
+		return;
+
+	raw_rtt = cong->time - time;
+	if (raw_rtt > ack_delay + QUIC_RTT_MAX)
+		return;
+
+	/* rfc9002#section-5.1:
+	 *   latest_rtt = ack_time - send_time_of_largest_acked
+	 */
+	cong->latest_rtt = (u32)raw_rtt;
+
+	/* rfc9002#section-5.2: Estimating min_rtt */
+	if (!cong->min_rtt_valid) {
+		cong->min_rtt = cong->latest_rtt;
+		cong->min_rtt_valid = 1;
+	}
+	if (cong->min_rtt > cong->latest_rtt)
+		cong->min_rtt = cong->latest_rtt;
+
+	if (!cong->first_rtt_time) {
+		/* rfc9002#section-5.3:
+		 *   smoothed_rtt = latest_rtt
+		 *   rttvar = latest_rtt / 2
+		 */
+		cong->smoothed_rtt = cong->latest_rtt;
+		cong->rttvar = cong->smoothed_rtt / 2;
+		cong->first_rtt_time = cong->time;
+		goto out;
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
+out:
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
index 000000000000..eaa7b59c0769
--- /dev/null
+++ b/net/quic/cong.h
@@ -0,0 +1,143 @@
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
+ * The implementation derives congestion states from conditions rather than
+ * maintaining an explicit state variable:
+ *
+ * - Slow Start: window < ssthresh
+ * - Recovery Period: time <= recovery_time
+ * - Congestion Avoidance: window >= ssthresh && time > recovery_time
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
+
+struct quic_cong {
+	/* RTT tracking */
+	u32 max_ack_delay;   /* max_ack_delay from rfc9000#section-18.2 */
+	u32 smoothed_rtt;    /* Smoothed RTT */
+	u32 latest_rtt;      /* Latest RTT sample */
+	u32 min_rtt;         /* Lowest observed RTT */
+	u32 rttvar;          /* RTT variation */
+	u32 pto;             /* Probe timeout */
+
+	/* Timing & pacing */
+	u64 first_rtt_time;  /* First RTT sample timestamp */
+	u64 pc_start_time;   /* Persistent congestion tracking timestamp */
+	u64 recovery_time;   /* Recovery period start timestamp */
+	u64 pacing_rate;     /* Packet sending speed Bytes/sec */
+	u64 pacing_time;     /* Next scheduled send timestamp (ns) */
+	u64 time;            /* Cached current timestamp */
+
+	/* Congestion window */
+	u32 max_window;      /* Max growth cap */
+	u32 min_window;      /* Min window limit */
+	u32 loss_delay;      /* Time before marking loss */
+	u32 ssthresh;        /* Slow start threshold */
+	u32 window;          /* Bytes in flight allowed */
+	u32 mss;             /* QUIC MSS (excl. UDP) */
+
+	/* Algorithm-specific */
+	const struct quic_cong_ops *ops;
+	u64 priv[8];         /* Algo private data */
+
+	u32 initial_srtt;    /* Initial smoothed RTT */
+	u8 algo;             /* Congestion control algorithm */
+
+	/* Flags & state */
+	u8 min_rtt_valid;    /* min_rtt initialized */
+	u8 pc_detected;      /* Persistent congestion detected */
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
+	cong->min_window = mss * 2;
+
+	if (!cong->window)
+		cong->window = min(mss * 10, max(14720U, mss * 2));
+	if (cong->window < cong->min_window)
+		cong->window = cong->min_window;
+}
+
+static inline void *quic_cong_priv(struct quic_cong *cong)
+{
+	return (void *)cong->priv;
+}
+
+static inline bool quic_cong_in_slow_start(struct quic_cong *cong)
+{
+	return cong->window < cong->ssthresh;
+}
+
+static inline bool quic_cong_in_recovery(struct quic_cong *cong, u64 time)
+{
+	return time <= cong->recovery_time;
+}
+
+void quic_cong_on_packet_acked(struct quic_cong *cong, u64 time, u32 bytes,
+			       s64 number);
+void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number);
+void quic_cong_on_process_ecn(struct quic_cong *cong, u64 time);
+
+void quic_cong_on_packet_sent(struct quic_cong *cong, u64 time, u32 bytes,
+			      s64 number);
+void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_delay);
+void quic_cong_pace_update(struct quic_cong *cong, u64 max_rate);
+
+void quic_cong_set_srtt(struct quic_cong *cong, u32 srtt);
+void quic_cong_set_algo(struct quic_cong *cong, u8 algo);
+void quic_cong_init(struct quic_cong *cong);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 5ad2b08d632c..41f7de7d163a 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -53,6 +53,7 @@ static int quic_init_sock(struct sock *sk)
 	quic_conn_id_set_init(quic_source(sk), true);
 	quic_conn_id_set_init(quic_dest(sk), false);
 	quic_path_init(quic_paths(sk));
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

