Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500C28B415
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748777; cv=none; b=t66falaJdJpzskqo9IDdAPblNR+8S2WiWwzAPmO0c+OZP70Bqf1nO12iTdoC7bf+NJhxdzw6D7qt4czO0q2Ve+A5GLg11aiFa7PlwxHLHEQik/9gf801Punh2PeJujoQdqeMYFforYjt/3bzmKHCc4nSYuoLL37Q1dhxs6h3dbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748777; c=relaxed/simple;
	bh=GGK0wCkv4BDKvAs0zgp7UM4zRPJ8F6HRRtyF1xmLApM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7r9kqB2kSEBoSfSEa0+CsES3ox2hWMV6yy0TM8cZi5kYnvbr4ba1Beb/Q6dwlOTVjq1UD/L/6bmJvZvvbq7hd5exW9W8H7ZjdYeVHk7vivYOOAYpfU74iOcYdSG547GZvRYnWyhn2gw0NJbvpWkOCbouIT712sXu3MotDc/gYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4nR86vT; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4nR86vT"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-87c11268b97so77763046d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 07:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761748773; x=1762353573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDYPMTYJdx2KAO2GlL6SoqIu5E6+1EP1nHvBVary9Ro=;
        b=k4nR86vTt98V9E/4dttOnxypzFdEIbDIkQjvIk1Z+5cPCnTRDfx94eSf31Vp8YGkOQ
         INI5jkH4IyRRG9CvnEIN6N8K/C+VTT+xMQWcUQtaW7uAHlyVNfM1sjG0xxtl6rQQdoRS
         ocXzyE2gIQCPrICclPgdsqskw++9mN0EV+ESXGoL1uje2OoSpO83daBZID+nKxTptyf5
         /LJGIk67jch/tW/dqyuFqJULEVKSOmIeTMlYYWyUd/raiOBKBmE7be2fMsQVt4P4e4Zi
         S1ggyagLlChIihT0jVj6K8S1jzowhFrKqfc/2sA+NsXgyHLnku294zxzfOfVoXYHDbbJ
         1E/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748773; x=1762353573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDYPMTYJdx2KAO2GlL6SoqIu5E6+1EP1nHvBVary9Ro=;
        b=hCxM/xBqc2DiMYQdYs3rOPU94SaHatCuZ5hqdeYinzt5zrtYdLbMJ6I/ADT4bn6x+G
         bgWgD+YBdMoT+Qk6atlS9CvNzOcclPaniKvWhT7ZAihftezQR7PO8QNlWXn2xLq+qGHG
         2Y74R0SkThD5F8hKPDjR5WE2lryX29vLdW5REb8RVIUkYHSt1OT2OECulOM3sOqJnD5x
         V6SGzR6WwmHOQ9Hv83Tmqx26ewxTEAFVSBk+cwNQOAwANbIF26HSZPDOyzuJ6tn6w7rc
         2/jaVWFE0ZCYeylmc/gMQy8hYQPIoveyK2RJsAE+D97txOjc5Ajr5jqGrP18MSK4Ow0P
         Lrkg==
X-Forwarded-Encrypted: i=1; AJvYcCXofKPzvHHX9bYtn5afH5htamrY7qFbIX3SO50ZKneUwkX/pVwENx1Fvprh5wVT5LiJsZMewVuYo+1q@vger.kernel.org
X-Gm-Message-State: AOJu0YyxywKF/9AxSqx401TZf8q9xRc8IDOqkbh88b7OK7LCg7HfllID
	qVj8QzXc++dDXoc34+qPC4fhs9uuqiLWPE0o2dH2ywAAIlqiwduCO97u
X-Gm-Gg: ASbGncvtyNtm1qESlgUBLdnz3jXfqwC2FcXcFxicYBj00gfDKgxbIOGQwZC7glsM4eE
	Zd65GEmxupW2ELQNViKYi/i0qEUQ+3IY/8Ko96vgtdQgQKwn5p0N4xYHQ77sPpYiIapxFvzktw+
	O2bMpBDbGpgcR/k4G6kZos/ffyR7lin7aCR4zFFGjZyLOnqMoP0iPpMIE5myMn07E/HEn40kE1d
	3+5/nOryvS3pCo0hXrvjyYmr6Vhn5azRVNClEpzmxQHVy6ZYKTyO5S1vRPDgc5I9GkNd7e3BVjm
	IQGK0jL5fMOrzwvNkt6WyyRU4geJImgcGpmLH0kQFW65BgM8F6hU7QawxFNVsiHU7LsEUqAXTT2
	l2iEBmelSdBt8wVENGSO6UojnTvVbKusaErqiQPPe2bZbVgdgCuP+eWhc2RNtnneODtbB7RC+Y7
	7VVgeZ3xupM8B5OpXfGlPvVmkI3k/LmX6QhxqVGlAXDRZWA/RRjDc=
X-Google-Smtp-Source: AGHT+IEjU4g+8z2TRC3yyPrA0gu4L2pviTSc4E9zou82jFd907AySJC1hqYWbpCmn5er5Pp471ZDew==
X-Received: by 2002:a05:6214:2a87:b0:7ec:6871:d0a3 with SMTP id 6a1803df08f44-88009b2d2d3mr37589436d6.11.1761748772746;
        Wed, 29 Oct 2025 07:39:32 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48a8bc4sm99556176d6.7.2025.10.29.07.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:39:32 -0700 (PDT)
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
Subject: [PATCH net-next v4 04/15] quic: provide family ops for address and protocol
Date: Wed, 29 Oct 2025 10:35:46 -0400
Message-ID: <204debefcf0329a04ecd03094eb4d428bf9a44f1.1761748557.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1761748557.git.lucien.xin@gmail.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce QUIC address and protocol family operations to handle IPv4/IPv6
specifics consistently, similar to SCTP. The new quic_family.{c,h} provide
helpers for routing, address parsing, skb transmit handling, ECN, preferred
address encoding, address comparison, and MTU reporting.

This consolidates protocol-family logic and enables cleaner dual-stack
support in the QUIC socket implementation.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
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
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 585 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  41 ++++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   4 +-
 net/quic/socket.h   |   1 +
 6 files changed, 631 insertions(+), 4 deletions(-)
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
index 000000000000..08bb1caa2b91
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,585 @@
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
+static int quic_v4_is_any_addr(union quic_addr *addr)
+{
+	return addr->v4.sin_addr.s_addr == htonl(INADDR_ANY);
+}
+
+static int quic_v6_is_any_addr(union quic_addr *addr)
+{
+	return ipv6_addr_any(&addr->v6.sin6_addr);
+}
+
+static void quic_v4_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	seq_printf(seq, "%pI4:%d\t", &addr->v4.sin_addr.s_addr, ntohs(addr->v4.sin_port));
+}
+
+static void quic_v6_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	seq_printf(seq, "%pI6c:%d\t", &addr->v6.sin6_addr, ntohs(addr->v4.sin_port));
+}
+
+static void quic_v4_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	conf->family = AF_INET;
+	conf->local_ip.s_addr = a->v4.sin_addr.s_addr;
+	conf->local_udp_port = a->v4.sin_port;
+	conf->use_udp6_rx_checksums = true;
+	conf->bind_ifindex = sk->sk_bound_dev_if;
+}
+
+static void quic_v6_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	conf->family = AF_INET6;
+	conf->local_ip6 = a->v6.sin6_addr;
+	conf->local_udp_port = a->v6.sin6_port;
+	conf->use_udp6_rx_checksums = true;
+	conf->ipv6_v6only = ipv6_only_sock(sk);
+	conf->bind_ifindex = sk->sk_bound_dev_if;
+}
+
+static int quic_v4_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
+			      struct flowi *fl)
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
+	fl4->flowi4_oif = sk->sk_bound_dev_if;
+
+	fl4->flowi4_scope = ip_sock_rt_scope(sk);
+	fl4->flowi4_dscp = inet_sk_dscp(inet_sk(sk));
+
+	rt = ip_route_output_key(sock_net(sk), fl4);
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
+
+	if (!sa->v4.sin_family) {
+		sa->v4.sin_family = AF_INET;
+		sa->v4.sin_addr.s_addr = fl4->saddr;
+	}
+	sk_setup_caps(sk, &rt->dst);
+	return 0;
+}
+
+static int quic_v6_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa,
+			      struct flowi *fl)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
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
+	fl6->flowi6_oif = sk->sk_bound_dev_if;
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
+
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	if (!sa->v6.sin6_family) {
+		sa->v6.sin6_family = AF_INET6;
+		sa->v6.sin6_addr = fl6->saddr;
+	}
+	ip6_dst_store(sk, dst, NULL, NULL);
+	return 0;
+}
+
+static void quic_v4_lower_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 tos = (inet_sk(sk)->tos | cb->ecn), ttl;
+	struct flowi4 *fl4 = &fl->u.ip4;
+	struct dst_entry *dst;
+	__be16 df = 0;
+
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI4:%d -> %pI4:%d\n", __func__,
+		 skb, skb->len, cb->number, &fl4->saddr, ntohs(fl4->fl4_sport),
+		 &fl4->daddr, ntohs(fl4->fl4_dport));
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
+	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr, fl4->daddr,
+			    tos, ttl, df, fl4->fl4_sport, fl4->fl4_dport, false, false, 0);
+}
+
+static void quic_v6_lower_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 tc = (inet6_sk(sk)->tclass | cb->ecn), ttl;
+	struct flowi6 *fl6 = &fl->u.ip6;
+	struct dst_entry *dst;
+	__be32 label;
+
+	pr_debug("%s: skb: %p, len: %d, num: %llu, %pI6c:%d -> %pI6c:%d\n", __func__,
+		 skb, skb->len, cb->number, &fl6->saddr, ntohs(fl6->fl6_sport),
+		 &fl6->daddr, ntohs(fl6->fl6_dport));
+
+	dst = sk_dst_get(sk);
+	if (!dst) {
+		kfree_skb(skb);
+		return;
+	}
+
+	ttl = (u8)ip6_dst_hoplimit(dst);
+	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
+	udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr, &fl6->daddr, tc,
+			     ttl, label, fl6->fl6_sport, fl6->fl6_dport, false, 0);
+}
+
+static void quic_v4_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa)
+{
+	struct udphdr *uh = quic_udphdr(skb);
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
+static void quic_v6_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa)
+{
+	struct udphdr *uh = quic_udphdr(skb);
+
+	sa->v6.sin6_family = AF_INET6;
+	sa->v6.sin6_port = uh->source;
+	sa->v6.sin6_addr = ipv6_hdr(skb)->saddr;
+
+	da->v6.sin6_family = AF_INET6;
+	da->v6.sin6_port = uh->dest;
+	da->v6.sin6_addr = ipv6_hdr(skb)->daddr;
+}
+
+static int quic_v4_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmphdr *hdr;
+
+	hdr = (struct icmphdr *)(skb_network_header(skb) - sizeof(struct icmphdr));
+	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED) {
+		*info = ntohs(hdr->un.frag.mtu);
+		return 0;
+	}
+
+	/* Defer other types' processing to UDP error handler. */
+	return 1;
+}
+
+static int quic_v6_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	struct icmp6hdr *hdr;
+
+	hdr = (struct icmp6hdr *)(skb_network_header(skb) - sizeof(struct icmp6hdr));
+	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG) {
+		*info = ntohl(hdr->icmp6_mtu);
+		return 0;
+	}
+
+	/* Defer other types' processing to UDP error handler. */
+	return 1;
+}
+
+static u8 quic_v4_get_msg_ecn(struct sk_buff *skb)
+{
+	return (ip_hdr(skb)->tos & INET_ECN_MASK);
+}
+
+static u8 quic_v6_get_msg_ecn(struct sk_buff *skb)
+{
+	return (ipv6_get_dsfield(ipv6_hdr(skb)) & INET_ECN_MASK);
+}
+
+static int quic_v4_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
+				 int addr_len)
+{
+	u32 len = sizeof(struct sockaddr_in);
+
+	if (addr_len < len || addr->sa_family != AF_INET)
+		return 1;
+	if (ipv4_is_multicast(quic_addr(addr)->v4.sin_addr.s_addr))
+		return 1;
+	memcpy(a, addr, len);
+	return 0;
+}
+
+static int quic_v6_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
+				 int addr_len)
+{
+	u32 len = sizeof(struct sockaddr_in);
+	int type;
+
+	if (addr_len < len)
+		return 1;
+
+	if (addr->sa_family != AF_INET6) {
+		if (ipv6_only_sock(sk))
+			return 1;
+		return quic_v4_get_user_addr(sk, a, addr, addr_len);
+	}
+
+	len = sizeof(struct sockaddr_in6);
+	if (addr_len < len)
+		return 1;
+	type = ipv6_addr_type(&quic_addr(addr)->v6.sin6_addr);
+	if (type != IPV6_ADDR_ANY && !(type & IPV6_ADDR_UNICAST))
+		return 1;
+	memcpy(a, addr, len);
+	return 0;
+}
+
+static void quic_v4_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+
+	memcpy(&addr->v4.sin_addr, p, QUIC_ADDR4_LEN);
+	p += QUIC_ADDR4_LEN;
+	memcpy(&addr->v4.sin_port, p, QUIC_PORT_LEN);
+	p += QUIC_PORT_LEN;
+	addr->v4.sin_family = AF_INET;
+	/* Skip over IPv6 address and port, not used for AF_INET sockets. */
+	p += QUIC_ADDR6_LEN;
+	p += QUIC_PORT_LEN;
+
+	if (!addr->v4.sin_port || quic_v4_is_any_addr(addr) ||
+	    ipv4_is_multicast(addr->v4.sin_addr.s_addr))
+		memset(addr, 0, sizeof(*addr));
+	*plen -= (p - *pp);
+	*pp = p;
+}
+
+static void quic_v6_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+	int type;
+
+	/* Skip over IPv4 address and port. */
+	p += QUIC_ADDR4_LEN;
+	p += QUIC_PORT_LEN;
+	/* Try to use IPv6 address and port first. */
+	memcpy(&addr->v6.sin6_addr, p, QUIC_ADDR6_LEN);
+	p += QUIC_ADDR6_LEN;
+	memcpy(&addr->v6.sin6_port, p, QUIC_PORT_LEN);
+	p += QUIC_PORT_LEN;
+	addr->v6.sin6_family = AF_INET6;
+
+	type = ipv6_addr_type(&addr->v6.sin6_addr);
+	if (!addr->v6.sin6_port || !(type & IPV6_ADDR_UNICAST)) {
+		memset(addr, 0, sizeof(*addr));
+		if (ipv6_only_sock(sk))
+			goto out;
+		/* Fallback to IPv4 if IPv6 address is not usable. */
+		return quic_v4_get_pref_addr(sk, addr, pp, plen);
+	}
+out:
+	*plen -= (p - *pp);
+	*pp = p;
+}
+
+static void quic_v4_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	memcpy(p, &addr->v4.sin_addr, QUIC_ADDR4_LEN);
+	p += QUIC_ADDR4_LEN;
+	memcpy(p, &addr->v4.sin_port, QUIC_PORT_LEN);
+	p += QUIC_PORT_LEN;
+	memset(p, 0, QUIC_ADDR6_LEN);
+	p += QUIC_ADDR6_LEN;
+	memset(p, 0, QUIC_PORT_LEN);
+}
+
+static void quic_v6_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	if (addr->sa.sa_family == AF_INET)
+		return quic_v4_set_pref_addr(sk, p, addr);
+
+	memset(p, 0, QUIC_ADDR4_LEN);
+	p += QUIC_ADDR4_LEN;
+	memset(p, 0, QUIC_PORT_LEN);
+	p += QUIC_PORT_LEN;
+	memcpy(p, &addr->v6.sin6_addr, QUIC_ADDR6_LEN);
+	p += QUIC_ADDR6_LEN;
+	memcpy(p, &addr->v6.sin6_port, QUIC_PORT_LEN);
+}
+
+static bool quic_v4_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+	if (a->v4.sin_family != addr->v4.sin_family)
+		return false;
+	if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY) ||
+	    addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+		return true;
+	return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
+}
+
+static bool quic_v6_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	if (a->v4.sin_port != addr->v4.sin_port)
+		return false;
+
+	if (a->sa.sa_family == AF_INET && addr->sa.sa_family == AF_INET) {
+		if (a->v4.sin_addr.s_addr == htonl(INADDR_ANY) ||
+		    addr->v4.sin_addr.s_addr == htonl(INADDR_ANY))
+			return true;
+		return a->v4.sin_addr.s_addr == addr->v4.sin_addr.s_addr;
+	}
+
+	if (a->sa.sa_family != addr->sa.sa_family) {
+		if (ipv6_only_sock(sk))
+			return false;
+		if (a->sa.sa_family == AF_INET6 && ipv6_addr_any(&a->v6.sin6_addr))
+			return true;
+		if (a->sa.sa_family == AF_INET && addr->sa.sa_family == AF_INET6 &&
+		    ipv6_addr_v4mapped(&addr->v6.sin6_addr) &&
+		    addr->v6.sin6_addr.s6_addr32[3] == a->v4.sin_addr.s_addr)
+			return true;
+		if (addr->sa.sa_family == AF_INET && a->sa.sa_family == AF_INET6 &&
+		    ipv6_addr_v4mapped(&a->v6.sin6_addr) &&
+		    a->v6.sin6_addr.s6_addr32[3] == addr->v4.sin_addr.s_addr)
+			return true;
+		return false;
+	}
+
+	if (ipv6_addr_any(&a->v6.sin6_addr) || ipv6_addr_any(&addr->v6.sin6_addr))
+		return true;
+	return ipv6_addr_equal(&a->v6.sin6_addr, &addr->v6.sin6_addr);
+}
+
+static int quic_v4_get_sk_addr(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	return inet_getname(sock, uaddr, peer);
+}
+
+static int quic_v6_get_sk_addr(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	union quic_addr *a = quic_addr(uaddr);
+	int ret;
+
+	ret = inet6_getname(sock, uaddr, peer);
+	if (ret < 0)
+		return ret;
+
+	if (a->sa.sa_family == AF_INET6 && ipv6_addr_v4mapped(&a->v6.sin6_addr)) {
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
+static void quic_v4_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	if (src) {
+		inet_sk(sk)->inet_sport = a->v4.sin_port;
+		inet_sk(sk)->inet_saddr = a->v4.sin_addr.s_addr;
+	} else {
+		inet_sk(sk)->inet_dport = a->v4.sin_port;
+		inet_sk(sk)->inet_daddr = a->v4.sin_addr.s_addr;
+	}
+}
+
+static void quic_v6_copy_sk_addr(struct in6_addr *skaddr, union quic_addr *a)
+{
+	if (a->sa.sa_family == AF_INET) {
+		skaddr->s6_addr32[0] = 0;
+		skaddr->s6_addr32[1] = 0;
+		skaddr->s6_addr32[2] = htonl(0x0000ffff);
+		skaddr->s6_addr32[3] = a->v4.sin_addr.s_addr;
+	} else {
+		*skaddr = a->v6.sin6_addr;
+	}
+}
+
+static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	if (src) {
+		inet_sk(sk)->inet_sport = a->v4.sin_port;
+		quic_v6_copy_sk_addr(&sk->sk_v6_rcv_saddr, a);
+	} else {
+		inet_sk(sk)->inet_dport = a->v4.sin_port;
+		quic_v6_copy_sk_addr(&sk->sk_v6_daddr, a);
+	}
+}
+
+static void quic_v4_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	inet_sk(sk)->tos = ((inet_sk(sk)->tos & ~INET_ECN_MASK) | ecn);
+}
+
+static void quic_v6_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	quic_v4_set_sk_ecn(sk, ecn);
+	inet6_sk(sk)->tclass = ((inet6_sk(sk)->tclass & ~INET_ECN_MASK) | ecn);
+}
+
+#define quic_af_ipv4(a)		((a)->sa.sa_family == AF_INET)
+
+u32 quic_encap_len(union quic_addr *a)
+{
+	return (quic_af_ipv4(a) ? sizeof(struct iphdr) : sizeof(struct ipv6hdr)) +
+	       sizeof(struct udphdr);
+}
+
+int quic_is_any_addr(union quic_addr *a)
+{
+	return quic_af_ipv4(a) ? quic_v4_is_any_addr(a) : quic_v6_is_any_addr(a);
+}
+
+void quic_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	quic_af_ipv4(addr) ? quic_v4_seq_dump_addr(seq, addr) : quic_v6_seq_dump_addr(seq, addr);
+}
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	quic_af_ipv4(a) ? quic_v4_udp_conf_init(sk, conf, a) : quic_v6_udp_conf_init(sk, conf, a);
+}
+
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa, struct flowi *fl)
+{
+	return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl) :
+				  quic_v6_flow_route(sk, da, sa, fl);
+}
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da, struct flowi *fl)
+{
+	quic_af_ipv4(da) ? quic_v4_lower_xmit(sk, skb, fl) : quic_v6_lower_xmit(sk, skb, fl);
+}
+
+#define quic_skb_ipv4(skb)	(ip_hdr(skb)->version == 4)
+
+void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa)
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
+u8 quic_get_msg_ecn(struct sk_buff *skb)
+{
+	return quic_skb_ipv4(skb) ? quic_v4_get_msg_ecn(skb) : quic_v6_get_msg_ecn(skb);
+}
+
+#define quic_pf_ipv4(sk)	((sk)->sk_family == PF_INET)
+
+int quic_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr, int addr_len)
+{
+	memset(a, 0, sizeof(*a));
+	return quic_pf_ipv4(sk) ? quic_v4_get_user_addr(sk, a, addr, addr_len) :
+				  quic_v6_get_user_addr(sk, a, addr, addr_len);
+}
+
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	memset(addr, 0, sizeof(*addr));
+	quic_pf_ipv4(sk) ? quic_v4_get_pref_addr(sk, addr, pp, plen) :
+			   quic_v6_get_pref_addr(sk, addr, pp, plen);
+}
+
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	quic_pf_ipv4(sk) ? quic_v4_set_pref_addr(sk, p, addr) : quic_v6_set_pref_addr(sk, p, addr);
+}
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	return quic_pf_ipv4(sk) ? quic_v4_cmp_sk_addr(sk, a, addr) :
+				  quic_v6_cmp_sk_addr(sk, a, addr);
+}
+
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer)
+{
+	return quic_pf_ipv4(sock->sk) ? quic_v4_get_sk_addr(sock, a, peer) :
+					quic_v6_get_sk_addr(sock, a, peer);
+}
+
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	quic_pf_ipv4(sk) ? quic_v4_set_sk_addr(sk, a, src) : quic_v6_set_sk_addr(sk, a, src);
+}
+
+void quic_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	quic_pf_ipv4(sk) ? quic_v4_set_sk_ecn(sk, ecn) : quic_v6_set_sk_ecn(sk, ecn);
+}
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			   unsigned int optlen)
+{
+	return quic_pf_ipv4(sk) ? ip_setsockopt(sk, level, optname, optval, optlen) :
+				  ipv6_setsockopt(sk, level, optname, optval, optlen);
+}
+
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen)
+{
+	return quic_pf_ipv4(sk) ? ip_getsockopt(sk, level, optname, optval, optlen) :
+				  ipv6_getsockopt(sk, level, optname, optval, optlen);
+}
diff --git a/net/quic/family.h b/net/quic/family.h
new file mode 100644
index 000000000000..dd7af2393d07
--- /dev/null
+++ b/net/quic/family.h
@@ -0,0 +1,41 @@
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
+#define QUIC_PREF_ADDR_LEN	(QUIC_ADDR4_LEN + QUIC_PORT_LEN + QUIC_ADDR6_LEN + QUIC_PORT_LEN)
+
+void quic_seq_dump_addr(struct seq_file *seq, union quic_addr *addr);
+int quic_is_any_addr(union quic_addr *a);
+u32 quic_encap_len(union quic_addr *a);
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da, struct flowi *fl);
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa, struct flowi *fl);
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a);
+
+void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa);
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info);
+u8 quic_get_msg_ecn(struct sk_buff *skb);
+
+int quic_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr, int addr_len);
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen);
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr);
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer);
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src);
+void quic_set_sk_ecn(struct sock *sk, u8 ecn);
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			   unsigned int optlen);
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index bde41db668fe..19b09aa4f8be 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -44,7 +44,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
 
 static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 {
-	return -EOPNOTSUPP;
+	return quic_get_sk_addr(sock, uaddr, peer);
 }
 
 static __poll_t quic_inet_poll(struct file *file, struct socket *sock, poll_table *wait)
diff --git a/net/quic/socket.c b/net/quic/socket.c
index abec673812f7..0b8fec63f769 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -116,7 +116,7 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_setsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
@@ -130,7 +130,7 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_getsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 }
diff --git a/net/quic/socket.h b/net/quic/socket.h
index 6cbf12bcae75..3f808489f571 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -11,6 +11,7 @@
 #include <net/udp_tunnel.h>
 
 #include "common.h"
+#include "family.h"
 
 #include "protocol.h"
 
-- 
2.47.1

