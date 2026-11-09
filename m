Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241766;
	b=dFrK01ZDj2yIyxnEBog4gV79wJ+LWocmVozVCn3NO3EpIc83QZbA/A5wifBss8xUBWDi
	 PsMIuagGC044OUQ6P/WUo0QDlTghxIMEz9ikXyfyCb9gNIjujxCcpzkRA0dHHOcv0Z7Dy
	 th81mQeop37oht4lp8Fw0zUocNreRG0thORH3LjQe2qpptUEQGe9+xRkB8Klc2AhKCefv
	 glkHpGIZE+r+sQPsRaKR1hOwwXFTWrUTab8/ekxcNIwTbqFRu5QHcIIRb2Wf11nQE29CX
	 Wrs6Ehs4bG5JcFuPXUAER+Xl0dvqn51IkFGLpYx4C3XyEcEE69Je3isLRkwBTQhGjQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0YCHIQ0j02yu+nkkTjWjgKnnt79Q5uBY+LE0FvTyF2k=;
	b=5iyHNwwl5J5Lz9GCW0UjgNYvvxbEL3QHszBff6NwEpsilwU3gwLwHuOfvLZAhZZ5fAuk
	 zcNnB9S4HXnHWcU9z3hHcchklQjBwhhvrRTKkcNXxcaqMitOE7hndz93kLJeuUvDv+A/o
	 ws3OVhh7710XU0yRc7tYCNpoNht/9ng+at8YvhEyPMxGezfIW9KlS1Q4d4WFOKZbdVBdQ
	 uykmtxZlUtyB+E1lDQv9RSmy4vsgWXCRSv+cX5uw6XlAUia0gvK3OdARUCeNyMbNQLxya
	 VoS1REMQHGglUlVF/bqv5iOUBPucYSJVR9rEQkQOFhSALxlG7aZDUXN5N94quBqERew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ycNbSI4i;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0340606EE90
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 16:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0340606EE90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ycNbSI4i
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e64d52949so91404685a.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 08:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794241764; x=1794846564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0YCHIQ0j02yu+nkkTjWjgKnnt79Q5uBY+LE0FvTyF2k=;
        b=ycNbSI4iCOkF8mmDTi4dl32XlUT9wmohMxrZdz2EJID7M8osnCx2Rq4q1Z0dq1nXXK
         fkZ5+F3idZUV8l/oq6/1+zpijcqFvyPnQsiwKibRKQOkpLvyjL6ngGyMsJoYpMHHsG8h
         YRL9zFFo8fum/qU2yeC25kn0b9ZL4ZY5XqmQN9J1hwVVNp+GWLx9QEa02mB1aSOzvt1c
         gHBwShHucRS8Wl8TLgh0HFeSXSNm6tpXqDhJlrguz7zCrnCj//J+1bmlwETHAL8u3I4D
         yT/WZT1F7t2paJbt6ZdrfyLgrkg1eXdKAvEHsRR4EAtN3JRvx8d7VC84CERDq4Vk9pGm
         Ie1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794241764; x=1794846564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0YCHIQ0j02yu+nkkTjWjgKnnt79Q5uBY+LE0FvTyF2k=;
        b=pTYpX42z0u+Gqs41qL+KJe0cfQGHldjvB0zMVXFxbwgKZvXrKaDbbb9kwjgvn3JXVT
         3EzqPYZj6/4U2KdBJUrMW0/hx2dl1Qp9+cI9cu1K7AaLMOHq7CoNX1nxVO6CuiXx5LDr
         iKsxeV6T38eYT0Gizv30US49Un7+ezQAxvQcMX6sqkIYTCwyp3oxi7I2W3nFR3ThqRXm
         TICDfiyozGPWewrWwFW1ctI1s5hWHfvvfwX7AobUt6NFqTpCsK7waSfU8qP/e2gM5DXA
         FG+4P+r1fAhgQcB2ZK2rWP6rg7Q6ERXIr6HolIAWZVnpk4rC0jXIE/YPIQga9cPjWpC4
         7aCg==
X-Forwarded-Encrypted: i=1; AL+hErGmX5ZG9KfPSd/nEGTgpNnODAkGYFHmHee5aMxayVG8H2gVSTTElMP30eNg8BTKALspXf6xnLnEYPr1@vger.kernel.org
X-Gm-Message-State: APuU4Z9HBBx+vU+vBjBdz62ZLIsZk9//3zP94TPxmVLijOzZoM7U/lbh
	EPRd9WEZIpsbK27C85H55gUOJ45sOpsHdY4JCG2ok7viXbT4gUBvB+Pi
X-Gm-Gg: AYBFou2IyHaZyd777ABP61RZXMXX+udmooXi2Xz1ojimSomsdlo5H8GGcM2at9da8LW
	0v3KEQm8ierrwiX0MxiDhjWJVUfAyEj7+6MeHvttMGLMVfUwX3SVSg0f/TEYfoarumtvH1+ci2q
	+a/h9cpkFxSc5qRqdEgf+t5NuJMcUhYBYj0SiuAmlmlG9wfGZOhlBFfVWaHG8zm57MaeC5yYr3S
	vQFBgZxHI91GNdi2fo9sEf1ulAeXQ3rRa+2ejI+DRUcehNhg3hBVlOkvuq3KfcI5JoF//t8XAXP
	4qMmZpRL9Jg61TG43bfCZFkeTCuOOHy/ys1y3UU2XHjmJYK/S/mSKkkNFM6GhYAg1boQvIVO3aY
	WJOhZVDzK3EkF5fboV9j3p0alBO6MXcDcm/8wBWzezgdAWZqQZD833TABnfo3wJECkytJGyTM9m
	jIwwZxlprWlScwo2X0lGOdPWWDg4mERgXnvLqJ4yDjpv0VjIeVsB8sr2i096oeKkDfZ4KXid5QA
	Iyq3ILa4N8YocltPh/k2/Zxycz3FyjIiSpuxvHXAJQTfUzB8NdBa2D/zNdJbyqnIyVdVlABQHMm
	fMhV2lFdrjtdXKUcDObJgcfrZICc0LgU5tSSB7MpgKXAJTtD2PA6rRT8SuLkHqFLkFCw6kODCEP
	uxFrz3gBxb9/gdjWIFDAppGgT116exKJ85rUpWha3Ta5a8RB3M7veZiXNnTY8ROu2o92lQNsAnt
	joTkIEkYFf9csmQErs
X-Received: by 2002:a05:620a:40cf:b0:93e:c12c:f124 with SMTP id af79cd13be357-947842beb25mr665048185a.80.1794241763612;
        Mon, 09 Nov 2026 08:29:23 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7915e2sm9102985a.23.2026.11.09.08.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:29:22 -0800 (PST)
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
Subject: [PATCH net-next v18 10/15] quic: add packet number space
Date: Mon,  9 Nov 2026 11:27:31 -0500
Message-ID: <fda017f7e2ebe19deb54aa43d2de4022b6f9ea4c.1794241656.git.lucien.xin@gmail.com>
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

