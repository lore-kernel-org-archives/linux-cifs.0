Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C06D30DD13
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 22:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758235155; cv=none; b=GNhXn44ZujxL6KAJLKY473I9tbnllAOXT3qHAAFVpE8pU4A8mUNn9iamAFpcG44FOTfoDw+nuKVqao/geHaUWfPm669rts4EwPmEvvyE68BOgpsACWpWE8AV4w+SP8JJ+okTEvFLxkl/Mf95T2Q4dsbWR4/T5hxR0QW6oMUtEbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758235155; c=relaxed/simple;
	bh=1sxo409Tm0pNWuvjyiGIEOPFhAKDwsNg01oD5foa4Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKKTNPI+9iIzx3BGY5hwlSzaLY2HXBtakPAELz1/iPvtsg+X8wSvtNaNk1LiukgmaGQg3lL8S3p8aHu7ILWtky8hyEzLNAnwPjLCX4xtqhgkMZfCI3kS9QI31BWmeILckblWECkXwIPO7nJg8f3e83iqbasSFJ9NyejnZcyImS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R0cJAbxh; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R0cJAbxh"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-80e2c52703bso147305085a.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 15:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758235152; x=1758839952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9ZMTAYZpLtP2ArAlPTHN24TawTFpXMIL0o/rbCJiGM=;
        b=R0cJAbxhVsMSVPa214/C7lnwhEn3Z28onIgvlPlUUM4/AD2nBZPWg550t228nTqZXL
         AcYHwnEziKJnmj2LnBkTp2AFYfQ7x+VmXGMe3sCXGneOxDdf15U6cXQkhT4eYQW74aBw
         OuKjk72E6l3OoPU91niXao7uYOBvqpan47ptIG5KVzCsg4nWHUHNytieuWaoRXEtv0df
         VmfsFmk6RRCjCSK+NVDu4kcOnloAUtWlkpJYae9VOh43Kq9QMFMrsx+/xfezzK+sJ8Ke
         7ns+Mto27q/096kJt1xFoVJpcNwHLGoTvyQuhm/47Nbic69jalASpj52FuUJR6SoHWsd
         sXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758235152; x=1758839952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9ZMTAYZpLtP2ArAlPTHN24TawTFpXMIL0o/rbCJiGM=;
        b=iozNiFQLFnruB0uMy9KUYH0oh6/1ewMtLTg4L551VGc2j91w6HXQ8jxg9MgfKJXvRT
         UWGJ/DJftL3DHbIf9ANet0FhJ7B0s9vqkGwYZtBwykLjXiap14by/yp+5MMu6Wc/2OIH
         0zm8IQUPxtvwdzH8CAMY6LJeHaHhB0DVNTi0avokuGXqOI4Y0Te46PxAp36/CIAudh+s
         wsg9sgAtMOUkIc+qShRXPaYhqVfUcr/NwcAr879v+I7rqCXBB0PARUKHbljDOA1/5xx3
         iH+rmjNtjD2p0Bg4FM+pz3EQR/eKDZPExhcPhz+dvG2UnJejffck3tlVnctgI4pEGQP6
         n6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/yfYwZh+/pGlGnYH1NY6t/dKcMKOtJjaKPyHP2X/3tHafqxy3w7FyoEGhk1x9U/Ijcy7SXrLVqWhm@vger.kernel.org
X-Gm-Message-State: AOJu0YzRIIbETK5jYP/t24ZcSKPd7DubhS+LvGBc6aWVxs6WIawwoBy0
	JROXB7Z9K0Pu5cT5HM3UXLvmD1B66LckKXCzdDzWPtvETZJ0igExTfSv
X-Gm-Gg: ASbGncuryDVkOuFKjXIYvl7Es1MyMiWimJ3VHi2D93lk6UvpHl/EGgqA3DJSKdwoIdK
	0+Cdk1olIGNJItIzYcREEdBiAVcWmhTrzBeuJ6xoQj8vJOeSonpdDcCx8lNpSExqao60KyBD+sW
	xlxYqFO+4ua7MdBygr7BN2vaxx+GtP/GzQa+CK9IKu2YBQyh53IW6dRixXP6Y1g/LOcN3Ax+dj5
	O7uB12ZbLbp3Y36+moM/feIYaOl//8p9pGMpyTndzO0Z7hfUIUOzj233WCLgD6Nnni+oCL+afhE
	uQdmnqJgBoXZkptJckPAGfrzss4/U61cRpDd5GSOkB8ZQHPk7ezhfribpvCsL1QtYU/E8EK0FTR
	Z3sHGp8N/Q9WrNa4O0UtwwiNJAmwmYJ3y/Qjk1zMaiJ7Mw5AfA+ubu7nr6goKNTgVGtN5EkOgJe
	V+5VSH3Q==
X-Google-Smtp-Source: AGHT+IHAqKTNNoRBn5AfZ8+8DYLOvk2FgOyKXYTzICE9/hiMw8vXp+O7gmd1IinS9l2dBjf28dTOPw==
X-Received: by 2002:a05:620a:178d:b0:7e3:397c:8c24 with SMTP id af79cd13be357-83baa9eb805mr155019285a.48.1758235151791;
        Thu, 18 Sep 2025 15:39:11 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83630481fc7sm244631185a.43.2025.09.18.15.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:39:11 -0700 (PDT)
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
Subject: [PATCH net-next v3 04/15] quic: provide family ops for address and protocol
Date: Thu, 18 Sep 2025 18:34:53 -0400
Message-ID: <01dd8f3b9afc6c813f036924790997d3ed4bcf3d.1758234904.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1758234904.git.lucien.xin@gmail.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
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
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 589 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  41 +++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   4 +-
 net/quic/socket.h   |   1 +
 6 files changed, 635 insertions(+), 4 deletions(-)
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
index 000000000000..7c65c529f9b9
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,589 @@
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
+	struct flowi _fl;
+
+	if (__sk_dst_check(sk, 0))
+		return 1;
+
+	fl4 = &_fl.u.ip4;
+	memset(&_fl, 0x00, sizeof(_fl));
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
+	memcpy(fl, &_fl, sizeof(_fl));
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
+	struct flowi _fl;
+
+	if (__sk_dst_check(sk, np->dst_cookie))
+		return 1;
+
+	fl6 = &_fl.u.ip6;
+	memset(&_fl, 0x0, sizeof(_fl));
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
+	memcpy(fl, &_fl, sizeof(_fl));
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
+	return quic_af_ipv4(da) ? quic_v4_flow_route(sk, da, sa, fl)
+				: quic_v6_flow_route(sk, da, sa, fl);
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
+	quic_skb_ipv4(skb) ? quic_v4_get_msg_addrs(skb, da, sa)
+			   : quic_v6_get_msg_addrs(skb, da, sa);
+}
+
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	return quic_skb_ipv4(skb) ? quic_v4_get_mtu_info(skb, info)
+				  : quic_v6_get_mtu_info(skb, info);
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
+	return quic_pf_ipv4(sk) ? quic_v4_get_user_addr(sk, a, addr, addr_len)
+				: quic_v6_get_user_addr(sk, a, addr, addr_len);
+}
+
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	memset(addr, 0, sizeof(*addr));
+	quic_pf_ipv4(sk) ? quic_v4_get_pref_addr(sk, addr, pp, plen)
+			 : quic_v6_get_pref_addr(sk, addr, pp, plen);
+}
+
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	quic_pf_ipv4(sk) ? quic_v4_set_pref_addr(sk, p, addr) : quic_v6_set_pref_addr(sk, p, addr);
+}
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	return quic_pf_ipv4(sk) ? quic_v4_cmp_sk_addr(sk, a, addr)
+				: quic_v6_cmp_sk_addr(sk, a, addr);
+}
+
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer)
+{
+	return quic_pf_ipv4(sock->sk) ? quic_v4_get_sk_addr(sock, a, peer)
+				      : quic_v6_get_sk_addr(sock, a, peer);
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
+	return quic_pf_ipv4(sk) ? ip_setsockopt(sk, level, optname, optval, optlen)
+				: ipv6_setsockopt(sk, level, optname, optval, optlen);
+}
+
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen)
+{
+	return quic_pf_ipv4(sk) ? ip_getsockopt(sk, level, optname, optval, optlen)
+				: ipv6_getsockopt(sk, level, optname, optval, optlen);
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
index b54532916aa2..74553ca072bc 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -47,7 +47,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
 
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

