Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1846521B9F1;
	Sat,  5 Jul 2025 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744334; cv=none; b=J9rKxPScIlQHrpzWUrdpBKu1gQcW05w2rox8fg0LJxPakdxC2LQ47HG0RS9ryinlHYlRFp43FeAuy4R5siYSa2DjLaBvze483zh4mxOM3/A4Z8LPmGB0FyP6vw6ppJ/HLeank9wdt6LnLxzOCjyrEsFZ2JZCEOH3Pb1yoDeCxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744334; c=relaxed/simple;
	bh=MGzeulDEquj0pNatTG6aj1fq4s6W1POjOkkwWCvT7qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQGtGWBHUlz1k1pIhb8cEl4StHEhJfHyJusJsVkzLMCH6MFm+1ZLUhkZxV5O+RPplJ+jUL3qTNyNN4lIVixdsdo7nCvKnsIfNiZxE8CiOjZg0yroX2PzkZe1oIMMNzOs5HJbstswhtNlSJQWYTAIJjV/pUYuRjR1KaLjXxh3x98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gdG7keO6; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gdG7keO6"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso19111276d6.3;
        Sat, 05 Jul 2025 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744331; x=1752349131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++SaBN4ebimHMCAkPWQpnJL3iFAMfa83VmXCKaqB2U4=;
        b=gdG7keO6oKMDGGsX7BGMRNHAHe3Q76N7zwbUB4bpxuyKt02l4Ro4bL4qT5p9tW1qbF
         HFoBCMZJ1tb8HuXJGPwVutiyfzB5INGV+XH72KxcEEYz14jzWLqBq17UdFeBitMHtnQW
         5Ji4wKT9ZVg/jLAGcWtmzmhrqcMGTiT5iJpBN6UETI4gkN3AGopQWg54NNPs2dS05a/n
         Vaqk86lVtp8wIfDbtlMs6FcGcpwimth59VBvcNWjPyDxAnm7ZIpkdeKxGsyFM02DpWIL
         53gtaImxVkLztQe63gQL7jb7bYaTrF04KsCOKsVmhs3BIZXNJmHCILj4TzCOnYYRcjbv
         8EDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744331; x=1752349131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++SaBN4ebimHMCAkPWQpnJL3iFAMfa83VmXCKaqB2U4=;
        b=vejQNfMhFuxMysTj6irsxrGLbGoINhvxJz3L/4dGp73Dw1WOPugd65L2rpw/kV1wah
         rldjnMeZVjqPjhFp0TeXjBJoRVET67EpD7Nsnk/x4qyT3FCNNlbGRQ2NUgWBoKJ/AIVX
         c2LW243+MZXoI5yLjTqjIVpJu8/GYGhiLmS3ob8RmyN2+zZgyJAaTsvx267VpEUB1dN6
         uafHVOn11OSod/Jkri2jbGEXnFdA1qt5HMEtppiEGzEBUWSvLKEXKIXFXoCkjQVPK1kV
         e328QDtfoON2VFlyej+OZYQewthJxq3lidRF8p8WJkxaODZryGkGweKC6gPQdXBYmtDM
         p1NA==
X-Forwarded-Encrypted: i=1; AJvYcCUkbp1mSXjm0wyQju75TYt05hUfMXnrVn/z+k5o66O1axRGbXr7n/uZETWzFi7hJu3nj63HSugwLKdr@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn+j/69cGNclTSwUB4RO7bIDxI0ajCEXyqPxMA6X+I7V6UJKK/
	Fb79Gl2B2yawSJbCSC5w04qqKV5SK0E/FKricwUgfqlihYG81TfST/wsBG7TWRXKhsA=
X-Gm-Gg: ASbGncsYM4FZPQ8vA8CwwuRi4iYj2o/KDFcd5GOdYWwmTi1qELyn7Fpq4EOPEc9qVLL
	0MizSMWz00+oYUmjXQN43TNB+hVmxGdYGyy8aF/BL0weRb38TKFxOsy0axV6H07A9CBg19qPgOZ
	gnyyCi0N0KJ4rJN3HJ16onqM6v39zPYdETNEsIQ5iFwYPxTYJ2IjnC5HYPyiKXECGAoQ2KoQaVd
	QA111zwW3KRx4tYcCKSuMXgfN9vmzg5ry+F65689QhU5KnX6+E/bCoSbVFE9vnLkJ9/oF1Q1gX3
	QQyLtzCLt8tMpLipE9fEFcqyog2oMUzd6MU/fLI8kYbtZARhArYhDecRrY5TZhqzBtMTB3O8/55
	qzClpF13t9naOdqVjFUvKIxLz8Sw=
X-Google-Smtp-Source: AGHT+IHVE6raZbM4P2MXcLBorVtErLjowOEcfqg6A8SlwU6psZ4iz6Qx247B9VY8IZueS/i/mrKWrg==
X-Received: by 2002:a05:6214:419e:b0:702:bf75:f0bc with SMTP id 6a1803df08f44-702d16b4f13mr57394566d6.37.1751744330532;
        Sat, 05 Jul 2025 12:38:50 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:49 -0700 (PDT)
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
Subject: [PATCH net-next 04/15] quic: provide family ops for address and protocol
Date: Sat,  5 Jul 2025 15:31:43 -0400
Message-ID: <bc745a9ddd4b26b331fc7f24e06a04a4d6d9a2e6.1751743914.git.lucien.xin@gmail.com>
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

This patch introduces two new abstraction structures to simplify handling
of IPv4 and IPv6 differences across the QUIC stack:

- quic_addr_family_ops: for address comparison, flow routing,
  UDP config, MTU lookup, formatted output, etc.

- quic_proto_family_ops: for socket address helpers and preference.

With these additions, the QUIC core logic can remain agnostic of the
address family and socket type, improving modularity and reducing
repetitive checks throughout the codebase.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile   |   2 +-
 net/quic/family.c   | 666 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/family.h   |  40 +++
 net/quic/protocol.c |   2 +-
 net/quic/socket.c   |   4 +-
 net/quic/socket.h   |   1 +
 6 files changed, 711 insertions(+), 4 deletions(-)
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
index 000000000000..a1e44e60a15a
--- /dev/null
+++ b/net/quic/family.c
@@ -0,0 +1,666 @@
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
+struct quic_addr_family_ops {
+	u32	iph_len;				/* Network layer header length */
+	int	(*is_any_addr)(union quic_addr *addr);	/* Check if the addr is a wildcard (ANY) */
+
+	/* Initialize UDP tunnel socket configuration */
+	void	(*udp_conf_init)(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *addr);
+	/* Perform IP route lookup */
+	int	(*flow_route)(struct sock *sk, union quic_addr *da, union quic_addr *sa,
+			      struct flowi *fl);
+	/* Transmit packet through UDP tunnel socket */
+	void	(*lower_xmit)(struct sock *sk, struct sk_buff *skb, struct flowi *fl);
+
+	/* Extract source and destination IP addresses from the packet */
+	void	(*get_msg_addrs)(union quic_addr *da, union quic_addr *sa, struct sk_buff *skb);
+	/* Dump the address into a seq_file (e.g., for /proc/net/quic/sks) */
+	void	(*seq_dump_addr)(struct seq_file *seq, union quic_addr *addr);
+	 /* Extract MTU information from an ICMP packet */
+	int	(*get_mtu_info)(struct sk_buff *skb, u32 *info);
+	/* Extract ECN bits from the packet */
+	u8	(*get_msg_ecn)(struct sk_buff *skb);
+};
+
+struct quic_proto_family_ops {
+	/* Validate and convert user address from bind/connect/setsockopt */
+	int	(*get_user_addr)(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
+				 int addr_len);
+	/* Get the 'preferred_address' from transport parameters (rfc9000#section-18.2) */
+	void	(*get_pref_addr)(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen);
+	/* Set the 'preferred_address' into transport parameters (rfc9000#section-18.2) */
+	void	(*set_pref_addr)(struct sock *sk, u8 *p, union quic_addr *addr);
+
+	/* Compare two addresses considering socket family and wildcard (ANY) match */
+	bool	(*cmp_sk_addr)(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+	/* Get socket's local or peer address (getsockname/getpeername) */
+	int	(*get_sk_addr)(struct socket *sock, struct sockaddr *addr, int peer);
+	/* Set socket's source or destination address */
+	void	(*set_sk_addr)(struct sock *sk, union quic_addr *addr, bool src);
+	/* Set ECN bits for the socket */
+	void	(*set_sk_ecn)(struct sock *sk, u8 ecn);
+
+	/* Handle getsockopt() for non-SOL_QUIC levels */
+	int	(*getsockopt)(struct sock *sk, int level, int optname, char __user *optval,
+			      int __user *optlen);
+	/* Handle setsockopt() for non-SOL_QUIC levels */
+	int	(*setsockopt)(struct sock *sk, int level, int optname, sockptr_t optval,
+			      unsigned int optlen);
+};
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
+}
+
+static void quic_v6_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	conf->family = AF_INET6;
+	conf->local_ip6 = a->v6.sin6_addr;
+	conf->local_udp_port = a->v6.sin6_port;
+	conf->use_udp6_rx_checksums = true;
+	conf->ipv6_v6only = ipv6_only_sock(sk);
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
+static void quic_v4_get_msg_addrs(union quic_addr *da, union quic_addr *sa, struct sk_buff *skb)
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
+static void quic_v6_get_msg_addrs(union quic_addr *da, union quic_addr *sa, struct sk_buff *skb)
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
+static struct quic_addr_family_ops quic_af_inet = {
+	.iph_len		= sizeof(struct iphdr),
+	.is_any_addr		= quic_v4_is_any_addr,
+	.udp_conf_init		= quic_v4_udp_conf_init,
+	.flow_route		= quic_v4_flow_route,
+	.lower_xmit		= quic_v4_lower_xmit,
+	.seq_dump_addr		= quic_v4_seq_dump_addr,
+	.get_msg_addrs		= quic_v4_get_msg_addrs,
+	.get_mtu_info		= quic_v4_get_mtu_info,
+	.get_msg_ecn		= quic_v4_get_msg_ecn,
+};
+
+static struct quic_addr_family_ops quic_af_inet6 = {
+	.iph_len		= sizeof(struct ipv6hdr),
+	.is_any_addr		= quic_v6_is_any_addr,
+	.udp_conf_init		= quic_v6_udp_conf_init,
+	.flow_route		= quic_v6_flow_route,
+	.lower_xmit		= quic_v6_lower_xmit,
+	.seq_dump_addr		= quic_v6_seq_dump_addr,
+	.get_msg_addrs		= quic_v6_get_msg_addrs,
+	.get_mtu_info		= quic_v6_get_mtu_info,
+	.get_msg_ecn		= quic_v6_get_msg_ecn,
+};
+
+static struct quic_addr_family_ops *quic_afs[] = {
+	&quic_af_inet,
+	&quic_af_inet6
+};
+
+#define quic_af(a)		quic_afs[(a)->sa.sa_family == AF_INET6]
+#define quic_af_skb(skb)	quic_afs[ip_hdr(skb)->version == 6]
+
+static int quic_v4_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
+				 int addr_len)
+{
+	u32 len = sizeof(struct sockaddr_in);
+
+	if (addr_len < len || addr->sa_family != sk->sk_family)
+		return 1;
+	memcpy(a, addr, len);
+	return 0;
+}
+
+static int quic_v6_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr,
+				 int addr_len)
+{
+	u32 len = sizeof(struct sockaddr_in);
+
+	if (addr_len < len)
+		return 1;
+
+	if (addr->sa_family != sk->sk_family) {
+		if (ipv6_only_sock(sk))
+			return 1;
+		memcpy(a, addr, len);
+		return 0;
+	}
+
+	len = sizeof(struct sockaddr_in6);
+	if (addr_len < len)
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
+	/* Skip over IPv6 address and port,  not used for AF_INET sockets. */
+	p += QUIC_ADDR6_LEN;
+	p += QUIC_PORT_LEN;
+
+	addr->v4.sin_family = AF_INET;
+	*plen -= (p - *pp);
+	*pp = p;
+}
+
+static void quic_v6_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	u8 *p = *pp;
+
+	/* Skip over IPv4 address and port. */
+	p += QUIC_ADDR4_LEN;
+	p += QUIC_PORT_LEN;
+	/* Try to use IPv6 address and port first. */
+	memcpy(&addr->v6.sin6_addr, p, QUIC_ADDR6_LEN);
+	p += QUIC_ADDR6_LEN;
+	memcpy(&addr->v6.sin6_port, p, QUIC_PORT_LEN);
+	p += QUIC_PORT_LEN;
+
+	if (ipv6_only_sock(sk) ||
+	    addr->v6.sin6_port || !ipv6_addr_any(&addr->v6.sin6_addr)) {
+		addr->v4.sin_family = AF_INET6;
+		*plen -= (p - *pp);
+		*pp = p;
+		return;
+	}
+
+	/* Fallback to IPv4 if IPv6 address is not usable. */
+	quic_v4_get_pref_addr(sk, addr, pp, plen);
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
+static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	if (src) {
+		inet_sk(sk)->inet_sport = a->v4.sin_port;
+		if (a->sa.sa_family == AF_INET) {
+			sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
+			sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
+			sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
+			sk->sk_v6_rcv_saddr.s6_addr32[3] = a->v4.sin_addr.s_addr;
+		} else {
+			sk->sk_v6_rcv_saddr = a->v6.sin6_addr;
+		}
+	} else {
+		inet_sk(sk)->inet_dport = a->v4.sin_port;
+		if (a->sa.sa_family == AF_INET) {
+			sk->sk_v6_daddr.s6_addr32[0] = 0;
+			sk->sk_v6_daddr.s6_addr32[1] = 0;
+			sk->sk_v6_daddr.s6_addr32[2] = htonl(0x0000ffff);
+			sk->sk_v6_daddr.s6_addr32[3] = a->v4.sin_addr.s_addr;
+		} else {
+			sk->sk_v6_daddr = a->v6.sin6_addr;
+		}
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
+static struct quic_proto_family_ops quic_pf_inet = {
+	.get_user_addr		= quic_v4_get_user_addr,
+	.get_pref_addr		= quic_v4_get_pref_addr,
+	.set_pref_addr		= quic_v4_set_pref_addr,
+	.cmp_sk_addr		= quic_v4_cmp_sk_addr,
+	.get_sk_addr		= quic_v4_get_sk_addr,
+	.set_sk_addr		= quic_v4_set_sk_addr,
+	.set_sk_ecn		= quic_v4_set_sk_ecn,
+	.setsockopt		= ip_setsockopt,
+	.getsockopt		= ip_getsockopt,
+};
+
+static struct quic_proto_family_ops quic_pf_inet6 = {
+	.get_user_addr		= quic_v6_get_user_addr,
+	.get_pref_addr		= quic_v6_get_pref_addr,
+	.set_pref_addr		= quic_v6_set_pref_addr,
+	.cmp_sk_addr		= quic_v6_cmp_sk_addr,
+	.get_sk_addr		= quic_v6_get_sk_addr,
+	.set_sk_addr		= quic_v6_set_sk_addr,
+	.set_sk_ecn		= quic_v6_set_sk_ecn,
+	.setsockopt		= ipv6_setsockopt,
+	.getsockopt		= ipv6_getsockopt,
+};
+
+static struct quic_proto_family_ops *quic_pfs[] = {
+	&quic_pf_inet,
+	&quic_pf_inet6
+};
+
+#define quic_pf(sk)		quic_pfs[(sk)->sk_family == AF_INET6]
+
+int quic_common_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			   unsigned int optlen)
+{
+	return quic_pf(sk)->setsockopt(sk, level, optname, optval, optlen);
+}
+
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen)
+{
+	return quic_pf(sk)->getsockopt(sk, level, optname, optval, optlen);
+}
+
+u32 quic_encap_len(union quic_addr *a)
+{
+	return sizeof(struct udphdr) + quic_af(a)->iph_len;
+}
+
+int quic_is_any_addr(union quic_addr *a)
+{
+	return quic_af(a)->is_any_addr(a);
+}
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a)
+{
+	quic_af(a)->udp_conf_init(sk, conf, a);
+}
+
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa, struct flowi *fl)
+{
+	return quic_af(da)->flow_route(sk, da, sa, fl);
+}
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da, struct flowi *fl)
+{
+	quic_af(da)->lower_xmit(sk, skb, fl);
+}
+
+void quic_seq_dump_addr(struct seq_file *seq, union quic_addr *addr)
+{
+	quic_af(addr)->seq_dump_addr(seq, addr);
+}
+
+void quic_get_msg_addrs(union quic_addr *da, union quic_addr *sa, struct sk_buff *skb)
+{
+	memset(sa, 0, sizeof(*sa));
+	memset(da, 0, sizeof(*da));
+	quic_af_skb(skb)->get_msg_addrs(da, sa, skb);
+}
+
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info)
+{
+	return quic_af_skb(skb)->get_mtu_info(skb, info);
+}
+
+u8 quic_get_msg_ecn(struct sk_buff *skb)
+{
+	return quic_af_skb(skb)->get_msg_ecn(skb);
+}
+
+int quic_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr, int addr_len)
+{
+	memset(a, 0, sizeof(*a));
+	return quic_pf(sk)->get_user_addr(sk, a, addr, addr_len);
+}
+
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen)
+{
+	memset(addr, 0, sizeof(*addr));
+	quic_pf(sk)->get_pref_addr(sk, addr, pp, plen);
+}
+
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr)
+{
+	quic_pf(sk)->set_pref_addr(sk, p, addr);
+}
+
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr)
+{
+	return quic_pf(sk)->cmp_sk_addr(sk, a, addr);
+}
+
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer)
+{
+	return quic_pf(sock->sk)->get_sk_addr(sock, a, peer);
+}
+
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
+{
+	return quic_pf(sk)->set_sk_addr(sk, a, src);
+}
+
+void quic_set_sk_ecn(struct sock *sk, u8 ecn)
+{
+	quic_pf(sk)->set_sk_ecn(sk, ecn);
+}
diff --git a/net/quic/family.h b/net/quic/family.h
new file mode 100644
index 000000000000..8e0273864d7e
--- /dev/null
+++ b/net/quic/family.h
@@ -0,0 +1,40 @@
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
+int quic_common_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
+			   unsigned int optlen);
+int quic_common_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
+			   int __user *optlen);
+int quic_is_any_addr(union quic_addr *a);
+u32 quic_encap_len(union quic_addr *a);
+
+void quic_get_msg_addrs(union quic_addr *da, union quic_addr *sa, struct sk_buff *skb);
+void quic_get_pref_addr(struct sock *sk, union quic_addr *addr, u8 **pp, u32 *plen);
+void quic_set_pref_addr(struct sock *sk, u8 *p, union quic_addr *addr);
+void quic_seq_dump_addr(struct seq_file *seq, union quic_addr *addr);
+
+int quic_get_user_addr(struct sock *sk, union quic_addr *a, struct sockaddr *addr, int addr_len);
+bool quic_cmp_sk_addr(struct sock *sk, union quic_addr *a, union quic_addr *addr);
+int quic_get_sk_addr(struct socket *sock, struct sockaddr *a, bool peer);
+void quic_set_sk_addr(struct sock *sk, union quic_addr *a, bool src);
+
+void quic_lower_xmit(struct sock *sk, struct sk_buff *skb, union quic_addr *da, struct flowi *fl);
+int quic_flow_route(struct sock *sk, union quic_addr *da, union quic_addr *sa, struct flowi *fl);
+
+void quic_udp_conf_init(struct sock *sk, struct udp_port_cfg *conf, union quic_addr *a);
+int quic_get_mtu_info(struct sk_buff *skb, u32 *info);
+void quic_set_sk_ecn(struct sock *sk, u8 ecn);
+u8 quic_get_msg_ecn(struct sk_buff *skb);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 522c194d4577..08eb3b81f62f 100644
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
index 9cab01109db7..025fb3ae2941 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -121,7 +121,7 @@ static int quic_setsockopt(struct sock *sk, int level, int optname,
 			   sockptr_t optval, unsigned int optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_setsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_setsockopt(sk, optname, optval, optlen);
 }
@@ -135,7 +135,7 @@ static int quic_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
 	if (level != SOL_QUIC)
-		return -EOPNOTSUPP;
+		return quic_common_getsockopt(sk, level, optname, optval, optlen);
 
 	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 }
diff --git a/net/quic/socket.h b/net/quic/socket.h
index b3dec073e5d6..40e48a783d76 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -14,6 +14,7 @@
 #include <net/udp_tunnel.h>
 
 #include "common.h"
+#include "family.h"
 
 #include "protocol.h"
 
-- 
2.47.1

