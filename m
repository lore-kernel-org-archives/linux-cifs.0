Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDE21CC62;
	Sat,  5 Jul 2025 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744339; cv=none; b=O2sub84yavReIAyyR306Ztp42zva+wqOB3tgErgWimdXSkg/zc5REN0ONL8dpjp3YNPoxC1nzi1GWA+cRHAWGF+0z41XhimU0kfpyV24xnFJQAk0fYF/ocmmJhivJe5iugXPCOXJSvmTfThTdOhX1EKgMyCqHmVjcA+IQ4pWYr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744339; c=relaxed/simple;
	bh=jR05Kr6n1quMlcVHY9HYP0eCFVVxkZ7a7Gx5G4NeXHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQi+RhQTz/ItgqgmBJcB8CPu1xEaEO6kNp6CQqq5kbvnulvYcELbht7+trvqaRl/6nscEE+68YQiySpwAGjJwmp12qj0PzYv0Z/E7cTCEkDdWOYfCKNwb8xR97gwWCgwDN2yDeMP5ttgbpmKpf4mrn7Mw48kG18x/Qh98FXaY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWhPCUJZ; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWhPCUJZ"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fafdd322d3so23861916d6.3;
        Sat, 05 Jul 2025 12:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744335; x=1752349135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6WZcNSJ33r950DCnrEqmLxk6/WVf6JJAfk+h2XGpjY=;
        b=kWhPCUJZ+HB5im56GGrB6x6bpOee7yluO835tabJxaox46b3+arGK0CEdAtTrkiXD4
         ktwN6QcqsFnzG9TSuABdvQ1/Cq3EzuxjCfibQnEw/9WmcAbJsHICHex/zZ6xUtMUWBVe
         uk6/jY5P8hgO/AIpU+ubAonulfwBCpERX/UVlT6H7I/AaIMtFEZX+6uX8YpBG1LPc+QH
         avvg0PBpwVf+FTqT9UMfg+4yg9sIQXwZ7jfxuX2HEbPjmhW1vRhy9O15AOFesl34y37v
         vm+8qzZBjEfrequxIkJjtfj3lw41W3yMVzNc68CxJcc1N+WDqctdHE1KAwJsR5diS3yG
         p+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744335; x=1752349135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6WZcNSJ33r950DCnrEqmLxk6/WVf6JJAfk+h2XGpjY=;
        b=emSvo+R8nW98btq620KKwe8j+UOSxlqIMTAkUxuvk7qL92/R6FMuFlLwW6RgSaJI9K
         sagbrhIN6IvN1+gekjXkyELFMfiVewDLIxsSuA3GRCRnGcK7A4wCpHbkp5x//R7K/gZl
         P/S+IQCmMMGCGT0OpPBpevugElEYuz8Sogna5TIvYytaPUdcAPYF1Q0vCaVnqWoWh9F+
         YVe/6HKCMqDJV+4zAhW8GGvqLjTG8SiDqJzePdg4L9hfj2M82kEvyexCM3Nwmqtp1lSe
         TxboFOCOTeBU57Blx0oVnEfgp38cRWwHie8nIFBGnpH8VuYx0T1+SClkt/neaqKtL6+f
         cNoA==
X-Forwarded-Encrypted: i=1; AJvYcCUBenN+4s3hHCovh3616bDXB2y4uglXfead0bBtwFbRGOPKGbgqbS2aCwHHLqMNepXvchftTGwu5a4C@vger.kernel.org
X-Gm-Message-State: AOJu0YyvMiLDGMxXtypunThdChBvDATwPpkpDIe7qiBdTt07zxh2xzrQ
	/a+ApwLN6qyySA+bVp/2/SQMgJ3ZgghnAtYoHfkqr/gKUK1ZPAPleIdMiUpZwN0OFm0=
X-Gm-Gg: ASbGncuX4N2FS+AKpzsx1cTD4J+LZ0475VCykGTY5WPO3wbpwHjsqfuFavlHjX8SpBu
	PSN7Sd7yxfRBZ2BuTIY032rP5/7MCgJIsvp0vo6ZOIcNQ4nYkJEXLKdklEbNAuryhhGYZ1bZUGe
	TLL8I47c7Rv/jxVs3mODhQhvl8UhA7IUtqcaFMEjHdmr8VPtVxKEcOjvT8CI6qMJ4e/rtmaGu01
	ABJjjH0Aa7yznpxSQBm7ApEa+bTGlfE7CJXPthYgj8LIJrhY1YWrfpBM4PVmEa/QSPe1spjUyQW
	BEhymVmuHvCpzUYMqDrQ9A7bsvf7UjTnXS23C9hYQIRWdwsEe8xKSw07H1ba8mDpfsJSeStG5fF
	9y5kdkhsglpe6pAoq+9HpIaJ016Q=
X-Google-Smtp-Source: AGHT+IFQI/iH/XIxqZEnphabbrnIy9vGbljW/jMVZjNKuHL6jM+xqZ45PKF8+MBiizHz+H5/roje/A==
X-Received: by 2002:a05:6214:398f:b0:702:d7e1:9a61 with SMTP id 6a1803df08f44-702d7e19b8bmr24666106d6.32.1751744335265;
        Sat, 05 Jul 2025 12:38:55 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:54 -0700 (PDT)
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
Subject: [PATCH net-next 08/15] quic: add path management
Date: Sat,  5 Jul 2025 15:31:47 -0400
Message-ID: <5ec86fef7178bc8506e43dd3adcb221be659f96e.1751743914.git.lucien.xin@gmail.com>
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

This patch introduces 'quic_path_group' for managing paths, represented
by 'struct quic_path'. A connection may use two paths simultaneously
for connection migration.

Each path is associated with a UDP tunnel socket (sk), and a single
UDP tunnel socket can be related to multiple paths from different sockets.
These UDP tunnel sockets are wrapped in 'quic_udp_sock' structures and
stored in a hash table.

It includes mechanisms to bind and unbind paths, detect alternative paths
for migration, and swap paths to support seamless transition between
networks.

- quic_path_bind(): Bind a path to a port and associate it with a UDP sk.

- quic_path_free(): Unbind a path from a port and disassociate it from a
  UDP sk.

- quic_path_swap(): Swap two paths to facilitate connection migration.

- quic_path_detect_alt(): Determine if a packet is using an alternative
  path, used for connection migration.

 It also integrates basic support for Packetization Layer Path MTU
Discovery (PLPMTUD), using PING frames and ICMP feedback to adjust path
MTU and handle probe confirmation or resets during routing changes.

- quic_path_pl_recv(): state transition and pmtu update after the probe
  packet is acked.

- quic_path_pl_toobig(): state transition and pmtu update after
  receiving a toobig or needfrag icmp packet.

- quic_path_pl_send(): state transition and pmtu update after sending a
  probe packet.

- quic_path_pl_reset(): restart the probing when path routing changes.

- quic_path_pl_confirm(): check if probe packet gets acked.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile |   2 +-
 net/quic/path.c   | 507 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/path.h   | 162 +++++++++++++++
 net/quic/socket.c |   3 +
 net/quic/socket.h |  21 +-
 5 files changed, 692 insertions(+), 3 deletions(-)
 create mode 100644 net/quic/path.c
 create mode 100644 net/quic/path.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index eee7501588d3..1565fb5cef9d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o family.o protocol.o socket.o stream.o connid.o
+quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o
diff --git a/net/quic/path.c b/net/quic/path.c
new file mode 100644
index 000000000000..426d34bcb016
--- /dev/null
+++ b/net/quic/path.c
@@ -0,0 +1,507 @@
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
+#include <net/udp_tunnel.h>
+#include <linux/quic.h>
+
+#include "common.h"
+#include "family.h"
+#include "path.h"
+
+static int (*quic_path_rcv)(struct sk_buff *skb, u8 err);
+static struct workqueue_struct *quic_wq __read_mostly;
+
+static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	if (skb_linearize(skb))
+		return 0;
+
+	memset(skb->cb, 0, sizeof(skb->cb));
+	QUIC_SKB_CB(skb)->seqno = -1;
+	QUIC_SKB_CB(skb)->udph_offset = skb->transport_header;
+	QUIC_SKB_CB(skb)->time = jiffies_to_usecs(jiffies);
+	skb_set_transport_header(skb, sizeof(struct udphdr));
+	quic_path_rcv(skb, 0);
+	return 0;
+}
+
+static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
+{
+	if (skb_linearize(skb))
+		return 0;
+
+	QUIC_SKB_CB(skb)->udph_offset = skb->transport_header;
+	return quic_path_rcv(skb, 1);
+}
+
+static void quic_udp_sock_put_work(struct work_struct *work)
+{
+	struct quic_udp_sock *us = container_of(work, struct quic_udp_sock, work);
+	struct quic_hash_head *head;
+
+	head = quic_udp_sock_head(sock_net(us->sk), ntohs(us->addr.v4.sin_port));
+	mutex_lock(&head->m_lock);
+	__hlist_del(&us->node);
+	udp_tunnel_sock_release(us->sk->sk_socket);
+	mutex_unlock(&head->m_lock);
+	kfree(us);
+}
+
+static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk, union quic_addr *a)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {};
+	struct udp_port_cfg udp_conf = {};
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	struct quic_udp_sock *us;
+	struct socket *sock;
+
+	us = kzalloc(sizeof(*us), GFP_KERNEL);
+	if (!us)
+		return NULL;
+
+	quic_udp_conf_init(sk, &udp_conf, a);
+	if (udp_sock_create(net, &udp_conf, &sock)) {
+		pr_debug("%s: failed to create udp sock\n", __func__);
+		kfree(us);
+		return NULL;
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = quic_udp_rcv;
+	tuncfg.encap_err_lookup = quic_udp_err;
+	setup_udp_tunnel_sock(net, sock, &tuncfg);
+
+	refcount_set(&us->refcnt, 1);
+	us->sk = sock->sk;
+	memcpy(&us->addr, a, sizeof(*a));
+
+	head = quic_udp_sock_head(net, ntohs(a->v4.sin_port));
+	hlist_add_head(&us->node, &head->head);
+	INIT_WORK(&us->work, quic_udp_sock_put_work);
+
+	return us;
+}
+
+static bool quic_udp_sock_get(struct quic_udp_sock *us)
+{
+	return (us && refcount_inc_not_zero(&us->refcnt));
+}
+
+static void quic_udp_sock_put(struct quic_udp_sock *us)
+{
+	if (us && refcount_dec_and_test(&us->refcnt))
+		queue_work(quic_wq, &us->work);
+}
+
+/* Lookup a quic_udp_sock in the global hash table. If not found, creates and returns a new one
+ * associated with the given kernel socket.
+ */
+static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk, union quic_addr *a, u16 port)
+{
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	struct quic_udp_sock *us;
+
+	head = quic_udp_sock_head(net, port);
+	hlist_for_each_entry(us, &head->head, node) {
+		if (net != sock_net(us->sk))
+			continue;
+		if (a) {
+			if (quic_cmp_sk_addr(us->sk, &us->addr, a))
+				return us;
+			continue;
+		}
+		if (ntohs(us->addr.v4.sin_port) == port)
+			return us;
+	}
+	return NULL;
+}
+
+/* Binds a QUIC path to a local port and sets up a UDP socket. */
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	union quic_addr *a = quic_path_saddr(paths, path);
+	int rover, low, high, remaining;
+	struct net *net = sock_net(sk);
+	struct quic_hash_head *head;
+	struct quic_udp_sock *us;
+	u16 port;
+
+	port = ntohs(a->v4.sin_port);
+	if (port) {
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->m_lock);
+		us = quic_udp_sock_lookup(sk, a, port);
+		if (!quic_udp_sock_get(us)) {
+			us = quic_udp_sock_create(sk, a);
+			if (!us) {
+				mutex_unlock(&head->m_lock);
+				return -EINVAL;
+			}
+		}
+		mutex_unlock(&head->m_lock);
+
+		quic_udp_sock_put(paths->path[path].udp_sk);
+		paths->path[path].udp_sk = us;
+		return 0;
+	}
+
+	inet_get_local_port_range(net, &low, &high);
+	remaining = (high - low) + 1;
+	rover = (int)(((u64)get_random_u32() * remaining) >> 32) + low;
+	do {
+		rover++;
+		if (rover < low || rover > high)
+			rover = low;
+		port = (u16)rover;
+		if (inet_is_local_reserved_port(net, port))
+			continue;
+
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->m_lock);
+		if (quic_udp_sock_lookup(sk, NULL, port)) {
+			mutex_unlock(&head->m_lock);
+			cond_resched();
+			continue;
+		}
+		a->v4.sin_port = htons(port);
+		us = quic_udp_sock_create(sk, a);
+		if (!us) {
+			a->v4.sin_port = 0;
+			mutex_unlock(&head->m_lock);
+			return -EINVAL;
+		}
+		mutex_unlock(&head->m_lock);
+
+		quic_udp_sock_put(paths->path[path].udp_sk);
+		paths->path[path].udp_sk = us;
+		__sk_dst_reset(sk);
+		return 0;
+	} while (--remaining > 0);
+
+	return -EADDRINUSE;
+}
+
+/* Swaps the active and alternate QUIC paths.
+ *
+ * Promotes the alternate path (path[1]) to become the new active path (path[0]).  If the
+ * alternate path has a valid UDP socket, the entire path is swapped.  Otherwise, only the
+ * destination address is exchanged, assuming the source address is the same and no rebind is
+ * needed.
+ *
+ * This is typically used during path migration or alternate path promotion.
+ */
+void quic_path_swap(struct quic_path_group *paths)
+{
+	struct quic_path path = paths->path[0];
+
+	paths->alt_probes = 0;
+	paths->alt_state = QUIC_PATH_ALT_SWAPPED;
+
+	if (paths->path[1].udp_sk) {
+		paths->path[0] = paths->path[1];
+		paths->path[1] = path;
+		return;
+	}
+
+	paths->path[0].daddr = paths->path[1].daddr;
+	paths->path[1].daddr = path.daddr;
+}
+
+/* Frees resources associated with a QUIC path.
+ *
+ * This is used for cleanup during error handling or when the path is no longer needed.
+ */
+void quic_path_free(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	paths->alt_probes = 0;
+	paths->alt_state = QUIC_PATH_ALT_NONE;
+
+	quic_udp_sock_put(paths->path[path].udp_sk);
+	paths->path[path].udp_sk = NULL;
+	memset(quic_path_daddr(paths, path), 0, sizeof(union quic_addr));
+	memset(quic_path_saddr(paths, path), 0, sizeof(union quic_addr));
+}
+
+/* Detects and records a potential alternate path.
+ *
+ * If the new source or destination address differs from the active path, and alternate path
+ * detection is not disabled, the function pdates the alternate path slot (path[1]) with the
+ * new addresses.
+ *
+ * This is typically called on packet receive to detect new possible network paths (e.g., NAT
+ * rebinding, mobility).
+ *
+ * Returns 1 if a new alternate path was detected and updated, 0 otherwise.
+ */
+int quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa, union quic_addr *da,
+			 struct sock *sk)
+{
+	if ((!quic_cmp_sk_addr(sk, quic_path_saddr(paths, 0), sa) && !paths->disable_saddr_alt) ||
+	    (!quic_cmp_sk_addr(sk, quic_path_daddr(paths, 0), da) && !paths->disable_daddr_alt)) {
+		if (!quic_path_saddr(paths, 1)->v4.sin_port)
+			quic_path_set_saddr(paths, 1, sa);
+
+		if (!quic_cmp_sk_addr(sk, quic_path_saddr(paths, 1), sa))
+			return 0;
+
+		if (!quic_path_daddr(paths, 1)->v4.sin_port)
+			quic_path_set_daddr(paths, 1, da);
+
+		return quic_cmp_sk_addr(sk, quic_path_daddr(paths, 1), da);
+	}
+	return 0;
+}
+
+void quic_path_get_param(struct quic_path_group *paths, struct quic_transport_param *p)
+{
+	if (p->remote) {
+		p->disable_active_migration = paths->disable_saddr_alt;
+		return;
+	}
+	p->disable_active_migration = paths->disable_daddr_alt;
+}
+
+void quic_path_set_param(struct quic_path_group *paths, struct quic_transport_param *p)
+{
+	if (p->remote) {
+		paths->disable_saddr_alt = p->disable_active_migration;
+		return;
+	}
+	paths->disable_daddr_alt = p->disable_active_migration;
+}
+
+/* State Machine defined in rfc8899#section-5.2 */
+enum quic_plpmtud_state {
+	QUIC_PL_DISABLED,
+	QUIC_PL_BASE,
+	QUIC_PL_SEARCH,
+	QUIC_PL_COMPLETE,
+	QUIC_PL_ERROR,
+};
+
+#define QUIC_BASE_PLPMTU        1200
+#define QUIC_MAX_PLPMTU         9000
+#define QUIC_MIN_PLPMTU         512
+
+#define QUIC_MAX_PROBES         3
+
+#define QUIC_PL_BIG_STEP        32
+#define QUIC_PL_MIN_STEP        4
+
+/* Handle PLPMTUD probe failure on a QUIC path.
+ *
+ * Called immediately after sending a probe packet in QUIC Path MTU Discovery.  Tracks probe
+ * count and manages state transitions based on the number of probes sent and current PLPMTUD
+ * state (BASE, SEARCH, COMPLETE, ERROR).  Detects probe failures and black holes, adjusting
+ * PMTU and probe sizes accordingly.
+ *
+ * Return: New PMTU value if updated, else 0.
+ */
+u32 quic_path_pl_send(struct quic_path_group *paths, s64 number)
+{
+	u32 pathmtu = 0;
+
+	paths->pl.number = number;
+	if (paths->pl.probe_count < QUIC_MAX_PROBES)
+		goto out;
+
+	paths->pl.probe_count = 0;
+	if (paths->pl.state == QUIC_PL_BASE) {
+		if (paths->pl.probe_size == QUIC_BASE_PLPMTU) { /* BASE_PLPMTU Confirming Failed */
+			paths->pl.state = QUIC_PL_ERROR; /* Base -> Error */
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (paths->pl.pmtu == paths->pl.probe_size) { /* Black Hole Detected */
+			paths->pl.state = QUIC_PL_BASE;  /* Search -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_high = 0;
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		} else { /* Normal probe failure. */
+			paths->pl.probe_high = paths->pl.probe_size;
+			paths->pl.probe_size = paths->pl.pmtu;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		if (paths->pl.pmtu == paths->pl.probe_size) { /* Black Hole Detected */
+			paths->pl.state = QUIC_PL_BASE;  /* Search Complete -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	}
+
+out:
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n", __func__, paths,
+		 paths->pl.state, paths->pl.pmtu, paths->pl.probe_size, paths->pl.probe_high);
+	paths->pl.probe_count++;
+	return pathmtu;
+}
+
+/* Handle successful reception of a PMTU probe.
+ *
+ * Called when a probe packet is acknowledged. Updates probe size and transitions state if
+ * needed (e.g., from SEARCH to COMPLETE).  Expands PMTU using binary or linear search
+ * depending on state.
+ *
+ * Return: New PMTU to apply if search completes, or 0 if no change.
+ */
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer, bool *complete)
+{
+	u32 pathmtu = 0;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n", __func__, paths,
+		 paths->pl.state, paths->pl.pmtu, paths->pl.probe_size, paths->pl.probe_high);
+
+	*raise_timer = false;
+	paths->pl.number = 0;
+	paths->pl.pmtu = paths->pl.probe_size;
+	paths->pl.probe_count = 0;
+	if (paths->pl.state == QUIC_PL_BASE) {
+		paths->pl.state = QUIC_PL_SEARCH; /* Base -> Search */
+		paths->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (paths->pl.state == QUIC_PL_ERROR) {
+		paths->pl.state = QUIC_PL_SEARCH; /* Error -> Search */
+
+		paths->pl.pmtu = paths->pl.probe_size;
+		pathmtu = (u32)paths->pl.pmtu;
+		paths->pl.probe_size += QUIC_PL_BIG_STEP;
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (!paths->pl.probe_high) {
+			if (paths->pl.probe_size < QUIC_MAX_PLPMTU) {
+				paths->pl.probe_size =
+					(u16)min(paths->pl.probe_size + QUIC_PL_BIG_STEP,
+						 QUIC_MAX_PLPMTU);
+				*complete = false;
+				return pathmtu;
+			}
+			paths->pl.probe_high = QUIC_MAX_PLPMTU;
+		}
+		paths->pl.probe_size += QUIC_PL_MIN_STEP;
+		if (paths->pl.probe_size >= paths->pl.probe_high) {
+			paths->pl.probe_high = 0;
+			paths->pl.state = QUIC_PL_COMPLETE; /* Search -> Search Complete */
+
+			paths->pl.probe_size = paths->pl.pmtu;
+			pathmtu = (u32)paths->pl.pmtu;
+			*raise_timer = true;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		/* Raise probe_size again after 30 * interval in Search Complete */
+		paths->pl.state = QUIC_PL_SEARCH; /* Search Complete -> Search */
+		paths->pl.probe_size = (u16)min(paths->pl.probe_size + QUIC_PL_MIN_STEP,
+						QUIC_MAX_PLPMTU);
+	}
+
+	*complete = (paths->pl.state == QUIC_PL_COMPLETE);
+	return pathmtu;
+}
+
+/* Handle ICMP "Packet Too Big" messages.
+ *
+ * Responds to an incoming ICMP error by reducing the probe size or falling back to a safe
+ * baseline PMTU depending on current state.  Also handles cases where the PMTU hint lies
+ * between probe and current PMTU.
+ *
+ * Return: New PMTU to apply if state changes, or 0 if no change.
+ */
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu, bool *reset_timer)
+{
+	u32 pathmtu = 0;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n", __func__, paths,
+		 paths->pl.state, paths->pl.pmtu, paths->pl.probe_size, pmtu);
+
+	*reset_timer = false;
+	if (pmtu < QUIC_MIN_PLPMTU || pmtu >= (u32)paths->pl.probe_size)
+		return pathmtu;
+
+	if (paths->pl.state == QUIC_PL_BASE) {
+		if (pmtu >= QUIC_MIN_PLPMTU && pmtu < QUIC_BASE_PLPMTU) {
+			paths->pl.state = QUIC_PL_ERROR; /* Base -> Error */
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < (u32)paths->pl.pmtu) {
+			paths->pl.state = QUIC_PL_BASE;  /* Search -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_count = 0;
+
+			paths->pl.probe_high = 0;
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		} else if (pmtu > (u32)paths->pl.pmtu && pmtu < (u32)paths->pl.probe_size) {
+			paths->pl.probe_size = (u16)pmtu;
+			paths->pl.probe_count = 0;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		if (pmtu >= QUIC_BASE_PLPMTU && pmtu < (u32)paths->pl.pmtu) {
+			paths->pl.state = QUIC_PL_BASE;  /* Complete -> Base */
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+			paths->pl.probe_count = 0;
+
+			paths->pl.probe_high = 0;
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+			*reset_timer = true;
+		}
+	}
+	return pathmtu;
+}
+
+/* Reset PLPMTUD state for a path.
+ *
+ * Resets all PLPMTUD-related state to its initial configuration.  Called when a new path is
+ * initialized or when recovering from errors.
+ */
+void quic_path_pl_reset(struct quic_path_group *paths)
+{
+	paths->pl.number = 0;
+	paths->pl.state = QUIC_PL_BASE;
+	paths->pl.pmtu = QUIC_BASE_PLPMTU;
+	paths->pl.probe_size = QUIC_BASE_PLPMTU;
+}
+
+/* Check if a packet number confirms PLPMTUD probe.
+ *
+ * Checks whether the last probe (tracked by .number) has been acknowledged.  If the probe
+ * number lies within the ACK range, confirmation is successful.
+ *
+ * Return: true if probe is confirmed, false otherwise.
+ */
+bool quic_path_pl_confirm(struct quic_path_group *paths, s64 largest, s64 smallest)
+{
+	return paths->pl.number && paths->pl.number >= smallest && paths->pl.number <= largest;
+}
+
+int quic_path_init(int (*rcv)(struct sk_buff *skb, u8 err))
+{
+	quic_wq = create_workqueue("quic_workqueue");
+	if (!quic_wq)
+		return -ENOMEM;
+
+	quic_path_rcv = rcv;
+	return 0;
+}
+
+void quic_path_destroy(void)
+{
+	destroy_workqueue(quic_wq);
+}
diff --git a/net/quic/path.h b/net/quic/path.h
new file mode 100644
index 000000000000..a1d0370bf281
--- /dev/null
+++ b/net/quic/path.h
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
+#define QUIC_PATH_MIN_PMTU	1200U
+#define QUIC_PATH_MAX_PMTU	65536U
+
+#define QUIC_MIN_UDP_PAYLOAD	1200
+#define QUIC_MAX_UDP_PAYLOAD	65527
+
+#define QUIC_PATH_ENTROPY_LEN	8
+
+/* Connection Migration State Machine:
+ *
+ * +--------+      recv non-probing, free old path    +----------+
+ * |  NONE  | <-------------------------------------- | SWAPPED  |
+ * +--------+                                         +----------+
+ *      |   ^ \                                            ^
+ *      |    \ \                                           |
+ *      |     \ \   new path detected,                     | recv
+ *      |      \ \  has another DCID,                      | Path
+ *      |       \ \ snd Path Challenge                     | Response
+ *      |        \ -------------------------------         |
+ *      |         ------------------------------- \        |
+ *      | new path detected,            Path     \ \       |
+ *      | has no other DCID,            Challenge \ \      |
+ *      | request a new DCID            failed     \ \     |
+ *      v                                           \ v    |
+ * +----------+                                       +----------+
+ * | PENDING  | ------------------------------------> | PROBING  |
+ * +----------+  recv a new DCID, snd Path Challenge  +----------+
+ */
+enum {
+	QUIC_PATH_ALT_NONE,	/* No alternate path (migration complete or aborted) */
+	QUIC_PATH_ALT_PENDING,	/* Waiting for a new destination CID for migration */
+	QUIC_PATH_ALT_PROBING,	/* Validating the alternate path (PATH_CHALLENGE) */
+	QUIC_PATH_ALT_SWAPPED,	/* Alternate path is now active; roles swapped */
+};
+
+struct quic_udp_sock {
+	struct work_struct work;	/* Workqueue to destroy UDP tunnel socket */
+	struct hlist_node node;		/* Entry in address-based UDP socket hash table */
+	union quic_addr addr;
+	refcount_t refcnt;
+	struct sock *sk;		/* Underlying UDP tunnel socket */
+};
+
+struct quic_path {
+	union quic_addr daddr;		/* Destination address */
+	union quic_addr saddr;		/* Source address */
+	struct quic_udp_sock *udp_sk;	/* Wrapped UDP socket used to receive QUIC packets */
+};
+
+struct quic_path_group {
+	/* Connection ID validation during handshake (rfc9000#section-7.3) */
+	struct quic_conn_id retry_dcid;		/* Source CID from Retry packet */
+	struct quic_conn_id orig_dcid;		/* Destination CID from first Initial */
+
+	/* Path validation (rfc9000#section-8.2) */
+	u8 entropy[QUIC_PATH_ENTROPY_LEN];	/* Entropy for PATH_CHALLENGE */
+	struct quic_path path[2];		/* Active path (0) and alternate path (1) */
+	struct flowi fl;			/* Flow info from routing decisions */
+
+	/* Anti-amplification limit (rfc9000#section-8) */
+	u16 ampl_sndlen;	/* Bytes sent before address is validated */
+	u16 ampl_rcvlen;	/* Bytes received to lift amplification limit */
+
+	/* MTU discovery handling */
+	u32 mtu_info;		/* PMTU value from received ICMP, pending apply */
+	struct {		/* PLPMTUD probing (rfc8899) */
+		s64 number;	/* Packet number used for current probe */
+		u16 pmtu;	/* Confirmed path MTU */
+
+		u16 probe_size;	/* Current probe packet size */
+		u16 probe_high;	/* Highest failed probe size */
+		u8 probe_count;	/* Retry count for current probe_size */
+		u8 state;	/* Probe state machine (rfc8899#section-5.2) */
+	} pl;
+
+	/* Connection Migration (rfc9000#section-9) */
+	u8 disable_saddr_alt:1;	/* Remote disable_active_migration (rfc9000#section-18.2) */
+	u8 disable_daddr_alt:1;	/* Local disable_active_migration (rfc9000#section-18.2) */
+	u8 pref_addr:1;		/* Preferred address offered (rfc9000#section-18.2) */
+	u8 alt_probes;		/* Number of PATH_CHALLENGE probes sent */
+	u8 alt_state;		/* State for alternate path migration logic (see above) */
+
+	u8 ecn_probes;		/* ECN probe counter */
+	u8 validated:1;		/* Path validated with PATH_RESPONSE */
+	u8 blocked:1;		/* Blocked by anti-amplification limit */
+	u8 retry:1;		/* Retry used in initial packet */
+	u8 serv:1;		/* Indicates server side */
+};
+
+static inline union quic_addr *quic_path_saddr(struct quic_path_group *paths, u8 path)
+{
+	return &paths->path[path].saddr;
+}
+
+static inline void quic_path_set_saddr(struct quic_path_group *paths, u8 path,
+				       union quic_addr *addr)
+{
+	memcpy(quic_path_saddr(paths, path), addr, sizeof(*addr));
+}
+
+static inline union quic_addr *quic_path_daddr(struct quic_path_group *paths, u8 path)
+{
+	return &paths->path[path].daddr;
+}
+
+static inline void quic_path_set_daddr(struct quic_path_group *paths, u8 path,
+				       union quic_addr *addr)
+{
+	memcpy(quic_path_daddr(paths, path), addr, sizeof(*addr));
+}
+
+static inline union quic_addr *quic_path_uaddr(struct quic_path_group *paths, u8 path)
+{
+	return &paths->path[path].udp_sk->addr;
+}
+
+static inline bool quic_path_alt_state(struct quic_path_group *paths, u8 state)
+{
+	return paths->alt_state == state;
+}
+
+static inline void quic_path_set_alt_state(struct quic_path_group *paths, u8 state)
+{
+	paths->alt_state = state;
+}
+
+/* Returns the destination Connection ID (DCID) used for identifying the connection.
+ * Per rfc9000#section-7.3, handshake packets are considered part of the same connection
+ * if their DCID matches the one returned here.
+ */
+static inline struct quic_conn_id *quic_path_orig_dcid(struct quic_path_group *paths)
+{
+	return paths->retry ? &paths->retry_dcid : &paths->orig_dcid;
+}
+
+int quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa, union quic_addr *da,
+			 struct sock *sk);
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_free(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_swap(struct quic_path_group *paths);
+
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer, bool *complete);
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu, bool *reset_timer);
+u32 quic_path_pl_send(struct quic_path_group *paths, s64 number);
+
+void quic_path_get_param(struct quic_path_group *paths, struct quic_transport_param *p);
+void quic_path_set_param(struct quic_path_group *paths, struct quic_transport_param *p);
+bool quic_path_pl_confirm(struct quic_path_group *paths, s64 largest, s64 smallest);
+void quic_path_pl_reset(struct quic_path_group *paths);
+
+int quic_path_init(int (*rcv)(struct sk_buff *skb, u8 err));
+void quic_path_destroy(void);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index f03e19c6f73c..5fe0a83c63ba 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -61,6 +61,9 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_path_free(sk, quic_paths(sk), 0);
+	quic_path_free(sk, quic_paths(sk), 1);
+
 	quic_conn_id_set_free(quic_source(sk));
 	quic_conn_id_set_free(quic_dest(sk));
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 20101de43638..1471c525a871 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -18,6 +18,7 @@
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
+#include "path.h"
 
 #include "protocol.h"
 
@@ -43,6 +44,7 @@ struct quic_sock {
 	struct quic_stream_table	streams;
 	struct quic_conn_id_set		source;
 	struct quic_conn_id_set		dest;
+	struct quic_path_group		paths;
 };
 
 struct quic6_sock {
@@ -95,6 +97,16 @@ static inline struct quic_conn_id_set *quic_dest(const struct sock *sk)
 	return &quic_sk(sk)->dest;
 }
 
+static inline struct quic_path_group *quic_paths(const struct sock *sk)
+{
+	return &quic_sk(sk)->paths;
+}
+
+static inline bool quic_is_serv(const struct sock *sk)
+{
+	return quic_paths(sk)->serv;
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
@@ -118,14 +130,19 @@ static inline bool quic_is_closed(struct sock *sk)
 static inline void quic_set_state(struct sock *sk, int state)
 {
 	struct net *net = sock_net(sk);
+	int mib;
 
 	if (sk->sk_state == state)
 		return;
 
-	if (state == QUIC_SS_ESTABLISHED)
+	if (state == QUIC_SS_ESTABLISHED) {
+		mib = quic_is_serv(sk) ? QUIC_MIB_CONN_PASSIVEESTABS
+				       : QUIC_MIB_CONN_ACTIVEESTABS;
+		QUIC_INC_STATS(net, mib);
 		QUIC_INC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
-	else if (quic_is_established(sk))
+	} else if (quic_is_established(sk)) {
 		QUIC_DEC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
+	}
 
 	if (state == QUIC_SS_CLOSED)
 		sk->sk_prot->unhash(sk);
-- 
2.47.1

