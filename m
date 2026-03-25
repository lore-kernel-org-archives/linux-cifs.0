Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D6F2DF3EA
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 03:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774410572; cv=none; b=lPNnuIT8nL8093mEFnfAuTFdEPcAWqB5KHtpTVQuPQC3mYwV6DpKvQW/Ry5vyIZZzrFt1L8BZlxbndG2Mz8TMuUZbcDxDDuZXDRvth7t6bTYQRorhMejx1h7ZBP5pHywaXlnru+KvQwUmbN+lVg+sJmQwwNH5BwMZ4LNVa5FDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774410572; c=relaxed/simple;
	bh=ZPw8PNCf8kVvZG5ERze4P/B9wIV7n/qx7y2gUDpGR9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lthRtGP/Ut0qEkA9itqtqlbMnO1DkH0gVMIRRMIDVPZGxsjWzatQa1a3gHeLzDbi1tXOxbBJQTFDQxN2uco15X1of00a9SSRBak6LOWblE7yHkGsP7owcbVvwtsCRfYMMmK9r0XmTbsBcszFiwdDD+7a8IOTJj2PHfp5rEoCSEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fb9yRuiN; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fb9yRuiN"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506aa68065eso16310881cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 20:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774410567; x=1775015367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNwjo5K8PPVa+ptrJ9SEZH8KZqtvi/FX28vYT6/Syxo=;
        b=Fb9yRuiNrb9AcJDUsBCtfKylNK3avNZRuK2x7qkrKZKk3hwugyjMvaZIDVXA5ugqcJ
         IgD7Kb7X7PvZAJKwE6uMf9+QERVWR/LZDV/gxJpiVdpZimgnRSspkYgOkJY7FugLj3DX
         htCgeUZaNz5D6jtINFjcV55dpNva6/LVy8Z7jZ0ouWLbwnHSgmRQbFwPRls/XYAgOtmm
         sBfY0kJWkeilINoSr7zon/Rn/f612HkeFT8xJayPs1pZURn2QH8AlRrcr8RDdJIxAHng
         mx6bKW7i1l3oYjBhpcuAfV2112mN7zwVHPQIuuBGiG6p8wYUSCRCkNuuuWoWlhz7oPwa
         EaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774410567; x=1775015367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kNwjo5K8PPVa+ptrJ9SEZH8KZqtvi/FX28vYT6/Syxo=;
        b=TX2tXISfTVY9XN2R1F76rEp/TWS3dTpTtpQLrzImHoymUoG2TnImW8c8tDka5S7bB5
         4cMaw5kjGe9IBu4vgIAvrWNM3pkNsYYvO54RnKIZxNf6JLE639/Gld/f5a5HyyOUSEYl
         Rbm1MT773+AP+C/eo55u7t+HTDgj1WOIDB+auYYfcaHhbSfaAo90inCm00uUzeKbmGkL
         IJioefmd1xl6cQ8BaB67a5ClobEUyV8bbj7fK+Cz7nJvmV+VI1Vrx04JQRRZ4f8O/yjp
         +w1pnXJzTisTPE3GAKPPFlsD3+Ahfv2B9SJaaz6qza7wBwg9GFPkiTpuz3FFRgKvAIhK
         z5hQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/YwDS77txodHjZEmzzANMUl+KG0BrVOYyfN31UM4hBLu9yaXi9WrBW0cmaJdAdthtFkVFksWD6Cbm@vger.kernel.org
X-Gm-Message-State: AOJu0YzxWQmBrtZZa8MJqalKvFsPaW7EFu7dC4XwvfMc9mzJ6Frm+fUp
	n0dyBeS6LKOqhNpyXzgR/3dA1MSblKsCXCR+tDsnVbE3Uaqrs7HP0cI+
X-Gm-Gg: ATEYQzxfJhqD2A12RbgHR9QKnrYAYXtxRIS4yeKzwPjaDrskFA80HwNpw29DMT5iHpl
	VRzn9R4aRbTzBIM7aXJXBifK7J0KmFYdDj1rH6u47ZNteN8PAVUKPcYkwXrn2IyekhKGyjnLxid
	/XW+Wex7pNrF3Ooz1RCIKjh6u+rgscWccA/5n1oH/gt6qFs8Fq2q7yvR6ZP4p8OW1FMjFCNAque
	ZuHjPHQF64NVFbQooyLXnmr8WuyS4cR9ycgzNwC96iQ1CD2HAAjtWs9hCeJ/G0YDSeRWRBxiQOe
	paPuTCbjE8m4teYK8E0I7LhHL3M2Uwk8PI5lK/PKgo6yc6q2+irp4j9U6KRcav1fedYG/nrzrIL
	65WnEVfXhVYX38Wl/3G8dcencJRXgiIMeeAedGcRExHSI5iZpZ0C15UONZN5sVXjqHF7EI3p6y4
	qZf2uNgzWNmfwqUsB5pP+2nIf4w2qPp/6EuA3j7HNL7mnDEelDxUXBF5b2v0qAE6RSfsalIfRaf
	ydoxeyFtUFrdk6wrHUs+3oSjrxwti8bhmQcWV/0GEelw/dcjW4Poq3qveSVDCYPqQ==
X-Received: by 2002:a05:622a:4aca:b0:509:2618:cefb with SMTP id d75a77b69052e-50b80e31f79mr30250911cf.38.1774410566686;
        Tue, 24 Mar 2026 20:49:26 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36cb2e29sm150093001cf.1.2026.03.24.20.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 20:49:25 -0700 (PDT)
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
Subject: [PATCH net-next v11 02/15] net: build socket infrastructure for QUIC protocol
Date: Tue, 24 Mar 2026 23:47:07 -0400
Message-ID: <cae762719982e0700f5302c01a6b3b6fc16c3c73.1774410440.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1774410440.git.lucien.xin@gmail.com>
References: <cover.1774410440.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Acked-by: Paolo Abeni <pabeni@redhat.com>
---
v3:
  - Kconfig: add 'default n' for IP_QUIC (reported by Paolo).
  - quic_disconnect(): return -EOPNOTSUPP (suggested by Paolo).
  - quic_init/destroy_sock(): drop local_bh_disable/enable() calls (noted
    by Paolo).
  - sysctl: add alpn_demux option to en/disable ALPN-based demux.
  - SNMP: remove SNMP_MIB_SENTINEL, switch to
    snmp_get_cpu_field_batch_cnt() to align with latest net-next changes.
v4:
  - Remove unnecessary READ_ONCE() in quic_inet_connect() (reported by
    Paolo).
v5:
  - Update the type of the parameter 'addr' in quic_inet_connect(),
    quic_connect(), and quic_bind() to match the latest net-next changes.
  - Define quic_is_serv() to reuse sk->sk_max_ack_backlog for server-side
    detection; path->serv will be deleted in a later patch.
  - Use MODULE_ALIAS_NET_PF_PROTO instead of MODULE_ALIAS (suggested by
    Stefan).
  - Add the missing Documentation entry for the new sysctl options (noted
    by Paolo).
  - Add the missing MAINTAINERS entry for the QUIC PROTOCOL (noted by
    Jakub).
v6:
  - Relocate the QUIC PROTOCOL MAINTAINERS entry to its proper section
    (noted by Jakub).
v7:
  - Replace #ifdef CONFIG_XXX with #if IS_ENABLED(CONFIG_XXX) (noted by
    Paolo).
v8:
  - Fix an issue where an uninitialized value could be returned from
    quic_net_init() by initializing err to 0 (reported by AI review).
  - Replace the global ALPN demultiplexing sysctl with a static key that
    will be enabled only when ALPN is configured on a listening socket
    (noted by Stefan).
v10:
  - Note for AI reviews: inet6_register_protosw() never fails for QUIC,
    so checking its return value is unnecessary.
  - Remove sk_sndbuf/sk_rcvbuf initialization in quic_init_sock(), as it's
    already done in sock_init_data_uid() with sysctl_w/rmem_default.
v11:
  - Note for AI review: quic_sk(sk)->reqs is used only for listen sockets
    and will be initialized in quic_inet_listen() in a later patch, so
    there is no need to initialize it in quic_init_sock().
  - Set maximum line length to 80 characters.
  - Drop addr_len from quic_recvmsg() to match the latest
    proto_ops.recvmsg() update.
  - Use %lu for SNMP counters in quic_snmp_seq_show().
---
 Documentation/networking/ip-sysctl.rst |  39 +++
 MAINTAINERS                            |   7 +
 net/Kconfig                            |   1 +
 net/Makefile                           |   1 +
 net/quic/Kconfig                       |  36 +++
 net/quic/Makefile                      |   8 +
 net/quic/protocol.c                    | 376 +++++++++++++++++++++++++
 net/quic/protocol.h                    |  57 ++++
 net/quic/socket.c                      | 210 ++++++++++++++
 net/quic/socket.h                      |  89 ++++++
 10 files changed, 824 insertions(+)
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/protocol.c
 create mode 100644 net/quic/protocol.h
 create mode 100644 net/quic/socket.c
 create mode 100644 net/quic/socket.h

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2e3a746fcc6d..5e3aafe9e236 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3805,6 +3805,45 @@ l3mdev_accept - BOOLEAN
 	Default: 1 (enabled)
 
 
+``/proc/sys/net/quic/*`` Variables
+===================================
+
+quic_mem - vector of 3 LONGs: min, pressure, max
+	Number of pages allowed for queueing by all QUIC sockets.
+
+	min: below this number of pages QUIC is not bothered about its
+	memory appetite.
+
+	pressure: when amount of memory allocated by QUIC exceeds this number
+	of pages, QUIC moderates its memory consumption and enters memory
+	pressure mode, which is exited when memory consumption falls
+	under "min".
+
+	max: number of pages allowed for queueing by all QUIC sockets.
+
+	Defaults are calculated at boot time from amount of available
+	memory.
+
+quic_rmem - vector of 3 INTEGERs: min, default, max
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimal size of receive buffer used by QUIC sockets.
+	It is guaranteed to each QUIC socket, even under moderate memory
+	pressure.
+
+	Default: 4K
+
+quic_wmem - vector of 3 INTEGERs: min, default, max
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Amount of memory reserved for send buffers for QUIC sockets.
+	Each QUIC socket has rights to use it due to fact of its birth.
+
+	Default: 4K
+
+
 ``/proc/sys/net/core/*``
 ========================
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 7d65f9435950..532030036a8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21896,6 +21896,13 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/quantenna/
 
+QUIC PROTOCOL
+M:	Xin Long <lucien.xin@gmail.com>
+L:	quic@lists.linux.dev
+S:	Maintained
+W:	https://github.com/lxin/quic
+F:	net/quic/
+
 RADEON and AMDGPU DRM DRIVERS
 M:	Alex Deucher <alexander.deucher@amd.com>
 M:	Christian König <christian.koenig@amd.com>
diff --git a/net/Kconfig b/net/Kconfig
index 62266eaf0e95..dd2ed8420102 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -251,6 +251,7 @@ source "net/bridge/netfilter/Kconfig"
 
 endif # if NETFILTER
 
+source "net/quic/Kconfig"
 source "net/sctp/Kconfig"
 source "net/rds/Kconfig"
 source "net/tipc/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 90e3d72bf58b..cd43d03907cd 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_PHONET)		+= phonet/
 ifneq ($(CONFIG_VLAN_8021Q),)
 obj-y				+= 8021q/
 endif
+obj-$(CONFIG_IP_QUIC)		+= quic/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
 obj-$(CONFIG_RDS)		+= rds/
 obj-$(CONFIG_WIRELESS)		+= wireless/
diff --git a/net/quic/Kconfig b/net/quic/Kconfig
new file mode 100644
index 000000000000..bbd174c02c1f
--- /dev/null
+++ b/net/quic/Kconfig
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# QUIC configuration
+#
+
+menuconfig IP_QUIC
+	tristate "QUIC: A UDP-Based Multiplexed Secure Transport (Experimental)"
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
+	default n
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
index 000000000000..73ccbddeff79
--- /dev/null
+++ b/net/quic/protocol.c
@@ -0,0 +1,376 @@
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
+DEFINE_STATIC_KEY_FALSE(quic_alpn_demux_key);
+
+long sysctl_quic_mem[3];
+int sysctl_quic_rmem[3];
+int sysctl_quic_wmem[3];
+
+static int quic_inet_connect(struct socket *sock, struct sockaddr_unsized *addr,
+			     int addr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+
+	if (addr_len < (int)sizeof(addr->sa_family))
+		return -EINVAL;
+
+	return sk->sk_prot->connect(sk, addr, addr_len);
+}
+
+static int quic_inet_listen(struct socket *sock, int backlog)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_inet_getname(struct socket *sock, struct sockaddr *uaddr,
+			     int peer)
+{
+	return -EOPNOTSUPP;
+}
+
+static __poll_t quic_inet_poll(struct file *file, struct socket *sock,
+			       poll_table *wait)
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
+#if IS_ENABLED(CONFIG_PROC_FS)
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
+};
+
+static int quic_snmp_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned long buff[ARRAY_SIZE(quic_snmp_list)];
+	const int cnt = ARRAY_SIZE(quic_snmp_list);
+	struct net *net = seq->private;
+	u32 idx;
+
+	memset(buff, 0, sizeof(buff));
+
+	snmp_get_cpu_field_batch_cnt(buff, quic_snmp_list, cnt,
+				     quic_net(net)->stat);
+	for (idx = 0; idx < cnt; idx++)
+		seq_printf(seq, "%-32s\t%lu\n", quic_snmp_list[idx].name,
+			   buff[idx]);
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
+	int err = 0;
+
+	qn->stat = alloc_percpu(struct quic_mib);
+	if (!qn->stat)
+		return -ENOMEM;
+
+#if IS_ENABLED(CONFIG_PROC_FS)
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
+#if IS_ENABLED(CONFIG_PROC_FS)
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
+#if IS_ENABLED(CONFIG_SYSCTL)
+static struct ctl_table_header *quic_sysctl_header;
+
+static void quic_sysctl_register(void)
+{
+	quic_sysctl_header = register_net_sysctl(&init_net, "net/quic",
+						 quic_table);
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
+	/* Set QUIC memory limits based on available system memory, similar to
+	 * sctp_init().
+	 */
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
+#if IS_ENABLED(CONFIG_SYSCTL)
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
+#if IS_ENABLED(CONFIG_SYSCTL)
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
+MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261); /* IPPROTO_QUIC == 261 */
+MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 261);
+MODULE_AUTHOR("Xin Long <lucien.xin@gmail.com>");
+MODULE_DESCRIPTION("Support for the QUIC protocol (RFC9000)");
+MODULE_LICENSE("GPL");
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
new file mode 100644
index 000000000000..fbd0fe39eccc
--- /dev/null
+++ b/net/quic/protocol.h
@@ -0,0 +1,57 @@
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
+DECLARE_STATIC_KEY_FALSE(quic_alpn_demux_key);
+
+extern long sysctl_quic_mem[3];
+extern int sysctl_quic_rmem[3];
+extern int sysctl_quic_wmem[3];
+
+enum {
+	QUIC_MIB_NUM = 0,
+	QUIC_MIB_CONN_CURRENTESTABS, /* Current established connections */
+	QUIC_MIB_CONN_PASSIVEESTABS, /* Passively established connections */
+	QUIC_MIB_CONN_ACTIVEESTABS,  /* Actively established connections */
+	QUIC_MIB_PKT_RCVFASTPATHS,   /* Packets received on fast path */
+	QUIC_MIB_PKT_DECFASTPATHS,   /* Packets decrypted on fast path */
+	QUIC_MIB_PKT_ENCFASTPATHS,   /* Packets encrypted on fast path */
+	QUIC_MIB_PKT_RCVBACKLOGS,    /* Packets processed via backlog */
+	QUIC_MIB_PKT_DECBACKLOGS,    /* Packets decrypted in backlog */
+	QUIC_MIB_PKT_ENCBACKLOGS,    /* Packets encrypted in backlog */
+	QUIC_MIB_PKT_INVHDRDROP,     /* Dropped: invalid packet header */
+	QUIC_MIB_PKT_INVNUMDROP,     /* Dropped: invalid packet number */
+	QUIC_MIB_PKT_INVFRMDROP,     /* Dropped: invalid frame */
+	QUIC_MIB_PKT_RCVDROP,        /* Dropped on receive (general) */
+	QUIC_MIB_PKT_DECDROP,        /* Dropped: decryption failure */
+	QUIC_MIB_PKT_ENCDROP,        /* Dropped: encryption failure */
+	QUIC_MIB_FRM_RCVBUFDROP,     /* Frames dropped: recv buf limit */
+	QUIC_MIB_FRM_RETRANS,        /* Frames retransmitted */
+	QUIC_MIB_FRM_OUTCLOSES,      /* CONNECTION_CLOSE frames sent */
+	QUIC_MIB_FRM_INCLOSES,       /* CONNECTION_CLOSE frames rcvd */
+	QUIC_MIB_MAX
+};
+
+struct quic_mib {
+	unsigned long mibs[QUIC_MIB_MAX]; /* Counters indexed by QUIC_MIB_* */
+};
+
+struct quic_net {
+	DEFINE_SNMP_STAT(struct quic_mib, stat); /* Per-net QUIC MIB stats */
+#if IS_ENABLED(CONFIG_PROC_FS)
+	struct proc_dir_entry *proc_net; /* procfs entry for QUIC stats */
+#endif
+};
+
+struct quic_net *quic_net(struct net *net);
+
+#define QUIC_INC_STATS(net, field) SNMP_INC_STATS(quic_net(net)->stat, field)
+#define QUIC_DEC_STATS(net, field) SNMP_DEC_STATS(quic_net(net)->stat, field)
diff --git a/net/quic/socket.c b/net/quic/socket.c
new file mode 100644
index 000000000000..6605266eaa59
--- /dev/null
+++ b/net/quic/socket.c
@@ -0,0 +1,210 @@
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
+	__poll_t mask = EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
+	struct socket_wq *wq;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, mask);
+	rcu_read_unlock();
+}
+
+static int quic_init_sock(struct sock *sk)
+{
+	sk->sk_destruct = inet_sock_destruct;
+	sk->sk_write_space = quic_write_space;
+	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+	sk_sockets_allocated_inc(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+
+	return 0;
+}
+
+static void quic_destroy_sock(struct sock *sk)
+{
+	sk_sockets_allocated_dec(sk);
+	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+}
+
+static int quic_bind(struct sock *sk, struct sockaddr_unsized *addr,
+		     int addr_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int quic_connect(struct sock *sk, struct sockaddr_unsized *addr,
+			int addr_len)
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
+static int quic_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			int flags)
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
+static int quic_do_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+			      unsigned int optlen)
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
+static int quic_do_getsockopt(struct sock *sk, int optname, sockptr_t optval,
+			      sockptr_t optlen)
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
+	return quic_do_getsockopt(sk, optname, USER_SOCKPTR(optval),
+				  USER_SOCKPTR(optlen));
+}
+
+static void quic_release_cb(struct sock *sk)
+{
+}
+
+static int quic_disconnect(struct sock *sk, int flags)
+{
+	return -EOPNOTSUPP;
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
index 000000000000..98d3f738e909
--- /dev/null
+++ b/net/quic/socket.h
@@ -0,0 +1,89 @@
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
+static inline bool quic_is_serv(const struct sock *sk)
+{
+	return !!sk->sk_max_ack_backlog;
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
+	int mib;
+
+	if (sk->sk_state == state)
+		return;
+
+	if (state == QUIC_SS_ESTABLISHED) {
+		mib = quic_is_serv(sk) ? QUIC_MIB_CONN_PASSIVEESTABS :
+					 QUIC_MIB_CONN_ACTIVEESTABS;
+		QUIC_INC_STATS(net, mib);
+		QUIC_INC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
+	} else if (quic_is_established(sk)) {
+		QUIC_DEC_STATS(net, QUIC_MIB_CONN_CURRENTESTABS);
+	}
+
+	inet_sk_set_state(sk, state);
+	sk->sk_state_change(sk);
+}
-- 
2.47.1

