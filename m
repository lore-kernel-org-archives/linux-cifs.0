Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B7438C2A0
	for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233087; cv=none; b=s/icsqnPGm7KfC4Y3Nqa2YCURq2mvX+C14m7Ep4OFWid9VfjLIFEzrplbNK/8PdQ23O6AetP8e38maD3Z4+1mSm9tGyJMZ4fPWDu3HYZJuxY1c+AgBfxgR06sA5lTXKYuOdIa+TzykQmczoyjLTPUz//iQCIdOqVOhUhU2NNo/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233087; c=relaxed/simple;
	bh=MtvIPz+VqkZD0aFmyUltY+4TOabZ4W1vUQCGR6YtFA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMYI+FRTAh1BasjdpMUPRW+WemFpdSZs+hd32L4cTQ3e4uJMFYmzwG55VLI0k5XnN8yvT3tZyEz9cjemJy2NXngbUCGuUfCewJ/dkskEKHOXsbxmmwPBFTZjEEVBZ6utiDT/qx8Wg8hoAtJb/aWSjkt6fDDF4GPlSGwcDw4qqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOF0YUS4; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOF0YUS4"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ccedaf0b54so11433556d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780233083; x=1780837883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/9uM7iY52CGToEiuJIDRkNeq7CtevVHOvyfeHTOfuI=;
        b=QOF0YUS40RqfzQty5cuJ7vaAejC/lmqApPxltra8DqSLrDHA6oYJ9Ce1u5PbWIguh2
         dbEQDQNCuW1DjpEg5vJqiEHyMGhn3Pro7hv9oo7LwcGk4JIZNwFtRqltfx18WzoGgmpd
         HAAjGy7k+ssp0ykYXLzvLgyAmeSalmOqA/i0lLerA3Oi7f8ileKDu13QsdN+bcq8HClj
         WmIclgYkIXbp1vrk7D7vrn8BpfqiXimlerTN27DGz7I4EOA7bVHVesYl2DjkQinviP79
         96cOTdzab2g4IVD4s+XtP3tmJhuwWzKryv2URP0ojV8XsQEPeEJgbHvcmEHPc27AjKp8
         zlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780233083; x=1780837883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/9uM7iY52CGToEiuJIDRkNeq7CtevVHOvyfeHTOfuI=;
        b=osemEEKo0w64SPmn65dJZtQHjUhh/z2A3hxU8sauu4p0RuvlF5o9gCfVlHtl78gx/b
         1nc7kPWBcCMNgtZIGhY6/WZ+zCr6W4qmlxgtHTPbeN5CC/OiAE3QncLurJBSGx2sFyB9
         sNog96EgZb7a3Fb8exS1xh+GVPgelB+nMqsXYPTA/k6B6T1a3w7oJlP8K5PlzG3M4D5+
         C12xDl+4Zi3WWPjXu/esR94oloG4L7f/Qs9nuSeDEWFMYYFbnKAUrLDs4vlgyXnPEUAx
         4LfFubxdn1YeHJuxts10/pqgdzz4WcgjHw5hbIOVwcUp+LTvZZQedjaJypljXcuwODnT
         gYVg==
X-Forwarded-Encrypted: i=1; AFNElJ8WWsFzSVIhLmGb+Em4SvOc6fvs5JEiNxrBb3udNT8cqRsVoe7flsUkcLqJqEYhRIpau77pAuLaSAZw@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4BO9i8Gh87/tUWHqThLVcP7V9oHxnl+Xm3GAOv9dUWPHJSEPj
	SJJM3sUaMCOxIg/Sd/Ktn3EYiEh0zuuI+GB7o+blUKoeM8zvW9rM15Oj
X-Gm-Gg: Acq92OHeQuF/ASI+BC3G36ZyyHpnbPWS9xQgmtuakXxrfZ1sabqgHdCe1B0K8znsrqr
	O7AQKhuR0XBhl8b4TbGCOs6xO3UwMHTzXEthGVQueUo6Po1WE7jo3IN+/HyMe+BANwQMJBcasYw
	/FT7gYIItnanXoKZgUxy5fcXBUUND2Ncgwb8vEOxWpGAi8ihiwqfAClmacLMHay/7a1PgjuH1EN
	KGoSPalrQFg8XyiAPiM4K668SN9aSL8eew6p5ir4hZyzsIPpM12v3nx9QVeLBr6549X/2tW7a0c
	VXgtKu9HRdi8LO8kHtO9pvXOr5PE4EQyaIimKCP3GMPQUEcxzteSPB2UDDulJGGaKcI9ItsC8Rh
	NRnE45OzcLf62DeIrJP2IMD+Cci7ytXY/qOQN+LZmcJ6AEFWadrJWLY1V+jNhPHMRCP5ZNqyd/N
	PnavPrcLGfgmDPCqgAZKy5vjZEdJqvzUko1cg+CL+Ypymh6prmZd1yriQwFzhyqDl8TmynbRXAq
	uUifRRHC8ceaOiLzhlsXqz2kAdyQKXgcHtlzhrLI7ZYdFiL3kllZhlAU1cRnH4f+Rnuj7C0EjFS
X-Received: by 2002:a05:6214:5013:b0:8cd:b80e:6157 with SMTP id 6a1803df08f44-8cdb80e631amr68935556d6.14.1780233083209;
        Sun, 31 May 2026 06:11:23 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea2163b0sm69609746d6.38.2026.05.31.06.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:11:22 -0700 (PDT)
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
Subject: [PATCH net-next v12 04/15] quic: provide family ops for address and protocol
Date: Sun, 31 May 2026 09:08:40 -0400
Message-ID: <5b1b5061342c98a888846ee8a637c70476b78461.1780232931.git.lucien.xin@gmail.com>
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

Introduce QUIC address and protocol family operations to handle IPv4/IPv6
specifics consistently, similar to SCTP. The new quic_family.{c,h} provide
helpers for routing, skb transmit handling, address parsing and comparison
and UDP socket config initializing etc.

This consolidates protocol-family logic and enables cleaner dual-stack
support in the QUIC socket implementation.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
v2:
  - Add more checks for addrs in .get_user_addr() and .get_pref_addr().
  - Consider sk_bound_dev_if in .udp_conf_init() and .flow_route() to
    support vrf.
v3:
  - Remove quic_addr_family/proto_ops abstraction; use if statements to
    reduce indirect call overhead (suggested by Paolo).
  - quic_v6_set_sk_addr(): add quic_v6_copy_sk_addr() helper to avoid
    duplicate code (noted by Paolo).
  - quic_v4_flow_route(): use flowi4_dscp per latest net-next changes.
v4:
  - Remove unnecessary _fl variable from flow_route() functions (noted
    by Paolo).
  - Fix coding style of ?: operator (noted by Paolo).
v5:
  - Remove several unused functions from this patch series (suggested by Paolo):
    * quic_seq_dump_addr()
    * quic_get_msg_ecn()
    * quic_get_user_addr()
    * quic_get_pref_addr()
    * quic_set_pref_addr()
    * quic_set_sk_addr()
    * quic_set_sk_ecn()
  - Replace the sa->v4/v6.sin_family checks with quic_v4/v6_is_any_addr()
    in quic_v4/v6_flow_route() (suggested by Paolo).
  - Introduce quic_v4_match_v6_addr() to simplify family-mismatch checks
    between sk and addr in quic_v6_cmp_sk_addr() (notied by Paolo).
v6:
  - Use udp_hdr(skb) to access UDP header in quic_v4/6_get_msg_addrs(), as
    transport_header is no longer reset for QUIC.
v10:
  - Fix argument types passed to ip6_dst_store() in quic_v6_flow_route().
v11:
  - Set maximum line length to 80 characters.
  - Change return type of quic_is_any_addr() to bool.
  - Call local_bh_disable() in quic_lower_xmit() because
    udp(6)_tunnel_xmit_skb() requires a non-preemptible context.
  - Return a negative errno (-EINVAL) instead of 1 in
    quic_v4/v6_get_mtu_info().
v12:
  - Add helper functions quic_get_dev_if(), quic_set_skb_iif(),
    quic_sk_accept_pmtu(), and quic_sk_destruct().
  - Remove use_udp6_rx_checksums setting in quic_v4_udp_conf_init().
  - Enable use_udp6_tx_checksums and set bind_ifindex via
    quic_get_dev_if() in quic_v6_udp_conf_init().
  - Switch to ip_route_output_flow() in quic_v4_flow_route().
  - Set flowi4/6_uid, flowi4/6_mark, and derive flowi4/6_oif via
    quic_get_dev_if() in quic_v4/6_flow_route().
  - Call fl6_update_dst() for final_dst, and ip6_make_flowinfo() for
    flow label; also set sin6_scope_id for IPv6 link-local addresses in
    quic_v6_flow_route().
  - Set sin6_scope_id from skb->skb_iif in quic_v6_get_msg_addrs().
  - Fix indentation in quic_v4/6_get_mtu_info().
  - Do not match specific socket addresses against ANY in
    quic_v4/6_cmp_sk_addr() and quic_v4_match_v6_addr().
  - Handle sin6_scope_id for IPv6 link-local addresses and call
    quic_v4_cmp_sk_addr() instead of open-coding it in
    quic_v6_cmp_sk_addr().
  - Change the type of parameter peer from bool to int in
    quic_get_sk_addr().
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 452 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  44 +++++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   6 +-
 net/quic/socket.h   |   1 +
 6 files changed, 503 insertions(+), 4 deletions(-)
 create mode 100644 net/quic/family.c
 create mode 100644 net/quic/family.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index e0067272de7d..13bf4a4e5442 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := common.o protocol.o socket.o
+quic-y := common.o family.o protocol.o socket.o
diff --git a/net/quic/family.c b/net/quic/family.c
new file mode 100644
index 000000000000..3be0b1aadd31
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,452 @@
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
+#include <net/inet_common.h>
+#include <net/udp_tunnel.h>
+#include <linux/icmp.h>
+
+#include "common.h"
+#include "family.h"
+
+static bool quic_v4_is_any_addr(union quic_addr *addr)
+{
+	return addr->v4.sin_addr.s_addr == htonl(INADDR_ANY);
+}
+
+static bool quic_v6_is_any_addr(union quic_addr *addr)
+{
+	return ipv6_addr_any(&addr->v6.sin6_addr);
+}
+
+static void quic_v4_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf,
+				  union quic_addr *a)
+{
+	conf->family = AF_INET;
+	conf->local_ip.s_addr = a->v4.sin_addr.s_addr;
+	conf->local_udp_port = a->v4.sin_port;
+	conf->bind_ifindex = sk->sk_bound_dev_if;
+}
+
+static void quic_v6_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf,
+				  union quic_addr *a)
+{
+	conf->family = AF_INET6;
+	conf->local_ip6 = a->v6.sin6_addr;
+	conf->local_udp_port = a->v6.sin6_port;
+	conf->use_udp6_rx_checksums = true;
+	conf->use_udp6_tx_checksums = true;
+	conf->ipv6_v6only = ipv6_only_sock(sk);
+	conf->bind_ifindex = quic_get_dev_if(sk, a);
+}
+
+static int quic_v4_flow_route(struct sock *sk, union quic_addr *da,
+			      union quic_addr *sa, struct flowi *fl)
+{
+	struct flowi4 *fl4;
+	struct rtable *rt;
+
+	if (__sk_dst_check(sk, 0))
+		return 1;
+
+	memset(fl, 0x00, sizeof(*fl));
+	fl4 = &fl->u.ip4;
+	fl4->saddr = sa->v4.sin_addr.s_addr;
+	fl4->fl4_sport = sa->v4.sin_port;
+	fl4->daddr = da->v4.sin_addr.s_addr;
+	fl4->fl4_dport = da->v4.sin_port;
+	fl4->flowi4_proto = IPPROTO_UDP;
+	fl4->flowi4_oif = quic_get_dev_if(sk, da);
+
+	fl4->flowi4_scope = ip_sock_rt_scope(sk);
+	fl4->flowi4_dscp = inet_sk_dscp(inet_sk(sk));
+
+	fl4->flowi4_uid = sk_uid(sk);
+	fl4->flowi4_mark = sk->sk_mark;
+
+	rt = ip_route_output_flow(sock_net(sk), fl4, sk);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	if (quic_v4_is_any_addr(sa)) {
+		sa->v4.sin_family = AF_INET;
+		sa->v4.sin_addr.s_addr = fl4->saddr;
+	}
+	sk_setup_caps(sk, &rt->dst);
+	return 0;
+}
+
+static int quic_v6_flow_route(struct sock *sk, union quic_addr *da,
+			      union quic_addr *sa, struct flowi *fl)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct in6_addr *final_p, final;
+	struct ip6_flowlabel *flowlabel;
+	struct dst_entry *dst;
+	struct flowi6 *fl6;
+
+	if (__sk_dst_check(sk, np->dst_cookie))
+		return 1;
+
+	memset(fl, 0x00, sizeof(*fl));
+	fl6 = &fl->u.ip6;
+	fl6->saddr = sa->v6.sin6_addr;
+	fl6->fl6_sport = sa->v6.sin6_port;
+	fl6->daddr = da->v6.sin6_addr;
+	fl6->fl6_dport = da->v6.sin6_port;
+	fl6->flowi6_proto = IPPROTO_UDP;
+	fl6->flowi6_oif = quic_get_dev_if(sk, da);
+
+	if (inet6_test_bit(SNDFLOW, sk)) {
+		fl6->flowlabel = (da->v6.sin6_flowinfo & IPV6_FLOWINFO_MASK);
+		if (fl6->flowlabel & IPV6_FLOWLABEL_MASK) {
+			flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
+			if (IS_ERR(flowlabel))
+				return -EINVAL;
+			fl6_sock_release(flowlabel);
+		}
+	}
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, fl6->flowlabel);
+
+	fl6->flowi6_uid = sk_uid(sk);
+	fl6->flowi6_mark = sk->sk_mark;
+
+	rcu_read_lock();
+	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
+	rcu_read_unlock();
+
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	if (quic_v6_is_any_addr(sa)) {
+		sa->v6.sin6_family = AF_INET6;
+		sa->v6.sin6_addr = fl6->saddr;
+		if ((ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_LINKLOCAL))
+			sa->v6.sin6_scope_id = fl6->flowi6_oif;
+	}
+	ip6_dst_store(sk, dst, false, false);
+	return 0;
+}
+
+static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb,
+			       struct flowi *fl)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 tos = (inet_sk(sk)->tos | cb->ecn), ttl;
+	struct flowi4 *fl4 = &fl->u.ip4;
+	struct dst_entry *dst;
+	__be16 df = 0;
+
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI4:%d -> %pI4:%d\n",
+		 __func__, skb, skb->len, cb->number, &fl4->saddr,
+		 ntohs(fl4->fl4_sport), &fl4->daddr, ntohs(fl4->fl4_dport));
+
+	dst = sk_dst_get(sk);
+	if (!dst) {
+		kfree_skb(skb);
+		return;
+	}
+	if (ip_dont_fragment(sk, dst) && !skb->ignore_df)
+		df = htons(IP_DF);
+
+	ttl = (u8)ip4_dst_hoplimit(dst);
+	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr,
+			    fl4->daddr, tos, ttl, df, fl4->fl4_sport,
+			    fl4->fl4_dport, false, false, 0);
+}
+
+static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb,
+			       struct flowi *fl)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 tc = (inet6_sk(sk)->tclass | cb->ecn), ttl;
+	struct flowi6 *fl6 = &fl->u.ip6;
+	struct dst_entry *dst;
+	__be32 label;
+
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI6c:%d -> %pI6c:%d\n",
+		 __func__, skb, skb->len, cb->number, &fl6->saddr,
+		 ntohs(fl6->fl6_sport), &fl6->daddr, ntohs(fl6->fl6_dport));
+
+	dst = sk_dst_get(sk);
+	if (!dst) {
+		kfree_skb(skb);
+		return;
+	}
+
+	ttl = (u8)ip6_dst_hoplimit(dst);
+	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true,
+				   fl6);
+	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr, tc,
+			     ttl, label, fl6->fl6_sport, fl6->fl6_dport, false,
+			     0);
+}
+
+static void quic_v4_get_msg_addrs(struct sk_buff *skb, union quic_addr *da,
+				  union quic_addr *sa)
+{
+	struct udphdr *uh = udp_hdr(skb);
+
+	sa->v4.sin_family = AF_INET;
+	sa->v4.sin_port = uh->source;
+	sa->v4.sin_addr.s_addr = ip_hdr(skb)->saddr;
+
+	da->v4.sin_family = AF_INET;
+	da->v4.sin_port = uh->dest;
+	da->v4.sin_addr.s_addr = ip_hdr(skb)->daddr;
+}
+
+static void quic_v6_get_msg_addrs(struct sk_buff *skb, union quic_addr *da,
+				  union quic_addr *sa)
+{
+	struct udphdr *uh = udp_hdr(skb);
+
+	sa->v6.sin6_family = AF_INET6;
+	sa->v6.sin6_port = uh->source;
+	sa->v6.sin6_addr = ipv6_hdr(skb)->saddr;
+	sa->v6.sin6_scope_id = skb->skb_iif;
+
+	da->v6.sin6_family = AF_INET6;
+	da->v6.sin6_port = uh->dest;
+	da->v6.sin6_addr = ipv6_hdr(skb)->daddr;
+	da->v6.sin6_scope_id = skb->skb_iif;
+}
+
+static int quic_v4_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmphdr *hdr;
+
+	hdr = (struct icmphdr *)(skb_network_header(skb) -
+				 sizeof(struct icmphdr));
+	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED) {
+		*info = ntohs(hdr->un.frag.mtu);
+		return 0;
+	}
+
+	/* Defer other types' processing to UDP error handler. */
+	return -EINVAL;
+}
+
+static int quic_v6_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmp6hdr *hdr;
+
+	hdr = (struct icmp6hdr *)(skb_network_header(skb) -
+				  sizeof(struct icmp6hdr));
+	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG) {
+		*info = ntohl(hdr->icmp6_mtu);
+		return 0;
+	}
+
+	/* Defer other types' processing to UDP error handler. */
+	return -EINVAL;
+}
+
+static bool quic_v4_cmp_sk_addr(struct sock *sk, union quic_addr *a,
+				union quic_addr *addr)
+{
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+	if (a->v4.sin_family != addr->v4.sin_family)
+		return false;
+	/* No match: specific socket vs ANY lookup. */
+	if (addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+		return a->v4.sin_addr.s_addr == htonl(INADDR_ANY);
+	if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+		return true;
+	return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
+}
+
+static bool quic_v4_match_v6_addr(union quic_addr *a4, union quic_addr *a6,
+				  bool a6_from_sk)
+{
+	if (ipv6_addr_any(&a6->v6.sin6_addr))
+		return a6_from_sk;
+	if (!ipv6_addr_v4mapped(&a6->v6.sin6_addr))
+		return false;
+	if (a4->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+		return !a6_from_sk;
+	return a6->v6.sin6_addr.s6_addr32[3] == a4->v4.sin_addr.s_addr;
+}
+
+static bool quic_v6_cmp_sk_addr(struct sock *sk, union quic_addr *a,
+				union quic_addr *addr)
+{
+	if (a->sa.sa_family == AF_INET && addr->sa.sa_family == AF_INET)
+		return quic_v4_cmp_sk_addr(sk, a, addr);
+
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+
+	if (a->sa.sa_family != addr->sa.sa_family) {
+		if (ipv6_only_sock(sk))
+			return false;
+		if (a->sa.sa_family == AF_INET)
+			return quic_v4_match_v6_addr(a, addr, false);
+		return quic_v4_match_v6_addr(addr, a, true);
+	}
+
+	/* No match: specific socket vs ANY lookup. */
+	if (ipv6_addr_any(&addr->v6.sin6_addr))
+		return ipv6_addr_any(&a->v6.sin6_addr);
+	if (ipv6_addr_any(&a->v6.sin6_addr))
+		return true;
+	if (!ipv6_addr_equal(&a->v6.sin6_addr, &addr->v6.sin6_addr))
+		return false;
+	if ((ipv6_addr_type(&a->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
+	    a->v6.sin6_scope_id && addr->v6.sin6_scope_id &&
+	    a->v6.sin6_scope_id != addr->v6.sin6_scope_id)
+		return false;
+	return true;
+}
+
+static int quic_v4_get_sk_addr(struct socket *sock, struct sockaddr *uaddr,
+			       int peer)
+{
+	return inet_getname(sock, uaddr, peer);
+}
+
+static int quic_v6_get_sk_addr(struct socket *sock, struct sockaddr *uaddr,
+			       int peer)
+{
+	union quic_addr *a = quic_addr(uaddr);
+	int ret;
+
+	ret = inet6_getname(sock, uaddr, peer);
+	if (ret < 0)
+		return ret;
+
+	if (a->sa.sa_family == AF_INET6 &&
+	    ipv6_addr_v4mapped(&a->v6.sin6_addr)) {
+		a->v4.sin_family = AF_INET;
+		a->v4.sin_port = a->v6.sin6_port;
+		a->v4.sin_addr.s_addr = a->v6.sin6_addr.s6_addr32[3];
+	}
+
+	if (a->sa.sa_family == AF_INET) {
+		memset(a->v4.sin_zero, 0, sizeof(a->v4.sin_zero));
+		return sizeof(struct sockaddr_in);
+	}
+	return sizeof(struct sockaddr_in6);
+}
+
+#define quic_af_ipv4(a)		((a)->sa.sa_family == AF_INET)
+
+u32 quic_encap_len(union quic_addr *a)
+{
+	return (quic_af_ipv4(a) ? sizeof(struct iphdr) :
+				  sizeof(struct ipv6hdr)) +
+	       sizeof(struct udphdr);
+}
+
+bool quic_is_any_addr(union quic_addr *a)
+{
+	return quic_af_ipv4(a) ? quic_v4_is_any_addr(a) :
+				 quic_v6_is_any_addr(a);
+}
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf,
+			union quic_addr *a)
+{
+	quic_af_ipv4(a) ? quic_v4_udp_conf_init(sk, conf, a) :
+			  quic_v6_udp_conf_init(sk, conf, a);
+}
+
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
+		    struct flowi *fl)
+{
+	return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl) :
+				  quic_v6_flow_route(sk, da, sa, fl);
+}
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+		     struct flowi *fl)
+{
+	local_bh_disable();
+	quic_af_ipv4(da) ? quic_v4_lower_xmit(sk, skb, fl) :
+			   quic_v6_lower_xmit(sk, skb, fl);
+	local_bh_enable();
+}
+
+#define quic_skb_ipv4(skb)	(ip_hdr(skb)->version == 4)
+
+void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da,
+			union quic_addr *sa)
+{
+	memset(sa, 0, sizeof(*sa));
+	memset(da, 0, sizeof(*da));
+	quic_skb_ipv4(skb) ? quic_v4_get_msg_addrs(skb, da, sa) :
+			     quic_v6_get_msg_addrs(skb, da, sa);
+}
+
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	return quic_skb_ipv4(skb) ? quic_v4_get_mtu_info(skb, info) :
+				    quic_v6_get_mtu_info(skb, info);
+}
+
+#define quic_pf_ipv4(sk)	((sk)->sk_family == PF_INET)
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a,
+		      union quic_addr *addr)
+{
+	return quic_pf_ipv4(sk) ? quic_v4_cmp_sk_addr(sk, a, addr) :
+				  quic_v6_cmp_sk_addr(sk, a, addr);
+}
+
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, int peer)
+{
+	return quic_pf_ipv4(sock->sk) ? quic_v4_get_sk_addr(sock, a, peer) :
+					quic_v6_get_sk_addr(sock, a, peer);
+}
+
+int quic_get_dev_if(struct sock *sk, union quic_addr *a)
+{
+	if (!quic_af_ipv4(a) &&
+	    ipv6_addr_type(&a->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
+		return a->v6.sin6_scope_id;
+
+	return sk->sk_bound_dev_if;
+}
+
+void quic_set_skb_iif(struct sk_buff *skb)
+{
+	/* Save the inet/inet6 iif before skb dst/cb are cleared. */
+	skb->skb_iif = quic_skb_ipv4(skb) ? inet_iif(skb) : inet6_iif(skb);
+}
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	return quic_pf_ipv4(sk) ?
+	       ip_setsockopt(sk, level, optname, optval, optlen) :
+	       ipv6_setsockopt(sk, level, optname, optval, optlen);
+}
+
+int quic_common_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	return quic_pf_ipv4(sk) ?
+	       ip_getsockopt(sk, level, optname, optval, optlen) :
+	       ipv6_getsockopt(sk, level, optname, optval, optlen);
+}
+
+bool quic_sk_accept_pmtu(struct sock *sk, struct sk_buff *skb)
+{
+	return quic_skb_ipv4(skb) ? ip_sk_accept_pmtu(sk) :
+				    ip6_sk_accept_pmtu(sk);
+}
+
+void quic_sk_destruct(struct sock *sk)
+{
+	quic_pf_ipv4(sk) ? inet_sock_destruct(sk) : inet6_sock_destruct(sk);
+}
diff --git a/net/quic/family.h b/net/quic/family.h
new file mode 100644
index 000000000000..02342c4b7c99
--- /dev/null
+++ b/net/quic/family.h
@@ -0,0 +1,44 @@
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
+#define QUIC_PORT_LEN		2
+#define QUIC_ADDR4_LEN		4
+#define QUIC_ADDR6_LEN		16
+
+#define QUIC_PREF_ADDR_LEN \
+	(QUIC_ADDR4_LEN + QUIC_PORT_LEN + QUIC_ADDR6_LEN + QUIC_PORT_LEN)
+
+bool quic_is_any_addr(union quic_addr *a);
+u32 quic_encap_len(union quic_addr *a);
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da,
+		     struct flowi *fl);
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
+		    struct flowi *fl);
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf,
+			union quic_addr *a);
+
+void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da,
+			union quic_addr *sa);
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info);
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a,
+		      union quic_addr *addr);
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, int peer);
+
+int quic_get_dev_if(struct sock *sk, union quic_addr *a);
+void quic_set_skb_iif(struct sk_buff *skb);
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname,
+			   sockptr_t optval, unsigned int optlen);
+int quic_common_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *optval, int __user *optlen);
+bool quic_sk_accept_pmtu(struct sock *sk, struct sk_buff *skb);
+void quic_sk_destruct(struct sock *sk);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index a53a2b1218a6..c5cd6d609d06 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -47,7 +47,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
 static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr,
 			     int peer)
 {
-	return -EOPNOTSUPP;
+	return quic_get_sk_addr(sock, uaddr, peer);
 }
 
 static __poll_t quic_inet_poll(struct file *file, struct socket *sock,
diff --git a/net/quic/socket.c b/net/quic/socket.c
index a4889e5bbe90..adde76cb7396 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -121,7 +121,8 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_setsockopt(sk, level, optname, optval,
+					      optlen);
 
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
@@ -136,7 +137,8 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_getsockopt(sk, level, optname, optval,
+					      optlen);
 
 	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval),
 				  USER_SOCKPTR(optlen));
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 9a2f4b851676..0aa642e3b0ae 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -11,6 +11,7 @@
 #include <net/udp_tunnel.h>
 
 #include "common.h"
+#include "family.h"
 
 #include "protocol.h"
 
-- 
2.47.1

