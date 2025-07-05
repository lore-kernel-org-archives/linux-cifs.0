Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A8215175;
	Sat,  5 Jul 2025 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744341; cv=none; b=K7xbePhJwV9AAY4peM/9pYIWTLcKqy4OeA+GiJlR6I85eZyKBz8YIdnjNN7P+L455YJWc+1D5s3VI41jdt9uuZvJg47LGUw3a3LwCfF+THcV8LYY2FkD+LiRyPu957vKsAmRm/ifXIAMdZ49ulQFJIsthc9bvbE5wjoFXeM+FSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744341; c=relaxed/simple;
	bh=UbCGG9nYUBI4lioNCuqJGzvwuc61WJS2FL0b0EukvOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGiCcvr1WOeQvUCaCFiOmkwY6WAeVLrmqLuEN4yuuqpoHHH1b8Z2AgDsdtWnT37bvzHlx9mn5iC1TtgHUob0v1SOSUWEXK1s6gwkGB0A+kuPf+o/btNEBjrG6BqYhr4kgGcKohY8BU6LfXYee0XylN3XDfikIJkYBQv2Lu5XbLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFbjQC0+; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFbjQC0+"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7d20f79a00dso301553085a.0;
        Sat, 05 Jul 2025 12:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744338; x=1752349138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snI6sUqrHtLtpKEX9iDVQmJi14FlVGJ++uCGDC9Y5gw=;
        b=OFbjQC0+kulzIkmHeOGCZza9z8URCmuMcdutEHq9uyWRuDcdgOCXycBt1G5MIzOokE
         orAf0LvaCTGPPQqozik+knbsyOiOmjOIvKMSRyAUFdhRhp3L4Xmu5ASJ9gySHaKhwJRG
         oEd58X9LCD2dfCmsvyJvskR9vg3rcUFXM4BPavDMoa0AOJpfg8Zpov6mY8punnCf0PCV
         0CiIeikSJKyNqWeb2Ss35/X6Xbz7ZE8vM3YTpLuCl1pGh3UWv1tO/Pyrj/vy8FwBaMn9
         bNzCzA1PrpPG90C5CttLl8sDzSNAzO3frXS2hZdr/GSlea+2adxQrAGgKIjjcDVucKyf
         7jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744338; x=1752349138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=snI6sUqrHtLtpKEX9iDVQmJi14FlVGJ++uCGDC9Y5gw=;
        b=kvtb1n11CLiYzLszC2+U4MUSZEvfxqDkjQMz2ilJs04lADEfmd5mxMZLQPPqxrV/lL
         VkUcL5yyJjP5btMoERhxKOK10o5C+2duNPVk1vq7MLtSpp9RsnuiIL52ORpROrSSfQGI
         pAyG9bkHxXgRAyPBX/u+nJWYN+XtUEWKZb+rH/H9tSiAX2Ztun1s6WAaZ91LRwyXAfyS
         oLmnKKJbhIbB1Hrbxkj8t31kr+EXd446IWX3UXcS3mgCZJ1aG5jUTE2X0WEzI6mgbuzV
         GXuCPHoRtZzxah5iRccCVRO3DvnDugHleeYFxi+2b2XotrjGQVrvvmwL3OVW50nLE93W
         Egdw==
X-Forwarded-Encrypted: i=1; AJvYcCUonvneamhoUXIijV8iDFsDOC0/T7dhKgobJnxGs9voZv2IimY2FQVpKFm3+QKDc4U/QML7VExJtZaz@vger.kernel.org
X-Gm-Message-State: AOJu0Yzroea0Gcy0KIJIir2glFTkUYgyWCDl4W9vDXPos2bCMfcQ49S/
	k0WdDizB1dOI2yIYuFrril/b0RYMf1+1JHdAzNcD4hdekWB4T7ses8vHlSIa9aKoSiY=
X-Gm-Gg: ASbGncvCDUQtSBNZ9prQzZe84RnG8kEzLiWwfYRY3snJmmAgx+q6cjt29g2evEsvWPO
	QkseCMJdbhcuoHScghX4USNvA5qv0zaoNF85zUVLQ9w3Rt2/e4Ieokv60jY5/M97DK2aho3ATFH
	yfh0a5jYWwIGBfN5yflgS9+UJFFtNZEUWm8nGw3pCegi7a4PW9Lr83vwLkFfScay8sNMh96KUhX
	8qPlFwIYZB2yAnEILdfAN4VqaLAlVhKKrWNhNmu4hWMrSyMHMv1dCyp7p5twd1FWS5SWStIB5vZ
	pNpsH1PXRZBQMUdvPZO7wQD9Wpy8+mCXy/a/OZk6l5s7M3WqQXng/9tildazHDRuGfeT6qq/4wj
	//i9ThS8/0FdvaM/iS+pX6uGOef0=
X-Google-Smtp-Source: AGHT+IHboOJI4wu6ebDghXrR9C2AItW30U15+yIP04VULPUIfpJaxE087k7U/wjvJiG1I4sTUu7y2g==
X-Received: by 2002:a05:620a:3d89:b0:7d4:2840:5a10 with SMTP id af79cd13be357-7d5dcd09913mr826892185a.44.1751744337598;
        Sat, 05 Jul 2025 12:38:57 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:57 -0700 (PDT)
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
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 10/15] quic: add packet number space
Date: Sat,  5 Jul 2025 15:31:49 -0400
Message-ID: <33231313d9be0d365c94d833f80fca52386b7e80.1751743914.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile  |   2 +-
 net/quic/pnspace.c | 224 +++++++++++++++++++++++++++++++++++++++++++++
 net/quic/pnspace.h | 150 ++++++++++++++++++++++++++++++
 net/quic/socket.c  |  12 +++
 net/quic/socket.h  |   7 ++
 5 files changed, 394 insertions(+), 1 deletion(-)
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
index 000000000000..3f61b0bc6fc6
--- /dev/null
+++ b/net/quic/pnspace.c
@@ -0,0 +1,224 @@
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
+#include <linux/slab.h>
+
+#include "pnspace.h"
+
+int quic_pnspace_init(struct quic_pnspace *space)
+{
+	if (!space->pn_map) {
+		space->pn_map = kzalloc(BITS_TO_BYTES(QUIC_PN_MAP_INITIAL), GFP_KERNEL);
+		if (!space->pn_map)
+			return -ENOMEM;
+		space->pn_map_len = QUIC_PN_MAP_INITIAL;
+	} else {
+		bitmap_zero(space->pn_map, space->pn_map_len);
+	}
+
+	space->max_time_limit = QUIC_PNSPACE_TIME_LIMIT;
+	space->next_pn = QUIC_PNSPACE_NEXT_PN;
+	space->base_pn = -1;
+	return 0;
+}
+
+void quic_pnspace_free(struct quic_pnspace *space)
+{
+	space->pn_map_len = 0;
+	kfree(space->pn_map);
+}
+
+/* Expand the bitmap tracking received packet numbers.  Ensures the pn_map bitmap can
+ * cover at least @size packet numbers.  Allocates a larger bitmap, copies existing
+ * data, and updates metadata.
+ *
+ * Returns: 1 if the bitmap was successfully grown, 0 on failure or if the requested
+ * size exceeds QUIC_PN_MAP_SIZE.
+ */
+static int quic_pnspace_grow(struct quic_pnspace *space, u16 size)
+{
+	u16 len, inc, offset;
+	unsigned long *new;
+
+	if (size > QUIC_PN_MAP_SIZE)
+		return 0;
+
+	inc = ALIGN((size - space->pn_map_len), BITS_PER_LONG) + QUIC_PN_MAP_INCREMENT;
+	len = (u16)min(space->pn_map_len + inc, QUIC_PN_MAP_SIZE);
+
+	new = kzalloc(BITS_TO_BYTES(len), GFP_ATOMIC);
+	if (!new)
+		return 0;
+
+	offset = (u16)(space->max_pn_seen + 1 - space->base_pn);
+	bitmap_copy(new, space->pn_map, offset);
+	kfree(space->pn_map);
+	space->pn_map = new;
+	space->pn_map_len = len;
+
+	return 1;
+}
+
+/* Check if a packet number has been received.
+ *
+ * Returns: 0 if the packet number has not been received.  1 if it has already
+ * been received.  -1 if the packet number is too old or too far in the future
+ * to track.
+ */
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn)
+{
+	if (space->base_pn == -1) /* No any packet number received yet. */
+		return 0;
+
+	if (pn < space->min_pn_seen || pn >= space->base_pn + QUIC_PN_MAP_SIZE)
+		return -1;
+
+	if (pn < space->base_pn || (pn - space->base_pn < space->pn_map_len &&
+				    test_bit(pn - space->base_pn, space->pn_map)))
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
+	offset = (u16)find_next_zero_bit(space->pn_map, space->pn_map_len, offset);
+	space->base_pn += offset;
+	bitmap_shift_right(space->pn_map, space->pn_map, offset, space->pn_map_len);
+}
+
+/* Mark a packet number as received. Updates the packet number map to record
+ * reception of @pn.  Advances base_pn if possible, and updates max/min/last seen
+ * fields as needed.
+ *
+ * Returns: 0 on success or if the packet was already marked.  -ENOMEM if bitmap
+ * allocation failed during growth.
+ */
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn)
+{
+	s64 last_max_pn_seen;
+	u16 gap;
+
+	if (space->base_pn == -1) {
+		/* Initialize base_pn based on the peer's first packet number since peer's
+		 * packet numbers may start at a non-zero value.
+		 */
+		quic_pnspace_set_base_pn(space, pn + 1);
+		return 0;
+	}
+
+	/* Ignore packets with number less than current base (already processed). */
+	if (pn < space->base_pn)
+		return 0;
+
+	/* If gap is beyond current map length, try to grow the bitmap to accommodate. */
+	gap = (u16)(pn - space->base_pn);
+	if (gap >= space->pn_map_len && !quic_pnspace_grow(space, gap + 1))
+		return -ENOMEM;
+
+	if (space->max_pn_seen < pn) {
+		space->max_pn_seen = pn;
+		space->max_pn_time = space->time;
+	}
+
+	if (space->base_pn == pn) { /* If packet is exactly at base_pn (next expected packet). */
+		if (quic_pnspace_has_gap(space)) /* Advance base_pn to next unacked packet. */
+			quic_pnspace_move(space, pn);
+		else /* Fast path: increment base_pn if no gaps. */
+			space->base_pn++;
+	} else { /* Mark this packet as received in the bitmap. */
+		set_bit(gap, space->pn_map);
+	}
+
+	/* Only update min and last_max_pn_seen if this packet is the current max_pn. */
+	if (space->max_pn_seen != pn)
+		return 0;
+
+	/* Check if enough time has elapsed or enough packets have been received to
+	 * update tracking.
+	 */
+	last_max_pn_seen = min_t(s64, space->last_max_pn_seen, space->base_pn);
+	if (space->max_pn_time < space->last_max_pn_time + space->max_time_limit &&
+	    space->max_pn_seen <= last_max_pn_seen + QUIC_PN_MAP_LIMIT)
+		return 0;
+
+	/* Advance base_pn if last_max_pn_seen is ahead of current base_pn. This is
+	 * needed because QUIC doesn't retransmit packets; retransmitted frames are
+	 * carried in new packets, so we move forward.
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
+/* Find the next gap in received packet numbers. Scans pn_map for a gap starting from
+ * *@iter. A gap is a contiguous block of unreceived packets between received ones.
+ *
+ * Returns: 1 if a gap was found, 0 if no more gaps exist or are relevant.
+ */
+static int quic_pnspace_next_gap_ack(const struct quic_pnspace *space,
+				     s64 *iter, u16 *start, u16 *end)
+{
+	u16 start_ = 0, end_ = 0, offset = (u16)(*iter - space->base_pn);
+
+	start_ = (u16)find_next_zero_bit(space->pn_map, space->pn_map_len, offset);
+	if (space->max_pn_seen <= space->base_pn + start_)
+		return 0;
+
+	end_ = (u16)find_next_bit(space->pn_map, space->pn_map_len, start_);
+	if (space->max_pn_seen <= space->base_pn + end_ - 1)
+		return 0;
+
+	*start = start_ + 1;
+	*end = end_;
+	*iter = space->base_pn + *end;
+	return 1;
+}
+
+/* Generate gap acknowledgment blocks (GABs).  GABs describe ranges of unacknowledged
+ * packets between received ones, and are used in ACK frames.
+ *
+ * Returns: Number of generated GABs (up to QUIC_PN_MAX_GABS).
+ */
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space, struct quic_gap_ack_block *gabs)
+{
+	u16 start, end, ngaps = 0;
+	s64 iter;
+
+	if (!quic_pnspace_has_gap(space))
+		return 0;
+
+	iter = space->base_pn;
+	/* Loop through all gaps until the end of the window or max allowed gaps. */
+	while (quic_pnspace_next_gap_ack(space, &iter, &start, &end)) {
+		gabs[ngaps].start = start;
+		if (ngaps == QUIC_PN_MAX_GABS - 1) {
+			gabs[ngaps].end = (u16)(space->max_pn_seen - space->base_pn);
+			ngaps++;
+			break;
+		}
+		gabs[ngaps].end = end;
+		ngaps++;
+	}
+	return ngaps;
+}
diff --git a/net/quic/pnspace.h b/net/quic/pnspace.h
new file mode 100644
index 000000000000..ff700c2cd2ef
--- /dev/null
+++ b/net/quic/pnspace.h
@@ -0,0 +1,150 @@
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
+#define QUIC_PN_MAX_GABS	32
+#define QUIC_PN_MAP_MAX_PN	(BIT_ULL(62) - 1)
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
+	QUIC_ECN_LOCAL,		/* ECN bits from incoming IP headers */
+	QUIC_ECN_PEER,		/* ECN bits reported by peer in ACK frames */
+	QUIC_ECN_DIR_MAX
+};
+
+/* Represents a gap (range of missing packets) in the ACK map.  The values are offsets from
+ * base_pn, with both 'start' and 'end' being +1.
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
+ *   - last_max_pn_time = current time;
+ *
+ * Conditions to Advance pn_map:
+ *   - (max_pn_time - last_max_pn_time) >= max_time_limit, or
+ *   - (max_pn_seen - last_max_pn_seen) > QUIC_PN_MAP_LIMIT
+ *
+ * Gap Search Range:
+ *   - From (base_pn - 1) to max_pn_seen
+ */
+struct quic_pnspace {
+	/* ECN counters indexed by direction (TX/RX) and ECN codepoint (ECT1, ECT0, CE) */
+	u64 ecn_count[QUIC_ECN_DIR_MAX][QUIC_ECN_MAX];
+	unsigned long *pn_map;	/* Bit map tracking received packet numbers for ACK generation */
+	u16 pn_map_len;		/* Length of the packet number bit map (in bits) */
+	u8  need_sack:1;	/* Flag indicating a SACK frame should be sent for this space */
+	u8  sack_path:1;	/* Path used for sending the SACK frame */
+
+	s64 last_max_pn_seen;	/* Highest packet number seen before pn_map advanced */
+	u32 last_max_pn_time;	/* Timestamp when last_max_pn_seen was received */
+	u32 max_time_limit;	/* Time threshold to trigger pn_map advancement on packet receipt */
+	s64 min_pn_seen;	/* Smallest packet number received in this space */
+	s64 max_pn_seen;	/* Largest packet number received in this space */
+	u32 max_pn_time;	/* Time at which max_pn_seen was received */
+	s64 base_pn;		/* Packet number corresponding to the start of the pn_map */
+	u32 time;		/* Cached current time, or time accept a socket (listen socket) */
+
+	s64 max_pn_acked_seen;	/* Largest packet number acknowledged by the peer */
+	u32 max_pn_acked_time;	/* Time at which max_pn_acked_seen was acknowledged */
+	u32 last_sent_time;	/* Time when the last ack-eliciting packet was sent */
+	u32 loss_time;		/* Time after which the next packet can be declared lost */
+	u32 inflight;		/* Bytes of all ack-eliciting frames in flight in this space */
+	s64 next_pn;		/* Next packet number to send in this space */
+};
+
+static inline void quic_pnspace_set_max_pn_acked_seen(struct quic_pnspace *space,
+						      s64 max_pn_acked_seen)
+{
+	if (space->max_pn_acked_seen >= max_pn_acked_seen)
+		return;
+	space->max_pn_acked_seen = max_pn_acked_seen;
+	space->max_pn_acked_time = jiffies_to_usecs(jiffies);
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
+static inline void quic_pnspace_inc_ecn_count(struct quic_pnspace *space, u8 ecn)
+{
+	if (!ecn)
+		return;
+	space->ecn_count[QUIC_ECN_LOCAL][ecn - 1]++;
+}
+
+/* Check if any ECN-marked packets were received. */
+static inline bool quic_pnspace_has_ecn_count(struct quic_pnspace *space)
+{
+	return space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_ECT0] ||
+	       space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_ECT1] ||
+	       space->ecn_count[QUIC_ECN_LOCAL][QUIC_ECN_CE];
+}
+
+/* Updates the stored ECN counters based on values received in the peer's ACK
+ * frame. Each counter is updated only if the new value is higher.
+ *
+ * Returns: 1 if CE count was increased (congestion indicated), 0 otherwise.
+ */
+static inline int quic_pnspace_set_ecn_count(struct quic_pnspace *space, u64 *ecn_count)
+{
+	if (space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_ECT0] < ecn_count[QUIC_ECN_ECT0])
+		space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_ECT0] = ecn_count[QUIC_ECN_ECT0];
+	if (space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_ECT1] < ecn_count[QUIC_ECN_ECT1])
+		space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_ECT1] = ecn_count[QUIC_ECN_ECT1];
+	if (space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_CE] < ecn_count[QUIC_ECN_CE]) {
+		space->ecn_count[QUIC_ECN_PEER][QUIC_ECN_CE] = ecn_count[QUIC_ECN_CE];
+		return 1;
+	}
+	return 0;
+}
+
+u16 quic_pnspace_num_gabs(struct quic_pnspace *space, struct quic_gap_ack_block *gabs);
+int quic_pnspace_check(struct quic_pnspace *space, s64 pn);
+int quic_pnspace_mark(struct quic_pnspace *space, s64 pn);
+
+void quic_pnspace_free(struct quic_pnspace *space);
+int quic_pnspace_init(struct quic_pnspace *space);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 901288b1776a..5c0173c9d6cc 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -38,6 +38,8 @@ static void quic_write_space(struct sock *sk)
 
 static int quic_init_sock(struct sock *sk)
 {
+	u8 i;
+
 	sk->sk_destruct = inet_sock_destruct;
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
@@ -49,6 +51,11 @@ static int quic_init_sock(struct sock *sk)
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
+		if (quic_pnspace_init(quic_pnspace(sk, i)))
+			return -ENOMEM;
+	}
+
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
 
@@ -62,6 +69,11 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	u8 i;
+
+	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
+		quic_pnspace_free(quic_pnspace(sk, i));
+
 	quic_path_free(sk, quic_paths(sk), 0);
 	quic_path_free(sk, quic_paths(sk), 1);
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 93a6322a12c9..1bee3b9f594a 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -14,6 +14,7 @@
 #include <net/udp_tunnel.h>
 #include <linux/quic.h>
 
+#include "pnspace.h"
 #include "common.h"
 #include "family.h"
 #include "stream.h"
@@ -47,6 +48,7 @@ struct quic_sock {
 	struct quic_conn_id_set		dest;
 	struct quic_path_group		paths;
 	struct quic_cong		cong;
+	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
 };
 
 struct quic6_sock {
@@ -114,6 +116,11 @@ static inline struct quic_cong *quic_cong(const struct sock *sk)
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

