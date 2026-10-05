Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80ED4908A6
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227132; cv=none; b=idOmoXvKt+KSDUkCZsMO/SdYNw9RLXAl6sVFVMQI31r8y+T/aqxAXFZ5vq02s/TEAKo71Wd8g5omAavCOqP63Whj0IDPMLFG9CNWfqLG78hARaXJ++ShdJ7WnqQrjOtZNqqX9uKYXMMrKmuNgFQhNwb4/cpIfT4aCqG8NFzQ7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227132; c=relaxed/simple;
	bh=q6ylk+7Z1hNUhO4DZt/9O8op67Obk0FFd0aVz2dllXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jkoYwiULhQKlsBqfkQS624JY4/X+RA+ZocqiHI4QIyBA631Q1qjHbBqCbAqy3VeNYr1YAc60f4gKdo6u/uQybkQe+5WIEzt5mCA0ULaFeuGSoQ6kwJI53Mv16t3cUYW6mEb1rD6Au7mtvSAsMmxVO2YapgSw5x0MbxvvvE3f4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hg3zCfKw; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hg3zCfKw"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93c5818c4a4so158056285a.3
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791227129; x=1791831929; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KByenGI3jNALFFCDM3XPGGsjTq3ziVvTDgE9P+qsH+0=;
        b=hg3zCfKwDwt5Sj2Is6o0VrtvZmmcya6I/7ln5zsGmH/IDGVCbDNAAQcGpYLBRowIzi
         uKWMENUzl+HxQmCZvxZAU6BNqSI3pDzoZ9Xlr2Dg3AcFn7Adp/cZm5YvgqCcdTksYvg7
         B2ebsD/u04w+/+DDHk9xaO9MZAyAaVlLa9JgNg5+KB0HGQWCr9Qr1iwvZmN7+CcjaOzO
         5d0ZfImhKKHOVcqNEyfNdtyTooqY4GJzhSbyDkbF4S1K1VPlToruJuDDokranfXx9auC
         EhqbkUM2JKUbl4uKDlGxCfOB3LI7ZVwVKm5u/DF8AdZzARh2cyb0XjnBmcwMeP/I+XLy
         fobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791227129; x=1791831929;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KByenGI3jNALFFCDM3XPGGsjTq3ziVvTDgE9P+qsH+0=;
        b=glTWDOuNU9ERTvL712MDcbCF5JWowmnorpPk49jSVQOOGL7uL+u/0nLzzltUAkQBAd
         1g4rC8EBLz5Zmx8IDv5WvjRTa2M4gwT3z/8qItywowVRHIC91hx4rqpnwrueNGB2W9d0
         FKyol51UWAQ7wSgFQ0AA/7jlyg/7Oq5kHyUiSOOnH0Rb44CljTGMRzGg5zAMEK23T3Vl
         m8HYMxhSAud9xE2qsoPuYdRa8MsmMSJZHoD6UxUhjDTsWxjUR28krK2T4s8I19A2vucG
         lVSGpS8ImkqdTod5uUCVJtCf67icLjMbat6qI7FlBz9qtmLbYa+m3fomFNqF0GQ7oSrq
         Jflw==
X-Forwarded-Encrypted: i=1; AKwUvBw+iF8f4cpczjzbM5TD2+TqVYdeatepuiaQ5fIiySGG2d34ADu4TjVugGBcpamp7VIIzgRQE5p95zWl@vger.kernel.org
X-Gm-Message-State: AFuF++l4NTJpoNyJ/l9bpR6jVyKX5XYJ9EKY80WjMnRyrVSvKa6PHJXp
	arV8JjrjdbBF96qOoVu1Ce9OGMFidmMfjl6wFhUbXoroH8kwIf+rMsA4
X-Gm-Gg: AYBFou1tIijDX3kOKyulcroCE6fhasByrPOfzEz/zsAasB6BbQkREib7gwErr2+esDd
	S5TMbZJ3QyRjoTMs3h2knNpfKoaC+ur2IYg3N/XVbVTvbZKyyRjLgSj3O4JTVJ/upZskW+vwzqL
	ACxWyQeaTeI6a5croywcLuvblTsaR0DIICsm9X3HUY03KIBjIESl0IVB2aD3i4VWboyA9vcVDxi
	knxTDuFJqkkMJkt7LCNPvKFxzAQ9zrvMKIhUza00Ho40HSEALMjsQotaDJcisng7R9jkNm//Slu
	xPsonTtfADNHu8B3NtT3EUZUcztVs3+lqvw2OdZ37QlIGCZ4wJn3IxoJeEKAKHoBd12wpwAFEn0
	cwXcgngA7/kN0wFEiRikOiQFIJRieIIRadOzrZKiuh7PLO3PBH1oIiOqWd04eYSbYrAf6TTx/cu
	hutAfx9qFl7W6VkVhx/qNhRTujLrFXS/SYMyV6r6Y4XJZT0PGbIRSIyj1dfqk8tGpDtRjZD3xpF
	zRf1nFbNb1XF1LXkffhTyr8L6RjHQKge4W5LxmbnAwBGwOuA6I2FNb3CkbqVMhO6p2cZvaFLDAN
	umlJsGWORfS+MpIOtZKEe2awHc2t1wu5robcLhX/mzBBfCw43Q==
X-Received: by 2002:a05:620a:1a07:b0:93e:66e6:fa8 with SMTP id af79cd13be357-93e66e61029mr845948985a.20.1791227128341;
        Mon, 05 Oct 2026 12:05:28 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca263708sm927117785a.31.2026.10.05.12.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 12:05:27 -0700 (PDT)
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
Subject: [PATCH net-next v16 03/15] quic: provide common utilities and data structures
Date: Mon,  5 Oct 2026 15:03:58 -0400
Message-ID: <d70443b48ee6fb4364d692d7faed990d606a1f0f.1791227050.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1791227050.git.lucien.xin@gmail.com>
References: <cover.1791227050.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the concern about quic_put_int() handling a length of 3.
    Although quic_get_int() supports 3-byte integers, quic_put_int() is
    only used with the fixed integer lengths supported by its callers. A
    length of 3 is never passed to quic_put_int() in the later code, so
    the default case cannot be reached through any of its intended uses.

  - Ignore the concern about quic_put_varint() handling a length of 8.
    While QUIC variable-length integers support an 8-byte encoding, the
    later code only calls quic_put_varint() with lengths of 1, 2, or 4.
    A length of 8 is never passed by any caller, so no 8-byte case is
    required here.

  - Ignore the concern about quic_hash_tables_destroy() being
    non-idempotent.  The function is only called once in the QUIC module's
    lifecycle, and the later initialization and teardown paths ensure that
    it cannot be invoked more than once. Therefore, clearing the .hash
    pointers after vfree() is not necessary.

  - Ignore the concern about zero-length transport parameters in
    quic_get_param(). Although QUIC allows transport parameters with a
    zero-length value, this helper is only used later for parameters that
    carry a value. Zero-length parameters are handled separately and never
    passed to quic_get_param(), so the current parsing and return
    convention is sufficient for all its callers.

  - Ignore the concern about the inner IPv6 and connection-ID hashes being
    unseeded. The per-netns net_hash_mix(net) is already used as the seed
    of the final jhash_3words()/jhash_2words() call, so the resulting
    bucket selection is still randomized per network namespace. Therefore,
    seeding the intermediate jhash() calls is not necessary.

  - Ignore the concern about quic_get_param() leaving the cursor advanced
    on failure. Failures while parsing transport parameters are treated as
    fatal by all callers added in the next patchset, so the caller does not
    continue parsing from the partially advanced cursor. Therefore,
    restoring *pp and *plen on failure is not necessary.

v3:
  - Rework hashtables: split into two types and size them based on
    totalram_pages(), similar to SCTP (reported by Paolo).
  - struct quic_shash_table: use rwlock instead of spinlock.
  - quic_data_from/to_string(): add safety and common-case checks
    (noted by Paolo).
v4:
  - Handle the error returned by quic_hash_tables_init() properly
    (reported by Simon).
  - Use vmalloc() to simplify hashtable allocations (suggested by Paolo).
  - Replace rwlock_t with spinlock_t and use hlist_nulls_head in
    quic_shash_head for lockless lookup/access (suggested by Paolo).
  - Define QUIC_PN_BITS to replace a magical number in quic_get_num()
    (reported by Paolo)
  - Rename several hash-related functions:
    * quic_(listen_)sock_hash() → quic_(listen_)sock_head()
    * quic_(listen_)sock_head() → quic_(listen_)sock_hash()
    * quic_shash() → quic_addr_hash()
    * quic_ahash() → call its code directly in quic_sock_hash().
  - Include net in the hash calculations in quic_listen_sock_hash() and
    quic_udp_sock_head(), and include len in quic_source_conn_id_head().
v5:
  - Use u64 for skb_cb->time and u32 for skb_cb->seqno, and introduce
    quic_ktime_get_us() to obtain timestamps in microseconds.
  - Remove skb_cb->number_max and reuse number as the largest previously
    seen, and add skb_cb->crypto_ctx for async crypto context freeing.
  - Add case 8 to quic_put_int(), which will be used to pack a u64
    timestamp into the token in a later patch.
v6:
  - Since transport_header is no longer set for QUIC, use skb->data
    instead in quic_hdr() and quic_hshdr(). As the UDP header can now
    be accessed via udp_hdr(), drop udph_offset from struct quic_skb_cb.
  - Note for AI reviews: although ticket/token/alpn are not initialized
    in quic_init_sock(), it is safe to kfree() them in quic_destroy_sock()
    because they are always set to NULL (via sk_alloc() in inet/6_create()
    or memset(0) in quic_accept() in a later patchset).
v7:
  - Add the missing check len < length in quic_data_has/match() (reported
    by AI review).
v9:
  - Add BUILD_BUG_ON() to check size of struct quic_skb_cb in quic_init()
    (suggested by Paolo).
v10:
  - Add a comment to quic_conn_id_update() to clarify that the caller is
    responsible for ensuring the connection ID length does not
    exceed QUIC_CONN_ID_MAX_LEN.
  - Ensure quic_get_param() validates that the decoded parameter value
    consumes exactly the expected valuelen in quic_get_param() (noted by
    AI review).
  - Replace manual memcpy() + endian conversion and temporary union usage
    with get_unaligned_beNN() and put_unaligned_beNN() helpers for reading
    and writing integers in network byte order.
  - Replace vmalloc(size * sizeof(type)) with vmalloc_array() in hash
    table allocations.
  - Move *plen update to after successful parse in quic_get_int().
v11:
  - Set maximum line length to 80 characters.
  - Change return type of quic_data_match() and quic_data_has() to bool.
  - Add a check for len in quic_conn_id_update().
  - Avoid roundup_pow_of_two(0) in quic_hash_tables_init().
v12:
  - Move QUIC_VARINT_nBYTE_MAX definitions to common.h for later use.
  - Add sync field to struct quic_skb_cb to support forcing synchronous
    crypto processing for specific packets late.
v14:
  - Pass gfp flags through quic_data_append() and quic_data_dup().
  - Add an overflow check to quic_data_append(), even though current
    callers cannot trigger it.
  - Call quic_data_free() when len is zero in quic_data_dup().
  - Change the 'limit' type in quic_hash_tables_init() from u32 to
    unsigned long.
  - Use net_hash_mix(net) as the initval argument to jhash_Nwords().
v16:
  - Add crypto_err to struct quic_skb_cb, as a union with crypto_ctx, to
    preserve errors from asynchronous crypto operations. It will be used
    to implement AEAD usage limits in a later patch.
  - Remove the err parameter from .crypto_done() in struct quic_skb_cb, as
    errors from asynchronous crypto operations are now preserved in
    skb->cb.
  - Improve common.c file description.
  - Check each data length before copying to avoid partially writing
    oversized tokens before returning -EINVAL in quic_data_from_string().
---
 net/quic/Makefile   |   2 +-
 net/quic/common.c   | 565 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/common.h   | 220 +++++++++++++++++
 net/quic/protocol.c |  10 +
 net/quic/socket.c   |   4 +
 net/quic/socket.h   |  21 ++
 6 files changed, 821 insertions(+), 1 deletion(-)
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
index 000000000000..8114be4fbb1e
--- /dev/null
+++ b/net/quic/common.c
@@ -0,0 +1,565 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Common data structures and utility functions.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/unaligned.h>
+#include <net/netns/hash.h>
+#include <linux/vmalloc.h>
+#include <linux/jhash.h>
+
+#include "common.h"
+
+#define QUIC_VARINT_2BYTE_PREFIX	0x40
+#define QUIC_VARINT_4BYTE_PREFIX	0x80
+#define QUIC_VARINT_8BYTE_PREFIX	0xc0
+
+#define QUIC_VARINT_LENGTH(p)		BIT((*(p)) >> 6)
+
+struct quic_hashinfo {
+	struct quic_shash_table shash; /* Source connection ID hashtable */
+	struct quic_shash_table lhash; /* Listening sock hashtable */
+	struct quic_shash_table chash; /* Connection sock hashtable */
+	struct quic_uhash_table uhash; /* UDP sock hashtable */
+};
+
+static struct quic_hashinfo quic_hashinfo;
+
+u32 quic_sock_hash_size(void)
+{
+	return quic_hashinfo.chash.size;
+}
+
+u32 quic_sock_hash(struct net *net, union quic_addr *s, union quic_addr *d)
+{
+	u32 ports = ((__force u32)s->v4.sin_port) << 16 |
+		    (__force u32)d->v4.sin_port;
+	u32 saddr = (s->sa.sa_family == AF_INET6) ?
+		    jhash(&s->v6.sin6_addr, 16, 0) :
+		    (__force u32)s->v4.sin_addr.s_addr;
+	u32 daddr = (d->sa.sa_family == AF_INET6) ?
+		    jhash(&d->v6.sin6_addr, 16, 0) :
+		    (__force u32)d->v4.sin_addr.s_addr;
+	u32 hash = jhash_3words(saddr, daddr, ports, net_hash_mix(net));
+
+	return hash & (quic_sock_hash_size() - 1);
+}
+
+struct quic_shash_head *quic_sock_head(u32 hash)
+{
+	return &quic_hashinfo.chash.hash[hash];
+}
+
+u32 quic_listen_sock_hash_size(void)
+{
+	return quic_hashinfo.lhash.size;
+}
+
+u32 quic_listen_sock_hash(struct net *net, u16 port)
+{
+	u32 hash = jhash_1word((__force u32)port, net_hash_mix(net));
+
+	return hash & (quic_listen_sock_hash_size() - 1);
+}
+
+struct quic_shash_head *quic_listen_sock_head(u32 hash)
+{
+	return &quic_hashinfo.lhash.hash[hash];
+}
+
+struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *scid,
+						 u32 len)
+{
+	u32 hash = jhash_1word(jhash(scid, len, 0), net_hash_mix(net));
+	struct quic_shash_table *ht = &quic_hashinfo.shash;
+
+	return &ht->hash[hash & (ht->size - 1)];
+}
+
+struct quic_uhash_head *quic_udp_sock_head(struct net *net, u16 port)
+{
+	u32 hash = jhash_1word((__force u32)port, net_hash_mix(net));
+	struct quic_uhash_table *ht = &quic_hashinfo.uhash;
+
+	return &ht->hash[hash & (ht->size - 1)];
+}
+
+u32 quic_addr_hash(struct net *net, union quic_addr *a)
+{
+	u32 addr = (a->sa.sa_family == AF_INET6) ?
+		   jhash(&a->v6.sin6_addr, 16, 0) :
+		   (__force u32)a->v4.sin_addr.s_addr;
+
+	return jhash_2words(addr, (__force u32)a->v4.sin_port,
+			    net_hash_mix(net));
+}
+
+void quic_hash_tables_destroy(void)
+{
+	vfree(quic_hashinfo.shash.hash);
+	vfree(quic_hashinfo.lhash.hash);
+	vfree(quic_hashinfo.chash.hash);
+	vfree(quic_hashinfo.uhash.hash);
+}
+
+static int quic_shash_table_init(struct quic_shash_table *ht, u32 size)
+{
+	int i;
+
+	ht->hash = vmalloc_array(size, sizeof(struct quic_shash_head));
+	if (!ht->hash)
+		return -ENOMEM;
+
+	ht->size = size;
+	for (i = 0; i < ht->size; i++) {
+		spin_lock_init(&ht->hash[i].lock);
+		INIT_HLIST_NULLS_HEAD(&ht->hash[i].head, i);
+	}
+	return 0;
+}
+
+static int quic_uhash_table_init(struct quic_uhash_table *ht, u32 size)
+{
+	int i;
+
+	ht->hash = vmalloc_array(size, sizeof(struct quic_uhash_head));
+	if (!ht->hash)
+		return -ENOMEM;
+
+	ht->size = size;
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
+	unsigned long limit;
+	u32 size;
+	int err;
+
+	/* Scale hash table size based on system memory, similar to SCTP. */
+	if (nr_pages >= (128 * 1024))
+		limit = nr_pages >> (22 - PAGE_SHIFT);
+	else
+		limit = nr_pages >> (24 - PAGE_SHIFT);
+
+	limit = roundup_pow_of_two(limit ?: 1);
+
+	/* Source connection ID table (fast lookup, larger size) */
+	size = min_t(unsigned long, limit, 64 * 1024UL);
+	err = quic_shash_table_init(&quic_hashinfo.shash, size);
+	if (err)
+		goto err;
+	size = min_t(unsigned long, limit, 16 * 1024UL);
+	err = quic_shash_table_init(&quic_hashinfo.lhash, size);
+	if (err)
+		goto err;
+	err = quic_shash_table_init(&quic_hashinfo.chash, size);
+	if (err)
+		goto err;
+	err = quic_uhash_table_init(&quic_hashinfo.uhash, size);
+	if (err)
+		goto err;
+	return 0;
+err:
+	quic_hash_tables_destroy();
+	return err;
+}
+
+/* Returns the number of bytes required to encode a QUIC variable-length
+ * integer.
+ */
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
+		v = get_unaligned_be16(p) & QUIC_VARINT_2BYTE_MAX;
+		break;
+	case 4:
+		v = get_unaligned_be32(p) & QUIC_VARINT_4BYTE_MAX;
+		break;
+	case 8:
+		v = get_unaligned_be64(p) & QUIC_VARINT_8BYTE_MAX;
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
+	u8 *p = *pp;
+	u64 v = 0;
+
+	if (*plen < len)
+		return 0;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		v = get_unaligned_be16(p);
+		break;
+	case 3:
+		v = get_unaligned_be24(p);
+		break;
+	case 4:
+		v = get_unaligned_be32(p);
+		break;
+	case 8:
+		v = get_unaligned_be64(p);
+		break;
+	default:
+		return 0;
+	}
+	*plen -= len;
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
+	if (num <= QUIC_VARINT_1BYTE_MAX) {
+		*p++ = (u8)num;
+		return p;
+	}
+	if (num <= QUIC_VARINT_2BYTE_MAX) {
+		put_unaligned_be16((u16)num, p);
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	}
+	if (num <= QUIC_VARINT_4BYTE_MAX) {
+		put_unaligned_be32((u32)num, p);
+		*p |= QUIC_VARINT_4BYTE_PREFIX;
+		return p + 4;
+	}
+	put_unaligned_be64(num, p);
+	*p |= QUIC_VARINT_8BYTE_PREFIX;
+	return p + 8;
+}
+
+/* Writes a fixed-length integer to the buffer in network byte order. */
+u8 *quic_put_int(u8 *p, u64 num, u8 len)
+{
+	switch (len) {
+	case 1:
+		*p++ = (u8)num;
+		return p;
+	case 2:
+		put_unaligned_be16((u16)num, p);
+		return p + 2;
+	case 4:
+		put_unaligned_be32((u32)num, p);
+		return p + 4;
+	case 8:
+		put_unaligned_be64(num, p);
+		return p + 8;
+	default:
+		return NULL;
+	}
+}
+
+/* Encodes a value as a variable-length integer with explicit length. */
+u8 *quic_put_varint(u8 *p, u64 num, u8 len)
+{
+	switch (len) {
+	case 1:
+		*p++ = (u8)num;
+		return p;
+	case 2:
+		put_unaligned_be16((u16)num, p);
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	case 4:
+		put_unaligned_be32((u32)num, p);
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
+/* Writes a transport parameter as two varints: ID and value length, followed
+ * by value.
+ */
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
+	if (quic_get_var(pp, plen, pdest) != valuelen)
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
+	if (cand <= expected - hwin && cand < BIT_ULL(QUIC_PN_BITS) - win)
+		return cand + win;
+	if (cand > expected + hwin && cand >= win)
+		return cand - win;
+	return cand;
+}
+
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len, gfp_t gfp)
+{
+	if (!len) {
+		quic_data_free(to);
+		return 0;
+	}
+
+	data = kmemdup(data, len, gfp);
+	if (!data)
+		return -ENOMEM;
+
+	kfree(to->data);
+	to->data = data;
+	to->len = len;
+	return 0;
+}
+
+int quic_data_append(struct quic_data *to, u8 *data, u32 len, gfp_t gfp)
+{
+	u8 *p;
+
+	if (!len)
+		return 0;
+
+	if (to->len > U32_MAX - len)
+		return -EOVERFLOW;
+
+	p = kmalloc(to->len + len, gfp);
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
+ * Returns true if a match is found, false otherwise.
+ */
+bool quic_data_has(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		if (!quic_get_int(&p, &len, &length, 1) || len < length)
+			return false;
+		quic_data(&d, p, length);
+		if (!quic_data_cmp(&d, d2))
+			return true;
+	}
+	return false;
+}
+
+/* Check if any element of 'd1' is present in the list 'd2'.
+ *
+ * Iterates through each element in 'd1', and uses 'quic_data_has()' to check
+ * for its presence in 'd2'.
+ *
+ * Returns true if any match is found, false otherwise.
+ */
+bool quic_data_match(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		if (!quic_get_int(&p, &len, &length, 1) || len < length)
+			return false;
+		quic_data(&d, p, length);
+		if (quic_data_has(d2, &d))
+			return true;
+	}
+	return false;
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
+			if (d.len == U8_MAX)
+				return -EINVAL;
+			*p++ = *from++;
+			len--;
+			d.len++;
+			remlen--;
+		}
+		*d.data = (u8)(d.len);
+		to->len += d.len + 1;
+	}
+	return 0;
+}
diff --git a/net/quic/common.h b/net/quic/common.h
new file mode 100644
index 000000000000..8e13ddda2cf6
--- /dev/null
+++ b/net/quic/common.h
@@ -0,0 +1,220 @@
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
+#include <net/net_namespace.h>
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
+#define QUIC_PN_MAX_LEN		4 /* For encoded packet number */
+#define QUIC_PN_BITS		62
+#define QUIC_PN_MAX		(BIT_ULL(QUIC_PN_BITS) - 1)
+
+#define QUIC_VARINT_1BYTE_MAX		0x3fULL
+#define QUIC_VARINT_2BYTE_MAX		0x3fffULL
+#define QUIC_VARINT_4BYTE_MAX		0x3fffffffULL
+#define QUIC_VARINT_8BYTE_MAX		0x3fffffffffffffffULL
+
+struct quic_conn_id {
+	u8 data[QUIC_CONN_ID_MAX_LEN];
+	u8 len;
+};
+
+static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data,
+				       u32 len)
+{
+	/* The caller must ensure len does not exceed QUIC_CONN_ID_MAX_LEN. */
+	if (WARN_ON_ONCE(len > QUIC_CONN_ID_MAX_LEN))
+		return;
+	memcpy(conn_id->data, data, len);
+	conn_id->len = (u8)len;
+}
+
+struct quic_skb_cb {
+	void (*crypto_done)(struct sk_buff *skb); /* Async crypto callback */
+	union { /* Async context before completion, error after completion */
+		void *crypto_ctx;
+		int crypto_err;
+	};
+	union {
+		struct sk_buff *last; /* Last packet in bundle on TX */
+		u64 time; /* Arrival timestamp in UDP tunnel on RX */
+	};
+	s64 number;  /* Parsed packet number, or the largest previously seen */
+	u32 seqno;   /* Dest connection ID number on RX */
+	u16 length;  /* Payload length + packet number length */
+
+	u16 number_offset; /* Offset of packet number field */
+	u8 number_len;     /* Length of the packet number field */
+	u8 level; /* Encryption level: Initial, Handshake, App, or Early */
+
+	u16 errcode;     /* Error code on packet processing failure */
+	u8 errframe;     /* Frame type causing packet processing failure */
+
+	u8 key_update:1; /* Key update triggered by this packet */
+	u8 key_phase:1;  /* Key phase used (0 or 1) */
+	u8 backlog:1;    /* Enqueued into backlog list */
+	u8 resume:1;     /* Crypto already processed (encrypted or decrypted) */
+	u8 path:1;       /* Packet arrived from a new or migrating path */
+	u8 sync:1;       /* Force synchronous crypto (process context only) */
+	u8 ecn:2;        /* ECN marking used on TX */
+};
+
+#define QUIC_SKB_CB(skb)	((struct quic_skb_cb *)&((skb)->cb[0]))
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
+	return (struct quichdr *)skb->data;
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
+	return (struct quichshdr *)skb->data;
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
+	struct hlist_nulls_head	head;
+	spinlock_t		lock; /* Protects 'head' in atomic context */
+};
+
+struct quic_shash_table {
+	struct quic_shash_head *hash;
+	u32 size;
+};
+
+struct quic_uhash_head {
+	struct hlist_head	head;
+	struct mutex		lock; /* Protects 'head' in process context */
+};
+
+struct quic_uhash_table {
+	struct quic_uhash_head *hash;
+	u32 size;
+};
+
+struct quic_data {
+	u8 *data;
+	u32 len;
+};
+
+static inline struct quic_data *quic_data(struct quic_data *d, u8 *data,
+					  u32 len)
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
+static inline u64 quic_ktime_get_us(void)
+{
+	return ktime_to_us(ktime_get());
+}
+
+u32 quic_sock_hash(struct net *net, union quic_addr *s, union quic_addr *d);
+struct quic_shash_head *quic_sock_head(u32 hash);
+u32 quic_sock_hash_size(void);
+
+u32 quic_listen_sock_hash(struct net *net, u16 port);
+struct quic_shash_head *quic_listen_sock_head(u32 hash);
+u32 quic_listen_sock_hash_size(void);
+
+struct quic_shash_head *quic_source_conn_id_head(struct net *net, u8 *scid,
+						 u32 len);
+struct quic_uhash_head *quic_udp_sock_head(struct net *net, u16 port);
+u32 quic_addr_hash(struct net *net, union quic_addr *a);
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
+int quic_data_append(struct quic_data *to, u8 *data, u32 len, gfp_t gfp);
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len, gfp_t gfp);
+bool quic_data_match(struct quic_data *d1, struct quic_data *d2);
+bool quic_data_has(struct quic_data *d1, struct quic_data *d2);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 91db48e79c2c..450da877c121 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -311,6 +311,9 @@ static __init int quic_init(void)
 	int max_share, err = -ENOMEM;
 	unsigned long limit;
 
+	BUILD_BUG_ON(sizeof(struct quic_skb_cb) >
+		     sizeof_field(struct sk_buff, cb));
+
 	/* Set QUIC memory limits based on available system memory, similar to
 	 * sctp_init().
 	 */
@@ -335,6 +338,10 @@ static __init int quic_init(void)
 	if (err)
 		goto err_percpu_counter;
 
+	err = quic_hash_tables_init();
+	if (err)
+		goto err_hash;
+
 	err = register_pernet_subsys(&quic_net_ops);
 	if (err)
 		goto err_def_ops;
@@ -352,6 +359,8 @@ static __init int quic_init(void)
 err_protosw:
 	unregister_pernet_subsys(&quic_net_ops);
 err_def_ops:
+	quic_hash_tables_destroy();
+err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
 err_percpu_counter:
 	return err;
@@ -364,6 +373,7 @@ static __exit void quic_exit(void)
 #endif
 	quic_protosw_exit();
 	unregister_pernet_subsys(&quic_net_ops);
+	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
 	pr_info("quic: exit\n");
 }
diff --git a/net/quic/socket.c b/net/quic/socket.c
index f133fb55484f..34a1975853af 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -54,6 +54,10 @@ static int quic_init_sock(struct sock *sk)
 
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
index 98d3f738e909..9a2f4b851676 100644
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
 static inline bool quic_is_serv(const struct sock *sk)
 {
 	return !!sk->sk_max_ack_backlog;
-- 
2.47.1

