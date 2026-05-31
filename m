Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D78438C402
	for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233094; cv=none; b=FN9lA74kE1TvTS0ZOnPdfWnzcfAByfgpsFSPNCP/NqBkDV1yUE86HjETyQTBlt8R0m8fKz9buV7f3fKtTOPp8Bm4dKPqFiMPUNTN22xDQkOQma6S/gXv66LbOryi+fX9743zKSqaUNR6Si7EMoeNkVIV6rnjrXuUrRPYppD7Mp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233094; c=relaxed/simple;
	bh=/pw4OteC/QAvN7tcAUS4FHe10XWK//WEZbR+xm3N3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOPCfE3vvOeGB2Tm+jDbIxtBce1JHgDKQY98bRDM8ymSQoJGmdRFaBOBE5sQZafo7EaLNShtHMxer9BQuO7Yp80P/WyjAFS79pZ2ZXqS45XE6N4yfOrEAA0q0SaQY4KJbzbjSfwmtKsJL9TLQ3AjhSkLcY91Dfdf4iezHewKMYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nI2cieH1; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nI2cieH1"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccf7b7d188so12890046d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780233090; x=1780837890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSkuyeq44vaZhegpxll4olfxPrhn6DN776emu7bQN1c=;
        b=nI2cieH129wwBhGg6Nyl594QOpGDWle04GNs2rWau6UqYXMD6YQlYvGqKB7iOmB6PJ
         i5Dqz2a6ltrLpybmosPkmuE6R/EOe7eDVdP3RQXjY4bnUSgHCIqWxMvQfO73/egHOqBb
         +8mA6jXNt/oLJsFlP7RB3qB26iiwBxzcw9YetKI7oBtyHAcQT3dUbjrjXS12VLc8qL70
         ffyxE7+9EAIAHCCKcbE+UOCYVjdj45DIkN2kfY/L4xkrPyzWQeO2deMqSlBUTdsTLCn2
         snqgW7EUdo2ccSiWi/8dcwchaY64Z0nZoaFiY2crEP3kfzrCzphm7iKOkJl0j/94wX4T
         RmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780233090; x=1780837890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xSkuyeq44vaZhegpxll4olfxPrhn6DN776emu7bQN1c=;
        b=VYVAxe12/3Bmn3rqZO8oPM92HRxj78KYL/UrJY5P3Usv1I0j9qV5d6M4PRxK2Xtv9Y
         wjCioUwgrsCzDBoKRGmbARF9CaFAR7/we6AOVe86kZXGiJ1oSNPX/htSjGgWuJf41grx
         WrGhNfKhk8cElmNJpHau4s7ddpNpV/+3m5t+cPEcVSxN4FNNNE1KDjj/AtnjeOImqOaf
         X07JWisUrN+c3ECQdaWSfS2lXr1GMrLzbs4HPcTaMvmb04RnRUdLBZdT167Vuiuj5b6L
         jrq5WotrOOO2ycMa1qTBIXyeVDK8CKedjDDMpHjdqR1hVe0m4VkwIpOllJ2neHK/s45f
         BiGw==
X-Forwarded-Encrypted: i=1; AFNElJ//kZ1/BC4yKGltTwExu4rj4W//MH7XlBJSmE5DbZ7TfNCv1zhZ7658s7i0lWbWhi89OjkZYXkel5hO@vger.kernel.org
X-Gm-Message-State: AOJu0YzzlbFYW7Y+VPWZqsJM3Q/cnQffVrczXCreR7isKaAtKszk9PoZ
	bgIIuZoGWAfTz/9Lvk933zo8G91LwpUidfPBKE4Lb4705LqK+2TzZ+EI
X-Gm-Gg: Acq92OHcx4D4yU412/2MwpegGRotej7Sb6qC06bGgRFH+UjneuaTUav+LFA+osWFAvg
	/Mmf8orPkpay8APtY28602aeOIZNgBCMHIX6sTf62tqmszz77B9vSFM2oarMj/qQok3qo8mM0qC
	pK1/Ls+vf1E4lpdgEECAOaaizJETiWSbSlY9Pf6Ji1dnnQLUaMqmQeBJkIFLlsGuVWxnMcNiuRk
	Awwv7LA9Xe/QsoFRwrX0FEFO9GIHwqtcuropv6RpQm/ErkkosAkMWZ7iYYTr3IgEt/JrUQBs/+G
	+sqtNQJZ+efGhfEk2mdKHPuPsqzfnLZQScvSb34OfAy5YOXRYHKIp/8+jWsaavpUZOHwgH/de9k
	3GMpbtuMqO4lwliIgo85m7icaz/qvfDnMKSr4NQgeULk3MkgC8M/Cgbe2icvwK8lzfyYmIRcVwH
	k4lZhuzLBFTnkNWP++Fo0oNTvzpXwoPi49Gz3613gn1sKTVysBZD0e6Fer6Wn79YfIMfVwoTpW2
	8Yoby4+TGLmZhWgFmJRzd/eAvJZOUPH4iNTd5F0JexmrKOUEKceF7XlkGpOjZIIA4j3xMS0dTsI
	xel6e4UvB7o=
X-Received: by 2002:a05:6214:488b:b0:8cc:f135:52aa with SMTP id 6a1803df08f44-8ccf1355523mr76862706d6.21.1780233089973;
        Sun, 31 May 2026 06:11:29 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea2163b0sm69609746d6.38.2026.05.31.06.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:11:28 -0700 (PDT)
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
Subject: [PATCH net-next v12 08/15] quic: add path management
Date: Sun, 31 May 2026 09:08:44 -0400
Message-ID: <4f88c87ea7b3649530b75f6caf80220984ba2660.1780232931.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1780232930.git.lucien.xin@gmail.com>
References: <cover.1780232930.git.lucien.xin@gmail.com>
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

- quic_path_unbind(): Unbind a path from a port and disassociate it from a
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
v3:
  - Fix annotation in quic_udp_sock_lookup() (noted by Paolo).
  - Use inet_sk_get_local_port_range() instead of
    inet_get_local_port_range() (suggested by Paolo).
  - Adjust global UDP tunnel socket hashtable operations for the new
    hashtable type.
  - Delete quic_workqueue; use system_wq for UDP tunnel socket destroy.
v4:
  - Cache UDP tunnel socket pointer and its source address in struct
    quic_path for RCU-protected lookup/access.
  - Return -EAGAIN instead of -EINVAL in quic_path_bind() when UDP
    socket is being released in workqueue.
  - Move udp_tunnel_sock_release() out of the mutex_lock to avoid a
    warning of lockdep in quic_udp_sock_put_work().
  - Introduce quic_wq for UDP socket release work, so all pending works
    can be flushed before destroying the hashtable in quic_exit().
v5:
  - Rename quic_path_free() to quic_path_unbind() (suggested by Paolo).
  - Remove the 'serv' member from struct quic_path_group, since
    quic_is_serv() defined in a previous patch now uses
    sk->sk_max_ack_backlog for server-side detection.
  - Use quic_ktime_get_us() to set skb_cb->time, as RTT is measured
    in microseconds and jiffies_to_usecs() is not accurate enough.
v6:
  - Do not reset transport_header for QUIC in quic_udp_rcv(), allowing
    removal of udph_offset and enabling access to the UDP header via
    udp_hdr(); Pull skb->data in quic_udp_rcv() to allow access to the
    QUIC header via skb->data.
v7:
  - Pass udp sk to quic_path_rcv() and move the call to skb_linearize()
    and skb_set_owner_sk_safe() to .quic_path_rcv().
  - Delete the call to skb_linearize() and skb_set_owner_sk_safe() from
    quic_udp_err(), as it should not change skb in .encap_err_lookup()
    (noted by AI review).
v8:
  - Remove indirect quic_path_rcv and late call quic_packet_rcv()
    directly via extern (noted by Paolo).
  - Add a comment in quic_udp_rcv() clarifying it must return 0.
  - Add a comment in quic_udp_sock_put() clarifying the UDP socket
    may be freed in atomic RX context during connection migration.
  - Reorder some quic_path_group members to reduce struct size.
v10:
  - Replace open-coded kzalloc(sizeof(*us)) with kzalloc_obj(*us) in
    quic_stream_create().
  - Use get_random_u32_below() for ephemeral port selection instead of
    manual scaling of get_random_u32() in quic_path_bind().
  - Reset additional PLPMTUD probe state (probe_high, probe_count) in
    quic_path_pl_reset() to ensure a clean probe restart.
  - Add plpmtud_interval to struct quic_path_group to store the PLPMTUD
    probe timer interval, previously kept in struct quic_sock.config.
v11:
  - Set maximum line length to 80 characters.
  - Add additional comments in quic_path_bind() and quic_path_pl_send()
    for clarity.
  - Return ERR_PTR() instead of NULL on error in quic_udp_sock_create().
  - Change return type of quic_path_detect_alt() to bool.
  - Allocate quic_wq using alloc_workqueue(WQ_MEM_RECLAIM | WQ_UNBOUND)
    for UDP socket destruction and backlog packet processing (noted by
    AI review).
v12:
  - Call quic_set_skb_iif() at the start of quic_udp_rcv().
  - Set us->bind_ifindex from udp_conf.bind_ifindex instead of
    sk->sk_bound_dev_if in quic_udp_sock_create().
  - Compare us->bind_ifindex against quic_get_dev_if(sk, a) instead of
    sk->sk_bound_dev_if, and do not match when only one is zero in
    quic_udp_sock_lookup().
  - Call cond_resched() in the retry loop of quic_path_bind() when
    quic_udp_sock_create() returns -EADDRINUSE.
  - Improve address-change handling and disable_saddr/daddr_alt checks
    in quic_path_detect_alt().
  - Do not pass WQ_MEM_RECLAIM to alloc_workqueue() to avoid a potential
    deadlock.
  - Change ampl_snd/rcvlen in struct quic_path_group to u32 to avoid
    overflow, and move mtu_info for a better layout.
  - Add keepalive_interval to struct quic_path_group to control path
    liveness probing, and add version to indicate version negotiation
    was performed.
  - Pass sk instead of sk_socket to setup_udp_tunnel_sock() and
    udp_tunnel_sock_release(), following their parameter type changes.
  - Set bit fields paths->disable_saddr_alt and paths->disable_daddr_alt
    from p->disable_active_migration using '!!'.
  - Add QUIC_PMTUD_RAISE_TIMER_FACTOR for later use.
  - Change QUIC_PATH_MAX_PMTU from 65536U to 65535U.
---
 net/quic/Makefile   |   2 +-
 net/quic/path.c     | 568 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/path.h     | 188 +++++++++++++++
 net/quic/protocol.c |  14 ++
 net/quic/socket.c   |   3 +
 net/quic/socket.h   |   7 +
 6 files changed, 781 insertions(+), 1 deletion(-)
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
index 000000000000..f21b424c54d1
--- /dev/null
+++ b/net/quic/path.c
@@ -0,0 +1,568 @@
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
+static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	quic_set_skb_iif(skb);
+
+	memset(skb->cb, 0, sizeof(skb->cb));
+	QUIC_SKB_CB(skb)->seqno = -1;
+	QUIC_SKB_CB(skb)->time = quic_ktime_get_us();
+
+	skb_pull(skb, sizeof(struct udphdr));
+	skb_dst_force(skb);
+	kfree_skb(skb);
+	/* .encap_rcv must return 0 if skb was either consumed or dropped. */
+	return 0;
+}
+
+static int quic_udp_err(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
+
+static void quic_udp_sock_put_work(struct work_struct *work)
+{
+	struct quic_udp_sock *us = container_of(work, struct quic_udp_sock,
+						work);
+	struct quic_uhash_head *head;
+	struct sock *sk = us->sk;
+
+	/* Hold the sock to safely access it in quic_udp_sock_lookup() even
+	 * after udp_tunnel_sock_release(). The release must occur before
+	 * __hlist_del() so a new UDP tunnel socket can be created for the same
+	 * address and port if quic_udp_sock_lookup() fails to find one.
+	 *
+	 * Note: udp_tunnel_sock_release() cannot be called under the mutex due
+	 * to some lockdep warnings.
+	 */
+	sock_hold(sk);
+	udp_tunnel_sock_release(sk);
+
+	head = quic_udp_sock_head(sock_net(sk), ntohs(us->addr.v4.sin_port));
+	mutex_lock(&head->lock);
+	__hlist_del(&us->node);
+	mutex_unlock(&head->lock);
+
+	sock_put(sk);
+	kfree(us);
+}
+
+static struct quic_udp_sock *quic_udp_sock_create(struct sock *sk,
+						  union quic_addr *a)
+{
+	struct udp_tunnel_sock_cfg tuncfg = {};
+	struct udp_port_cfg udp_conf = {};
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+	struct socket *sock;
+	int err;
+
+	us = kzalloc_obj(*us, GFP_KERNEL);
+	if (!us)
+		return ERR_PTR(-ENOMEM);
+
+	quic_udp_conf_init(sk, &udp_conf, a);
+	err = udp_sock_create(net, &udp_conf, &sock);
+	if (err) {
+		pr_debug("%s: failed to create udp sock\n", __func__);
+		kfree(us);
+		return ERR_PTR(err);
+	}
+
+	tuncfg.encap_type = 1;
+	tuncfg.encap_rcv = quic_udp_rcv;
+	tuncfg.encap_err_lookup = quic_udp_err;
+	setup_udp_tunnel_sock(net, sock->sk, &tuncfg);
+
+	refcount_set(&us->refcnt, 1);
+	us->sk = sock->sk;
+	memcpy(&us->addr, a, sizeof(*a));
+	us->bind_ifindex = udp_conf.bind_ifindex;
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
+	return refcount_inc_not_zero(&us->refcnt);
+}
+
+static void quic_udp_sock_put(struct quic_udp_sock *us)
+{
+	/* The UDP socket may be freed in atomic RX context during connection
+	 * migration; defer the release to a workqueue.
+	 */
+	if (refcount_dec_and_test(&us->refcnt))
+		queue_work(quic_wq, &us->work);
+}
+
+/* Lookup a quic_udp_sock in the global hash table by port or address.  If 'a'
+ * is provided, it searches for a socket whose local address matches 'a' and,
+ * if applicable, matches the device binding. If 'a' is NULL, it searches only
+ * by port.
+ */
+static struct quic_udp_sock *quic_udp_sock_lookup(struct sock *sk,
+						  union quic_addr *a, u16 port)
+{
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+
+	head = quic_udp_sock_head(net, port);
+	hlist_for_each_entry(us, &head->head, node) {
+		if (net != sock_net(us->sk))
+			continue;
+		if (a) {
+			if (quic_cmp_sk_addr(us->sk, &us->addr, a) &&
+			    us->bind_ifindex == quic_get_dev_if(sk, a))
+				return us;
+			continue;
+		}
+		if (ntohs(us->addr.v4.sin_port) == port)
+			return us;
+	}
+	return NULL;
+}
+
+static void quic_path_set_udp_sk(struct quic_path *path,
+				 struct quic_udp_sock *us)
+{
+	if (path->udp_sk)
+		quic_udp_sock_put(path->udp_sk);
+
+	path->udp_sk = us;
+	if (!us) {
+		path->usk = NULL;
+		memset(&path->uaddr, 0, sizeof(path->uaddr));
+		return;
+	}
+	path->usk = us->sk;
+	memcpy(&path->uaddr, &us->addr, sizeof(us->addr));
+}
+
+/* Binds a QUIC path to a local port and sets up a UDP socket. */
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	union quic_addr *a = quic_path_saddr(paths, path);
+	int rover, low, high, remaining;
+	struct net *net = sock_net(sk);
+	struct quic_uhash_head *head;
+	struct quic_udp_sock *us;
+	u16 port;
+
+	port = ntohs(a->v4.sin_port);
+	if (port) {
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->lock);
+		us = quic_udp_sock_lookup(sk, a, port);
+		if (us) {
+			/* Allow reuse of an existing UDP tunnel socket.
+			 * However, if it is in the middle of asynchronous
+			 * teardown (via workqueue), it is temporarily unusable.
+			 * Return -EAGAIN (not -EADDRINUSE) to signal the caller
+			 * to retry soon.
+			 */
+			if (!quic_udp_sock_get(us)) {
+				mutex_unlock(&head->lock);
+				return -EAGAIN;
+			}
+		} else {
+			us = quic_udp_sock_create(sk, a);
+			if (IS_ERR(us)) {
+				mutex_unlock(&head->lock);
+				return PTR_ERR(us);
+			}
+		}
+		mutex_unlock(&head->lock);
+		quic_path_set_udp_sk(&paths->path[path], us);
+		return 0;
+	}
+
+	inet_sk_get_local_port_range(sk, &low, &high);
+	remaining = (high - low) + 1;
+	rover = get_random_u32_below(remaining) + low;
+	do {
+		rover++;
+		if (rover < low || rover > high)
+			rover = low;
+		port = (u16)rover;
+		if (inet_is_local_reserved_port(net, port))
+			continue;
+
+		head = quic_udp_sock_head(net, port);
+		mutex_lock(&head->lock);
+		if (quic_udp_sock_lookup(sk, NULL, port)) {
+			mutex_unlock(&head->lock);
+			cond_resched();
+			continue;
+		}
+		a->v4.sin_port = htons(port);
+		us = quic_udp_sock_create(sk, a);
+		if (IS_ERR(us)) {
+			a->v4.sin_port = 0;
+			mutex_unlock(&head->lock);
+			if (PTR_ERR(us) == -EADDRINUSE) {
+				cond_resched();
+				continue;
+			}
+			return PTR_ERR(us);
+		}
+		mutex_unlock(&head->lock);
+
+		quic_path_set_udp_sk(&paths->path[path], us);
+		__sk_dst_reset(sk);
+		return 0;
+	} while (--remaining > 0);
+
+	return -EADDRINUSE;
+}
+
+/* Swaps the active and alternate QUIC paths.
+ *
+ * Promotes the alternate path (path[1]) to become the new active path
+ * (path[0]).  If the alternate path has a valid UDP socket, the entire path is
+ * swapped.  Otherwise, only the destination address is exchanged, assuming the
+ * source address is the same and no rebind is needed.
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
+ * This is used for cleanup during error handling or when the path is no longer
+ * needed.
+ */
+void quic_path_unbind(struct sock *sk, struct quic_path_group *paths, u8 path)
+{
+	paths->alt_probes = 0;
+	paths->alt_state = QUIC_PATH_ALT_NONE;
+
+	quic_path_set_udp_sk(&paths->path[path], NULL);
+
+	memset(quic_path_daddr(paths, path), 0, sizeof(union quic_addr));
+	memset(quic_path_saddr(paths, path), 0, sizeof(union quic_addr));
+}
+
+/* Detects and records a potential alternate path.
+ *
+ * If the new source or destination address differs from the active path, and
+ * alternate path detection is not disabled, the function updates the alternate
+ * path slot (path[1]) with the new addresses.
+ *
+ * This is typically called on packet receive to detect new possible network
+ * paths (e.g., NAT rebinding, mobility).
+ *
+ * Returns true if a new alternate path was detected and updated, false
+ * otherwise.
+ */
+bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
+			  union quic_addr *da, struct sock *sk)
+{
+	bool remote = !quic_cmp_sk_addr(sk, quic_path_daddr(paths, 0), da);
+	bool local = !quic_cmp_sk_addr(sk, quic_path_saddr(paths, 0), sa);
+
+	if (!local && !remote)
+		return false;
+
+	if ((local && paths->disable_saddr_alt) ||
+	    (remote && paths->disable_daddr_alt))
+		return false;
+
+	if (!quic_path_saddr(paths, 1)->v4.sin_port)
+		quic_path_set_saddr(paths, 1, sa);
+
+	if (!quic_cmp_sk_addr(sk, quic_path_saddr(paths, 1), sa))
+		return false;
+
+	if (!quic_path_daddr(paths, 1)->v4.sin_port)
+		quic_path_set_daddr(paths, 1, da);
+
+	return quic_cmp_sk_addr(sk, quic_path_daddr(paths, 1), da);
+}
+
+void quic_path_get_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p)
+{
+	if (p->remote) {
+		p->disable_active_migration = paths->disable_saddr_alt;
+		return;
+	}
+	p->disable_active_migration = paths->disable_daddr_alt;
+}
+
+void quic_path_set_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p)
+{
+	if (p->remote) {
+		paths->disable_saddr_alt = !!p->disable_active_migration;
+		return;
+	}
+	paths->disable_daddr_alt = !!p->disable_active_migration;
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
+ * Called immediately after sending a probe packet in QUIC Path MTU Discovery.
+ * Tracks probe count and manages state transitions based on the number of
+ * probes sent and current PLPMTUD state (BASE, SEARCH, COMPLETE, ERROR).
+ * Detects probe failures and black holes, adjusting PMTU and probe sizes
+ * accordingly.
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
+		if (paths->pl.probe_size == QUIC_BASE_PLPMTU) {
+			/* BASE_PLPMTU Confirming Failed: Base -> Error. */
+			paths->pl.state = QUIC_PL_ERROR;
+
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	} else if (paths->pl.state == QUIC_PL_SEARCH) {
+		if (paths->pl.pmtu == paths->pl.probe_size) {
+			/* Black Hole Detected: Search -> Base. */
+			paths->pl.state = QUIC_PL_BASE;
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
+		if (paths->pl.pmtu == paths->pl.probe_size) {
+			/* Black Hole Detected:  Search Complete -> Base. */
+			paths->pl.state = QUIC_PL_BASE;
+			paths->pl.probe_size = QUIC_BASE_PLPMTU;
+
+			/* probe_high already reset when entering COMPLETE. */
+			paths->pl.pmtu = QUIC_BASE_PLPMTU;
+			pathmtu = QUIC_BASE_PLPMTU;
+		}
+	}
+
+out:
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, paths->pl.probe_high);
+	paths->pl.probe_count++;
+	return pathmtu;
+}
+
+/* Handle successful reception of a PMTU probe.
+ *
+ * Called when a probe packet is acknowledged. Updates probe size and
+ * transitions state if needed (e.g., from SEARCH to COMPLETE).  Expands PMTU
+ * using binary or linear search depending on state.
+ *
+ * Return: New PMTU to apply if search completes, or 0 if no change.
+ */
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer,
+		      bool *complete)
+{
+	u32 pathmtu = 0;
+	u16 next;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, high: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, paths->pl.probe_high);
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
+				next = paths->pl.probe_size + QUIC_PL_BIG_STEP;
+				paths->pl.probe_size =
+					min_t(u16, next, QUIC_MAX_PLPMTU);
+				*complete = false;
+				return pathmtu;
+			}
+			paths->pl.probe_high = QUIC_MAX_PLPMTU;
+		}
+		paths->pl.probe_size += QUIC_PL_MIN_STEP;
+		if (paths->pl.probe_size >= paths->pl.probe_high) {
+			paths->pl.probe_high = 0;
+			/* Search -> Search Complete */
+			paths->pl.state = QUIC_PL_COMPLETE;
+
+			paths->pl.probe_size = paths->pl.pmtu;
+			pathmtu = (u32)paths->pl.pmtu;
+			*raise_timer = true;
+		}
+	} else if (paths->pl.state == QUIC_PL_COMPLETE) {
+		/* Raise probe_size after 30 * interval in Search Complete;
+		 * Search Complete -> Search.
+		 */
+		paths->pl.state = QUIC_PL_SEARCH;
+		next = paths->pl.probe_size + QUIC_PL_MIN_STEP;
+		paths->pl.probe_size = min_t(u16, next, QUIC_MAX_PLPMTU);
+	}
+
+	*complete = (paths->pl.state == QUIC_PL_COMPLETE);
+	return pathmtu;
+}
+
+/* Handle ICMP "Packet Too Big" messages.
+ *
+ * Responds to an incoming ICMP error by reducing the probe size or falling
+ * back to a safe baseline PMTU depending on current state.  Also handles cases
+ * where the PMTU hint lies between probe and current PMTU.
+ *
+ * Return: New PMTU to apply if state changes, or 0 if no change.
+ */
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu,
+			bool *reset_timer)
+{
+	u32 pathmtu = 0;
+
+	pr_debug("%s: dst: %p, state: %d, pmtu: %d, size: %d, ptb: %d\n",
+		 __func__, paths, paths->pl.state, paths->pl.pmtu,
+		 paths->pl.probe_size, pmtu);
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
+		} else if (pmtu > (u32)paths->pl.pmtu &&
+			   pmtu < (u32)paths->pl.probe_size) {
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
+ * Resets all PLPMTUD-related state to its initial configuration.  Called when
+ * a new path is initialized or when recovering from errors.
+ */
+void quic_path_pl_reset(struct quic_path_group *paths)
+{
+	paths->pl.number = 0;
+	paths->pl.probe_high = 0;
+	paths->pl.probe_count = 0;
+	paths->pl.state = QUIC_PL_BASE;
+	paths->pl.pmtu = QUIC_BASE_PLPMTU;
+	paths->pl.probe_size = QUIC_BASE_PLPMTU;
+}
+
+/* Check if a packet number confirms PLPMTUD probe.
+ *
+ * Checks whether the last probe (tracked by .number) has been acknowledged.
+ * If the probe number lies within the ACK range, confirmation is successful.
+ *
+ * Return: true if probe is confirmed, false otherwise.
+ */
+bool quic_path_pl_confirm(struct quic_path_group *paths, s64 largest,
+			  s64 smallest)
+{
+	return paths->pl.number && paths->pl.number >= smallest &&
+	       paths->pl.number <= largest;
+}
diff --git a/net/quic/path.h b/net/quic/path.h
new file mode 100644
index 000000000000..c08d0aa3a9e3
--- /dev/null
+++ b/net/quic/path.h
@@ -0,0 +1,188 @@
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
+#define QUIC_PATH_MAX_PMTU	65535U
+
+#define QUIC_MIN_UDP_PAYLOAD	1200
+#define QUIC_MAX_UDP_PAYLOAD	65527
+
+#define QUIC_PATH_ENTROPY_LEN	8
+
+#define QUIC_PMTUD_RAISE_TIMER_FACTOR	30
+
+extern struct workqueue_struct	*quic_wq;
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
+	QUIC_PATH_ALT_NONE,
+	QUIC_PATH_ALT_PENDING, /* Waiting for new dest conn ID for migration */
+	QUIC_PATH_ALT_PROBING, /* Validating alternate path (PATH_CHALLENGE) */
+	QUIC_PATH_ALT_SWAPPED, /* Alternate path is now active; roles swapped */
+};
+
+struct quic_udp_sock {
+	struct work_struct work; /* Workqueue to destroy UDP tunnel socket */
+	struct hlist_node node;  /* Node in addr-based UDP socket hash table */
+	union quic_addr addr; /* Source addr of underlying UDP tunnel socket */
+	int bind_ifindex;
+	refcount_t refcnt;
+	struct sock *sk; /* Underlying UDP tunnel socket */
+};
+
+struct quic_path {
+	union quic_addr daddr; /* Destination address */
+	union quic_addr saddr; /* Source address */
+
+	/* Wrapped UDP socket for receiving QUIC */
+	struct quic_udp_sock *udp_sk;
+	/* Cached UDP tunnel socket and source addr for RCU access */
+	union quic_addr uaddr;
+	struct sock *usk;
+};
+
+struct quic_path_group {
+	/* Connection ID validation during handshake (rfc9000#section-7.3) */
+	struct quic_conn_id retry_dcid; /* Source CID from Retry packet */
+	struct quic_conn_id orig_dcid;  /* Destination CID from first Initial */
+
+	/* Path validation (rfc9000#section-8.2) */
+	u8 entropy[QUIC_PATH_ENTROPY_LEN]; /* Entropy for PATH_CHALLENGE */
+	struct quic_path path[2]; /* Active path (0) and alternate path (1) */
+	struct flowi fl;          /* Flow info from routing decisions */
+
+	/* Anti-amplification limit (rfc9000#section-8) */
+	u32 ampl_sndlen; /* Bytes sent before address is validated */
+	u32 ampl_rcvlen; /* Bytes received to lift amplification limit */
+
+	/* MTU discovery handling */
+	struct { /* PLPMTUD probing (rfc8899) */
+		s64 number; /* Packet number used for current probe */
+		u16 pmtu;   /* Confirmed path MTU */
+
+		u16 probe_size; /* Current probe packet size */
+		u16 probe_high; /* Highest failed probe size */
+		u8 probe_count; /* Retry count for current probe_size */
+		u8 state;       /* Probe state machine (rfc8899#section-5.2) */
+	} pl;
+	u32 mtu_info; /* PMTU value from received ICMP, pending apply */
+
+	u32 plpmtud_interval;   /* Time interval for the PLPMTUD probe timer */
+	u32 keepalive_interval; /* Time interval to maintain path liveness */
+
+	u8 ecn_probes;  /* ECN probe counter */
+	u8 validated:1; /* Path validated with PATH_RESPONSE */
+	u8 blocked:1;   /* Blocked by anti-amplification limit */
+	u8 version:1;   /* Version negotiation performed */
+	u8 retry:1;     /* Retry used in initial packet */
+
+	/* Connection Migration (rfc9000#section-9) */
+	u8 disable_saddr_alt:1;	/* Remote disable_active_migration parameter */
+	u8 disable_daddr_alt:1;	/* Local disable_active_migration parameter */
+	u8 pref_addr:1; /* Preferred address offered (rfc9000#section-18.2) */
+	u8 alt_probes;  /* Number of PATH_CHALLENGE probes sent */
+	u8 alt_state;   /* Connection migration state (see above) */
+};
+
+static inline union quic_addr *quic_path_saddr(struct quic_path_group *paths,
+					       u8 path)
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
+static inline union quic_addr *quic_path_daddr(struct quic_path_group *paths,
+					       u8 path)
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
+static inline union quic_addr *quic_path_uaddr(struct quic_path_group *paths,
+					       u8 path)
+{
+	return &paths->path[path].uaddr;
+}
+
+static inline struct sock *quic_path_usock(struct quic_path_group *paths,
+					   u8 path)
+{
+	return paths->path[path].usk;
+}
+
+static inline bool quic_path_alt_state(struct quic_path_group *paths, u8 state)
+{
+	return paths->alt_state == state;
+}
+
+static inline void quic_path_set_alt_state(struct quic_path_group *paths,
+					   u8 state)
+{
+	paths->alt_state = state;
+}
+
+/* Returns the destination Connection ID (DCID) used for identifying the
+ * connection.  Per rfc9000#section-7.3, handshake packets are considered part
+ * of the same connection if their DCID matches the one returned here.
+ */
+static inline struct quic_conn_id *
+quic_path_orig_dcid(struct quic_path_group *paths)
+{
+	return paths->retry ? &paths->retry_dcid : &paths->orig_dcid;
+}
+
+bool quic_path_detect_alt(struct quic_path_group *paths, union quic_addr *sa,
+			  union quic_addr *da, struct sock *sk);
+int quic_path_bind(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_unbind(struct sock *sk, struct quic_path_group *paths, u8 path);
+void quic_path_swap(struct quic_path_group *paths);
+
+u32 quic_path_pl_recv(struct quic_path_group *paths, bool *raise_timer,
+		      bool *complete);
+u32 quic_path_pl_toobig(struct quic_path_group *paths, u32 pmtu,
+			bool *reset_timer);
+u32 quic_path_pl_send(struct quic_path_group *paths, s64 number);
+
+void quic_path_get_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p);
+void quic_path_set_param(struct quic_path_group *paths,
+			 struct quic_transport_param *p);
+bool quic_path_pl_confirm(struct quic_path_group *paths,
+			  s64 largest, s64 smallest);
+void quic_path_pl_reset(struct quic_path_group *paths);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index c5cd6d609d06..6a98cd6488e5 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -21,6 +21,7 @@
 static unsigned int quic_net_id __read_mostly;
 
 struct percpu_counter quic_sockets_allocated;
+struct workqueue_struct *quic_wq;
 
 DEFINE_STATIC_KEY_FALSE(quic_alpn_demux_key);
 
@@ -342,6 +343,15 @@ static __init int quic_init(void)
 	if (err)
 		goto err_hash;
 
+	/* Allocate an unbound workqueue for UDP socket destruction and backlog
+	 * packet processing.
+	 */
+	quic_wq = alloc_workqueue("quic_workqueue", WQ_UNBOUND, 0);
+	if (!quic_wq) {
+		err = -ENOMEM;
+		goto err_wq;
+	}
+
 	err = register_pernet_subsys(&quic_net_ops);
 	if (err)
 		goto err_def_ops;
@@ -359,6 +369,8 @@ static __init int quic_init(void)
 err_protosw:
 	unregister_pernet_subsys(&quic_net_ops);
 err_def_ops:
+	destroy_workqueue(quic_wq);
+err_wq:
 	quic_hash_tables_destroy();
 err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
@@ -373,6 +385,8 @@ static __exit void quic_exit(void)
 #endif
 	quic_protosw_exit();
 	unregister_pernet_subsys(&quic_net_ops);
+	flush_workqueue(quic_wq);
+	destroy_workqueue(quic_wq);
 	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
 	pr_info("quic: exit\n");
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 07c436740eaf..0e5595d14b88 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -60,6 +60,9 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_path_unbind(sk, quic_paths(sk), 0);
+	quic_path_unbind(sk, quic_paths(sk), 1);
+
 	quic_conn_id_set_free(quic_source(sk));
 	quic_conn_id_set_free(quic_dest(sk));
 
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 68a58f0016cc..91338601905e 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -15,6 +15,7 @@
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
+#include "path.h"
 
 #include "protocol.h"
 
@@ -39,6 +40,7 @@ struct quic_sock {
 	struct quic_stream_table	streams;
 	struct quic_conn_id_set		source;
 	struct quic_conn_id_set		dest;
+	struct quic_path_group		paths;
 };
 
 struct quic6_sock {
@@ -86,6 +88,11 @@ static inline struct quic_conn_id_set *quic_dest(const struct sock *sk)
 	return &quic_sk(sk)->dest;
 }
 
+static inline struct quic_path_group *quic_paths(const struct sock *sk)
+{
+	return &quic_sk(sk)->paths;
+}
+
 static inline bool quic_is_serv(const struct sock *sk)
 {
 	return !!sk->sk_max_ack_backlog;
-- 
2.47.1

