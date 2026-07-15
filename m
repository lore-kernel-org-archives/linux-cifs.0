Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CFF3C8733
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147535; cv=none; b=CAtkFuaVI7Gnd+docA7kTp2SIlF1gKXQFQCtkdGviDfoqG1G0iLdtFRMp5oN7K7EcWS9PXt941qoWo4RNHKJSpk3nnuds72bNDfALdGGVkrl1MmHdqgTCFVCjxoQsySvHXl681i/a1QiTthUn894/mEQ9H1lPkFPSlVoeJBun/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147535; c=relaxed/simple;
	bh=0r8yX2S8cEasGDE125TjDQJ21xYaWWgJjBumkXiCWbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRz5YfoA9iUOrw3MvBLA0KGZ9MOnuDtfCTO5cXU1mbyBXXbNIByS+Zm4Mwhfdqmi2G7TTr++u7ZEcoCUNLxhPyxc/PqpIPuqSy7wMWea2MZ2mdTRpMjwsV8hd/UdTnYqca28p7Lmz+8ZiEsJPTB4DyZ3bP7YuzpnmjRixi8/xfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rS7A8V1g; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rS7A8V1g"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8e5be46f663so18002806d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147532; x=1784752332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5YvpKR0E0GmOZhERriC9kIOcoXqX2al/3FI9Z0m7oVk=;
        b=rS7A8V1ghBNh1Ij6gi9qqV8aJYuZED70gX1r73/UAbQNpVTst0ed0UFfBrywbgnijS
         kF4EjDv593Ctt3/lhmv5AjKJqnXt8VrXOqznuoOlaplbkzZBQIXZKHUaOYYTB0QDnsQg
         MQeOLvg+OHlZziMKj46HwBST6mQ3Rfu/N14/XCNNHKY17u3Ru4ok7oOBYwY135Eld+jh
         aapU4sS1Cj+szqZBb4DMzSi4rKmsl9C6cvWIB9EEEnTp5iAwRng9yf5IraCwoAmfO/A3
         VFHPdsoEoHvim0+cEHDIZT3xndSqCi5ktXJX0c0IT6/PsCEt+MPeTQb/M+sAoJVN4U9I
         BD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147532; x=1784752332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5YvpKR0E0GmOZhERriC9kIOcoXqX2al/3FI9Z0m7oVk=;
        b=I7ANiklV8oEHLF5LkgqUKq7zL1/IerRNiZp9od3vVmfg7beaqcZkX58Um0ixC0ZajY
         Qoub7qrbC2b76X8wdKPH/cyaGs2ewOsq6B5+e4IHwU4I2YvG+Gtfxej7vlkNo19GNL4m
         s+/yHqJ3XGQmmrIMK9JQ5PIjR9jZ6wGm8zQnq3IEaxX3EYxu9eB/RWPmLNOsquMpJHjn
         TKe2RICsYB+OpgL9sCV/SNDlAkro/H7UJmpIP0UtE6VUbMyC5KbH3FF7XXztHqEgCqOb
         wPijOWarp00NfL8485eYmf/RyyQISK7AuHQK9+n4xR44GKYVIQlqnLKOTNKTdAtM/rJe
         VXRw==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Q1vQLGg/AXRZ8GXJnxW0yBQLTuE/XjS4DWPrAMhmkYtZN9EeNZprE+TLHxdn8cHdGVjLKBHtqd/C@vger.kernel.org
X-Gm-Message-State: AOJu0Yx55iCfJChQ9Uh45dw3hBHVRWd5DhQmtMY7m0/ckCd7ziK7KXRB
	avhAn0ojLBd/ltOFVUGt9D/q2LD35iP/Z4meYG1fNyFEwQhy8QIARbs6
X-Gm-Gg: AfdE7ckCb9itUzNiX6S/gEyMtZPexk5zmLE9lSvZayATreC8mC3+cyGMzfclUODhu1I
	3uHfjj/qj4N6WTnf4AG+qPmzqGLZetS8K4Xbihb1XRH4LJvKPlQGcqcmr53JnVjPFRyNH2cD6bz
	MDRIsvX/GwwWpKAlk/sC4LPnvNbYU7hX3Sd1g4oiJAsEiSH8S7YGlq0rVSU8hPq4ZnzhjtFx33w
	MlCAOIK2cJTBXkE8HEjWwDs53X7yHZYzXJqnWyaLpY0yxIxkQtRlEwVMR/xJ9zaZEFkK3+uktCH
	d4tH7wCBJsxWoZpBNoc71nttzL2wV1+AGv4QzBBV+63e1Ah9RwTZTIr4s/o/v+ZvZytYF1aZ7lX
	q36x0Rj6wirCy6/UvBALFdDLFuN5EEM8qcToOnmc7VLwxYFxwKyMT2eDlyVXnusQyY6h60MRp74
	frrVR3A8NBOBLfQtFA9W3C/UEQfSkFDMbf0Pg+Tpuh+1TsPPK2zwNz0D/kVmtxm97WpSfdkGHQ3
	XRHZOfXwN9rlOpZuqMdcc/buT+5OPoYfvB88nEBbfkGZ6CuGhsHFyMQyKmMpeGdwA==
X-Received: by 2002:a05:6214:2f8c:b0:8e9:f62b:8fa2 with SMTP id 6a1803df08f44-90402464ff6mr223551116d6.55.1784147531927;
        Wed, 15 Jul 2026 13:32:11 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:11 -0700 (PDT)
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
Subject: [PATCH net-next v14 07/15] quic: add connection id management
Date: Wed, 15 Jul 2026 16:27:10 -0400
Message-ID: <f9f87420735a8cdb08706515ab38688b62f29ca4.1784147238.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile |   2 +-
 net/quic/connid.c | 271 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/connid.h | 183 +++++++++++++++++++++++++++++++
 net/quic/socket.c |   6 +
 net/quic/socket.h |  13 +++
 5 files changed, 474 insertions(+), 1 deletion(-)
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
index 000000000000..a6d42679ee97
--- /dev/null
+++ b/net/quic/connid.c
@@ -0,0 +1,271 @@
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
+#include <crypto/utils.h>
+#include <linux/quic.h>
+#include <net/sock.h>
+
+#include "common.h"
+#include "connid.h"
+
+/* Lookup a source connection ID (scid) in the global source connection ID hash
+ * table.
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
+	if (!hlist_nulls_unhashed(&s_conn_id->node)) {
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data,
+						len);
+		spin_lock_bh(&head->lock);
+		hlist_nulls_del_init_rcu(&s_conn_id->node);
+		spin_unlock_bh(&head->lock);
+	}
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
+	bool dest = id_set->entry_size == sizeof(struct quic_dest_conn_id);
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_dest_conn_id *d_conn_id;
+	struct quic_common_conn_id *common;
+	struct quic_shash_head *head;
+	struct list_head *list;
+
+	/* Locate insertion point to keep list ordered by number. */
+	list = &id_set->head;
+	list_for_each_entry(common, list, list) {
+		if (number == common->number) {
+			if (quic_conn_id_cmp(&common->id, conn_id))
+				return -EINVAL;
+			if (dest && data) {
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
+	if (dest) {
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
+		common->hashed = 1;
+		s_conn_id = (struct quic_source_conn_id *)common;
+		s_conn_id->sk = data;
+
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk),
+						common->id.data,
+						common->id.len);
+		spin_lock_bh(&head->lock);
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
index 000000000000..abad396a6ad6
--- /dev/null
+++ b/net/quic/connid.h
@@ -0,0 +1,183 @@
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
+	u32 number; /* Sequence number assigned to this Connection ID */
+	u8 hashed;  /* Non-zero if stored in source_conn_id hash table */
+};
+
+struct quic_source_conn_id {
+	struct quic_common_conn_id common;
+	struct hlist_nulls_node node; /* Hash table node for fast lookup */
+	struct rcu_head rcu; /* RCU header for deferred destruction */
+	struct sock *sk;      /* Socket associated with this Connection ID */
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
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 88a6954b90b1..07c436740eaf 100644
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

