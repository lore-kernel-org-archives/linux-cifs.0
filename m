Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393816;
	b=NscdGG5luMVAPFW7VJ0v/R6zJJxsEFTvkJfqNpx9iPnVrruoE+bKHxTNz5UiyavN/ynQ
	 ePtF/yn35aGFlXiJRjMOsAdpA7YxrZezv2kc9K1jPH4mIrj/j/uAKwdrPIkE/BxcKpUrA
	 hA/lZ8WG44fMGmISEqFzoqWwAqY9Tiqgj/8S+XfzD9+HdAoQzL3xosbvy4iteg0q3OReJ
	 YwUh2K4eaCH4mZHfmIhO3AAsX8Y1Z23i2ZLbGL5e6WamDt5zN5mN0nToBXSiRydRnjcst
	 oqvRjI6XcvNiXXwxDhdbqxGXkkPAX9Rjv1IE1in4wsohDO6N1sJErgGCLSP76xwRuzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393816;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQkKlQn02KLe1TCZoDSav6IRuZOp3WaThiWqEbjItY0=;
	b=MlkvQobHpabnvvKnK5Dl8Jf+q16kYjz3rOApWfY/tjinmkfFPgaAxoEDHIGf2nR6BUos
	 0jcCuv4n90K7d4p5uVcXSm86zLPNYw5aDrtT7PCKc+d3FGmpO9owiyr9iW0db2Y9QCCi8
	 cf3Ru2DSMYECTA5m0ZseRAIxEAdiAleMt+LqPA3MoZIZA9q1Q7mjcUoqwrepUwTQaDPIi
	 hKYlU84bgkM2rCxPgUOS0MCq/GOFjuMwMVXaeTHP5KSR3PClrtFuF2QkphbfRC9amAm7I
	 rHGpwpKZ+bALsVZrpDgq/kTSODjrK/RzwDWW1ycmAtWpGsYEtVMeFg5SHKaY+oYKD8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oOMTsZoN;
	arc=none smtp.remote-ip=209.85.219.47
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCC606A320
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 00:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17CCC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oOMTsZoN
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-921375f52b8so30533396d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393815; x=1795998615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VQkKlQn02KLe1TCZoDSav6IRuZOp3WaThiWqEbjItY0=;
        b=oOMTsZoN2oubJvnoV7NCwCTHsBvjcw+NOUEuWuM6Xjzh0QLN+cIvXwz2yeawaY9I6n
         MCl0eJtaG8Yjr+MyHoMZkfoi0ZJV1ocQ9EBuZxnlUvGGLnYqLUtxH8cEbo6oMUXgghnw
         iOeHdu37PsK/5qE3ngYVeGQ6Cb/BzRAgiBzmf6tatAtU6yvngLN0djnHaFgLvqvprVer
         D3dD8djGCpSZMFkRlO89LIpU1nLBgNhCwHC7X1utOPmYHer6Oa6sT49l8O2fLUOiak5I
         Oir5cSTnPr91KEfMecRnN2RayYju9bJT2IemrkIU9DtJBb9MqPVKycRp4xQaKoS3v7A0
         uDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393815; x=1795998615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VQkKlQn02KLe1TCZoDSav6IRuZOp3WaThiWqEbjItY0=;
        b=U2J6z8d83epMPgtfuKY7gQfJpYALnZmwv+sp2uDFYhsbBnDaFyX4ZbYVK8ya9ZVeLF
         hqKQd8fOFG8Ebaf3jM1ozNbAeUT08C49O+SmErQjXoKb5rMQ9scrVd5s6La6uRGxIG6v
         XJIS5Xf9iKcU07p7712K1pHHsX6FCNJcKILMhjWhnJofAUtv9NxLNU7riz9jIzUey4Vz
         LfXtpusGg5XikUSj+YUY5ysqI4qSDSzjtvjgd7Nz/iICeTNX4RBkaRaK80aZGcEPgSgw
         BeCUUkQslyTbvAXuiv1MrZYtX0OQlKmGb4BFo84udEPi0sziL7O0DXo6S4/qTY5m25tn
         Wn7g==
X-Forwarded-Encrypted: i=1; AL+hErGoBR89BBizxL78vKKJIPYOM3mJuHHDakyfZ61wDgDvYWF7julb6wP2czWX9KMZAbpl/0M3oOwkWP5S@vger.kernel.org
X-Gm-Message-State: APuU4Z9S7xCb7ppF6a4JKpxH13EcAzt/Lm4VUfRD1VkvKuo8sXMsbsED
	kNmJId8jtK5IEtx5ydnQK2TSUQ26VGmtISi/0VIelPi5LpQT2jSiAIHI
X-Gm-Gg: AZFdTZdPJP4rmboC2Hagi17Y6Ymi7XtDTjf+yrg1cJQZT3MFJhUGJtWMTzPKbmBKJHP
	7pZlGIwZJrrvG0YNoWEsuXlKmc9uC4sTbH00GgV+AMZVhur9UrXkAVKvknWIyBdNLq28Y0Mu1+O
	vld98HYVAnfX0k7qzlAKjwwrv9ghMnA99vERhMdzbOq0MFASx6FKwEWc86J9z6qGcW+Nrg2F0SI
	Q0A9uFLFHsapL+CfaqS5zCGWZMkw/DM7GjTm0ZZG/lko/f+epbkFxgN4xdPAUPh89NaDflTpu5+
	REgXyPmwnHGho+Zexp5iQR/C4Xu32JLQuxGs4zk2Q80N6iFiE67sfH5nbOLmUNgbKgdD/QzudLn
	dylRB2ZesTKgMP+j9JRJeWZdxvm8EejYfjQIZvKbpMc8ZQG/sE4c5PQAV1rBeEjFqlObnS8VljG
	nz4Ui2x0EeX99pDsGy3iIqeIs9TX3iVhmlLUWL4AaT5fbPnn2b0uOUFoXJ4cu4TRN5mOWx2XeIU
	5S/Mgwdz3UHOOQ/hdApQg2AHfw3Bx8k7HrQ5RvoFuxtjkJrYmipXSEt26H+PmCuDeDUK+mCxA+M
	TaH31rzacas7+zBHT/Cdj/z4/mxJr0n/GGFG+fFE75fy2s3wGWa1kgOA1xnSRE6FaoUff5LnOR/
	Lr1AWcbHp8nm+EeV1xmVhKkcvKvAkJg7frunBpjV6S0qmpWuhEhcNGNYT6ZckDC08b3YfyV8=
X-Received: by 2002:a05:6214:848e:10b0:921:1d53:9a9d with SMTP id 6a1803df08f44-92134ab93ccmr135846666d6.20.1795393814952;
        Sun, 22 Nov 2026 16:30:14 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm91433716d6.21.2026.11.22.16.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 16:30:14 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
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
Subject: [PATCH net-next v19 10/15] quic: add packet number space
Date: Sun, 22 Nov 2026 19:28:06 -0500
Message-ID: <095039b2ac3108167adb3124f1ce5d2f66ba13c0.1795393691.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1795393690.git.lucien.xin@gmail.com>
References: <cover.1795393690.git.lucien.xin@gmail.com>
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

This patch introduces 'quic_pnspace', which manages per packet number
space members.

It maintains the next packet number to assign, tracks the total length of
frames currently in flight, and records the time when the next packet may
be considered lost. It also keeps track of the largest acknowledged packet
number, the time it was acknowledged, and when the most recent ack
eliciting packet was sent. These fields are useful for loss detection,
RTT estimation, and congestion control.

To support ACK frame generation, quic_pnspace includes a packet number
acknowledgment map (pn_map) that tracks received packet numbers.
Supporting functions are provided to validate and mark received packet
numbers and compute the number of gap blocks needed during ACK frame
construction.

- quic_pnspace_check(): Validates a received packet number.

- quic_pnspace_mark(): Marks a received packet number in the ACK map.

- quic_pnspace_num_gabs(): Returns the gap ACK blocks for constructing
  ACK frames.

It also tracks ECN counts and provides helpers to validate peer ECN counts
per rfc9000#section-13.4.2.1.

Note QUIC uses separate packet number spaces for each encryption level
(APP, INITIAL, HANDSHAKE, EARLY) except EARLY and all generations of
APP keys use the same packet number space, as describe in
rfc9002#section-4.1.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the concern about valid reordered packets being rejected when
    their packet number is smaller than min_pn_seen in
    quic_pnspace_check(). The QUIC packet number decoding and duplicate
    detection logic requires maintaining a lower bound for the packet
    numbers that can still be tracked. Packets arriving below this window
    are treated as too old, which is expected behavior.

  - Ignore the concern about incorrectly reporting packets as missing when
    the maximum number of gap acknowledgment blocks is reached in
    quic_pnspace_num_gabs(). QUIC ACK frames have a bounded number of ACK
    ranges in this implementation. When the limit is exceeded, the ACK
    generation logic intentionally sacrifices older range precision and
    preserves the most recent acknowledgment information.

  - Ignore the concern about an out-of-bounds ECN index. The callers of
    quic_pnspace_inc_ecn_acked() and quic_pnspace_inc_ecn_local() will
    guarantee ecn <= QUIC_ECN_MAX in the next patchset.

  - Ignore the concern about a missing third ECN validation condition in
    quic_pnspace_validate_ecn(). RFC 9000 section 13.4.2.1 explicitly
    allows the total increase in ECT(0), ECT(1), and ECN-CE counts to
    exceed the number of newly acknowledged packets, for example when an
    earlier ACK was lost. The function correctly implements the required
    ECN validation checks; no additional total-increase check is needed.

  - Ignore the concern about initializing base_pn to pn + 1 in
    quic_pnspace_mark(). This does not imply that packets below pn were
    received; it only means packet numbers below pn are not tracked when
    generating ACK/SACK information. Missing packets below the first
    received packet therefore do not result in false acknowledgments.

  - Ignore the concern about quic_pnspace_mark() not validating the packet
    number range. Callers always invoke quic_pnspace_check() before
    quic_pnspace_mark(), so the input has already been validated. Adding
    the same range check again in quic_pnspace_mark() would be redundant.

  - Ignore the concern about memcg accounting for the packet number space
    structures. Each struct quic_pnspace is only about 184 bytes, or
    roughly 552 bytes per socket for all three spaces. The larger
    allocations, including the packet number bitmaps and stream hash table,
    are already memcg-accounted, so the unaccounted overhead is negligible
    and does not pose a meaningful memcg bypass risk.

  - Ignore the concern about freeing packet number spaces before connection
    ID teardown in quic_destroy_sock(). The socket is marked closed before
    destruction, and lock_sock() prevents incoming packets from accessing
    it during teardown.  Backlogged packets are dropped by the closed-state
    check, deferred work is flushed, and timers are stopped before the
    spaces are freed. Therefore, no current code path can access the freed
    spaces.

  - Ignore the concern about the initial has_gap() result.
    quic_pnspace_mark() checks base_pn == -1 first and calls
    quic_pnspace_set_base_pn() to initialize the related fields before
    quic_pnspace_has_gap() can be reached. The other caller,
    quic_pnspace_num_gaps(), is only invoked when generating an ACK in
    response to a received packet, so this initialization has already
    happened.

v5:
  - Change timestamp variables from u32 to u64 and use quic_ktime_get_us()
    to set max_pn_acked_time, as jiffies_to_usecs() is not accurate enough.
  - Reorder some members in quic_pnspace to reduce 32-bit holes (noted
    by Paolo).
v6:
  - Note for AI reviews: it's safe to do cast (u16)(pn - space->base_pn)
    in quic_pnspace_mark(), as the pn < base_pn + QUIC_PN_MAP_SIZE (4096)
    validation is always done in quic_pnspace_check(), which will always
    be called before quic_pnspace_mark() in a later patchset.
  - Note for AI reviews: failures in quic_pnspace_init() do not result in a
    pn_map leak in quic_init_sock(), because quic_destroy_sock() is always
    called to free it in err path, either via inet/6_create() or through
    quic_accept() in a later patchset.
v8:
  - Replace bitfields with plain u8 in struct quic_pnspace.
v10:
  - Fix a grammar error in the comment of quic_pnspace_check().
v11:
  - Note for AI reviews: RFC 9000 does not define integer IDs for packet
    number spaces. In this implementation, App=0, Initial=1,
    Handshake=2, and Early maps to 0 (3 % 3).
  - Set maximum line length to 80 characters.
  - clear space->pn_map pointer after free in quic_pnspace_free().
  - Change quic_pnspace_grow() to return negative errno on failure or 0
    on success.
  - Change return type of quic_pnspace_next_gap_ack() and
    quic_pnspace_set_ecn_count() to bool.
  - Return -EINVAL instead of -1 on failure in quic_pnspace_check().
v12:
  - Initialize max_pn_acked_seen to -1 in quic_pnspace_init().
  - Allow large packet number jumps when processing higher PN values
    (>= base_pn + QUIC_PN_MAP_SIZE) in quic_pnspace_check(),
    quic_pnspace_mark(), and quic_pnspace_grow().
  - Call quic_pnspace_has_gap() before updating max_pn_seen in
    quic_pnspace_mark().
  - Rename ECN-related helpers:
    quic_pnspace_set_ecn_count() -> quic_pnspace_set_ecn_peer(),
    quic_pnspace_has_ecn_count() -> quic_pnspace_has_ecn_local(),
    quic_pnspace_inc_ecn_count() -> quic_pnspace_inc_ecn_local().
  - Add QUIC_ECN_ACKED and introduce quic_pnspace_inc_ecn_acked(),
    quic_pnspace_reset_ecn_acked(), and quic_pnspace_validate_ecn() for
    validating ECN counts in ACKs.
  - Add sack_pending field in struct quic_pnspace for later use in sack
    piggybacking.
v14:
  - Pass gfp flags to quic_pnspace_mark() and quic_pnspace_grow().
  - Add more pn checks in quic_pnspace_check().
  - Remove dead code from the else branch in quic_pnspace_init().
v15:
  - Use a sliding-window approach in quic_pnspace_num_gabs() to preserve
    the most recent gaps when their total number exceeds
    QUIC_PN_MAP_MAX_GAPS.
  - Improve the annotation for quic_pnspace_check().
v16:
  - Correct the quic_pnspace_num_gabs() annotation to reflect that at most
    QUIC_PN_MAP_MAX_GABS - 1 gaps are preserved individually, with the
    remaining gap reserved for merging older gaps (noted by Sashiko AI
    review).
  - Clarify that min_pn_seen in struct quic_pnspace represents the lower
    bound of the trackable packet number window, rather than simply the
    smallest packet number received (noted by Sashiko AI review).
  - Improve pnspace.c file description.
  - Fix pn_map comment for last_max_pn_time and Gap Search Range.
v17:
  - Update the comment to document that the packet count condition uses the
    minimum of last_max_pn_seen and base_pn when deciding whether to
    advance pn_map.
  - Account pn_map allocations to memcg in quic_pnspace_init() and
    quic_pnspace_grow() and converts the code to use the bitmap API
    (bitmap_zalloc, bitmap_free).
v18:
  - Allocate packet number space structures separately instead of embedding
    them in struct quic_sock.
---
 net/quic/Makefile  |   2 +-
 net/quic/pnspace.c | 273 +++++++++++++++++++++++++++++++++++++++++++++
 net/quic/pnspace.h | 201 +++++++++++++++++++++++++++++++++
 net/quic/socket.c  |  26 +++++
 net/quic/socket.h  |   7 ++
 5 files changed, 508 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/pnspace.c
 create mode 100644 net/quic/pnspace.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 4d4a42c6d565..9d8e18297911 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o
+	  cong.o pnspace.o
diff --git a/net/quic/pnspace.c b/net/quic/pnspace.c
new file mode 100644
index 000000000000..fcf68f0df184
--- /dev/null
+++ b/net/quic/pnspace.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Packet number space management.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/slab.h>
+
+#include "common.h"
+#include "pnspace.h"
+
+int quic_pnspace_init(struct quic_pnspace *space)
+{
+	space->pn_map = bitmap_zalloc(QUIC_PN_MAP_INITIAL, GFP_KERNEL_ACCOUNT);
+	if (!space->pn_map)
+		return -ENOMEM;
+	space->pn_map_len = QUIC_PN_MAP_INITIAL;
+
+	space->max_time_limit = QUIC_PNSPACE_TIME_LIMIT;
+	space->next_pn = QUIC_PNSPACE_NEXT_PN;
+	space->max_pn_acked_seen = -1;
+	space->base_pn = -1;
+	return 0;
+}
+
+void quic_pnspace_free(struct quic_pnspace *space)
+{
+	bitmap_free(space->pn_map);
+	space->pn_map = NULL;
+	space->pn_map_len = 0;
+}
+
+/* Expand the bitmap tracking received packet numbers.  Ensures the pn_map
+ * bitmap can cover at least @size packet numbers.  Allocates a larger bitmap,
+ * copies existing data, and updates metadata.
+ *
+ * Return: 0 on success, or a negative errno value on failure.
+ */
+static int quic_pnspace_grow(struct quic_pnspace *space, u16 size, gfp_t gfp)
+{
+	u16 len, inc, offset;
+	unsigned long *new;
+
+	inc = ALIGN((size - space->pn_map_len), BITS_PER_LONG) +
+	      QUIC_PN_MAP_INCREMENT;
+	len = (u16)min(space->pn_map_len + inc, QUIC_PN_MAP_SIZE);
+
+	new = bitmap_zalloc(len, gfp | __GFP_ACCOUNT);
+	if (!new)
+		return -ENOMEM;
+
+	offset = (u16)(space->max_pn_seen + 1 - space->base_pn);
+	bitmap_copy(new, space->pn_map, offset);
+	bitmap_free(space->pn_map);
+	space->pn_map = new;
+	space->pn_map_len = len;
+
+	return 0;
+}
+
+/* Check if a packet number has been received.
+ *
+ * Returns: 0 if the packet number has not been received.  1 if it has already
+ * been received. -EINVAL if the packet number is invalid (out of range 0 to
+ * QUIC_PN_MAX) or too old to track (below min_pn_seen).
+ */
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn)
+{
+	if (pn > QUIC_PN_MAX || pn < 0)
+		return -EINVAL;
+
+	if (space->base_pn == -1) /* No packet number received yet. */
+		return 0;
+
+	if (pn < space->min_pn_seen)
+		return -EINVAL;
+
+	if (pn < space->base_pn)
+		return 1;
+	if (pn - space->base_pn < space->pn_map_len &&
+	    test_bit(pn - space->base_pn, space->pn_map))
+		return 1;
+
+	return 0;
+}
+
+/* Advance base_pn past contiguous received packet numbers.  Finds the next gap
+ * (unreceived packet) beyond @pn, shifts the bitmap, and updates base_pn
+ * accordingly.
+ */
+static void quic_pnspace_move(struct quic_pnspace *space, s64 pn)
+{
+	u16 offset;
+
+	offset = (u16)(pn + 1 - space->base_pn);
+	offset = (u16)find_next_zero_bit(space->pn_map, space->pn_map_len,
+					 offset);
+	space->base_pn += offset;
+	bitmap_shift_right(space->pn_map, space->pn_map, offset,
+			   space->pn_map_len);
+}
+
+/* Mark a packet number as received. Updates the packet number map to record
+ * reception of @pn.  Advances base_pn if possible, and updates max/min/last
+ * seen fields as needed.
+ *
+ * Returns: 0 on success or if the packet was already marked, or a negative
+ * error returned by bitmap growth when expanding the map.
+ */
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn, gfp_t gfp)
+{
+	s64 last_max_pn_seen, off;
+	u64 last_max_pn_time;
+	bool has_gap;
+	int err;
+
+	if (space->base_pn == -1) {
+		/* Initialize base_pn based on the peer's first packet number
+		 * since peer's packet numbers may start at a non-zero value.
+		 */
+		quic_pnspace_set_base_pn(space, pn + 1);
+		return 0;
+	}
+
+	/* Ignore packets with number less than current base (already
+	 * processed).
+	 */
+	if (pn < space->base_pn)
+		return 0;
+
+	/* If offset is beyond current map length, try to grow the bitmap to
+	 * accommodate.
+	 */
+	off = pn - space->base_pn;
+	if (off >= space->pn_map_len) {
+		if (off >= QUIC_PN_MAP_SIZE) {
+			bitmap_zero(space->pn_map, space->pn_map_len);
+			quic_pnspace_set_base_pn(space, pn + 1);
+			return 0;
+		}
+		err = quic_pnspace_grow(space, off + 1, gfp);
+		if (err)
+			return err;
+	}
+
+	has_gap = quic_pnspace_has_gap(space);
+	if (space->max_pn_seen < pn) {
+		space->max_pn_seen = pn;
+		space->max_pn_time = space->time;
+	}
+
+	if (space->base_pn == pn) { /* PN is next expected packet. */
+		if (has_gap) /* Advance to next gap. */
+			quic_pnspace_move(space, pn);
+		else /* Fast path: increment base_pn if no gaps. */
+			space->base_pn++;
+	} else { /* Mark this packet as received in the bitmap. */
+		set_bit(off, space->pn_map);
+	}
+
+	/* Only update min and last_max_pn_seen if this packet is the current
+	 * max_pn.
+	 */
+	if (space->max_pn_seen != pn)
+		return 0;
+
+	/* Check if enough time has elapsed or enough packets have been
+	 * received to update tracking.
+	 */
+	last_max_pn_seen = min_t(s64, space->last_max_pn_seen, space->base_pn);
+	last_max_pn_time = space->last_max_pn_time;
+	if (space->max_pn_time < last_max_pn_time + space->max_time_limit &&
+	    space->max_pn_seen <= last_max_pn_seen + QUIC_PN_MAP_LIMIT)
+		return 0;
+
+	/* Advance base_pn if last_max_pn_seen is ahead of current base_pn.
+	 * This is needed because QUIC doesn't retransmit packets;
+	 * retransmitted frames are carried in new packets, so we move forward.
+	 */
+	if (space->last_max_pn_seen + 1 > space->base_pn)
+		quic_pnspace_move(space, space->last_max_pn_seen);
+
+	space->min_pn_seen = space->last_max_pn_seen;
+	space->last_max_pn_seen = space->max_pn_seen;
+	space->last_max_pn_time = space->max_pn_time;
+	return 0;
+}
+
+/* Find the next gap in received packet numbers. Scans pn_map for a gap
+ * starting from *@iter. A gap is a contiguous block of unreceived packets
+ * between received ones.
+ *
+ * Returns: true if a gap was found, false if no more gaps exist or are
+ * relevant.
+ */
+static bool quic_pnspace_next_gap_ack(const struct quic_pnspace *space,
+				      s64 *iter, u16 *start, u16 *end)
+{
+	u16 start_ = 0, end_ = 0, offset = (u16)(*iter - space->base_pn);
+
+	start_ = (u16)find_next_zero_bit(space->pn_map, space->pn_map_len,
+					 offset);
+	if (space->max_pn_seen <= space->base_pn + start_)
+		return false;
+
+	end_ = (u16)find_next_bit(space->pn_map, space->pn_map_len, start_);
+	if (space->max_pn_seen <= space->base_pn + end_ - 1)
+		return false;
+
+	*start = start_ + 1;
+	*end = end_;
+	*iter = space->base_pn + *end;
+	return true;
+}
+
+/* Generate gap acknowledgment blocks (GABs). GABs describe ranges of
+ * unacknowledged packets between received ones, and are used in ACK frames.
+ *
+ * This function uses a sliding window approach to ensure the most recent gaps
+ * are preserved when the total number exceeds QUIC_PN_MAP_MAX_GABS. If there
+ * are more gaps than the limit, the oldest gaps are merged into a single gap,
+ * and the newest (QUIC_PN_MAP_MAX_GABS - 1) gaps are preserved individually.
+ *
+ * Returns: Number of generated GABs (up to QUIC_PN_MAP_MAX_GABS).
+ */
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space,
+			  struct quic_gap_ack_block *gabs)
+{
+	struct quic_gap_ack_block tmp[QUIC_PN_MAP_MAX_GABS];
+	u16 start, end, mstart = 0, ngaps = 0, i = 0;
+	s64 iter;
+
+	if (!quic_pnspace_has_gap(space))
+		return 0;
+
+	iter = space->base_pn;
+
+	/* Scan all gaps using a sliding window to keep the newest ones. */
+	while (quic_pnspace_next_gap_ack(space, &iter, &start, &end)) {
+		if (ngaps < QUIC_PN_MAP_MAX_GABS) {
+			if (ngaps == 0)
+				mstart = start;
+			gabs[ngaps].start = start;
+			gabs[ngaps].end = end;
+			ngaps++;
+			continue;
+		}
+		gabs[i].start = start;
+		gabs[i].end = end;
+		i = (i + 1) % QUIC_PN_MAP_MAX_GABS;
+	}
+	if (i == 0) {
+		if (ngaps == QUIC_PN_MAP_MAX_GABS)
+			gabs[0].start = mstart;
+		return ngaps;
+	}
+
+	/* Overflow occurred: merge all discarded gaps with the gap at
+	 * position i (which hasn't been overwritten yet) into one.
+	 */
+	gabs[i].start = mstart;
+	memcpy(tmp, gabs, ngaps * sizeof(*gabs));
+	memcpy(gabs, &tmp[i], (ngaps - i) * sizeof(*gabs));
+	memcpy(gabs + (ngaps - i), tmp, i * sizeof(*gabs));
+
+	return ngaps;
+}
diff --git a/net/quic/pnspace.h b/net/quic/pnspace.h
new file mode 100644
index 000000000000..562bbc139c3c
--- /dev/null
+++ b/net/quic/pnspace.h
@@ -0,0 +1,201 @@
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
+#define QUIC_PN_MAP_MAX_GABS	32
+
+#define QUIC_PN_MAP_INITIAL	64
+#define QUIC_PN_MAP_INCREMENT	QUIC_PN_MAP_INITIAL
+#define QUIC_PN_MAP_SIZE	4096
+#define QUIC_PN_MAP_LIMIT	(QUIC_PN_MAP_SIZE * 3 / 4)
+
+#define QUIC_PNSPACE_MAX	(QUIC_CRYPTO_MAX - 1)
+#define QUIC_PNSPACE_NEXT_PN	0
+#define QUIC_PNSPACE_TIME_LIMIT	(333000 * 3)
+
+enum {
+	QUIC_ECN_ECT1,
+	QUIC_ECN_ECT0,
+	QUIC_ECN_CE,
+	QUIC_ECN_MAX
+};
+
+enum {
+	QUIC_ECN_LOCAL, /* ECN bits from incoming IP headers */
+	QUIC_ECN_PEER,  /* ECN bits reported by peer in ACK frames */
+	QUIC_ECN_ACKED, /* ECN bits from packets newly ACKed */
+	QUIC_ECN_DIR_MAX
+};
+
+/* Represents a gap (range of missing packets) in the ACK map.  The values are
+ * offsets from base_pn, with both 'start' and 'end' being +1.
+ */
+struct quic_gap_ack_block {
+	u16 start;
+	u16 end;
+};
+
+/* Packet Number Map (pn_map) Layout:
+ *
+ *     min_pn_seen -->++-----------------------+---------------------+---
+ *         base_pn -----^   last_max_pn_seen --^       max_pn_seen --^
+ *
+ * Map Advancement Logic:
+ *   - min_pn_seen = last_max_pn_seen;
+ *   - base_pn = first zero bit after last_max_pn_seen;
+ *   - last_max_pn_seen = max_pn_seen;
+ *   - last_max_pn_time = max_pn_time;
+ *
+ * Conditions to Advance pn_map:
+ *   - (max_pn_time - last_max_pn_time) >= max_time_limit, or
+ *   - (max_pn_seen - min(last_max_pn_seen, base_pn)) > QUIC_PN_MAP_LIMIT
+ *
+ * Gap Search Range:
+ *   - From base_pn to max_pn_seen
+ */
+struct quic_pnspace {
+	/* ECN counters indexed by dir and ECN codepoint (ECT1, ECT0, CE) */
+	u64 ecn_count[QUIC_ECN_DIR_MAX][QUIC_ECN_MAX];
+	unsigned long *pn_map; /* Received PN bitmap for ACK generation */
+	u16 pn_map_len;        /* Length of the PN bit map (in bits) */
+	u8  need_sack;         /* Flag indicating a SACK frame should be sent */
+	u8  sack_path;         /* Path used for sending the SACK frame */
+	u8  sack_pending;      /* Delayed ACK pending */
+
+	s64 last_max_pn_seen; /* Largest PN seen before pn_map advance */
+	u64 last_max_pn_time; /* Timestamp last_max_pn_seen was received */
+	s64 min_pn_seen;      /* Lower bound of the trackable PN window */
+	s64 max_pn_seen;      /* Largest PN received */
+	u64 max_pn_time;      /* Timestamp max_pn_seen was received */
+	s64 base_pn; /* PN corresponding to the start of the pn_map */
+	u64 time;    /* Cached now, or latest socket accept timestamp */
+
+	s64 max_pn_acked_seen; /* Largest PN ACKed by peer */
+	u64 max_pn_acked_time; /* Timestamp max_pn_acked_seen was ACKed */
+	u64 last_sent_time;    /* Timestamp last ack-eliciting packet sent */
+	u64 loss_time;         /* Timestamp the packet can be declared lost */
+	s64 next_pn;           /* Next PN to send */
+
+	u32 max_time_limit; /* Time threshold to trigger pn_map advance */
+	u32 inflight;       /* Ack-eliciting bytes in flight */
+};
+
+static inline void
+quic_pnspace_set_max_pn_acked_seen(struct quic_pnspace *space,
+				   s64 max_pn_acked_seen)
+{
+	if (space->max_pn_acked_seen >= max_pn_acked_seen)
+		return;
+	space->max_pn_acked_seen = max_pn_acked_seen;
+	space->max_pn_acked_time = quic_ktime_get_us();
+}
+
+static inline void quic_pnspace_set_base_pn(struct quic_pnspace *space, s64 pn)
+{
+	space->base_pn = pn;
+	space->max_pn_seen = space->base_pn - 1;
+	space->last_max_pn_seen = space->max_pn_seen;
+	space->min_pn_seen = space->max_pn_seen;
+
+	space->max_pn_time = space->time;
+	space->last_max_pn_time = space->max_pn_time;
+}
+
+static inline bool quic_pnspace_has_gap(const struct quic_pnspace *space)
+{
+	return space->base_pn != space->max_pn_seen + 1;
+}
+
+static inline void quic_pnspace_inc_ecn_acked(struct quic_pnspace *space,
+					      u8 ecn)
+{
+	if (!ecn)
+		return;
+	space->ecn_count[QUIC_ECN_ACKED][ecn - 1]++;
+}
+
+static inline void quic_pnspace_reset_ecn_acked(struct quic_pnspace *space)
+{
+	space->ecn_count[QUIC_ECN_ACKED][QUIC_ECN_ECT0] = 0;
+	space->ecn_count[QUIC_ECN_ACKED][QUIC_ECN_ECT1] = 0;
+	space->ecn_count[QUIC_ECN_ACKED][QUIC_ECN_CE] = 0;
+}
+
+static inline void quic_pnspace_inc_ecn_local(struct quic_pnspace *space,
+					      u8 ecn)
+{
+	if (!ecn)
+		return;
+	space->ecn_count[QUIC_ECN_LOCAL][ecn - 1]++;
+}
+
+/* Check if any ECN-marked packets were received. */
+static inline bool quic_pnspace_has_ecn_local(struct quic_pnspace *space)
+{
+	return space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_ECT0] ||
+	       space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_ECT1] ||
+	       space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_CE];
+}
+
+/* Validate ECN counts received in an ACK. */
+static inline bool quic_pnspace_validate_ecn(struct quic_pnspace *space,
+					     u64 *ecn_count)
+{
+	u64 *acked = space->ecn_count[QUIC_ECN_ACKED];
+	u64 *peer = space->ecn_count[QUIC_ECN_PEER];
+	u64 ect0, ect1, ce;
+
+	if (peer[QUIC_ECN_ECT0] > ecn_count[QUIC_ECN_ECT0] ||
+	    peer[QUIC_ECN_ECT1] > ecn_count[QUIC_ECN_ECT1] ||
+	    peer[QUIC_ECN_CE] > ecn_count[QUIC_ECN_CE])
+		return false;
+
+	/* rfc9000#section-13.4.2.1:
+	 *
+	 * ECN validation also fails if the sum of the increase in ECT(0) and
+	 * ECN-CE counts is less than the number of newly acknowledged packets
+	 * that were originally sent with an ECT(0) marking (Same for ECT(1)).
+	 */
+	ect0 = ecn_count[QUIC_ECN_ECT0] - peer[QUIC_ECN_ECT0];
+	ect1 = ecn_count[QUIC_ECN_ECT1] - peer[QUIC_ECN_ECT1];
+	ce = ecn_count[QUIC_ECN_CE] - peer[QUIC_ECN_CE];
+
+	return ect0 + ce >= acked[QUIC_ECN_ECT0] &&
+	       ect1 + ce >= acked[QUIC_ECN_ECT1];
+}
+
+/* Updates the stored ECN counters based on values received in the peer's ACK
+ * frame. Each counter is updated only if the new value is higher.
+ *
+ * Returns: true if CE count was increased (congestion indicated), false
+ * otherwise.
+ */
+static inline bool quic_pnspace_set_ecn_peer(struct quic_pnspace *space,
+					     u64 *ecn_count)
+{
+	u64 *count = space->ecn_count[QUIC_ECN_PEER];
+
+	if (count[QUIC_ECN_ECT0] < ecn_count[QUIC_ECN_ECT0])
+		count[QUIC_ECN_ECT0] = ecn_count[QUIC_ECN_ECT0];
+	if (count[QUIC_ECN_ECT1] < ecn_count[QUIC_ECN_ECT1])
+		count[QUIC_ECN_ECT1] = ecn_count[QUIC_ECN_ECT1];
+	if (count[QUIC_ECN_CE] < ecn_count[QUIC_ECN_CE]) {
+		count[QUIC_ECN_CE] = ecn_count[QUIC_ECN_CE];
+		return true;
+	}
+	return false;
+}
+
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space,
+			  struct quic_gap_ack_block *gabs);
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn);
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn, gfp_t gfp);
+
+void quic_pnspace_free(struct quic_pnspace *space);
+int quic_pnspace_init(struct quic_pnspace *space);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 41f7de7d163a..78a08dd998a8 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -42,6 +42,9 @@ static void quic_write_space(struct sock *sk)
 
 static int quic_init_sock(struct sock *sk)
 {
+	struct quic_pnspace *space;
+	u8 i;
+
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 	sock_set_flag(sk, SOCK_RCU_FREE);
@@ -58,11 +61,34 @@ static int quic_init_sock(struct sock *sk)
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
+	/* Allocate pnspace structures for each packet number space. */
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
+		space = kzalloc_obj(*space);
+		if (!space)
+			return -ENOMEM;
+		if (quic_pnspace_init(space)) {
+			kfree(space);
+			return -ENOMEM;
+		}
+		quic_sk(sk)->space[i] = space;
+	}
+
 	return 0;
 }
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	struct quic_pnspace *space;
+	u8 i;
+
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
+		space = quic_pnspace(sk, i);
+		if (!space)
+			continue;
+		quic_pnspace_free(space);
+		kfree(space);
+	}
+
 	quic_path_unbind(sk, quic_paths(sk), 0);
 	quic_path_unbind(sk, quic_paths(sk), 1);
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 9201ca3edad0..7f19e2b3d7fb 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -12,6 +12,7 @@
 #include <linux/quic.h>
 
 #include "common.h"
+#include "pnspace.h"
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
@@ -43,6 +44,7 @@ struct quic_sock {
 	struct quic_conn_id_set		dest;
 	struct quic_path_group		paths;
 	struct quic_cong		cong;
+	struct quic_pnspace		*space[QUIC_PNSPACE_MAX];
 };
 
 struct quic6_sock {
@@ -105,6 +107,11 @@ static inline struct quic_cong *quic_cong(const struct sock *sk)
 	return &quic_sk(sk)->cong;
 }
 
+static inline struct quic_pnspace *quic_pnspace(const struct sock *sk, u8 level)
+{
+	return quic_sk(sk)->space[level % QUIC_CRYPTO_EARLY];
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

