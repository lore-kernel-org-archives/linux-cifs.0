Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E4306D47
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758235154; cv=none; b=Vi0NdvNdIAmhvZCg5OBVWdXbbS4GX0lhpeDckMBMxgZtOsWGK78wr5zDaj9XYFcaIgCYzNmT7RQic1T5bUUjqL9xuq0M3QnN6xMylPA8Qq9ClzwGJfvVo6RfyfE3KlAhxe94g3H1ExSVojZUt1mRR+/9U2LYL1SVlwUITyueaw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758235154; c=relaxed/simple;
	bh=x/cxauaDFk3Hz9OUhkApbcqw9pjuaz1VgJzYO0ceDBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFMj2H2tzpI4Dm6RbpvPGi1jn6javTymvEPZzQNJcelxSAlEUAe99QC/kzEoUdrYENHAUQo0jSx4E8jMYyy+jInd7zLMhqM2jFgAvyxulMr4NzH61Uv6ckDDj0StsBpNX4OGA6PAMeRb7nlBV+xBwjUo5TvROPfewAXqTwRHWhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqSVsQMc; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqSVsQMc"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-816ac9f9507so252034985a.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 15:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758235150; x=1758839950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ovb3BXbiCLSRRnt9KE5Q+5dq+QnPzPOWGM7f/5+w1E=;
        b=NqSVsQMcbydcvQq0mqxKDwqpwnJxUgeryH057veOnhiiTGkTLm7Q1rtZFc/iDdPKnt
         zmuKErLEYrqVdeeZN9mASvQEMY7TVz7rX0KPWlWK2SsNCsc8hlohirYbXk7vz8cPCnaV
         AefWJgpImA9xXsdsYV67bTbhASk41XjToz7B6nM17UwSVSIvcn5P0rwe77eQR7THGX7I
         W0liXUI7ypYUJbNQ05RfePhFrLgvzUhiePFJOze0RFF27UOPxjadCVnPDSGkdcSXa1y8
         XRSXxzEJb0I5UE2KW+K4fRsURK8v6+MSgEHP374w75RFJPnLmyukU1cj0zLC7TsktEtv
         lYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758235150; x=1758839950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Ovb3BXbiCLSRRnt9KE5Q+5dq+QnPzPOWGM7f/5+w1E=;
        b=hmUTiY2UMkHlgMoD/Zf00xPMwc2I2eWc2J5HlLoky4/sSw9mCN75JP9578DNR7FDD+
         lZ5RgUEzMllkn0CvMWFj9aOdBITCzUCD0eXARxmF0/a9laUyyBXe0yg6PFF57z24dMAO
         BwWRnABCJOfXKKFtOLEuI+azkE3WcnubTWTu6I7l1L3799cGbS+5LR/3JNvjsxUnnNlo
         j8uHM+MduqTy/dcrncsehDb6UriOeapjj1eDUZopS4qg24gjlTS72EAw3ujZsoBevsj0
         Ij1gc8sQVXTxdfgSiJ6Vz89LEdNd0382hnMg66GlU12MdsGEng9WrsXrDmSKX7ipQsD6
         9QRw==
X-Forwarded-Encrypted: i=1; AJvYcCVQw5PUdSB4o16SYQ/v9JRDk5Qndk5VA+5xup+V7LBgAKsP185LVOm5iw0BNtP6Bx8+aOs8A1gQoZaV@vger.kernel.org
X-Gm-Message-State: AOJu0YzXuWUqnC16RfbD0PpMP3lid7VlNQpTkoOXTM38pv2jMzyxh3ld
	tnXxTaq261+0DuVeeDnLLo5b6+2x2u28dd3viPaSkhsNMo+CN4qISxPNw8oxjWE+UfE=
X-Gm-Gg: ASbGncte+0Lf+r9N2IpkEsA2G+v/kef8mrxtvm96PEvdTa9gTQGHLnI/JtckBcwRX7d
	panEZLbF+KgRouaVEYEPWVAL3jsXnPFhB/MMb49Rf8sDGl1G4sOD+AyBg4P3ehBTCyl0s491ERt
	2igkIYWCaCmz4PDNYiIRn0E+whcpFPY3F3AKUnaSA/YIsWI4M9+aGjGrGbkef9ewVmE9jfyHVdO
	G9w/49kuAoB1jGmPykpnLtqb5gp6iU2RJx/3ExpXaXqpJ0MSuNO1py0QTtwfkS0avnjNh2jKS4y
	PqiGSBeo+2ghBJnZM3XXIAN6Vc748YwMU29uLlNZHgnVwNbDiN8sMKcT4rAkn15Ihx+T5Bkf4lE
	eaBB0My6XogGbD0ntE+axPluCwGQEyB8y/ntaCmiaYZhfhMpGTBWvyDuAGgW7BuwiSnPxKhxihf
	UClf5eqg==
X-Google-Smtp-Source: AGHT+IFxn4VJQgf4/p5ua4lFhNRsZB8VGXjrIRRJRwVjJ3O6L7oYkVZKp/XhSRzvdjwIX01bWoNfew==
X-Received: by 2002:a05:620a:318d:b0:828:804a:47f2 with SMTP id af79cd13be357-83b83bfa99dmr168952985a.9.1758235150241;
        Thu, 18 Sep 2025 15:39:10 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83630481fc7sm244631185a.43.2025.09.18.15.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:39:09 -0700 (PDT)
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
Subject: [PATCH net-next v3 03/15] quic: provide common utilities and data structures
Date: Thu, 18 Sep 2025 18:34:52 -0400
Message-ID: <a7fb75136c7c2e51b7081d3bff421e01b435288f.1758234904.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1758234904.git.lucien.xin@gmail.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch provides foundational data structures and utilities used
throughout the QUIC stack.

It introduces packet header types, connection ID support, and address
handling. Hash tables are added to manage socket lookup and connection
ID mapping.

A flexible binary data type is provided, along with helpers for parsing,
matching, and memory management. Helpers for encoding and decoding
transport parameters and frames are also included.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v3:
  - Rework hashtables: split into two types and size them based on
    totalram_pages(), similar to SCTP (reported by Paolo).
  - struct quic_shash_table: use rwlock instead of spinlock.
  - quic_data_from/to_string(): add safety and common-case checks
    (noted by Paolo).
---
 net/quic/Makefile   |   2 +-
 net/quic/common.c   | 594 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/common.h   | 221 ++++++++++++++++
 net/quic/protocol.c |   6 +
 net/quic/socket.c   |   4 +
 net/quic/socket.h   |  21 ++
 6 files changed, 847 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/common.c
 create mode 100644 net/quic/common.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 020e4dd133d8..e0067272de7d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := protocol.o socket.o
+quic-y := common.o protocol.o socket.o
diff --git a/net/quic/common.c b/net/quic/common.c
new file mode 100644
index 000000000000..8f5f2cb4eef2
--- /dev/null
+++ b/net/quic/common.c
@@ -0,0 +1,594 @@
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
+#include "common.h"
+
+#define QUIC_VARINT_1BYTE_MAX		0x3fULL
+#define QUIC_VARINT_2BYTE_MAX		0x3fffULL
+#define QUIC_VARINT_4BYTE_MAX		0x3fffffffULL
+
+#define QUIC_VARINT_2BYTE_PREFIX	0x40
+#define QUIC_VARINT_4BYTE_PREFIX	0x80
+#define QUIC_VARINT_8BYTE_PREFIX	0xc0
+
+#define QUIC_VARINT_LENGTH(p)		BIT((*(p)) >> 6)
+#define QUIC_VARINT_VALUE_MASK		0x3f
+
+struct quic_hashinfo {
+	struct quic_shash_table		shash; /* Source connection ID hashtable */
+	struct quic_shash_table		lhash; /* Listening sock hashtable */
+	struct quic_shash_table		chash; /* Connection sock hashtable */
+	struct quic_uhash_table		uhash; /* UDP sock hashtable */
+};
+
+static struct quic_hashinfo quic_hashinfo;
+
+u32 quic_sock_hash_size(void)
+{
+	return quic_hashinfo.chash.size;
+}
+
+struct quic_shash_head *quic_sock_hash(u32 hash)
+{
+	return &quic_hashinfo.chash.hash[hash];
+}
+
+struct quic_shash_head *quic_sock_head(struct net *net, union quic_addr *s, union quic_addr *d)
+{
+	struct quic_shash_table *ht = &quic_hashinfo.chash;
+
+	return &ht->hash[quic_ahash(net, s, d) & (ht->size - 1)];
+}
+
+u32 quic_listen_sock_hash_size(void)
+{
+	return quic_hashinfo.lhash.size;
+}
+
+struct quic_shash_head *quic_listen_sock_hash(u32 hash)
+{
+	return &quic_hashinfo.lhash.hash[hash];
+}
+
+struct quic_shash_head *quic_listen_sock_head(struct net *net, u16 port)
+{
+	struct quic_shash_table *ht = &quic_hashinfo.lhash;
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *scid)
+{
+	struct quic_shash_table *ht = &quic_hashinfo.shash;
+
+	return &ht->hash[jhash(scid, 4, 0) & (ht->size - 1)];
+}
+
+struct quic_uhash_head *quic_udp_sock_head(struct net *net, u16 port)
+{
+	struct quic_uhash_table *ht = &quic_hashinfo.uhash;
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+struct quic_shash_head *quic_stream_head(struct quic_shash_table *ht, s64 stream_id)
+{
+	return &ht->hash[stream_id & (ht->size - 1)];
+}
+
+static void quic_shash_table_free(struct quic_shash_table *ht)
+{
+	free_pages((unsigned long)ht->hash, get_order(ht->size * sizeof(struct quic_shash_head)));
+	ht->hash = NULL;
+}
+
+static void quic_uhash_table_free(struct quic_uhash_table *ht)
+{
+	free_pages((unsigned long)ht->hash, get_order(ht->size * sizeof(struct quic_uhash_head)));
+	ht->hash = NULL;
+}
+
+void quic_hash_tables_destroy(void)
+{
+	quic_shash_table_free(&quic_hashinfo.shash);
+	quic_shash_table_free(&quic_hashinfo.lhash);
+	quic_shash_table_free(&quic_hashinfo.chash);
+	quic_uhash_table_free(&quic_hashinfo.uhash);
+}
+
+static int quic_shash_table_init(struct quic_shash_table *ht, u32 max_size, int order)
+{
+	int i, max_order, size;
+
+	max_order = get_order(max_size * sizeof(struct quic_shash_head));
+	order = min(order, max_order);
+	/* Try to allocate hash buckets; if fails, retry with smaller order. */
+	do {
+		ht->hash = (struct quic_shash_head *)
+			__get_free_pages(GFP_KERNEL | __GFP_NOWARN, order);
+	} while (!ht->hash && --order > 0);
+
+	if (!ht->hash)
+		return -ENOMEM;
+
+	/* Calculate actual number of buckets from allocated memory. */
+	size = (1UL << order) * PAGE_SIZE / sizeof(struct quic_shash_head);
+	/* Round down to power of two (simplifies masking in hash functions). */
+	ht->size = rounddown_pow_of_two(size);
+	for (i = 0; i < ht->size; i++) {
+		rwlock_init(&ht->hash[i].lock);
+		INIT_HLIST_HEAD(&ht->hash[i].head);
+	}
+	return 0;
+}
+
+static int quic_uhash_table_init(struct quic_uhash_table *ht, u32 max_size, int order)
+{
+	int i, max_order, size;
+
+	/* Same sizing logic as in quic_shash_table_init(). */
+	max_order = get_order(max_size * sizeof(struct quic_uhash_head));
+	order = min(order, max_order);
+	do {
+		ht->hash = (struct quic_uhash_head *)
+			__get_free_pages(GFP_KERNEL | __GFP_NOWARN, order);
+	} while (!ht->hash && --order > 0);
+
+	if (!ht->hash)
+		return -ENOMEM;
+
+	size = (1UL << order) * PAGE_SIZE / sizeof(struct quic_uhash_head);
+	ht->size = rounddown_pow_of_two(size);
+	for (i = 0; i < ht->size; i++) {
+		mutex_init(&ht->hash[i].lock);
+		INIT_HLIST_HEAD(&ht->hash[i].head);
+	}
+	return 0;
+}
+
+int quic_hash_tables_init(void)
+{
+	unsigned long nr_pages = totalram_pages();
+	unsigned long goal;
+	int err, order;
+
+	/* Calculate the hashtable size similar to SCTP in sctp_init(). */
+	if (nr_pages >= (128 * 1024))
+		goal = nr_pages >> (22 - PAGE_SHIFT);
+	else
+		goal = nr_pages >> (24 - PAGE_SHIFT);
+	order = get_order(goal);
+
+	/* Source connection ID table (fast lookup, larger size) */
+	err = quic_shash_table_init(&quic_hashinfo.shash, 64 * 1024, order);
+	if (err)
+		goto err;
+	err = quic_shash_table_init(&quic_hashinfo.lhash, 16 * 1024, order);
+	if (err)
+		goto err;
+	err = quic_shash_table_init(&quic_hashinfo.chash, 16 * 1024, order);
+	if (err)
+		goto err;
+	err = quic_uhash_table_init(&quic_hashinfo.uhash, 16 * 1024, order);
+	if (err)
+		goto err;
+	return 0;
+err:
+	quic_hash_tables_destroy();
+	return err;
+}
+
+union quic_var {
+	u8	u8;
+	__be16	be16;
+	__be32	be32;
+	__be64	be64;
+};
+
+/* Returns the number of bytes required to encode a QUIC variable-length integer. */
+u8 quic_var_len(u64 n)
+{
+	if (n <= QUIC_VARINT_1BYTE_MAX)
+		return 1;
+	if (n <= QUIC_VARINT_2BYTE_MAX)
+		return 2;
+	if (n <= QUIC_VARINT_4BYTE_MAX)
+		return 4;
+	return 8;
+}
+
+/* Decodes a QUIC variable-length integer from a buffer. */
+u8 quic_get_var(u8 **pp, u32 *plen, u64 *val)
+{
+	union quic_var n = {};
+	u8 *p = *pp, len;
+	u64 v = 0;
+
+	if (!*plen)
+		return 0;
+
+	len = QUIC_VARINT_LENGTH(p);
+	if (*plen < len)
+		return 0;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be16_to_cpu(n.be16);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be32_to_cpu(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be64_to_cpu(n.be64);
+		break;
+	default:
+		return 0;
+	}
+
+	*plen -= len;
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+/* Reads a fixed-length integer from the buffer. */
+u32 quic_get_int(u8 **pp, u32 *plen, u64 *val, u32 len)
+{
+	union quic_var n;
+	u8 *p = *pp;
+	u64 v = 0;
+
+	if (*plen < len)
+		return 0;
+	*plen -= len;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		v = be16_to_cpu(n.be16);
+		break;
+	case 3:
+		n.be32 = 0;
+		memcpy(((u8 *)&n.be32) + 1, p, 3);
+		v = be32_to_cpu(n.be32);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		v = be32_to_cpu(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		v = be64_to_cpu(n.be64);
+		break;
+	default:
+		return 0;
+	}
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+u32 quic_get_data(u8 **pp, u32 *plen, u8 *data, u32 len)
+{
+	if (*plen < len)
+		return 0;
+
+	memcpy(data, *pp, len);
+	*pp += len;
+	*plen -= len;
+
+	return len;
+}
+
+/* Encodes a value into the QUIC variable-length integer format. */
+u8 *quic_put_var(u8 *p, u64 num)
+{
+	union quic_var n;
+
+	if (num <= QUIC_VARINT_1BYTE_MAX) {
+		*p++ = (u8)(num & 0xff);
+		return p;
+	}
+	if (num <= QUIC_VARINT_2BYTE_MAX) {
+		n.be16 = cpu_to_be16((u16)num);
+		*((__be16 *)p) = n.be16;
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	}
+	if (num <= QUIC_VARINT_4BYTE_MAX) {
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		*p |= QUIC_VARINT_4BYTE_PREFIX;
+		return p + 4;
+	}
+	n.be64 = cpu_to_be64(num);
+	*((__be64 *)p) = n.be64;
+	*p |= QUIC_VARINT_8BYTE_PREFIX;
+	return p + 8;
+}
+
+/* Writes a fixed-length integer to the buffer in network byte order. */
+u8 *quic_put_int(u8 *p, u64 num, u8 len)
+{
+	union quic_var n;
+
+	switch (len) {
+	case 1:
+		*p++ = (u8)(num & 0xff);
+		return p;
+	case 2:
+		n.be16 = cpu_to_be16((u16)(num & 0xffff));
+		*((__be16 *)p) = n.be16;
+		return p + 2;
+	case 4:
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		return p + 4;
+	default:
+		return NULL;
+	}
+}
+
+/* Encodes a value as a variable-length integer with explicit length. */
+u8 *quic_put_varint(u8 *p, u64 num, u8 len)
+{
+	union quic_var n;
+
+	switch (len) {
+	case 1:
+		*p++ = (u8)(num & 0xff);
+		return p;
+	case 2:
+		n.be16 = cpu_to_be16((u16)(num & 0xffff));
+		*((__be16 *)p) = n.be16;
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	case 4:
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		*p |= QUIC_VARINT_4BYTE_PREFIX;
+		return p + 4;
+	default:
+		return NULL;
+	}
+}
+
+u8 *quic_put_data(u8 *p, u8 *data, u32 len)
+{
+	if (!len)
+		return p;
+
+	memcpy(p, data, len);
+	return p + len;
+}
+
+/* Writes a transport parameter as two varints: ID and value length, followed by value. */
+u8 *quic_put_param(u8 *p, u16 id, u64 value)
+{
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, quic_var_len(value));
+	return quic_put_var(p, value);
+}
+
+/* Reads a QUIC transport parameter value. */
+u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
+{
+	u64 valuelen;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return 0;
+
+	if (*plen < valuelen)
+		return 0;
+
+	if (!quic_get_var(pp, plen, pdest))
+		return 0;
+
+	return (u8)valuelen;
+}
+
+/* rfc9000#section-a.3: DecodePacketNumber()
+ *
+ * Reconstructs the full packet number from a truncated one.
+ */
+s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n)
+{
+	s64 expected = max_pkt_num + 1;
+	s64 win = BIT_ULL(n * 8);
+	s64 hwin = win / 2;
+	s64 mask = win - 1;
+	s64 cand;
+
+	cand = (expected & ~mask) | pkt_num;
+	if (cand <= expected - hwin && cand < (1ULL << 62) - win)
+		return cand + win;
+	if (cand > expected + hwin && cand >= win)
+		return cand - win;
+	return cand;
+}
+
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len)
+{
+	if (!len)
+		return 0;
+
+	data = kmemdup(data, len, GFP_ATOMIC);
+	if (!data)
+		return -ENOMEM;
+
+	kfree(to->data);
+	to->data = data;
+	to->len = len;
+	return 0;
+}
+
+int quic_data_append(struct quic_data *to, u8 *data, u32 len)
+{
+	u8 *p;
+
+	if (!len)
+		return 0;
+
+	p = kzalloc(to->len + len, GFP_ATOMIC);
+	if (!p)
+		return -ENOMEM;
+	p = quic_put_data(p, to->data, to->len);
+	p = quic_put_data(p, data, len);
+
+	kfree(to->data);
+	to->len = to->len + len;
+	to->data = p - to->len;
+	return 0;
+}
+
+/* Check whether 'd2' is equal to any element inside the list 'd1'.
+ *
+ * 'd1' is assumed to be a sequence of length-prefixed elements. Each element
+ * is compared to 'd2' using 'quic_data_cmp()'.
+ *
+ * Returns 1 if a match is found, 0 otherwise.
+ */
+int quic_data_has(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (!quic_data_cmp(&d, d2))
+			return 1;
+	}
+	return 0;
+}
+
+/* Check if any element of 'd1' is present in the list 'd2'.
+ *
+ * Iterates through each element in 'd1', and uses 'quic_data_has()' to check
+ * for its presence in 'd2'.
+ *
+ * Returns 1 if any match is found, 0 otherwise.
+ */
+int quic_data_match(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (quic_data_has(d2, &d))
+			return 1;
+	}
+	return 0;
+}
+
+/* Serialize a list of 'quic_data' elements into a comma-separated string.
+ *
+ * Each element in 'from' is length-prefixed. This function copies their raw
+ * content into the output buffer 'to', inserting commas in between. The
+ * resulting string length is written to '*plen'.
+ */
+int quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from)
+{
+	u32 remlen = *plen;
+	struct quic_data d;
+	u8 *data = to, *p;
+	u64 length;
+	u32 len;
+
+	p = from->data;
+	len = from->len;
+	while (len) {
+		if (!quic_get_int(&p, &len, &length, 1) || len < length)
+			return -EINVAL;
+
+		quic_data(&d, p, length);
+		if (d.len > remlen)
+			return -EOVERFLOW;
+
+		data = quic_put_data(data, d.data, d.len);
+		remlen -= d.len;
+		p += d.len;
+		len -= d.len;
+		if (len) {
+			if (!remlen)
+				return -EOVERFLOW;
+			data = quic_put_int(data, ',', 1);
+			remlen--;
+		}
+	}
+	*plen = data - to;
+	return 0;
+}
+
+/* Parse a comma-separated string into a 'quic_data' list format.
+ *
+ * Each comma-separated token is turned into a length-prefixed element. The
+ * first byte of each element stores the length. Elements are stored in
+ * 'to->data', and 'to->len' is updated.
+ */
+int quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
+{
+	u32 remlen = to->len;
+	struct quic_data d;
+	u8 *p = to->data;
+
+	to->len = 0;
+	while (len) {
+		while (len && *from == ' ') {
+			from++;
+			len--;
+		}
+		if (!len)
+			break;
+		if (!remlen)
+			return -EOVERFLOW;
+		d.data = p++;
+		d.len  = 0;
+		remlen--;
+		while (len) {
+			if (*from == ',') {
+				from++;
+				len--;
+				break;
+			}
+			if (!remlen)
+				return -EOVERFLOW;
+			*p++ = *from++;
+			len--;
+			d.len++;
+			remlen--;
+		}
+		if (d.len > U8_MAX)
+			return -EINVAL;
+		*d.data = (u8)(d.len);
+		to->len += d.len + 1;
+	}
+	return 0;
+}
diff --git a/net/quic/common.h b/net/quic/common.h
new file mode 100644
index 000000000000..6c1c0c3af561
--- /dev/null
+++ b/net/quic/common.h
@@ -0,0 +1,221 @@
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
+#include <net/netns/hash.h>
+#include <linux/jhash.h>
+
+#define QUIC_MAX_ACK_DELAY	(16384 * 1000)
+#define QUIC_DEF_ACK_DELAY	25000
+
+#define QUIC_STREAM_BIT_FIN	0x01
+#define QUIC_STREAM_BIT_LEN	0x02
+#define QUIC_STREAM_BIT_OFF	0x04
+#define QUIC_STREAM_BIT_MASK	0x08
+
+#define QUIC_CONN_ID_MAX_LEN	20
+#define QUIC_CONN_ID_DEF_LEN	8
+
+struct quic_conn_id {
+	u8 data[QUIC_CONN_ID_MAX_LEN];
+	u8 len;
+};
+
+static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data, u32 len)
+{
+	memcpy(conn_id->data, data, len);
+	conn_id->len = (u8)len;
+}
+
+struct quic_skb_cb {
+	/* Callback when encryption/decryption completes in async mode */
+	void (*crypto_done)(struct sk_buff *skb, int err);
+	union {
+		struct sk_buff *last;		/* Last packet in TX bundle */
+		s64 seqno;			/* Dest connection ID number on RX */
+	};
+	s64 number_max;		/* Largest packet number seen before parsing this one */
+	s64 number;		/* Parsed packet number */
+	u16 errcode;		/* Error code if encryption/decryption fails */
+	u16 length;		/* Payload length + packet number length */
+	u32 time;		/* Arrival time in UDP tunnel */
+
+	u16 number_offset;	/* Offset of packet number field */
+	u16 udph_offset;	/* Offset of UDP header */
+	u8 number_len;		/* Length of the packet number field */
+	u8 level;		/* Encryption level: Initial, Handshake, App, or Early */
+
+	u8 key_update:1;	/* Key update triggered by this packet */
+	u8 key_phase:1;		/* Key phase used (0 or 1) */
+	u8 backlog:1;		/* Enqueued into backlog list */
+	u8 resume:1;		/* Crypto already processed (encrypted or decrypted) */
+	u8 path:1;		/* Packet arrived from a new or migrating path */
+	u8 ecn:2;		/* ECN marking used on TX */
+};
+
+#define QUIC_SKB_CB(skb)	((struct quic_skb_cb *)&((skb)->cb[0]))
+
+static inline struct udphdr *quic_udphdr(const struct sk_buff *skb)
+{
+	return (struct udphdr *)(skb->head + QUIC_SKB_CB(skb)->udph_offset);
+}
+
+struct quichdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     key:1,
+	     reserved:2,
+	     spin:1,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     spin:1,
+	     reserved:2,
+	     key:1,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichdr *quic_hdr(struct sk_buff *skb)
+{
+	return (struct quichdr *)skb_transport_header(skb);
+}
+
+struct quichshdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     reserved:2,
+	     type:2,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     type:2,
+	     reserved:2,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichshdr *quic_hshdr(struct sk_buff *skb)
+{
+	return (struct quichshdr *)skb_transport_header(skb);
+}
+
+union quic_addr {
+	struct sockaddr_in6 v6;
+	struct sockaddr_in v4;
+	struct sockaddr sa;
+};
+
+static inline union quic_addr *quic_addr(const void *addr)
+{
+	return (union quic_addr *)addr;
+}
+
+struct quic_shash_head {
+	struct hlist_head	head;
+	rwlock_t		lock;	/* Protects 'head' in atomic context */
+};
+
+struct quic_shash_table {
+	struct quic_shash_head *hash;
+	u32 size;
+};
+
+struct quic_uhash_head {
+	struct hlist_head	head;
+	struct mutex		lock;	/* Protects 'head' in process context */
+};
+
+struct quic_uhash_table {
+	struct quic_uhash_head *hash;
+	u32 size;
+};
+
+static inline u32 quic_shash(const struct net *net, const union quic_addr *a)
+{
+	u32 addr = (a->sa.sa_family == AF_INET6) ? jhash(&a->v6.sin6_addr, 16, 0)
+						 : (__force u32)a->v4.sin_addr.s_addr;
+
+	return  jhash_3words(addr, (__force u32)a->v4.sin_port, net_hash_mix(net), 0);
+}
+
+static inline u32 quic_ahash(const struct net *net, const union quic_addr *s,
+			     const union quic_addr *d)
+{
+	u32 ports = ((__force u32)s->v4.sin_port) << 16 | (__force u32)d->v4.sin_port;
+	u32 saddr = (s->sa.sa_family == AF_INET6) ? jhash(&s->v6.sin6_addr, 16, 0)
+						  : (__force u32)s->v4.sin_addr.s_addr;
+	u32 daddr = (d->sa.sa_family == AF_INET6) ? jhash(&d->v6.sin6_addr, 16, 0)
+						  : (__force u32)d->v4.sin_addr.s_addr;
+
+	return  jhash_3words(saddr, ports, net_hash_mix(net), daddr);
+}
+
+struct quic_data {
+	u8 *data;
+	u32 len;
+};
+
+static inline struct quic_data *quic_data(struct quic_data *d, u8 *data, u32 len)
+{
+	d->data = data;
+	d->len  = len;
+	return d;
+}
+
+static inline int quic_data_cmp(struct quic_data *d1, struct quic_data *d2)
+{
+	return d1->len != d2->len || memcmp(d1->data, d2->data, d1->len);
+}
+
+static inline void quic_data_free(struct quic_data *d)
+{
+	kfree(d->data);
+	d->data = NULL;
+	d->len = 0;
+}
+
+struct quic_shash_head *quic_sock_head(struct net *net, union quic_addr *s, union quic_addr *d);
+struct quic_shash_head *quic_listen_sock_head(struct net *net, u16 port);
+struct quic_shash_head *quic_stream_head(struct quic_shash_table *ht, s64 stream_id);
+struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *scid);
+struct quic_uhash_head *quic_udp_sock_head(struct net *net, u16 port);
+
+struct quic_shash_head *quic_listen_sock_hash(u32 hash);
+struct quic_shash_head *quic_sock_hash(u32 hash);
+u32 quic_listen_sock_hash_size(void);
+u32 quic_sock_hash_size(void);
+
+void quic_hash_tables_destroy(void);
+int quic_hash_tables_init(void);
+
+u32 quic_get_data(u8 **pp, u32 *plen, u8 *data, u32 len);
+u32 quic_get_int(u8 **pp, u32 *plen, u64 *val, u32 len);
+s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n);
+u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen);
+u8 quic_get_var(u8 **pp, u32 *plen, u64 *val);
+u8 quic_var_len(u64 n);
+
+u8 *quic_put_param(u8 *p, u16 id, u64 value);
+u8 *quic_put_data(u8 *p, u8 *data, u32 len);
+u8 *quic_put_varint(u8 *p, u64 num, u8 len);
+u8 *quic_put_int(u8 *p, u64 num, u8 len);
+u8 *quic_put_var(u8 *p, u64 num);
+
+int quic_data_from_string(struct quic_data *to, u8 *from, u32 len);
+int quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from);
+
+int quic_data_match(struct quic_data *d1, struct quic_data *d2);
+int quic_data_append(struct quic_data *to, u8 *data, u32 len);
+int quic_data_has(struct quic_data *d1, struct quic_data *d2);
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index f79f43f0c17f..b54532916aa2 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -336,6 +336,9 @@ static __init int quic_init(void)
 	if (err)
 		goto err_percpu_counter;
 
+	if (quic_hash_tables_init())
+		goto err_hash;
+
 	err = register_pernet_subsys(&quic_net_ops);
 	if (err)
 		goto err_def_ops;
@@ -353,6 +356,8 @@ static __init int quic_init(void)
 err_protosw:
 	unregister_pernet_subsys(&quic_net_ops);
 err_def_ops:
+	quic_hash_tables_destroy();
+err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
 err_percpu_counter:
 	return err;
@@ -365,6 +370,7 @@ static __exit void quic_exit(void)
 #endif
 	quic_protosw_exit();
 	unregister_pernet_subsys(&quic_net_ops);
+	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
 	pr_info("quic: exit\n");
 }
diff --git a/net/quic/socket.c b/net/quic/socket.c
index f189cf25ada8..abec673812f7 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -52,6 +52,10 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_data_free(quic_ticket(sk));
+	quic_data_free(quic_token(sk));
+	quic_data_free(quic_alpn(sk));
+
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 }
diff --git a/net/quic/socket.h b/net/quic/socket.h
index ded8eb2e6a9c..6cbf12bcae75 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -10,6 +10,8 @@
 
 #include <net/udp_tunnel.h>
 
+#include "common.h"
+
 #include "protocol.h"
 
 extern struct proto quic_prot;
@@ -25,6 +27,10 @@ enum quic_state {
 struct quic_sock {
 	struct inet_sock		inet;
 	struct list_head		reqs;
+
+	struct quic_data		ticket;
+	struct quic_data		token;
+	struct quic_data		alpn;
 };
 
 struct quic6_sock {
@@ -42,6 +48,21 @@ static inline struct list_head *quic_reqs(const struct sock *sk)
 	return &quic_sk(sk)->reqs;
 }
 
+static inline struct quic_data *quic_token(const struct sock *sk)
+{
+	return &quic_sk(sk)->token;
+}
+
+static inline struct quic_data *quic_ticket(const struct sock *sk)
+{
+	return &quic_sk(sk)->ticket;
+}
+
+static inline struct quic_data *quic_alpn(const struct sock *sk)
+{
+	return &quic_sk(sk)->alpn;
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

