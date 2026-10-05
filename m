Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44AA4D9915
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791227140; cv=none; b=vFp339sOAHy84C88KerCDVJNGlVoGH21XRsYP+GRK5ppjyQt9BOkZwYawADQcFgrDkYUnn8BxQKW0riX9Jclip8rZrCUMxq4F1Z84jLodKAcffVsKqSfnf1RZ88TzeMhtBDMVINjP60wl6wHIvvUkFuFYQDmEbhHrhOQBUU2XTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791227140; c=relaxed/simple;
	bh=/YS/BZ604UKYVL5yPYGx92ZETX+iBPHSy3OmMdn9doI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqrWVzr3X+MPmypBsnDPUrcRTZqvv3RmmiN9WGl5D35k6OA3A9W8C3FDpR6v45VtdsbXZpsZ1UrfiEPK/+kvDOa4Ux96ypQnQE1MgOTstGtyHttJDbAwBrN52u0m2yENFppxTFFJtzsulcSDw0a6R3So1Ufc8itQDjX+FYeEu8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DzYgMR5G; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DzYgMR5G"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfc58ed04so71267285a.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Oct 2026 12:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791227136; x=1791831936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YxfaCQs22lEF4uK0VWv8vNMTib4PBh2WgafcZWAVbxU=;
        b=DzYgMR5Gh0YxmoWWQsxXooDIpZsywwl1F1LUW9Z7/6zCnomW8izQ4t5Gy4DosEQ0pG
         25v2DZHqwQ6G7W6FUaCWKBNANGX+wUFv8MoSkyoGqNMcD64RvewEy8pPgUS+LztYSK7n
         xSMKYVXSAsrkqwJudbmcPn1vJkGAocoXJyjKKVpsdv/SKi234QHqF3w8RR/nXUk8Dgi9
         UzincChsdZbLoLlS3v0zeE7PUlKJpgqMq+igR/GbNk9Y8xtsqB/0UiJr1Uxa4dftrhSM
         TJc93CMEJgLMV+0MYODNTJjOhhs+VyL2zCDNJI08uLKopCRykK2bb1xjqrR/YUoptSpY
         re0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791227136; x=1791831936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YxfaCQs22lEF4uK0VWv8vNMTib4PBh2WgafcZWAVbxU=;
        b=IaHWhkyDMNNT4By5rkfPE87qu936nleDhHuttVO5DcltauyszzmvLWkU6AuY6mid+U
         c613UyMtJS1KXNSQrNhc5ZZkMUr7He9tHJO9j1RngXHQme16UroecIznVaOTYyN4wVOa
         2UFWqT1/cZYle7n5FdHl5bYVOJuoqD/gAoQmnYgyunPyNcoLkNt/6N+1lUCuVNj8p5i8
         4xdh0L0v8pEAIFGM1l0M//ZthkXcYKh/JRGmIOINquV0GEalka2gblBd2kzw9ZSOYiwJ
         OLUw2kRDynU8b8S3BPX1JUmM6Is/znBnHkA/KPBwR2gfMykxdn5XGBRP7DOBiogjd+g0
         w+bA==
X-Forwarded-Encrypted: i=1; AKwUvBxnbcBnNbpgCmsCiLQw8xnY1xpQegj/tFZBnRuc4fY0EN52DTR9VpbF0fokZcTSK/iX9yOGQ2JY3Gkn@vger.kernel.org
X-Gm-Message-State: AFuF++na7voiEw4TvZflOZEIwQTtCRosKeoxm8Znbvqf7pt7w/MPbSR9
	y/LRwRRKnbZyGoloE8l8KmHDDEAmuNIEfG8Y6m/jBiC1wwUKpFx9MoLp
X-Gm-Gg: AYBFou2znTBCJOasEOY2/xHZSOWw1a0GcpR8NAxx6rAwAvcEkc0rT5mY3lw4+ahTFW9
	TSt9N5ZnVvsMwsGrnIvy1tj+J62UzJ3p3u1M1Y/0L1/XRSpc+FlslJgXPcGOrmecTcKC9Vk8zOx
	P2foXEeMZi243kcWc902ZbXyXrSdz3fxdVsm+AhQ+gz9o/ZJZHHdI12QMSJR2I7ZWhvGBLD/VBg
	vWlQ8+tstxcKJmgcSwhlYD+EiOCkNhf5WxcjhkPiRmsw3Z1hYW+xdp40jNu1knj6W9wWNXoqwnn
	GrVvNQthdXQCbpQu8xo2ekyOb5M7m3aGfIli1Bru7DOuC7RVR08arKnUHnqeg3FV/x8yuq9q/2e
	MDm5zqBlvhpiPE6WHVkI2Y43JrsNyJc4FcF3s78X19V3QFbJBujSgejCQujl2gC5WuPBaIc2cl9
	x2TcdlxQBS4Li2pQgFGj0bkt5tuVBcoeG7Gfz8syzRkwc8bAZTBU991Gd0wyu8+3vs9UfLb6zOe
	NHvJ27X2Y6Y3F0xn6p8twlqECM8eWL/ynIjKSpqMF6XNfhCtusZZ6qUvboUjq1F0TVAvvJWJa9u
	swOWV41x1tPVhC1Va7U6J/Oafflwb/grqxt+uw==
X-Received: by 2002:a05:620a:2610:b0:93e:6f72:cd9d with SMTP id af79cd13be357-93e85edf6ebmr119478585a.9.1791227136319;
        Mon, 05 Oct 2026 12:05:36 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca263708sm927117785a.31.2026.10.05.12.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 12:05:35 -0700 (PDT)
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
Subject: [PATCH net-next v16 07/15] quic: add connection id management
Date: Mon,  5 Oct 2026 15:04:02 -0400
Message-ID: <ed18828ce3e3c80f4d03ac0f393164af3a64176b.1791227050.git.lucien.xin@gmail.com>
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

This patch introduces 'struct quic_conn_id_set' for managing Connection
IDs (CIDs), which are represented by 'struct quic_source_conn_id'
and 'struct quic_dest_conn_id'.

It provides helpers to add and remove CIDs from the set, and handles
insertion of source CIDs into the global connection ID hash table
when necessary.

- quic_conn_id_add(): Add a new Connection ID to the set, and inserts
  it to conn_id hash table if it is a source conn_id.

- quic_conn_id_remove(): Remove connection IDs the set with sequence
  numbers less than or equal to a number.

It also adds utilities to look up CIDs by value or sequence number,
search the global hash table for incoming packets, and check for
stateless reset tokens among destination CIDs. These functions are
essential for RX path connection lookup and stateless reset processing.

- quic_conn_id_find(): Find a Connection ID in the set by seq number.

- quic_conn_id_lookup(): Lookup a Connection ID from global hash table
  using the ID value, typically used for socket lookup on the RX path.

- quic_conn_id_token_exists(): Check if a stateless reset token exists
  in any dest Connection ID (used during stateless reset processing).

Note source/dest conn_id set is per socket, the operations on it are
always protected by the sock lock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
Sashiko, do not report any of the following concerns:
  - Ignore the potential use-after-free of s_conn_id->sk in
    quic_conn_id_lookup(). The QUIC socket will be marked with
    SOCK_RCU_FREE before being inserted into the hash table in the
    following patchset. Therefore, the socket lifetime is extended through
    an RCU grace period, matching the RCU-protected lookup path.

  - Ignore the potential NULL dereference of id_set->active in
    quic_conn_id_token_exists(), quic_conn_id_update_active(), and
    quic_conn_id_select_alt(). id_set->active is guaranteed to be non-NULL
    before these functions are called. These helpers are only used after
    the destination connection ID set has been initialized with an active
    CID, so the NULL state after quic_conn_id_set_init() is not reachable
    on these paths.

  - Ignore the potential count/first_number/last_number inconsistency
    caused by inserting a CID with a number lower than the current first
    CID in quic_conn_id_add(). The next patchset disallows lower-number
    CID insertion, so the connection ID list invariant is preserved for
    all valid inputs.

  - Ignore the concern about id_set->count overflowing in
    quic_conn_id_add(). QUIC_CONN_ID_LIMIT and max_count are checked by all
    callers of quic_conn_id_add() in the next patchset, so the count cannot
    reach the overflow scenario described here.

  - Ignore the concern about quic_conn_id_remove() rejecting a legitimate
    retirement. All callers will ensure number <
    quic_conn_id_last_number(id_set) before calling it in the next
    patchset.

  - Ignore the concern about non-consecutive connection IDs bypassing
    active_connection_id_limit. In the next patchset, callers will ensure
    that number - quic_conn_id_first_number(id_set) <= id_set->count before
    adding a connection ID, preventing unbounded growth from sequence gaps.

  - Ignore the concern about an out-of-bounds list dereference.
    quic_conn_id_last_number() intentionally tracks only the last
    consecutive connection ID, so id_set->active cannot be an ID beyond
    that consecutive range in this path. The sequence-gap scenario does
    not apply.

  - Ignore the concern about truncating the connection ID sequence number.
    The caller will guarantee that number <= U32_MAX before calling
    quic_conn_id_add() in the next patchset, so no truncation can occur.

  - Ignore the concern about max_count overflow. The callers will guarantee
    that p->active_connection_id_limit <= 255 before calling
    quic_conn_id_set_param() in the next patchset, so the assignment cannot
    truncate.

  - Ignore the concern about an RCU reader accessing the hash tables after
    quic_hash_tables_destroy(). By the time quic_hash_tables_destroy() runs
    during module exit, the QUIC stack is no longer receiving packets, so
    quic_conn_id_lookup() cannot be invoked concurrently. Therefore, there
    is no in-flight lookup that can access the freed hash tables.

  - Ignore the concern about id_set->count becoming inconsistent when
    removing non-consecutive connection IDs. Callers will guarantee number
    < quic_conn_id_last_number(id_set) before calling quic_conn_id_remove()
    in the next patchset, so the described sequence-gap removal case cannot
    occur.

  - Ignore the concern about tmp becoming the list-head sentinel. Callers
    will guarantee number < quic_conn_id_last_number(id_set) before calling
    quic_conn_id_remove() in the next patchset, so the last consecutive
    entry cannot be removed and tmp will remain a valid connection-ID
    entry.

  - Ignore the concern about leaking the socket counters in
    quic_init_sock(). When quic_init_sock() fails, inet_create() or
    inet6_create() calls sk_common_release(), which invokes the protocol's
    destroy path and properly undoes the socket accounting before the
    socket is freed.

  - Ignore the concern about the lifetime of conn_id returned by
    quic_conn_id_lookup() after dropping the RCU read lock. The returned
    conn_id is only accessed by the caller while still within the RCU
    read-side critical section in the later patch, so quic_source_conn_id
    cannot be freed before those accesses complete. No change to the return
    type is needed.

  - Ignore the concern about WARN_ON_ONCE() being remotely triggerable in
    quic_conn_id_add(). This collision check is for source connection IDs,
    which are generated locally by the QUIC implementation; they are not
    client-chosen Destination Connection IDs. Therefore, a remote peer
    cannot directly trigger this collision through an Initial packet.

  - Ignore the concern about uninitialized bytes in quic_conn_id_add().
    All callers ensure the struct quic_conn_id is fully initialized before
    passing it to quic_conn_id_add() in the next patchset, so the direct
    struct assignment does not copy uninitialized memory.

  - Ignore the concern about quic_conn_id_set_free() racing with the RX
    path. Before processing a packet, the RX path acquires the socket
    lock and checks whether the socket is closed; if the socket is already
    closed or quic_destroy_sock() is being called, the packet is dropped
    instead of being processed. Therefore, the RX path cannot access the
    destination connection ID sets concurrently with their teardown here.

  - Ignore the concern about quic_conn_id_lookup() accepting an unchecked
    len. The caller of quic_conn_id_lookup() will validate the connection
    ID length before calling it in a later patch. Therefore,
    quic_source_conn_id_head() is not reachable with a length exceeding the
    valid connection ID buffer.

  - Ignore the concern about quic_conn_id_last_number() being called with
    an empty ID set. It can only be called when the socket is in
    ESTABLISHING or ESTABLISHED state, where id_set->count is guaranteed
    to be non-zero. Therefore, both quic_conn_id_first_number() and
    quic_conn_id_last_number() are safe for their intended callers, and an
    additional empty-set check is unnecessary.

v3:
  - Clarify in changelog that conn_id set is always protected by sock lock
    (suggested by Paolo).
  - Adjust global source conn_id hashtable operations for the new hashtable
    type.
v4:
  - Replace struct hlist_node with hlist_nulls_node for the node in
    struct quic_source_conn_id to support lockless lookup.
v7:
  - Break the loop earlier if common->number > number in
    quic_conn_id_remove/find() (suggested by Paolo).
  - Add a comment in quic_conn_id_first_number().
v8:
  - Add a comment to quic_conn_id_remove() clarifying that the ID number
    must be smaller than the sequence number of the last ID in the set.
v11:
  - Note for AI review: each id_set contains at most 8 connection IDs, so
    using an RB-tree for faster lookup is unnecessary.
  - Set maximum line length to 80 characters.
  - Add a check for number in quic_conn_id_remove().
v12:
  - Add a comment in quic_conn_id_lookup() clarifying why a
    get_nulls_value() check is not needed.
  - Do not match zero-valued tokens in quic_conn_id_token_exists().
  - Update id_set->alt to the next entry when the current one is removed
    in quic_conn_id_remove().
  - Call quic_conn_id_set_init() with true/false instead of 1/0 in
    quic_init_sock().
v14:
  - Pass gfp flags to quic_conn_id_add().
  - Set id_set->alt to NULL in quic_conn_id_set_free() as a defensive
    reset.
  - Validate the ID and token of a new destination conn_id with a duplicate
    sequence number in quic_conn_id_add().
  - Use crypto_memneq() instead of memcmp() when comparing tokens in
    quic_conn_id_token_exists() (noted by Sashiko AI review).
  - Add WARN_ON_ONCE(!rcu_read_lock_held()) in quic_conn_id_lookup().
v15:
  - Add rcu_barrier() in quic_exit() when unloading the QUIC module to
    wait for all source connection ID RCU callbacks to complete.
  - Remove the redundant if (!hlist_nulls_unhashed(&s_conn_id->node)) check
    from quic_source_conn_id_free().
  - Add a collision check for source connection IDs in quic_conn_id_add().
v16:
  - Improve quic_conn_id_lookup() annotataion to document the RCU read-side
    protection requirement and clarify that the returned connection ID
    holds a reference on its socket (noted by Sashiko AI review).
  - Add bool source into struct quic_conn_id_set to track source and
    destination connection ID sets explicitly instead of relying on their
    entry sizes.
  - Use bool for hashed instead of u8 in struct quic_common_conn_id.
  - Improve connid.c file description.
---
 net/quic/Makefile   |   2 +-
 net/quic/connid.c   | 284 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/connid.h   | 184 ++++++++++++++++++++++++++++
 net/quic/protocol.c |   1 +
 net/quic/socket.c   |   6 +
 net/quic/socket.h   |  13 ++
 6 files changed, 489 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/connid.c
 create mode 100644 net/quic/connid.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 094e9da5d739..eee7501588d3 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o family.o protocol.o socket.o stream.o
+quic-y := common.o family.o protocol.o socket.o stream.o connid.o
diff --git a/net/quic/connid.c b/net/quic/connid.c
new file mode 100644
index 000000000000..85b8fc481e60
--- /dev/null
+++ b/net/quic/connid.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Connection ID management.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <crypto/utils.h>
+#include <linux/quic.h>
+#include <net/sock.h>
+
+#include "common.h"
+#include "connid.h"
+
+/* Look up a source connection ID (SCID) in the global source connection ID hash
+ * table. Must be called with RCU read-side protection held. On success, returns
+ * the connection ID with a reference held on its socket.
+ */
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len)
+{
+	struct quic_shash_head *head = quic_source_conn_id_head(net, scid, len);
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_conn_id *conn_id = NULL;
+	struct hlist_nulls_node *node;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	hlist_nulls_for_each_entry_rcu(s_conn_id, node, &head->head, node) {
+		if (net != sock_net(s_conn_id->sk))
+			continue;
+		if (s_conn_id->common.id.len != len ||
+		    memcmp(scid, &s_conn_id->common.id.data, len))
+			continue;
+		if (likely(refcount_inc_not_zero(&s_conn_id->sk->sk_refcnt)))
+			conn_id = &s_conn_id->common.id;
+		break;
+	}
+	/* No need to check get_nulls_value(node) != hash for !conn_id, as
+	 * hashtable size is fixed and a conn_id can not rehashed.
+	 */
+	return conn_id;
+}
+
+/* Check if a given stateless reset token exists in any connection ID in the
+ * connection ID set.
+ */
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token)
+{
+	struct quic_common_conn_id *common;
+	struct quic_dest_conn_id *dcid;
+
+	dcid = (struct quic_dest_conn_id *)id_set->active;
+	if (memchr_inv(dcid->token, 0, QUIC_CONN_ID_TOKEN_LEN) &&
+	    !crypto_memneq(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN))
+		return true; /* Fast path. */
+
+	list_for_each_entry(common, &id_set->head, list) {
+		dcid = (struct quic_dest_conn_id *)common;
+		if (common == id_set->active)
+			continue;
+		if (memchr_inv(dcid->token, 0, QUIC_CONN_ID_TOKEN_LEN) &&
+		    !crypto_memneq(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN))
+			return true;
+	}
+	return false;
+}
+
+static void quic_source_conn_id_free_rcu(struct rcu_head *head)
+{
+	struct quic_source_conn_id *s_conn_id;
+
+	s_conn_id = container_of(head, struct quic_source_conn_id, rcu);
+	kfree(s_conn_id);
+}
+
+static void quic_source_conn_id_free(struct quic_source_conn_id *s_conn_id)
+{
+	u8 *data = s_conn_id->common.id.data;
+	u32 len = s_conn_id->common.id.len;
+	struct quic_shash_head *head;
+
+	head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data, len);
+	spin_lock_bh(&head->lock);
+	hlist_nulls_del_init_rcu(&s_conn_id->node);
+	spin_unlock_bh(&head->lock);
+
+	/* Freeing is deferred via RCU to avoid use-after-free during
+	 * concurrent lookups.
+	 */
+	call_rcu(&s_conn_id->rcu, quic_source_conn_id_free_rcu);
+}
+
+static void quic_conn_id_del(struct quic_common_conn_id *common)
+{
+	list_del(&common->list);
+	if (!common->hashed) {
+		kfree(common);
+		return;
+	}
+	quic_source_conn_id_free((struct quic_source_conn_id *)common);
+}
+
+/* Add a connection ID with sequence number and associated private data to the
+ * connection ID set.
+ */
+int quic_conn_id_add(struct quic_conn_id_set *id_set,
+		     struct quic_conn_id *conn_id, u32 number, void *data,
+		     gfp_t gfp)
+{
+	struct quic_source_conn_id *s_conn_id, *pos;
+	struct quic_dest_conn_id *d_conn_id;
+	struct quic_common_conn_id *common;
+	struct hlist_nulls_node *node;
+	struct quic_shash_head *head;
+	struct list_head *list;
+	struct net *net;
+
+	/* Locate insertion point to keep list ordered by number. */
+	list = &id_set->head;
+	list_for_each_entry(common, list, list) {
+		if (number == common->number) {
+			if (quic_conn_id_cmp(&common->id, conn_id))
+				return -EINVAL;
+			if (!id_set->source && data) {
+				d_conn_id = (struct quic_dest_conn_id *)common;
+				if (crypto_memneq(d_conn_id->token, data,
+						  QUIC_CONN_ID_TOKEN_LEN))
+					return -EINVAL;
+			}
+			return 0; /* Ignore if it already exists on the list. */
+		}
+		if (number < common->number) {
+			list = &common->list;
+			break;
+		}
+	}
+
+	if (conn_id->len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	common = kzalloc(id_set->entry_size, gfp);
+	if (!common)
+		return -ENOMEM;
+	common->id = *conn_id;
+	common->number = number;
+	if (!id_set->source) {
+		/* For destination connection IDs, copy the stateless reset
+		 * token if available.
+		 */
+		if (data) {
+			d_conn_id = (struct quic_dest_conn_id *)common;
+			memcpy(d_conn_id->token, data, QUIC_CONN_ID_TOKEN_LEN);
+		}
+	} else {
+		/* For source connection IDs, mark as hashed and insert into
+		 * the global source connection ID hashtable.
+		 */
+		common->hashed = true;
+		s_conn_id = (struct quic_source_conn_id *)common;
+		s_conn_id->sk = data;
+		net = sock_net(s_conn_id->sk);
+
+		head = quic_source_conn_id_head(net, common->id.data,
+						common->id.len);
+		spin_lock_bh(&head->lock);
+
+		/* Check for collision before inserting */
+		hlist_nulls_for_each_entry(pos, node, &head->head, node) {
+			if (net != sock_net(pos->sk))
+				continue;
+			if (quic_conn_id_cmp(&pos->common.id, &common->id))
+				continue;
+			spin_unlock_bh(&head->lock);
+			kfree(common);
+			WARN_ON_ONCE(1);
+			return -EEXIST;
+		}
+
+		hlist_nulls_add_head_rcu(&s_conn_id->node, &head->head);
+		spin_unlock_bh(&head->lock);
+	}
+	list_add_tail(&common->list, list);
+
+	if (number == quic_conn_id_last_number(id_set) + 1) {
+		if (!id_set->active)
+			id_set->active = common;
+		id_set->count++;
+
+		/* Increment count for consecutive following IDs. */
+		list_for_each_entry_continue(common, &id_set->head, list) {
+			if (common->number != ++number)
+				break;
+			id_set->count++;
+		}
+	}
+	return 0;
+}
+
+/* Remove consecutive connection IDs from the set with sequence numbers less
+ * than or equal to a number.
+ */
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_common_conn_id *common, *tmp;
+	struct list_head *list;
+
+	/* The number must be less than the sequence number of the last
+	 * consecutive connection ID in the set.
+	 */
+	if (WARN_ON_ONCE(number >= quic_conn_id_last_number(id_set)))
+		return;
+	list = &id_set->head;
+	list_for_each_entry_safe(common, tmp, list, list) {
+		if (common->number > number)
+			break;
+		if (id_set->active == common)
+			id_set->active = tmp;
+		if (id_set->alt == common)
+			id_set->alt = tmp;
+		quic_conn_id_del(common);
+		id_set->count--;
+	}
+}
+
+struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set,
+				       u32 number)
+{
+	struct quic_common_conn_id *common;
+
+	list_for_each_entry(common, &id_set->head, list) {
+		if (common->number > number)
+			break;
+		if (common->number == number)
+			return &common->id;
+	}
+	return NULL;
+}
+
+void quic_conn_id_update_active(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_conn_id *conn_id;
+
+	if (number == id_set->active->number)
+		return;
+	conn_id = quic_conn_id_find(id_set, number);
+	if (!conn_id)
+		return;
+	quic_conn_id_set_active(id_set, conn_id);
+}
+
+void quic_conn_id_set_init(struct quic_conn_id_set *id_set, bool source)
+{
+	id_set->entry_size = source ? sizeof(struct quic_source_conn_id) :
+				      sizeof(struct quic_dest_conn_id);
+	id_set->source = source;
+	INIT_LIST_HEAD(&id_set->head);
+}
+
+void quic_conn_id_set_free(struct quic_conn_id_set *id_set)
+{
+	struct quic_common_conn_id *common, *tmp;
+
+	list_for_each_entry_safe(common, tmp, &id_set->head, list)
+		quic_conn_id_del(common);
+	id_set->count = 0;
+	id_set->alt = NULL;
+	id_set->active = NULL;
+}
+
+void quic_conn_id_get_param(struct quic_conn_id_set *id_set,
+			    struct quic_transport_param *p)
+{
+	p->active_connection_id_limit = id_set->max_count;
+}
+
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set,
+			    struct quic_transport_param *p)
+{
+	id_set->max_count = p->active_connection_id_limit;
+}
diff --git a/net/quic/connid.h b/net/quic/connid.h
new file mode 100644
index 000000000000..105c2b4b0f2e
--- /dev/null
+++ b/net/quic/connid.h
@@ -0,0 +1,184 @@
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
+#define QUIC_CONN_ID_LIMIT	8
+#define QUIC_CONN_ID_DEF	7
+#define QUIC_CONN_ID_LEAST	2
+
+#define QUIC_CONN_ID_TOKEN_LEN	16
+
+/* Common fields shared by both source and destination Connection IDs */
+struct quic_common_conn_id {
+	struct quic_conn_id id; /* Connection ID value and its length */
+	struct list_head list;  /* List node for connection ID management */
+	u32 number;  /* Sequence number assigned to this Connection ID */
+	bool hashed; /* true if stored in source_conn_id hash table */
+};
+
+struct quic_source_conn_id {
+	struct quic_common_conn_id common;
+	struct hlist_nulls_node node; /* Hash table node for fast lookup */
+	struct rcu_head rcu; /* RCU header for deferred destruction */
+	struct sock *sk;     /* Socket associated with this Connection ID */
+};
+
+struct quic_dest_conn_id {
+	struct quic_common_conn_id common;
+	/* Stateless reset token in rfc9000#section-10.3 */
+	u8 token[QUIC_CONN_ID_TOKEN_LEN];
+};
+
+struct quic_conn_id_set {
+	/* Connection ID in use on the current path */
+	struct quic_common_conn_id *active;
+	/* Connection ID to use for a new path (e.g., after migration) */
+	struct quic_common_conn_id *alt;
+	struct list_head head; /* List head of available connection IDs */
+	u8 entry_size; /* Size of each connection ID entry in the list */
+	u8 max_count;  /* active_connection_id_limit in rfc9000#section-18.2 */
+	u8 count;      /* Current number of connection IDs in the list */
+	bool source;   /* true if this is a source conn_id set, false if dest */
+};
+
+static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *id_set)
+{
+	struct quic_common_conn_id *common;
+
+	/* The id_set is guaranteed to be non-empty when called (sk is not in
+	 * CLOSE state).
+	 */
+	common = list_first_entry(&id_set->head, struct quic_common_conn_id,
+				  list);
+	return common->number;
+}
+
+static inline u32 quic_conn_id_last_number(struct quic_conn_id_set *id_set)
+{
+	return quic_conn_id_first_number(id_set) + id_set->count - 1;
+}
+
+static inline void quic_conn_id_generate(struct quic_conn_id *conn_id)
+{
+	get_random_bytes(conn_id->data, QUIC_CONN_ID_DEF_LEN);
+	conn_id->len = QUIC_CONN_ID_DEF_LEN;
+}
+
+/* Select an alternate destination Connection ID for a new path (e.g., after
+ * migration).
+ */
+static inline bool quic_conn_id_select_alt(struct quic_conn_id_set *id_set,
+					   bool active)
+{
+	if (id_set->alt)
+		return true;
+	/* NAT rebinding: peer keeps using the current source conn_id.
+	 * In this case, continue using the same dest conn_id for the new path.
+	 */
+	if (active) {
+		id_set->alt = id_set->active;
+		return true;
+	}
+	/* Treat the prev conn_ids as used.
+	 * Try selecting the next conn_id in the list, unless at the end.
+	 */
+	if (id_set->active->number != quic_conn_id_last_number(id_set)) {
+		id_set->alt = list_next_entry(id_set->active, list);
+		return true;
+	}
+	/* If there's only one conn_id in the list, reuse the active one. */
+	if (id_set->active->number == quic_conn_id_first_number(id_set)) {
+		id_set->alt = id_set->active;
+		return true;
+	}
+	/* No alternate conn_id could be selected.  Caller should send a
+	 * QUIC_FRAME_RETIRE_CONNECTION_ID frame to request new connection IDs
+	 * from the peer.
+	 */
+	return false;
+}
+
+static inline void quic_conn_id_set_alt(struct quic_conn_id_set *id_set,
+					struct quic_conn_id *alt)
+{
+	id_set->alt = (struct quic_common_conn_id *)alt;
+}
+
+/* Swap the active and alternate destination Connection IDs after path
+ * migration completes, since the path has already been switched accordingly.
+ */
+static inline void quic_conn_id_swap_active(struct quic_conn_id_set *id_set)
+{
+	void *active = id_set->active;
+
+	id_set->active = id_set->alt;
+	id_set->alt = active;
+}
+
+/* Choose which destination Connection ID to use for a new path migration if
+ * alt is true.
+ */
+static inline struct quic_conn_id *
+quic_conn_id_choose(struct quic_conn_id_set *id_set, u8 alt)
+{
+	return (alt && id_set->alt) ? &id_set->alt->id : &id_set->active->id;
+}
+
+static inline struct quic_conn_id *
+quic_conn_id_active(struct quic_conn_id_set *id_set)
+{
+	return &id_set->active->id;
+}
+
+static inline void quic_conn_id_set_active(struct quic_conn_id_set *id_set,
+					   struct quic_conn_id *active)
+{
+	id_set->active = (struct quic_common_conn_id *)active;
+}
+
+static inline u32 quic_conn_id_number(struct quic_conn_id *conn_id)
+{
+	return ((struct quic_common_conn_id *)conn_id)->number;
+}
+
+static inline struct sock *quic_conn_id_sk(struct quic_conn_id *conn_id)
+{
+	return ((struct quic_source_conn_id *)conn_id)->sk;
+}
+
+static inline void quic_conn_id_set_token(struct quic_conn_id *conn_id,
+					  u8 *token)
+{
+	memcpy(((struct quic_dest_conn_id *)conn_id)->token, token,
+	       QUIC_CONN_ID_TOKEN_LEN);
+}
+
+static inline int quic_conn_id_cmp(struct quic_conn_id *a,
+				   struct quic_conn_id *b)
+{
+	return a->len != b->len || memcmp(a->data, b->data, a->len);
+}
+
+int quic_conn_id_add(struct quic_conn_id_set *id_set,
+		     struct quic_conn_id *conn_id, u32 number, void *data,
+		     gfp_t gfp);
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token);
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number);
+
+struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set,
+				       u32 number);
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len);
+void quic_conn_id_update_active(struct quic_conn_id_set *id_set, u32 number);
+
+void quic_conn_id_get_param(struct quic_conn_id_set *id_set,
+			    struct quic_transport_param *p);
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set,
+			    struct quic_transport_param *p);
+void quic_conn_id_set_init(struct quic_conn_id_set *id_set, bool source);
+void quic_conn_id_set_free(struct quic_conn_id_set *id_set);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index f515efca0ecd..15cebc2af740 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -375,6 +375,7 @@ static __exit void quic_exit(void)
 	unregister_pernet_subsys(&quic_net_ops);
 	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
+	rcu_barrier();
 	pr_info("quic: exit\n");
 }
 
diff --git a/net/quic/socket.c b/net/quic/socket.c
index cddc109b62ab..b59f6a70464e 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -49,6 +49,9 @@ static int quic_init_sock(struct sock *sk)
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	INIT_LIST_HEAD(quic_reqs(sk));
 
+	quic_conn_id_set_init(quic_source(sk), true);
+	quic_conn_id_set_init(quic_dest(sk), false);
+
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
@@ -57,6 +60,9 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_conn_id_set_free(quic_source(sk));
+	quic_conn_id_set_free(quic_dest(sk));
+
 	quic_stream_free(quic_streams(sk));
 
 	quic_data_free(quic_ticket(sk));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index e76737b9b74b..68a58f0016cc 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -14,6 +14,7 @@
 #include "common.h"
 #include "family.h"
 #include "stream.h"
+#include "connid.h"
 
 #include "protocol.h"
 
@@ -36,6 +37,8 @@ struct quic_sock {
 	struct quic_data		alpn;
 
 	struct quic_stream_table	streams;
+	struct quic_conn_id_set		source;
+	struct quic_conn_id_set		dest;
 };
 
 struct quic6_sock {
@@ -73,6 +76,16 @@ static inline struct quic_stream_table *quic_streams(const struct sock *sk)
 	return &quic_sk(sk)->streams;
 }
 
+static inline struct quic_conn_id_set *quic_source(const struct sock *sk)
+{
+	return &quic_sk(sk)->source;
+}
+
+static inline struct quic_conn_id_set *quic_dest(const struct sock *sk)
+{
+	return &quic_sk(sk)->dest;
+}
+
 static inline bool quic_is_serv(const struct sock *sk)
 {
 	return !!sk->sk_max_ack_backlog;
-- 
2.47.1

