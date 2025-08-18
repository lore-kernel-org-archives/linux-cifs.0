Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F01340D81;
	Mon, 18 Aug 2025 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526361; cv=none; b=sW1aglyLALwbg5IyOSIy6R1JMZ+5TtJtLKDK3/KgkqG3lJnrgUgkobmvbvuLfBW6cYmSgyeBt7CfhuPF5r30TnznEuKQHrkCozf0cak5OJQYVPAbJPw/BmbfUh6apjYwQ1jluINIlyYoNh/kzOIrlFGvv0MGjlCBDfrsLF3YLwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526361; c=relaxed/simple;
	bh=KWPmknhL0u/DnGdytLbsiyq9a31JxkiWULBYwX90EZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISrZA5jD3l7HvMXtb6QWw6TxojRuTKrdUspFhvSWTdPifQ6ysNhEOu7CW+Lkygc+PvQ8QVMHetFbfl5j860SorPAo37ci4ftNRoTFeg9eZuBHUXPv+TCApc4yKfTFSJeKmlL1PcRNDKD2fzXpqJw/SKzc/3WuuLOvRCg1VkHeb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXgN9Ea9; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXgN9Ea9"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e931cdd710dso3217860276.3;
        Mon, 18 Aug 2025 07:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526358; x=1756131158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbiAktdR5ys+s+QKYVqJwXJFko0U8oXo0MNFFycxMO8=;
        b=QXgN9Ea9OC2dsfTJUiV08Sver4mRd6L2bDKi8qBC/ZED8tftCzxvAHOnr/8Vf1qF3n
         K80aGKNagVwivh4Eru5I+jAIxYfHyn0CWQN5dSdR4+I6hdRbVa+QKzO+sq/wrinnRlKk
         g7M/Zqfu3WzPoBqyDg5DZ9kiBLPGZCgCcacpRe96WGWJv7tz7to2RrIeDPsnWGFbHsDX
         R1+WUkXgwddT0ywT+3b109Eo7XCrVVMfzRPHvjAqSLXwuIq82g2HvqM4jWfrj/gYUYay
         Bwh+iKl1J+0aPxsQHo9c+Kry0HFeg4ChJlHjoVKanPo2zXwxSL0mUohUQfiyb2y1HP9H
         FdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526358; x=1756131158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbiAktdR5ys+s+QKYVqJwXJFko0U8oXo0MNFFycxMO8=;
        b=hzsFwB6hc89qaO3HzazhK0QPOArQiLfpYouPro84jE0TNQUD8GAktb51lq0DYu7RnP
         Ms2XtfHlTR6/hUmT8Plhszv5IFKMpXalhw2QtCb+V1+YNHB6te4bq9GQVfsKlXWjF3P/
         f7vlzEYf7X53vEkHbtzBdS1NXaaw9TjCu4Zs+YX+nbxFEcOR731XN/xwVJlQkxNNPB8b
         vGYlxmJd0zukSx5fa/Ay6ylPiuoqruPwGNyWcFr7IIn5R7PBwOUt4FUBepEjLxMly9JK
         XOoX6CkhpfEzQ6giJEszTuYlfgZxkw4GcktGR22VCZaVKICwoka/qQ6sAOZBBMxqftUq
         fBhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrH8B4ARyWwm+IXtFFVZwoqGJNn/ribv7Nb5UBh+mStXDIlg2wCVAs52igdeiXSLR6GA0uWPqu1wxc@vger.kernel.org
X-Gm-Message-State: AOJu0YzvPd6FxDpY/I9xxk4rB3rxgSre2KWf++HQshYllyjQ5RjigtQG
	xpShvcY+AqCugGlJc79vmn3FbYMs27KPhkl51gc5HACQDrzIxoLmrHNPO+rmbOuIN3Q=
X-Gm-Gg: ASbGnctNdC6ntBz37lje4sxbUp7CuWk4TRKgsnZ0QR3atJBQtiTZ7XSLSQfmDZhCL2A
	obTDukRajatodNfE+jAo2Ij2ePEj7GLxkCj2HmSVn7od30O9ZaIoTnHu+cDHLyeXxZ8MzlQQHx4
	Fjq3xznWvYx6tbd/Vbg5wp1AdpX/+oRTduRPWI71ZMFwZqymYBBjw8nYzMo9bqCw7VJCc8VG/cc
	WBkBku1CcBMBsa3ezR0okDBWf6+S2SV7leltHZpKjJ0503S9eBrN7AyYC/fromDc7wjurx6zU0q
	wtHvhxVM9aLKj7+A42TZLZvQBpGbA41TBiOEjVVI1x8vyP4toQItR5s61VYPUf55T/oR/4O1zZX
	9FPeWVTCJIffc8Qp6vPbNgsbWvrxFeYZvK6G2Z2dl4DwiD2NENECCBw5gTmUIiXl1W2eJW6irIA
	==
X-Google-Smtp-Source: AGHT+IFJix8hyMKeakn46hCrXOJrd9+8bTk2d83y4L4Uoc1wP9QvkwSC2DYzKVOqW1qK7SAD0yY5yw==
X-Received: by 2002:a05:6902:2d08:b0:e93:3460:ed23 with SMTP id 3f1490d57ef6-e933460ee6dmr12624151276.17.1755526356356;
        Mon, 18 Aug 2025 07:12:36 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:36 -0700 (PDT)
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
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 07/15] quic: add connection id management
Date: Mon, 18 Aug 2025 10:04:30 -0400
Message-ID: <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1755525878.git.lucien.xin@gmail.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile |   2 +-
 net/quic/connid.c | 222 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/connid.h | 162 +++++++++++++++++++++++++++++++++
 net/quic/socket.c |   6 ++
 net/quic/socket.h |  13 +++
 5 files changed, 404 insertions(+), 1 deletion(-)
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
index 000000000000..5fe38092caba
--- /dev/null
+++ b/net/quic/connid.c
@@ -0,0 +1,222 @@
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
+#include <net/sock.h>
+
+#include "common.h"
+#include "connid.h"
+
+/* Lookup a source connection ID (scid) in the global source connection ID hash table. */
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len)
+{
+	struct quic_hash_head *head = quic_source_conn_id_head(net, scid);
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_conn_id *conn_id = NULL;
+
+	spin_lock(&head->s_lock);
+	hlist_for_each_entry(s_conn_id, &head->head, node) {
+		if (net == sock_net(s_conn_id->sk) && s_conn_id->common.id.len == len &&
+		    !memcmp(scid, &s_conn_id->common.id.data, s_conn_id->common.id.len)) {
+			sock_hold(s_conn_id->sk);
+			conn_id = &s_conn_id->common.id;
+			break;
+		}
+	}
+
+	spin_unlock(&head->s_lock);
+	return conn_id;
+}
+
+/* Check if a given stateless reset token exists in any connection ID in the connection ID set. */
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token)
+{
+	struct quic_common_conn_id *common;
+	struct quic_dest_conn_id *dcid;
+
+	dcid = (struct quic_dest_conn_id *)id_set->active;
+	if (!memcmp(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN)) /* Fast path. */
+		return true;
+
+	list_for_each_entry(common, &id_set->head, list) {
+		dcid = (struct quic_dest_conn_id *)common;
+		if (common == id_set->active)
+			continue;
+		if (!memcmp(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN))
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
+	struct quic_hash_head *head;
+
+	if (!hlist_unhashed(&s_conn_id->node)) {
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data);
+		spin_lock_bh(&head->s_lock);
+		hlist_del_init(&s_conn_id->node);
+		spin_unlock_bh(&head->s_lock);
+	}
+
+	/* Freeing is deferred via RCU to avoid use-after-free during concurrent lookups. */
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
+/* Add a connection ID with sequence number and associated private data to the connection ID set. */
+int quic_conn_id_add(struct quic_conn_id_set *id_set,
+		     struct quic_conn_id *conn_id, u32 number, void *data)
+{
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_dest_conn_id *d_conn_id;
+	struct quic_common_conn_id *common;
+	struct quic_hash_head *head;
+	struct list_head *list;
+
+	/* Locate insertion point to keep list ordered by number. */
+	list = &id_set->head;
+	list_for_each_entry(common, list, list) {
+		if (number == common->number)
+			return 0; /* Ignore if it is already exists on the list. */
+		if (number < common->number) {
+			list = &common->list;
+			break;
+		}
+	}
+
+	if (conn_id->len > QUIC_CONN_ID_MAX_LEN)
+		return -EINVAL;
+	common = kzalloc(id_set->entry_size, GFP_ATOMIC);
+	if (!common)
+		return -ENOMEM;
+	common->id = *conn_id;
+	common->number = number;
+	if (id_set->entry_size == sizeof(struct quic_dest_conn_id)) {
+		/* For destination connection IDs, copy the stateless reset token if available. */
+		if (data) {
+			d_conn_id = (struct quic_dest_conn_id *)common;
+			memcpy(d_conn_id->token, data, QUIC_CONN_ID_TOKEN_LEN);
+		}
+	} else {
+		/* For source connection IDs, mark as hashed and insert into the global source
+		 * connection ID hashtable.
+		 */
+		common->hashed = 1;
+		s_conn_id = (struct quic_source_conn_id *)common;
+		s_conn_id->sk = data;
+
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), common->id.data);
+		spin_lock_bh(&head->s_lock);
+		hlist_add_head(&s_conn_id->node, &head->head);
+		spin_unlock_bh(&head->s_lock);
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
+/* Remove connection IDs from the set with sequence numbers less than or equal to a number. */
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_common_conn_id *common, *tmp;
+	struct list_head *list;
+
+	list = &id_set->head;
+	list_for_each_entry_safe(common, tmp, list, list) {
+		if (common->number <= number) {
+			if (id_set->active == common)
+				id_set->active = tmp;
+			quic_conn_id_del(common);
+			id_set->count--;
+		}
+	}
+}
+
+struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_common_conn_id *common;
+
+	list_for_each_entry(common, &id_set->head, list)
+		if (common->number == number)
+			return &common->id;
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
+	id_set->entry_size = source ? sizeof(struct quic_source_conn_id)
+				    : sizeof(struct quic_dest_conn_id);
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
+	id_set->active = NULL;
+}
+
+void quic_conn_id_get_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p)
+{
+	p->active_connection_id_limit = id_set->max_count;
+}
+
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p)
+{
+	id_set->max_count = p->active_connection_id_limit;
+}
diff --git a/net/quic/connid.h b/net/quic/connid.h
new file mode 100644
index 000000000000..cff37b2fb95b
--- /dev/null
+++ b/net/quic/connid.h
@@ -0,0 +1,162 @@
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
+	struct quic_conn_id id;	/* The actual Connection ID value and its length */
+	struct list_head list;	/* Linked list node for conn_id list management */
+	u32 number;		/* Sequence number assigned to this Connection ID */
+	u8 hashed;		/* Non-zero if this ID is stored in source_conn_id hashtable */
+};
+
+struct quic_source_conn_id {
+	struct quic_common_conn_id common;
+	struct hlist_node node; /* Hash table node for fast lookup by Connection ID */
+	struct rcu_head rcu;	/* RCU header for deferred destruction */
+	struct sock *sk;	/* Pointer to sk associated with this Connection ID */
+};
+
+struct quic_dest_conn_id {
+	struct quic_common_conn_id common;
+	u8 token[QUIC_CONN_ID_TOKEN_LEN];	/* Stateless reset token in rfc9000#section-10.3 */
+};
+
+struct quic_conn_id_set {
+	/* Connection ID in use on the current path */
+	struct quic_common_conn_id *active;
+	/* Connection ID to use for a new path (e.g., after migration) */
+	struct quic_common_conn_id *alt;
+	struct list_head head;	/* Head of the linked list of available connection IDs */
+	u8 entry_size;		/* Size of each connection ID entry (in bytes) in the list */
+	u8 max_count;		/* active_connection_id_limit in rfc9000#section-18.2 */
+	u8 count;		/* Current number of connection IDs in the list */
+};
+
+static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *id_set)
+{
+	struct quic_common_conn_id *common;
+
+	common = list_first_entry(&id_set->head, struct quic_common_conn_id, list);
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
+/* Select an alternate destination Connection ID for a new path (e.g., after migration). */
+static inline bool quic_conn_id_select_alt(struct quic_conn_id_set *id_set, bool active)
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
+	 * QUIC_FRAME_RETIRE_CONNECTION_ID frame to request new connection IDs from the peer.
+	 */
+	return false;
+}
+
+static inline void quic_conn_id_set_alt(struct quic_conn_id_set *id_set, struct quic_conn_id *alt)
+{
+	id_set->alt = (struct quic_common_conn_id *)alt;
+}
+
+/* Swap the active and alternate destination Connection IDs after path migration completes,
+ * since the path has already been switched accordingly.
+ */
+static inline void quic_conn_id_swap_active(struct quic_conn_id_set *id_set)
+{
+	void *active = id_set->active;
+
+	id_set->active = id_set->alt;
+	id_set->alt = active;
+}
+
+/* Choose which destination Connection ID to use for a new path migration if alt is true. */
+static inline struct quic_conn_id *quic_conn_id_choose(struct quic_conn_id_set *id_set, u8 alt)
+{
+	return (alt && id_set->alt) ? &id_set->alt->id : &id_set->active->id;
+}
+
+static inline struct quic_conn_id *quic_conn_id_active(struct quic_conn_id_set *id_set)
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
+static inline void quic_conn_id_set_token(struct quic_conn_id *conn_id, u8 *token)
+{
+	memcpy(((struct quic_dest_conn_id *)conn_id)->token, token, QUIC_CONN_ID_TOKEN_LEN);
+}
+
+static inline int quic_conn_id_cmp(struct quic_conn_id *a, struct quic_conn_id *b)
+{
+	return a->len != b->len || memcmp(a->data, b->data, a->len);
+}
+
+int quic_conn_id_add(struct quic_conn_id_set *id_set, struct quic_conn_id *conn_id,
+		     u32 number, void *data);
+bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token);
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number);
+
+struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set, u32 number);
+struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len);
+void quic_conn_id_update_active(struct quic_conn_id_set *id_set, u32 number);
+
+void quic_conn_id_get_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p);
+void quic_conn_id_set_param(struct quic_conn_id_set *id_set, struct quic_transport_param *p);
+void quic_conn_id_set_init(struct quic_conn_id_set *id_set, bool source);
+void quic_conn_id_set_free(struct quic_conn_id_set *id_set);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 0ac51cc0c249..02b2056078dc 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -42,6 +42,9 @@ static int quic_init_sock(struct sock *sk)
 	sk->sk_write_space = quic_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
+	quic_conn_id_set_init(quic_source(sk), 1);
+	quic_conn_id_set_init(quic_dest(sk), 0);
+
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
@@ -58,6 +61,9 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_conn_id_set_free(quic_source(sk));
+	quic_conn_id_set_free(quic_dest(sk));
+
 	quic_stream_free(quic_streams(sk));
 
 	quic_data_free(quic_ticket(sk));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 3eba18514ae6..43f86cabb698 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -14,6 +14,7 @@
 #include "common.h"
 #include "family.h"
 #include "stream.h"
+#include "connid.h"
 
 #include "protocol.h"
 
@@ -37,6 +38,8 @@ struct quic_sock {
 	struct quic_data		alpn;
 
 	struct quic_stream_table	streams;
+	struct quic_conn_id_set		source;
+	struct quic_conn_id_set		dest;
 };
 
 struct quic6_sock {
@@ -79,6 +82,16 @@ static inline struct quic_stream_table *quic_streams(const struct sock *sk)
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
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

