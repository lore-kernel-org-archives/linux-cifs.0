Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3291BD9C9
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 03:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991896; cv=none; b=X7bWpSi/w6Em3NHusv1jn5LiDeEDWUhMch28ZtZExY1ISBhNW8uBtbETzLJ256bPpfQurvhIq7I7USnuDXR020KQDA/QPCq+lWi2r4VM6dy+mwSex7bHr3VBaCRg2NkRkCcWwmBteI7YRSlvg+brXlNv7SoLFV1mtiYBmhhpHJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991896; c=relaxed/simple;
	bh=bCv+Tu7cn88RQhqgzqtRR49sDCbg4MnJaP9RseqNbfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUS1Js3P9kmoDyPtIV18woStfUQccnqpxmw/rbRmCWbD1mu2mvJFiCppE6G9/XYCMSkeleTuYCZI6/dqawTaY3adCLxcEHQp00aoOalfGfsYNH/n2RcA5dBzpK6mlBx5tfPHN1Aq4C/j7gzzmFPeIqDSxYKQYGY/MaqIUpz4R9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icmosLDn; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icmosLDn"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d1890f7ee4so4019031a34.0
        for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 19:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771991894; x=1772596694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsRboBvHZL0+XhByNSVGQ65XPDCDJtsXFLuF6x91vCI=;
        b=icmosLDnQ5f3T+MrV7T96MtPdTNfJuoe7SdNRL10f8QGZH7M1Ej+IS5hs2G3oBOHes
         ScDKDz4DA9QzlhLVhCLZ9SZMQJGnVy13pFV1ULSTBN84z6mbCeD2hG3irHLlwuWCzZCt
         XjXW5MmK3RCXdfidIvcGTmEWARdsBQCyptNoOrqC5SfE1KqePlKHY6VvJ9fyi2X0HzJV
         ZogZRivmKN2hpzvTgDHyxDj29oNKoB/8G/jd1aViQ285stPxGNp8EDIfhEaORDp8c2PP
         VwKrXGY5+RvPbIbxFSMF8RKXPe7DrPtHRQoVgUhgDJ64LlMw84uqEd6cGyKNegIzqM44
         /lbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991894; x=1772596694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EsRboBvHZL0+XhByNSVGQ65XPDCDJtsXFLuF6x91vCI=;
        b=dOXOFDmF500H47nw81Vl/e2IdOJ6oLE4IOEX8dLXyRzSAvK94McVOLsBymqmpD15hH
         I0kNqCGUmtiUQzEL2PwY0+HVBT6brOvoa6mezBM/MPbxqePOSIJTJp/y/BB3sa8ZGnSr
         IsR+AZpAycX1wxPqaR5qS8GsuPyc7RMJEUI4Z5iBUrUZkm0RDM65g/S2RUuF92VqV3Ie
         jmFCpwJp3Mq0x+wDUF7L+NPw6Wia06lJPAZckUoLQ+M79yCqt+6msJuyQ8zse42HoAxW
         I0fP1SNu0hQPxnbOLOKKYIOoxE3PTOEGKk/8OlqK0ar71VR1rDuN04eNZ1aLsF+T0uXp
         +1SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFSw08QE0SIvZonyvv/blESM7g52deQA+TJBOU4J+ZQR8jisBWv2HBwVQiSP6kDDZiseIlgKx21Ydz@vger.kernel.org
X-Gm-Message-State: AOJu0YzT8mhJPccDuaHF+vuB7+bHPBcbkccayWhN4GbXVyk+XFwbGPru
	itCCk8x3BLOoJAhKwZiDmXDSR61o9/FQkU0+HFmb3m9GJUjmtBnvRZOXDnISm02A
X-Gm-Gg: ATEYQzz4m/+VrfbgiI8dcaXRLJfA3DL4YQPcofQSRWWyFa3cRrPrFtMRsZC28dBgNvj
	hbPao2FDzCe4S6LFcT//bYkElXMApwYFJw/XdE+ZthEg9PQDJh5dQqTeUu5IbKhJA9qvfrNqwg/
	xvzf9fWBpWUfVEWWuinCyTSntOlZNLYN2CK8ijBZvyzBRb5178OwSoUxyiLeANwlk6CduG+uroV
	bELvST5LAkxKMMgeDva9G3ymZAX8rlF6yOhbfbnknRFAwv//+buuJeKKN7/vkVjPsgh7YNLEDt2
	y9HCZjU3VAxsRy70sbpDcAqifA/z49yoeOu1tet8CPCUnu1tf/wtDzRjl4rfUzqm6BYLLjJ+hSy
	gt5Y8xOfE7tA3pDuZZJrA+KjC1o8LB8m4vzmgi483lr5DxnUUhaZPH3sX/vK813L6NioplFlTZH
	WJpYr1iGD8Y6/TvucNKJSle9Pbk5Gt9nIOEdyISK0k64QCr9xgf061mM8QBmPVsKEVvrxp0UKZ6
	9OpVUk7iWCmB/GSt6dqvbSJawlkaOb70uuMCzHD3o7fTbVyhDPpFVMTIH+BPeIFGg==
X-Received: by 2002:a05:620a:199c:b0:8c6:a723:415a with SMTP id af79cd13be357-8cb8c9cdc40mr1886463885a.11.1771986939614;
        Tue, 24 Feb 2026 18:35:39 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e62f453sm112363586d6.36.2026.02.24.18.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 18:35:39 -0800 (PST)
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
Subject: [PATCH net-next v10 04/15] quic: provide family ops for address and protocol
Date: Tue, 24 Feb 2026 21:34:10 -0500
Message-ID: <dfb955f48c56147f8ccb8e4a58c1fd432d1486a0.1771986861.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 372 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  33 ++++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   4 +-
 net/quic/socket.h   |   1 +
 6 files changed, 410 insertions(+), 4 deletions(-)
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
index 000000000000..5e00065ff192
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,372 @@
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
+	if (quic_v4_is_any_addr(sa)) {
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
+	if (quic_v6_is_any_addr(sa)) {
+		sa->v6.sin6_family = AF_INET6;
+		sa->v6.sin6_addr = fl6->saddr;
+	}
+	ip6_dst_store(sk, dst, false, false);
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
+static void quic_v6_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa)
+{
+	struct udphdr *uh = udp_hdr(skb);
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
+static bool quic_v4_match_v6_addr(union quic_addr *a4, union quic_addr *a6)
+{
+	if (ipv6_addr_any(&a6->v6.sin6_addr))
+		return true;
+	if (ipv6_addr_v4mapped(&a6->v6.sin6_addr) &&
+	    a6->v6.sin6_addr.s6_addr32[3] == a4->v4.sin_addr.s_addr)
+		return true;
+	return false;
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
+		if (a->sa.sa_family == AF_INET)
+			return quic_v4_match_v6_addr(a, addr);
+		return quic_v4_match_v6_addr(addr, a);
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
+#define quic_pf_ipv4(sk)	((sk)->sk_family == PF_INET)
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
index 000000000000..624a5d7a8471
--- /dev/null
+++ b/net/quic/family.h
@@ -0,0 +1,33 @@
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
+int quic_is_any_addr(union quic_addr *a);
+u32 quic_encap_len(union quic_addr *a);
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da, struct flowi *fl);
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa, struct flowi *fl);
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a);
+
+void quic_get_msg_addrs(struct sk_buff *skb, union quic_addr *da, union quic_addr *sa);
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info);
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer);
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			   unsigned int optlen);
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index f20e4aef1fa5..1fecbd3e3d9d 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -46,7 +46,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
 
 static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 {
-	return -EOPNOTSUPP;
+	return quic_get_sk_addr(sock, uaddr, peer);
 }
 
 static __poll_t quic_inet_poll(struct file *file, struct socket *sock, poll_table *wait)
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 6e1999f171b1..1ef8a7932932 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -113,7 +113,7 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_setsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
@@ -127,7 +127,7 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_getsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 }
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

