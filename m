Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EDF4369A
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 04:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771994114; cv=none; b=JlsYCEpIy2gq0NiXMX+g6mSYtMGUE8O/vSROmyjPylgkXy2Ba8M2875g35Xaze5H98e6O6hU9/7h6sB4fqxxjC5oGE0nl2vQnewOmLuGdcDQI6aiWb2n1llHOANIrAQrGkiq97+NqsiEIuoweISXywOQkU7CzHbJtyY8DkMR3Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771994114; c=relaxed/simple;
	bh=vipvYjgx0yVkCDNZFKal18iDk1gm/ISJ0D4CYN8Uzl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dsrm6j655YDxZ2sRsFIVWVVmXNYCdzP0gYRPxewQ9CVFFTBTk9eIeTNotgcbCv0laAhGYHimOGabAN779epc8wvQz2NK0cpwGGHayZxCdnfZ+ip9c2Ytb/gaE483nhszmE3P/5YW7A48LH4MvcdrOjaehWJ1pygO7fwLOMAlzak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U8Bbf8ol; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8Bbf8ol"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-662f5c5507cso4912277eaf.3
        for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 20:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771994112; x=1772598912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWoRfQ3aBBEvjGJy0/aid5e58XofNNYza9COxBEyuD4=;
        b=U8Bbf8olxANssl5LbEV/ZfLL2Wz7usIa4KlmjmCTsiLZ9wq5gJR+DyOzOi5lxkirNV
         lyvM5bLZHm7NoVu9MCAn2qDoXzJx4QaccOgHYOlpE4NTJUrscUE/0Wb+0+Pzfm3mV5T3
         25ksaSSYXzA3dWTO3c83z/IuFiw1BQsPwc3k1NjmAbtKLOU04qbpjM0BM5itdyjg7lna
         T7NJR/XNtlVcX9iYqNBH3kmufnd9mvSQJYkcAplla6mOwRZRVKCH8We5bb5uXIcgfoF8
         lnKmxWXppdXIkKERPvs+uYI90078FYeo6WA7okIyF9xK9FoB3imIszZz3mWV2e3b7MXa
         tjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771994112; x=1772598912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vWoRfQ3aBBEvjGJy0/aid5e58XofNNYza9COxBEyuD4=;
        b=XSUnK0/DW7rgUFY+ul7Yplq3O0AvxZM/n1NEJs/66poLKoktm4SE0JyGvxDUZsx0/d
         HRjHPioWi0JzhDMq+jXyVriiixcR5InW30qpuu/Obp3vWYLi7oPDzxvJj/SA+nQxljGx
         4lGASjLb2P/u02mtoLJiag9lMlBmXe0ncRSBrrHAIZqdYv26jzUyw5K5rWY17u57kXDN
         UpsECa0Vq2AEH2GJBnW4UAvYBPuHn0JLpN5rKHWU33ue2XDR57J03/ResQ9j359KEwLr
         dhZWC0/yTbwMXCz16mK20KMsJaKKYP7EVtnGqcjrSkJoAQo51nQqM48SXwIsWNArCWiL
         /9Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUZw4RMGfXSDpq1wyFCW+O6cfxSVPGj+oHUAQoCtTLnEz51cwhwVQbiRrPkxo5ftQ+2cZjP5MkX6O9m@vger.kernel.org
X-Gm-Message-State: AOJu0YxF+tIq0u8UMsBji64Pu5fko1cThttdugI2w0f9He3VMvp+DpXj
	sQT70ahNbUpMSotXKwa/BFX6CbCUamdg2nV7+kEQajv8SA0CFzWJ3Ars3JQiJRjw
X-Gm-Gg: ATEYQzzdzihHQEWuIJTlqw3+rz3d6wWtY85SKQVADRZGQNKI6zxZkjA5jfznRGKziC1
	lNn9XldHmWaYsxjVNzmbaMCncOaH7GJL3Moeigop4juan0sVrrLJ7vOpmXbCyqMi3cD4yxzVA5H
	e8lra1tGyzqb/oLPf3SlkXCQNeJUjpN2h8Hof6pZH+mcCGpAfR51c0MnUFqzSqpEePOyLu7VXkU
	WlcT1PaPpWiO79Ne9w7YW4iCPBUVMQRAL0cYqLaMkQ/6YQg1CJ8hV7T6S6g482ei0BconDg4xIb
	XqR3KqVq7pAqhHC/n9wDtDjbqo68mNjMLlwsnX7f/0zu9dxnbqOWjDvtTJL2qODhHMuuPdz1hRV
	JRq19xR8AyOGFSFqUsuQxxYkdRMVq0nOaZQEFMbPwEQGA53I05TvjRf3SiPA8tLmhrxNhEarMlk
	xhPrUPceNUmIoDkdBu8Ey2oAm4XR5jSMEE5pMuKd89bvRF0KPzA6rR1N8tJ8vxcPWrYjYBYE8ib
	+a5sLy42m51C3Oy+W5E7myiUEK/4URrYFvZXTzFSwO1JvUdfbDEidkTKVxr5yP1h+zXfkFiHIVq
X-Received: by 2002:a05:6214:485:b0:895:4b79:83a3 with SMTP id 6a1803df08f44-89979c3d88emr178356426d6.8.1771986943740;
        Tue, 24 Feb 2026 18:35:43 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e62f453sm112363586d6.36.2026.02.24.18.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 18:35:43 -0800 (PST)
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
	Paulo Alcantara <pc@manguebit.com>,
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
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Subject: [PATCH net-next v10 07/15] quic: add connection id management
Date: Tue, 24 Feb 2026 21:34:13 -0500
Message-ID: <3c95d6d174a7712cb572a889649e2b37776b85c2.1771986861.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1771986861.git.lucien.xin@gmail.com>
References: <cover.1771986861.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile |   2 +-
 net/quic/connid.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/connid.h | 163 +++++++++++++++++++++++++++++++++
 net/quic/socket.c |   6 ++
 net/quic/socket.h |  13 +++
 5 files changed, 410 insertions(+), 1 deletion(-)
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
index 000000000000..5473b1086927
--- /dev/null
+++ b/net/quic/connid.c
@@ -0,0 +1,227 @@
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
+	struct quic_shash_head *head = quic_source_conn_id_head(net, scid, len);
+	struct quic_source_conn_id *s_conn_id;
+	struct quic_conn_id *conn_id = NULL;
+	struct hlist_nulls_node *node;
+
+	hlist_nulls_for_each_entry_rcu(s_conn_id, node, &head->head, node) {
+		if (net == sock_net(s_conn_id->sk) && s_conn_id->common.id.len == len &&
+		    !memcmp(scid, &s_conn_id->common.id.data, s_conn_id->common.id.len)) {
+			if (likely(refcount_inc_not_zero(&s_conn_id->sk->sk_refcnt)))
+				conn_id = &s_conn_id->common.id;
+			break;
+		}
+	}
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
+	u32 len = s_conn_id->common.id.len;
+	struct quic_shash_head *head;
+
+	if (!hlist_nulls_unhashed(&s_conn_id->node)) {
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data, len);
+		spin_lock_bh(&head->lock);
+		hlist_nulls_del_init_rcu(&s_conn_id->node);
+		spin_unlock_bh(&head->lock);
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
+	struct quic_shash_head *head;
+	struct list_head *list;
+
+	/* Locate insertion point to keep list ordered by number. */
+	list = &id_set->head;
+	list_for_each_entry(common, list, list) {
+		if (number == common->number)
+			return 0; /* Ignore if it already exists on the list. */
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
+		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), common->id.data,
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
+/* Remove connection IDs from the set with sequence numbers less than or equal to a number.
+ * The number must be smaller than the sequence number of the last ID in the set.
+ */
+void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
+{
+	struct quic_common_conn_id *common, *tmp;
+	struct list_head *list;
+
+	list = &id_set->head;
+	list_for_each_entry_safe(common, tmp, list, list) {
+		if (common->number > number)
+			break;
+		if (id_set->active == common)
+			id_set->active = tmp;
+		quic_conn_id_del(common);
+		id_set->count--;
+	}
+}
+
+struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set, u32 number)
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
index 000000000000..f5bb590ffd93
--- /dev/null
+++ b/net/quic/connid.h
@@ -0,0 +1,163 @@
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
+	struct hlist_nulls_node node;	/* Hash table node for fast lookup by Connection ID */
+	struct rcu_head rcu;		/* RCU header for deferred destruction */
+	struct sock *sk;		/* Pointer to sk associated with this Connection ID */
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
+	/* The id_set is guaranteed to be non-empty when called (sk is not in CLOSE state). */
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
index 8102361404de..fdbe80b4690d 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -44,6 +44,9 @@ static int quic_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
+	quic_conn_id_set_init(quic_source(sk), 1);
+	quic_conn_id_set_init(quic_dest(sk), 0);
+
 	if (quic_stream_init(quic_streams(sk)))
 		return -ENOMEM;
 
@@ -52,6 +55,9 @@ static int quic_init_sock(struct sock *sk)
 
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

