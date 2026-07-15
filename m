Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50073C13F1
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147531; cv=none; b=ohFEV2iqYV1AptieO5jMJ5FMm5mddunBdxy+iqXVoEw5rYP0VvO/9wmAOZzjrV3M3T0J53QveiPXO85ZUf4jfrSSZSpPRD9lc+G+nc0pL2NEDUSbv+e/psDvXGNc0m3P+F2z4vcWqkPtIWxwEP7AuJMVeca7NfJONVd4JYU0gnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147531; c=relaxed/simple;
	bh=nlN1guc9wjOmQ62d1sU2TOz8uEuguM25B1H3BniBlQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1zcOPTQOqZbfxOg9oU1aA5sSVmAi4q7Op92Q9I9hjFihucdoEIB/Pzcn+9EAoueoJRYjnervKNNxBpEkfKSt5luLjrVfHbtyGm6+wCmLdCd4Ym3zP0r9FJwj/DaOLEFf/1Olbnv9VHp8AyWs9i3A2uCFj0OJZ8M9uF04Espav0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGPFPGYJ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGPFPGYJ"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e602d2c0fso78725585a.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147528; x=1784752328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hDHZba/a0nUf32Vz8HinVhtsb3a+vwpGyIw2I8qAF8c=;
        b=ZGPFPGYJWKU+vwgZFD6ZNlj8qjlMhgwEgkaCLXNOyaQ5tYmIoplEuhlsp5LnBM4lAA
         kZa7ccxL9y/gNC9uherZXwKs4D5IBRf/5E+WK3ItZ0ahoyj+jujxo5I5+ekvlVji1562
         Sg70HsqmGu0fxMJJlDaOLjk/qyLFNxNmFvx4qE3qroCuYpLDcKVKKs4SNZUUwkOwytVw
         1epsrRd7yv8Ufdr9Gi3Hq5HDu62aY/uNu7gWyqowd6j3KecribLsC0YICuCNAOB0B7Fw
         J4Eu+N6HwRiO1dGOap3IGRfThQ4GTfWKQJDmVphd1d/yvlOACC/QBjDRFKLQVH1sLun4
         ITBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147528; x=1784752328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hDHZba/a0nUf32Vz8HinVhtsb3a+vwpGyIw2I8qAF8c=;
        b=Df+xgTIV6bScsS7R4+QGGB42TQfRwiQ7V7AUR+SxuTWwzb1zr8++OXJ/sGfizXwnmh
         q2xMmU74K1esXk3FCioRWo28P0dfMFCFaP44J7kDU/7VwthE+gDi8if2s7jefuOxQQNw
         HmTfCrJsjcoIMIEresj+La/ZVAdcdyFCXz2c2y8xCaj1IAeSOMgSYwy16TalKLi8a+U6
         MS/x7trC8ZqvgPogn+eafNVPcfC/ddA+IdSppz8uSGzuPObKsyqCXm3u1v9/gilfxsQ9
         YmodXsWLHkN9IzMLr1Unc9nOkEsMmu7SSVOcrWdLJFA3nD9DRGxKUO30B19Vua7WxedY
         M1ww==
X-Forwarded-Encrypted: i=1; AHgh+Ro4OkzGwVF7VSH5VKVVABDoTMc8W9Bnka/3+AGpw4c4glipdfh8rxhjq9J/9ONMnz1UJL7e75zJxFOz@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/HEujt2CX6jFQaR+q3irzUlYtyrGzzIpsqnvwrULT9nHhlNL0
	yo0LfipfgHZIBEWO5MTTmAIbNv4eBGWPl2V4QjJBxDhTakAPcjp4Fgqt
X-Gm-Gg: AfdE7clXDcWlff9fSUwC/lJxSFmJpV7NrCqzrGZHvGfudAhlqIGB3gsVP/qOSWG+AMe
	ComuLd6ufnBhlem4Hgr+eiu93p5ClJ61EeJZ4nt97g9NlISIx3UnljGoECQB5J3PL2LSB7Jp+Xr
	MtYx8CzM7FLVRoFyvtEF7ZWgDVdEiw5FWgsRJrsvyT+mmTzedl5AgOlvjmXZnh/i9RenYtqoI8W
	i1NLhaeVmsq+3tQfs0ZzY+lyovVv2+78lEwMwwwpwOezDGGu2zrgG05QuOISlWyTwizaVbPZWPt
	bHdDsu2IeBVWrLvXvsthUNPdio6+e2gsPAuqPXA9XwyLKg7vDVXpKtb2eUUQ53wI9Eb0hiTXPHm
	BT5TlSis//fWNp5stGwd7BgecfSgfoBHVWjWb3xMn+zV07+ljl5E6nJSLuTW3VkUDeDGRL3IZdn
	sw9r89DkYHMJINwm522uWITOTHt5p2I3wY1Fk0h7845f9woobxWNe2aAwnIrLLjBpKyHHONphl7
	lkfCLTrYre4+b+16XG5WqLlbJl2TXLh7a6lHQtyfTlPP8+kOPzReKs=
X-Received: by 2002:a05:620a:269b:b0:915:9da9:b541 with SMTP id af79cd13be357-930a25c084fmr120677385a.10.1784147527392;
        Wed, 15 Jul 2026 13:32:07 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:06 -0700 (PDT)
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
Subject: [PATCH net-next v14 04/15] quic: provide family ops for address and protocol
Date: Wed, 15 Jul 2026 16:27:07 -0400
Message-ID: <747c35166e957a27a72aba1a1d4a8245daa0ab5d.1784147238.git.lucien.xin@gmail.com>
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
v14:
  - Return sk_bound_dev_if from quic_get_dev_if() when the IPv6 link-local
    address sin6_scope_id is zero.
  - Use %lld for cb->number in pr_debug() in quic_v4_lower_xmit() and
    quic_v6_lower_xmit() (noted by Sashiko AI review).
  - Remove quic_v4_match_v6_addr() since IPv4-mapped IPv6 addresses will
    be saved after conversion to IPv4 addresses.
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 439 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  44 +++++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   6 +-
 net/quic/socket.h   |   1 +
 6 files changed, 490 insertions(+), 4 deletions(-)
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
index 000000000000..be792cfadabc
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,439 @@
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
+	pr_debug("%s: skb: %p, len: %d, num: %lld, %pI4:%d -> %pI4:%d\n",
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
+	pr_debug("%s: skb: %p, len: %d, num: %lld, %pI6c:%d -> %pI6c:%d\n",
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
+		return quic_is_any_addr(a);
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
+	    ipv6_addr_type(&a->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL &&
+	    a->v6.sin6_scope_id)
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
index 71827050185f..a4378f1bb91a 100644
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

