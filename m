Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F34D4896
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227147; cv=none; b=kDpj2HNBh1P0tz5hJuTJ4pB02nTyUD9Ne0Sj4yHeTcg/sIEHVjtR+xS1tR3acA5favpoZkPBHCn/IDQ1Mr3rEA4aDopECevrqrDCDny9rMXc8O0yYy9LLlVHQ9R5EuZ7wAJvwzMFfYJBiu0caY+24V8ybPT3asw+MesK3LTdl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227147; c=relaxed/simple;
	bh=OLlKZLoC/fmo4lNRZ10yhaSRH/TGo0yRYnki5YNY3Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSEA6iuHJFnPXApnr02RmOlnyl3b83XoQ3hBu8M0yBDwfxNbS83KFaXXNcsG7gkneMJLS2r74cKam+EXR+AIq+pWffFZK9ZnbJTrbE0RLp5Gf3gGMWnWN8mtqvbJAGSNUHTnKVtk76B4N7s88j7ODFTIevGvw/+rZsnkF03pxJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTZlqAgX; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTZlqAgX"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e76469b93so75460685a.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 12:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791227142; x=1791831942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4tVDxQmwUTwKldvA5+5wht1zURL+hYcPd0x7D2xRhaM=;
        b=FTZlqAgX6BYFDTS2dluB6NU6ia2LHniicyCl0MsxyECdUMQp0YUgJxQnPEBuiEIJXb
         /mDTPaY9KNftppvKlU9+PCayjEJtsIaQXmFvKwzas0YvBLdb1LujkCPQzC1TWY1MZPgP
         KfIwXWqalVajWC8DaxFA2rb/aDWhD3aMqdkBwue8HN4vJ9TV1xOS5s9pL4YYTG1qUrJR
         dzvr5Ptuu99Qtem2DR1LJAqIJ6jy+OG5ttzC/Rh/ZdiQ9/A2S6G7+V0A6MppF4ew4ES9
         hqXEeTYV7S+3jtpM2P+ol283o2JU8illcJJBfVAiKdYVX9LvDXPj0Q2rDfQvBtMY+q/n
         6voA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791227142; x=1791831942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4tVDxQmwUTwKldvA5+5wht1zURL+hYcPd0x7D2xRhaM=;
        b=xFPQIt/pxVDphV9OXGAyibzl6g2VjkiHLNTI2dqOqG5i9KzHNKEl6QMr5fwGqeOLrQ
         O6BSIBOxql49GHbpnH7LJrqPU529K3VZtCR3SD7oEs4TDA1WfgiVxtv+SghoXeAs0o6j
         ye7BhnK8dMODMduqbiK7hBeBV93Y5nn53Bkf8UqLJtw6JE8rk03XhQFSpnDXuyQDeS/D
         Fr+rgrf8eudQKQOZwur1X4rMNZiGVQVC5/ghuKz3rg8T7lomA01LXLIuCKSyZF1ZFHKf
         yb91clCHz1I90ycJVbqMAGuhMjk3UQuKpnIP8JQZtjyZYORzqZaqdDb/WyatNAdXMREF
         Dpjg==
X-Forwarded-Encrypted: i=1; AKwUvBz1NI6ADFSCHXqM9oq0kyj59pabQV9Do5Oj6pohWGnf7tmzGuT0/hEVAH3Z0SfZon7yoJXG0XovichC@vger.kernel.org
X-Gm-Message-State: AFuF++mt16oO7yS6o/GnOb9D0WvUYwjGXjBzrcLPeWugJp66ZDGF5iPc
	kdr8I+Wl7n+a0MIL7xgJeR2q1IhGYoffi7vrrDcqwwWE7P5WowtSjGmr
X-Gm-Gg: AYBFou11+ixDJ+NuVVZ7cMTZtFnM9yejgblnbv1vjFVv+4xUkoWQLb9Dxik76GzE1B3
	b4xvIdKm8KdVghOfZTRQJuXrl7n00sMHeX9SaVKup6BNX2TPjfJg4fzxp9Y45Br0egK7HWMWTGt
	BUMLuefgufmOWSc3MNM8Vo0LnmEkc3I4Lb9ArtecubFDNAMu6U0WREfVwcy55iJyeAHO9QjBBba
	W3N/9llQ7waIaBYMQTEOL1hToZzUbcb+l1j0Qjb1CVWvihVlq5/mTDk5ys5vHAyT7eMViJtBs0Z
	BQMSM143dcfZSNgfD1NiRGo8CfMbrGNuxiBx0a4wJ5uQBCYkZc/qjTzPIE/xZnTvE3tePnbORvH
	LKZmn/th5lGEEPSLE8gb1V88+GDonsw1qft0nV6AjbZ2xfCH0JZXefEewDMdQGUnoYofrhdFjb9
	Q4XnGEzm+LS5cfWjgH31AGGrAowNwyI93fLeVnxWnb5Lf01tOBZs+H6tUycJu4HKMAuOEwPEa4x
	wA9bp+gHgfU4G3qV6RNRMk5F2Zv7z5564K3B4sDJdufweJSI+gqHhI5gYgEBYHnp+k/u2ii1vPW
	djG1cukwJlED4LUIsXNrG+qYl32gSlqvvrMBvQ==
X-Received: by 2002:a05:620a:27c4:b0:93c:82bc:146c with SMTP id af79cd13be357-93e510370e0mr1430059685a.37.1791227142207;
        Mon, 05 Oct 2026 12:05:42 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca263708sm927117785a.31.2026.10.05.12.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 12:05:41 -0700 (PDT)
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
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v16 10/15] quic: add packet number space
Date: Mon,  5 Oct 2026 15:04:05 -0400
Message-ID: <4e13764a900fab1fe886a34a3c05351262b9a585.1791227050.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1791227050.git.lucien.xin@gmail.com>
References: <cover.1791227050.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
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
acknowledgment map (pn_ack_map) that tracks received packet numbers.
Supporting functions are provided to validate and mark received packet
numbers and compute the number of gap blocks needed during ACK frame
construction.

- quic_pnspace_check(): Validates a received packet number.

- quic_pnspace_mark(): Marks a received packet number in the ACK map.

- quic_pnspace_num_gabs(): Returns the gap ACK blocks for constructing
  ACK frames.

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
---
 net/quic/Makefile  |   2 +-
 net/quic/pnspace.c | 273 +++++++++++++++++++++++++++++++++++++++++++++
 net/quic/pnspace.h | 201 +++++++++++++++++++++++++++++++++
 net/quic/socket.c  |  12 ++
 net/quic/socket.h  |   7 ++
 5 files changed, 494 insertions(+), 1 deletion(-)
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
index 000000000000..18c7a65403e6
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
+	space->pn_map = kzalloc(BITS_TO_BYTES(QUIC_PN_MAP_INITIAL), GFP_KERNEL);
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
+	space->pn_map_len = 0;
+	kfree(space->pn_map);
+	space->pn_map = NULL;
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
+	new = kzalloc(BITS_TO_BYTES(len), gfp);
+	if (!new)
+		return -ENOMEM;
+
+	offset = (u16)(space->max_pn_seen + 1 - space->base_pn);
+	bitmap_copy(new, space->pn_map, offset);
+	kfree(space->pn_map);
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
index 000000000000..67981d5f1849
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
+ *   - (max_pn_seen - last_max_pn_seen) > QUIC_PN_MAP_LIMIT
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
index 567d9b8b325e..12f0817c8b55 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -42,6 +42,8 @@ static void quic_write_space(struct sock *sk)
 
 static int quic_init_sock(struct sock *sk)
 {
+	u8 i;
+
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
@@ -57,11 +59,21 @@ static int quic_init_sock(struct sock *sk)
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
+		if (quic_pnspace_init(quic_pnspace(sk, i)))
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	u8 i;
+
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
+		quic_pnspace_free(quic_pnspace(sk, i));
+
 	quic_path_unbind(sk, quic_paths(sk), 0);
 	quic_path_unbind(sk, quic_paths(sk), 1);
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 9201ca3edad0..68c7b22d1e88 100644
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
+	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 };
 
 struct quic6_sock {
@@ -105,6 +107,11 @@ static inline struct quic_cong *quic_cong(const struct sock *sk)
 	return &quic_sk(sk)->cong;
 }
 
+static inline struct quic_pnspace *quic_pnspace(const struct sock *sk, u8 level)
+{
+	return &quic_sk(sk)->space[level % QUIC_CRYPTO_EARLY];
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

