Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1D734DB64
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628676; cv=none; b=pIw/NhLvzY80Dky0vLeQr+s12sX/dfN81TxlNaB7Fvgf8c4A7+upOfqpxHiv4fUDqbZeEkZJT5Kk7YcfG2UbquOONjqV1y18LYWlequDcPM1AOBcRh6TE0q4hm0orqZQyyJys1ypWc5W5myVzWkWLNYTa0GG6717l3uhwCu0IX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628676; c=relaxed/simple;
	bh=YG9uVWbGqmlxX63bgzcZyuRpPs0gHpst/mtV873BMmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO7dmwhY91rgL/PKsxmp+rHEznZWRceuOqpW1bXLLSv73EsoO3s5STWyH+3TnXS0NRE3qMsFDRq/uL/TdEzcINevWwa46I57MycAtm3f3nBEP38xJJp6pbSi2vzIx5qmR4nXbNv3jfsSRcQUMrCBFlHq0EOkuutw+PK32MZ5G5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hlKmfOS6; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlKmfOS6"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88a2f2e5445so71266d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jan 2026 07:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767628673; x=1768233473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDYoC0fGdOhKXXrE0cxh2ujoXQmwJk2MSVG2vqyZch4=;
        b=hlKmfOS6kM4AD4y+hniJa9R3CEbW9eOlQClD95A75KqO9gnNXY7ym6sflB7VuJBAeq
         nGNCUTo+l81zwvDVRCO0kha4LpDdWsgaPlPVFAzfIVJD5CNPDL31gQRtOfTbci60Qtbc
         moNiPv1B+/aeLmxPNvmoz0HKwvcqPGkUMduoExqhX2KFiA3VsvJm7CJw+/0ryJMtPOOL
         wZAIKbA029Riaoi6ds1upJpi4DlbaAQQZKN0mEuAbfr6oOe3EenLBfpsssGbXDubo6Bm
         bYYk++HjJ2E212ABEzEXH2fCqa1+2ElfEBRY6+S4cUYeiHIbv7nXtG5fuxb8kKLb6vWm
         qXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767628673; x=1768233473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pDYoC0fGdOhKXXrE0cxh2ujoXQmwJk2MSVG2vqyZch4=;
        b=X0+HosaRxzYofKqhDdsyFb8TbMkYp/MlTJQay081H1k6JqYftCghXnd6lDH2Ykc1aS
         SIz/ClQcBk8qalYyHBfyYNg1Zhsx5w6MKBDZpOA77StfJEthLbXfvavhZyvWKJaU7C5a
         uqAnlykHYlm4jgD9fvdqTu8PlYePepIAcCpEoCDgeEglmgwjrMQH2hjWOJ8QXa1ECcpg
         pSHiurt55dcUKy1Agne7Hq367iN5V6fyWGCy5YxVI3BBWdl4lOgXyXxhWm/bIV1xcDol
         a0Ux+Dv5RuWGcAoD9XHYTALN1FZeJmU/D43ZI7O/sjhjFHgRz3J0tr6wj+aBDM2Bp6Dd
         DHAA==
X-Forwarded-Encrypted: i=1; AJvYcCXbFFr1wXnR1zyWucpXmX/b+Wub6yeGvlBTvb5FSY2ieOV36HrPXakztppdsIekWMZjIYiWaOWaxXXV@vger.kernel.org
X-Gm-Message-State: AOJu0YwAYX5lzz4qSXaSO7zrFimhqbaXgQi57M+URbswxQ3ne/S7Uldr
	eyQuIkMOo1WBZ8mpnOeSOr0ux4EJwbPOsKz5PLEkDPlK4f/52JG7h6iB
X-Gm-Gg: AY/fxX55uS8NNh4RshmzT8UoWZ3lrmazf21uUxljNFS2tFdqMfkcNbZ4YcLNsbDGGlZ
	2bx1zpGc/Kg5I8Fv/PipWzG7vUeMnA+hQL7C2FQaH62TxxliilltRwWdzpQh6LaFnCHGhOKjdFG
	lGOXOKowMahctra6mewc2/HDosvnqBnblc8v9r+N30h4QPbA3lBqzo1ylwFV4R2jig/r29AcdBQ
	Dm5yql8y0aGqTEr2YN1/fqAz+dT3twYW1J+ldfsO8o4zMLV9t7yCgVtfC2ooDhZDqnuDYrr7Iw/
	5dGycSmJHSNOnrUMmpUrdic6V0afZ+dzfRQWR8NBzyPrPQ9FGTd26rFMZuO9PhjwT4u82vqMoEW
	QmqQBDa9YLdJuGrV1SgyTekASfYt26HKX9Pk0OieTPSxaSZVrUXPC3+SbMJgoc2gueHthRS38TZ
	2xb5PYEO3C1Yh6kEIisnPAOCXSeDc9FNFLkE83jWuJzA38VXjHLKU=
X-Google-Smtp-Source: AGHT+IGgFyGe0ocwoTc6DtymQRYxVOJwyPvKgg4iY0K2D/IeS7Hqkw66gEtPVvxiN46/Kps+aVHvfA==
X-Received: by 2002:a05:622a:258f:b0:4f1:e928:3fda with SMTP id d75a77b69052e-4f4abcf0b55mr696760931cf.26.1767622096210;
        Mon, 05 Jan 2026 06:08:16 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac64a47esm368957221cf.24.2026.01.05.06.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:08:15 -0800 (PST)
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v6 04/16] quic: provide family ops for address and protocol
Date: Mon,  5 Jan 2026 09:04:30 -0500
Message-ID: <d6526f74c99731fa08bdd43f97330f9c2dd78e43.1767621882.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1767621882.git.lucien.xin@gmail.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
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
index 000000000000..5914fc3c3e49
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
index ba24f4f94f97..26684b106286 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -45,7 +45,7 @@ static int quic_inet_listen(struct socket *sock, int backlog)
 
 static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 {
-	return -EOPNOTSUPP;
+	return quic_get_sk_addr(sock, uaddr, peer);
 }
 
 static __poll_t quic_inet_poll(struct file *file, struct socket *sock, poll_table *wait)
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 784b8aaadb25..a0eedf59545a 100644
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

