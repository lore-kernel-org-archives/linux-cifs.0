Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA38A3376A6;
	Mon, 18 Aug 2025 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526348; cv=none; b=LqU3nOkyqqhy7HO5qlsc5DCVLMVpBA0xntFQSC5JnDjpOugNqunO+wKMWU01xM/EYThfPrJLPH1/IBU6hZOivjvTB49A8sGDCOMX6S1J2ZyjBGCGY90GC5FLBNxr8smgfGs7LeQCVrnHFOC481BAcE2mTmt9ArHgh8YYqBE217U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526348; c=relaxed/simple;
	bh=2ZIbb7SsG7Qpos6TxnBT9Bajb7t6thLPgxPtHsg3lUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovn/pNOeAlbAbBtrD1BW1huJP2+Lrk7wQ1QBA249q7i9Osj2/tssEYqL5CodDOftMu5bvUn+Omc59Apt0CZKblCMCSNW5EcCmkIppnYWL3TqB/pR02zXElua6Zw09aF52ZznMCjptp/+k4XfCW6deTCIBXzSyzre3+azbqlDL0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LaJG//gj; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LaJG//gj"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e94cfaa274fso866230276.0;
        Mon, 18 Aug 2025 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526344; x=1756131144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4e/q+kJXeAqQmPS7pcWlteAtgFBBd3fwbJQDa/Uf6nM=;
        b=LaJG//gjx+NGAhFMwtODdnAe6qXMiO7l/w4mNj9DmnHcXO6nGVQ4b7g+MgoGE02/pr
         yW3B9nG2ne4uVNRvKBA+/5Uw6WkRsykQ8OpAYQChsatwPOgi6VuJYyquXS6o0RKm3LKV
         b27q/MRPgxyYZ3gU9JrATJdLHkeXCAyBJ/SBz7f8vwtLCsrE7prauur7IQnff/QAMT0P
         NvgYnvPqFWmhHVgMUk4XO05utEBzS4OHlkWJ1HtEEsq7LYlCmxeAUTJvfuVKlDBCwkOa
         w6LAZ1/Yg0BdcA6dKVl3oDbHSdSI/G+cDpcg9cU0v4CcZwfbkoFr6YuryNgo27a01gjE
         764A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526344; x=1756131144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4e/q+kJXeAqQmPS7pcWlteAtgFBBd3fwbJQDa/Uf6nM=;
        b=LbNDPOusvV1zSAEGC/kBl5cGtkgc5dWznfxgQjnRPEp68YpD17IiSfHwr9lg2C+SAC
         /IxUKOnmOf7q6qtavd+/ICOGk4Ty7LWD5fj3N69wsbx2ar7ZvxTSPeko51hjrcOgMBaJ
         0neSo0Iqypc4R6ppAvBwIGAOWWr1R/L7VnIHbwVb5P8eVzXvetjotEIja5Qt9m+M9AIb
         F6QMODr9PqoKvn4brQ5ThaVcxbqQc1Rrf4E9wx/Hox0SdTHbvyucWQHdo/plVHSBkZUu
         eahgOxucNRn9SeWlXhvC4OSNgYhg0oQD4M0TnJvCV6GJb46v+P4wIlrOBvEMl5Jg6DVY
         rtMw==
X-Forwarded-Encrypted: i=1; AJvYcCVQQWeHLooT/OWjk4RIXFIt0MC4pibQcxmNUnAspp2j7EhX3W9IvH+pOWHLI5h+r7PBKc2rXJAJl+FT@vger.kernel.org
X-Gm-Message-State: AOJu0YysZHFmX3uVBKb4E0xjqKtLa6Gc/SDe9Sc+N6HBRNtb/CRNJGzh
	LHiDcs1T9w3KJ0yaNOoxE1fAySFMbsGdCUWxTyTcbuYDGbi0iu+q3n9cwhpbyzWanPw=
X-Gm-Gg: ASbGnctaeIjdYEnPNVNcRaOXqaDa5juWvciOxflQgmE9y6F0jlroUEzTAdPg/mb0q6k
	zTRHWW1YWI8O6n6ESvVa0ftb2n98iT7iE3h4q1sqJBr0O/f9WlZq7pxhzhL8LxXxPApnqBYKbuE
	JpcTg5jkcrTHaAV51jCO4dWtK1GP5HWB9RTOFYuiACMsMEco/+8NV73ZCeUP2++vdAtLyEKbW7N
	drdvyW8XiyCcFeQvNXR1KDuvS20o+4xbnZ8HKvqV+dt0GV721JIvick3fED/dxt2V3SQfN0knYw
	47bCdIoHU3kwcY1FywaltgmP1gwCBIsq25XE0X4eeYDBPn1ZjyC46OaQzNi1Y7VmX+ACA3RTAmM
	e21P8Omw1rqr1Esk/cGEXLiAS02QExwjhd2Qj2nja6n+VyX00My8zh+h9yUUEt0j9+ZoCTuCzPn
	w7YzSZXB13
X-Google-Smtp-Source: AGHT+IG0AxJvJ03Op1P6VtxxoA8SGSKAcJfh+SvXi8rM7sZ9GqA4tv5LhJhgNmEc6CzRXGq9jjZhaA==
X-Received: by 2002:a05:6902:128b:b0:e7d:49e1:83d4 with SMTP id 3f1490d57ef6-e93323b7e80mr14641024276.11.1755526342550;
        Mon, 18 Aug 2025 07:12:22 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:22 -0700 (PDT)
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
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 02/15] net: build socket infrastructure for QUIC protocol
Date: Mon, 18 Aug 2025 10:04:25 -0400
Message-ID: <0456736751c8beb50a089368d8adb71ecccb32b1.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1755525878.git.lucien.xin@gmail.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch lays the groundwork for QUIC socket support in the kernel.
It defines the core structures and protocol hooks needed to create
QUIC sockets, without implementing any protocol behavior at this stage.

Basic integration is included to allow building the module via
CONFIG_IP_QUIC=m.

This provides the scaffolding necessary for adding actual QUIC socket
behavior in follow-up patches.

Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/Kconfig         |   1 +
 net/Makefile        |   1 +
 net/quic/Kconfig    |  35 +++++
 net/quic/Makefile   |   8 +
 net/quic/protocol.c | 370 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/protocol.h |  55 +++++++
 net/quic/socket.c   | 213 +++++++++++++++++++++++++
 net/quic/socket.h   |  79 ++++++++++
 8 files changed, 762 insertions(+)
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/protocol.c
 create mode 100644 net/quic/protocol.h
 create mode 100644 net/quic/socket.c
 create mode 100644 net/quic/socket.h

diff --git a/net/Kconfig b/net/Kconfig
index d5865cf19799..1205f5b7cf59 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -249,6 +249,7 @@ source "net/bridge/netfilter/Kconfig"
 
 endif # if NETFILTER
 
+source "net/quic/Kconfig"
 source "net/sctp/Kconfig"
 source "net/rds/Kconfig"
 source "net/tipc/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index aac960c41db6..7c6de28e9aa5 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_PHONET)		+= phonet/
 ifneq ($(CONFIG_VLAN_8021Q),)
 obj-y				+= 8021q/
 endif
+obj-$(CONFIG_IP_QUIC)		+= quic/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
 obj-$(CONFIG_RDS)		+= rds/
 obj-$(CONFIG_WIRELESS)		+= wireless/
diff --git a/net/quic/Kconfig b/net/quic/Kconfig
new file mode 100644
index 000000000000..b64fa398750e
--- /dev/null
+++ b/net/quic/Kconfig
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# QUIC configuration
+#
+
+menuconfig IP_QUIC
+	tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Experimental)"
+	depends on INET
+	depends on IPV6
+	select CRYPTO
+	select CRYPTO_HMAC
+	select CRYPTO_HKDF
+	select CRYPTO_AES
+	select CRYPTO_GCM
+	select CRYPTO_CCM
+	select CRYPTO_CHACHA20POLY1305
+	select NET_UDP_TUNNEL
+	help
+	  QUIC: A UDP-Based Multiplexed and Secure Transport
+
+	  From rfc9000 <https://www.rfc-editor.org/rfc/rfc9000.html>.
+
+	  QUIC provides applications with flow-controlled streams for structured
+	  communication, low-latency connection establishment, and network path
+	  migration.  QUIC includes security measures that ensure
+	  confidentiality, integrity, and availability in a range of deployment
+	  circumstances.  Accompanying documents describe the integration of
+	  TLS for key negotiation, loss detection, and an exemplary congestion
+	  control algorithm.
+
+	  To compile this protocol support as a module, choose M here: the
+	  module will be called quic. Debug messages are handled by the
+	  kernel's dynamic debugging framework.
+
+	  If in doubt, say N.
diff --git a/net/quic/Makefile b/net/quic/Makefile
new file mode 100644
index 000000000000..020e4dd133d8
--- /dev/null
+++ b/net/quic/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for QUIC support code.
+#
+
+obj-$(CONFIG_IP_QUIC) += quic.o
+
+quic-y := protocol.o socket.o
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
new file mode 100644
index 000000000000..01a5fdfb5227
--- /dev/null
+++ b/net/quic/protocol.c
@@ -0,0 +1,370 @@
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
+#include <linux/version.h>
+#include <linux/proc_fs.h>
+#include <net/protocol.h>
+#include <net/rps.h>
+#include <net/tls.h>
+
+#include "socket.h"
+
+static unsigned int quic_net_id __read_mostly;
+
+struct percpu_counter quic_sockets_allocated;
+
+long sysctl_quic_mem[3];
+int sysctl_quic_rmem[3];
+int sysctl_quic_wmem[3];
+
+static int quic_inet_connect(struct socket *sock, struct sockaddr *addr, int addr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	const struct proto *prot;
+
+	if (addr_len < (int)sizeof(addr->sa_family))
+		return -EINVAL;
+
+	prot = READ_ONCE(sk->sk_prot);
+
+	return prot->connect(sk, addr, addr_len);
+}
+
+static int quic_inet_listen(struct socket *sock, int backlog)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
+{
+	return -EOPNOTSUPP;
+}
+
+static __poll_t quic_inet_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	return 0;
+}
+
+static struct ctl_table quic_table[] = {
+	{
+		.procname	= "quic_mem",
+		.data		= &sysctl_quic_mem,
+		.maxlen		= sizeof(sysctl_quic_mem),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax
+	},
+	{
+		.procname	= "quic_rmem",
+		.data		= &sysctl_quic_rmem,
+		.maxlen		= sizeof(sysctl_quic_rmem),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "quic_wmem",
+		.data		= &sysctl_quic_wmem,
+		.maxlen		= sizeof(sysctl_quic_wmem),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+};
+
+struct quic_net *quic_net(struct net *net)
+{
+	return net_generic(net, quic_net_id);
+}
+
+#ifdef CONFIG_PROC_FS
+static const struct snmp_mib quic_snmp_list[] = {
+	SNMP_MIB_ITEM("QuicConnCurrentEstabs", QUIC_MIB_CONN_CURRENTESTABS),
+	SNMP_MIB_ITEM("QuicConnPassiveEstabs", QUIC_MIB_CONN_PASSIVEESTABS),
+	SNMP_MIB_ITEM("QuicConnActiveEstabs", QUIC_MIB_CONN_ACTIVEESTABS),
+	SNMP_MIB_ITEM("QuicPktRcvFastpaths", QUIC_MIB_PKT_RCVFASTPATHS),
+	SNMP_MIB_ITEM("QuicPktDecFastpaths", QUIC_MIB_PKT_DECFASTPATHS),
+	SNMP_MIB_ITEM("QuicPktEncFastpaths", QUIC_MIB_PKT_ENCFASTPATHS),
+	SNMP_MIB_ITEM("QuicPktRcvBacklogs", QUIC_MIB_PKT_RCVBACKLOGS),
+	SNMP_MIB_ITEM("QuicPktDecBacklogs", QUIC_MIB_PKT_DECBACKLOGS),
+	SNMP_MIB_ITEM("QuicPktEncBacklogs", QUIC_MIB_PKT_ENCBACKLOGS),
+	SNMP_MIB_ITEM("QuicPktInvHdrDrop", QUIC_MIB_PKT_INVHDRDROP),
+	SNMP_MIB_ITEM("QuicPktInvNumDrop", QUIC_MIB_PKT_INVNUMDROP),
+	SNMP_MIB_ITEM("QuicPktInvFrmDrop", QUIC_MIB_PKT_INVFRMDROP),
+	SNMP_MIB_ITEM("QuicPktRcvDrop", QUIC_MIB_PKT_RCVDROP),
+	SNMP_MIB_ITEM("QuicPktDecDrop", QUIC_MIB_PKT_DECDROP),
+	SNMP_MIB_ITEM("QuicPktEncDrop", QUIC_MIB_PKT_ENCDROP),
+	SNMP_MIB_ITEM("QuicFrmRcvBufDrop", QUIC_MIB_FRM_RCVBUFDROP),
+	SNMP_MIB_ITEM("QuicFrmRetrans", QUIC_MIB_FRM_RETRANS),
+	SNMP_MIB_ITEM("QuicFrmOutCloses", QUIC_MIB_FRM_OUTCLOSES),
+	SNMP_MIB_ITEM("QuicFrmInCloses", QUIC_MIB_FRM_INCLOSES),
+	SNMP_MIB_SENTINEL
+};
+
+static int quic_snmp_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned long buff[QUIC_MIB_MAX];
+	struct net *net = seq->private;
+	u32 idx;
+
+	memset(buff, 0, sizeof(unsigned long) * QUIC_MIB_MAX);
+
+	snmp_get_cpu_field_batch(buff, quic_snmp_list, quic_net(net)->stat);
+	for (idx = 0; quic_snmp_list[idx].name; idx++)
+		seq_printf(seq, "%-32s\t%ld\n", quic_snmp_list[idx].name, buff[idx]);
+
+	return 0;
+}
+
+static int quic_net_proc_init(struct net *net)
+{
+	quic_net(net)->proc_net = proc_net_mkdir(net, "quic", net->proc_net);
+	if (!quic_net(net)->proc_net)
+		return -ENOMEM;
+
+	if (!proc_create_net_single("snmp", 0444, quic_net(net)->proc_net,
+				    quic_snmp_seq_show, NULL))
+		goto free;
+	return 0;
+free:
+	remove_proc_subtree("quic", net->proc_net);
+	quic_net(net)->proc_net = NULL;
+	return -ENOMEM;
+}
+
+static void quic_net_proc_exit(struct net *net)
+{
+	remove_proc_subtree("quic", net->proc_net);
+	quic_net(net)->proc_net = NULL;
+}
+#endif
+
+static const struct proto_ops quic_proto_ops = {
+	.family		   = PF_INET,
+	.owner		   = THIS_MODULE,
+	.release	   = inet_release,
+	.bind		   = inet_bind,
+	.connect	   = quic_inet_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = inet_accept,
+	.getname	   = quic_inet_getname,
+	.poll		   = quic_inet_poll,
+	.ioctl		   = inet_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = quic_inet_listen,
+	.shutdown	   = inet_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet_sendmsg,
+	.recvmsg	   = inet_recvmsg,
+	.mmap		   = sock_no_mmap,
+};
+
+static struct inet_protosw quic_stream_protosw = {
+	.type       = SOCK_STREAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quic_prot,
+	.ops        = &quic_proto_ops,
+};
+
+static struct inet_protosw quic_dgram_protosw = {
+	.type       = SOCK_DGRAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quic_prot,
+	.ops        = &quic_proto_ops,
+};
+
+static const struct proto_ops quicv6_proto_ops = {
+	.family		   = PF_INET6,
+	.owner		   = THIS_MODULE,
+	.release	   = inet6_release,
+	.bind		   = inet6_bind,
+	.connect	   = quic_inet_connect,
+	.socketpair	   = sock_no_socketpair,
+	.accept		   = inet_accept,
+	.getname	   = quic_inet_getname,
+	.poll		   = quic_inet_poll,
+	.ioctl		   = inet6_ioctl,
+	.gettstamp	   = sock_gettstamp,
+	.listen		   = quic_inet_listen,
+	.shutdown	   = inet_shutdown,
+	.setsockopt	   = sock_common_setsockopt,
+	.getsockopt	   = sock_common_getsockopt,
+	.sendmsg	   = inet_sendmsg,
+	.recvmsg	   = inet_recvmsg,
+	.mmap		   = sock_no_mmap,
+};
+
+static struct inet_protosw quicv6_stream_protosw = {
+	.type       = SOCK_STREAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quicv6_prot,
+	.ops        = &quicv6_proto_ops,
+};
+
+static struct inet_protosw quicv6_dgram_protosw = {
+	.type       = SOCK_DGRAM,
+	.protocol   = IPPROTO_QUIC,
+	.prot       = &quicv6_prot,
+	.ops        = &quicv6_proto_ops,
+};
+
+static int quic_protosw_init(void)
+{
+	int err;
+
+	err = proto_register(&quic_prot, 1);
+	if (err)
+		return err;
+
+	err = proto_register(&quicv6_prot, 1);
+	if (err) {
+		proto_unregister(&quic_prot);
+		return err;
+	}
+
+	inet_register_protosw(&quic_stream_protosw);
+	inet_register_protosw(&quic_dgram_protosw);
+	inet6_register_protosw(&quicv6_stream_protosw);
+	inet6_register_protosw(&quicv6_dgram_protosw);
+
+	return 0;
+}
+
+static void quic_protosw_exit(void)
+{
+	inet_unregister_protosw(&quic_dgram_protosw);
+	inet_unregister_protosw(&quic_stream_protosw);
+	proto_unregister(&quic_prot);
+
+	inet6_unregister_protosw(&quicv6_dgram_protosw);
+	inet6_unregister_protosw(&quicv6_stream_protosw);
+	proto_unregister(&quicv6_prot);
+}
+
+static int __net_init quic_net_init(struct net *net)
+{
+	struct quic_net *qn = quic_net(net);
+	int err;
+
+	qn->stat = alloc_percpu(struct quic_mib);
+	if (!qn->stat)
+		return -ENOMEM;
+
+#ifdef CONFIG_PROC_FS
+	err = quic_net_proc_init(net);
+	if (err) {
+		free_percpu(qn->stat);
+		qn->stat = NULL;
+	}
+#endif
+	return err;
+}
+
+static void __net_exit quic_net_exit(struct net *net)
+{
+	struct quic_net *qn = quic_net(net);
+
+#ifdef CONFIG_PROC_FS
+	quic_net_proc_exit(net);
+#endif
+	free_percpu(qn->stat);
+	qn->stat = NULL;
+}
+
+static struct pernet_operations quic_net_ops = {
+	.init = quic_net_init,
+	.exit = quic_net_exit,
+	.id   = &quic_net_id,
+	.size = sizeof(struct quic_net),
+};
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *quic_sysctl_header;
+
+static void quic_sysctl_register(void)
+{
+	quic_sysctl_header = register_net_sysctl(&init_net, "net/quic", quic_table);
+}
+
+static void quic_sysctl_unregister(void)
+{
+	unregister_net_sysctl_table(quic_sysctl_header);
+}
+#endif
+
+static __init int quic_init(void)
+{
+	int max_share, err = -ENOMEM;
+	unsigned long limit;
+
+	/* Set QUIC memory limits based on available system memory, similar to sctp_init(). */
+	limit = nr_free_buffer_pages() / 8;
+	limit = max(limit, 128UL);
+	sysctl_quic_mem[0] = (long)limit / 4 * 3;
+	sysctl_quic_mem[1] = (long)limit;
+	sysctl_quic_mem[2] = sysctl_quic_mem[0] * 2;
+
+	limit = (sysctl_quic_mem[1]) << (PAGE_SHIFT - 7);
+	max_share = min(4UL * 1024 * 1024, limit);
+
+	sysctl_quic_rmem[0] = PAGE_SIZE;
+	sysctl_quic_rmem[1] = 1024 * 1024;
+	sysctl_quic_rmem[2] = max(sysctl_quic_rmem[1], max_share);
+
+	sysctl_quic_wmem[0] = PAGE_SIZE;
+	sysctl_quic_wmem[1] = 16 * 1024;
+	sysctl_quic_wmem[2] = max(64 * 1024, max_share);
+
+	err = percpu_counter_init(&quic_sockets_allocated, 0, GFP_KERNEL);
+	if (err)
+		goto err_percpu_counter;
+
+	err = register_pernet_subsys(&quic_net_ops);
+	if (err)
+		goto err_def_ops;
+
+	err = quic_protosw_init();
+	if (err)
+		goto err_protosw;
+
+#ifdef CONFIG_SYSCTL
+	quic_sysctl_register();
+#endif
+	pr_info("quic: init\n");
+	return 0;
+
+err_protosw:
+	unregister_pernet_subsys(&quic_net_ops);
+err_def_ops:
+	percpu_counter_destroy(&quic_sockets_allocated);
+err_percpu_counter:
+	return err;
+}
+
+static __exit void quic_exit(void)
+{
+#ifdef CONFIG_SYSCTL
+	quic_sysctl_unregister();
+#endif
+	quic_protosw_exit();
+	unregister_pernet_subsys(&quic_net_ops);
+	percpu_counter_destroy(&quic_sockets_allocated);
+	pr_info("quic: exit\n");
+}
+
+module_init(quic_init);
+module_exit(quic_exit);
+
+MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
+MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
+MODULE_AUTHOR("Xin Long <lucien.xin@gmail.com>");
+MODULE_DESCRIPTION("Support for the QUIC protocol (RFC9000)");
+MODULE_LICENSE("GPL");
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
new file mode 100644
index 000000000000..6e6c5a6fc3f8
--- /dev/null
+++ b/net/quic/protocol.h
@@ -0,0 +1,55 @@
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
+extern struct percpu_counter quic_sockets_allocated;
+
+extern long sysctl_quic_mem[3];
+extern int sysctl_quic_rmem[3];
+extern int sysctl_quic_wmem[3];
+
+enum {
+	QUIC_MIB_NUM = 0,
+	QUIC_MIB_CONN_CURRENTESTABS,	/* Currently established connections */
+	QUIC_MIB_CONN_PASSIVEESTABS,	/* Connections established passively (server-side accept) */
+	QUIC_MIB_CONN_ACTIVEESTABS,	/* Connections established actively (client-side connect) */
+	QUIC_MIB_PKT_RCVFASTPATHS,	/* Packets received on the fast path */
+	QUIC_MIB_PKT_DECFASTPATHS,	/* Packets successfully decrypted on the fast path */
+	QUIC_MIB_PKT_ENCFASTPATHS,	/* Packets encrypted on the fast path (for transmission) */
+	QUIC_MIB_PKT_RCVBACKLOGS,	/* Packets received via backlog processing */
+	QUIC_MIB_PKT_DECBACKLOGS,	/* Packets decrypted in backlog handler */
+	QUIC_MIB_PKT_ENCBACKLOGS,	/* Packets encrypted in backlog handler */
+	QUIC_MIB_PKT_INVHDRDROP,	/* Packets dropped due to invalid headers */
+	QUIC_MIB_PKT_INVNUMDROP,	/* Packets dropped due to invalid packet numbers */
+	QUIC_MIB_PKT_INVFRMDROP,	/* Packets dropped due to invalid frames */
+	QUIC_MIB_PKT_RCVDROP,		/* Packets dropped on receive (general errors) */
+	QUIC_MIB_PKT_DECDROP,		/* Packets dropped due to decryption failure */
+	QUIC_MIB_PKT_ENCDROP,		/* Packets dropped due to encryption failure */
+	QUIC_MIB_FRM_RCVBUFDROP,	/* Frames dropped due to receive buffer limits */
+	QUIC_MIB_FRM_RETRANS,		/* Frames retransmitted */
+	QUIC_MIB_FRM_OUTCLOSES,		/* Frames of CONNECTION_CLOSE sent */
+	QUIC_MIB_FRM_INCLOSES,		/* Frames of CONNECTION_CLOSE received */
+	QUIC_MIB_MAX
+};
+
+struct quic_mib {
+	unsigned long	mibs[QUIC_MIB_MAX];	/* Array of counters indexed by the enum above */
+};
+
+struct quic_net {
+	DEFINE_SNMP_STAT(struct quic_mib, stat);	/* Per-network namespace MIB statistics */
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc_net;	/* procfs entry for dumping QUIC socket stats */
+#endif
+};
+
+struct quic_net *quic_net(struct net *net);
+
+#define QUIC_INC_STATS(net, field)	SNMP_INC_STATS(quic_net(net)->stat, field)
+#define QUIC_DEC_STATS(net, field)	SNMP_DEC_STATS(quic_net(net)->stat, field)
diff --git a/net/quic/socket.c b/net/quic/socket.c
new file mode 100644
index 000000000000..320a9a5a3c53
--- /dev/null
+++ b/net/quic/socket.c
@@ -0,0 +1,213 @@
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
+#include <linux/version.h>
+#include <net/tls.h>
+
+#include "socket.h"
+
+static DEFINE_PER_CPU(int, quic_memory_per_cpu_fw_alloc);
+static unsigned long quic_memory_pressure;
+static atomic_long_t quic_memory_allocated;
+
+static void quic_enter_memory_pressure(struct sock *sk)
+{
+	WRITE_ONCE(quic_memory_pressure, 1);
+}
+
+static void quic_write_space(struct sock *sk)
+{
+	struct socket_wq *wq;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
+	rcu_read_unlock();
+}
+
+static int quic_init_sock(struct sock *sk)
+{
+	sk->sk_destruct = inet_sock_destruct;
+	sk->sk_write_space = quic_write_space;
+	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
+
+	local_bh_disable();
+	sk_sockets_allocated_inc(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+	local_bh_enable();
+
+	return 0;
+}
+
+static void quic_destroy_sock(struct sock *sk)
+{
+	local_bh_disable();
+	sk_sockets_allocated_dec(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+	local_bh_enable();
+}
+
+static int quic_bind(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_connect(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_hash(struct sock *sk)
+{
+	return 0;
+}
+
+static void quic_unhash(struct sock *sk)
+{
+}
+
+static int quic_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
+			int *addr_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct sock *quic_accept(struct sock *sk, struct proto_accept_arg *arg)
+{
+	arg->err = -EOPNOTSUPP;
+	return NULL;
+}
+
+static void quic_close(struct sock *sk, long timeout)
+{
+	lock_sock(sk);
+
+	quic_set_state(sk, QUIC_SS_CLOSED);
+
+	release_sock(sk);
+
+	sk_common_release(sk);
+}
+
+static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval, unsigned int optlen)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_setsockopt(struct sock *sk, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	if (level != SOL_QUIC)
+		return -EOPNOTSUPP;
+
+	return quic_do_setsockopt(sk, optname, optval, optlen);
+}
+
+static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval, sockptr_t optlen)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	if (level != SOL_QUIC)
+		return -EOPNOTSUPP;
+
+	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
+}
+
+static void quic_release_cb(struct sock *sk)
+{
+}
+
+static int quic_disconnect(struct sock *sk, int flags)
+{
+	quic_set_state(sk, QUIC_SS_CLOSED); /* for a listen socket only */
+	return 0;
+}
+
+static void quic_shutdown(struct sock *sk, int how)
+{
+	quic_set_state(sk, QUIC_SS_CLOSED);
+}
+
+struct proto quic_prot = {
+	.name		=  "QUIC",
+	.owner		=  THIS_MODULE,
+	.init		=  quic_init_sock,
+	.destroy	=  quic_destroy_sock,
+	.shutdown	=  quic_shutdown,
+	.setsockopt	=  quic_setsockopt,
+	.getsockopt	=  quic_getsockopt,
+	.connect	=  quic_connect,
+	.bind		=  quic_bind,
+	.close		=  quic_close,
+	.disconnect	=  quic_disconnect,
+	.sendmsg	=  quic_sendmsg,
+	.recvmsg	=  quic_recvmsg,
+	.accept		=  quic_accept,
+	.hash		=  quic_hash,
+	.unhash		=  quic_unhash,
+	.release_cb	=  quic_release_cb,
+	.no_autobind	=  true,
+	.obj_size	=  sizeof(struct quic_sock),
+	.sysctl_mem		=  sysctl_quic_mem,
+	.sysctl_rmem		=  sysctl_quic_rmem,
+	.sysctl_wmem		=  sysctl_quic_wmem,
+	.memory_pressure	=  &quic_memory_pressure,
+	.enter_memory_pressure	=  quic_enter_memory_pressure,
+	.memory_allocated	=  &quic_memory_allocated,
+	.per_cpu_fw_alloc	=  &quic_memory_per_cpu_fw_alloc,
+	.sockets_allocated	=  &quic_sockets_allocated,
+};
+
+struct proto quicv6_prot = {
+	.name		=  "QUICv6",
+	.owner		=  THIS_MODULE,
+	.init		=  quic_init_sock,
+	.destroy	=  quic_destroy_sock,
+	.shutdown	=  quic_shutdown,
+	.setsockopt	=  quic_setsockopt,
+	.getsockopt	=  quic_getsockopt,
+	.connect	=  quic_connect,
+	.bind		=  quic_bind,
+	.close		=  quic_close,
+	.disconnect	=  quic_disconnect,
+	.sendmsg	=  quic_sendmsg,
+	.recvmsg	=  quic_recvmsg,
+	.accept		=  quic_accept,
+	.hash		=  quic_hash,
+	.unhash		=  quic_unhash,
+	.release_cb	=  quic_release_cb,
+	.no_autobind	=  true,
+	.obj_size	= sizeof(struct quic6_sock),
+	.ipv6_pinfo_offset	=  offsetof(struct quic6_sock, inet6),
+	.sysctl_mem		=  sysctl_quic_mem,
+	.sysctl_rmem		=  sysctl_quic_rmem,
+	.sysctl_wmem		=  sysctl_quic_wmem,
+	.memory_pressure	=  &quic_memory_pressure,
+	.enter_memory_pressure	=  quic_enter_memory_pressure,
+	.memory_allocated	=  &quic_memory_allocated,
+	.per_cpu_fw_alloc	=  &quic_memory_per_cpu_fw_alloc,
+	.sockets_allocated	=  &quic_sockets_allocated,
+};
diff --git a/net/quic/socket.h b/net/quic/socket.h
new file mode 100644
index 000000000000..ded8eb2e6a9c
--- /dev/null
+++ b/net/quic/socket.h
@@ -0,0 +1,79 @@
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
+#include <net/udp_tunnel.h>
+
+#include "protocol.h"
+
+extern struct proto quic_prot;
+extern struct proto quicv6_prot;
+
+enum quic_state {
+	QUIC_SS_CLOSED		= TCP_CLOSE,
+	QUIC_SS_LISTENING	= TCP_LISTEN,
+	QUIC_SS_ESTABLISHING	= TCP_SYN_RECV,
+	QUIC_SS_ESTABLISHED	= TCP_ESTABLISHED,
+};
+
+struct quic_sock {
+	struct inet_sock		inet;
+	struct list_head		reqs;
+};
+
+struct quic6_sock {
+	struct quic_sock	quic;
+	struct ipv6_pinfo	inet6;
+};
+
+static inline struct quic_sock *quic_sk(const struct sock *sk)
+{
+	return (struct quic_sock *)sk;
+}
+
+static inline struct list_head *quic_reqs(const struct sock *sk)
+{
+	return &quic_sk(sk)->reqs;
+}
+
+static inline bool quic_is_establishing(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_ESTABLISHING;
+}
+
+static inline bool quic_is_established(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_ESTABLISHED;
+}
+
+static inline bool quic_is_listen(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_LISTENING;
+}
+
+static inline bool quic_is_closed(struct sock *sk)
+{
+	return sk->sk_state == QUIC_SS_CLOSED;
+}
+
+static inline void quic_set_state(struct sock *sk, int state)
+{
+	struct net *net = sock_net(sk);
+
+	if (sk->sk_state == state)
+		return;
+
+	if (state == QUIC_SS_ESTABLISHED)
+		QUIC_INC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
+	else if (quic_is_established(sk))
+		QUIC_DEC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
+
+	inet_sk_set_state(sk, state);
+	sk->sk_state_change(sk);
+}
-- 
2.47.1

