Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6972C26C3BD
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 19:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776626468; cv=none; b=m0Szozgg7xMvjayQAf6Q0wMUagAVztNhgvF8HqWNtNSXX9IGjaYpwBW4tEB9TshosULE552CDrr+q+ozK+9Ua719jOMVulzBCTrF9/tcEQMDNgBKmihV4qADXvOjbfLBRJiPo3KvTloTLWiXyiULuxRyU/fMqrcLlJpvitF7/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776626468; c=relaxed/simple;
	bh=BPl7ADuNz7/gW/pd0zDxbcxpiGfp8YXTzEBUvCbIbsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tlXYU95Ybb9vsfarfN9MxGs41ggCyOrUHU1nBDbaPzc/v38DiILqTiWd3RQi3BUqSVHNUNqCXROWzICQMUBk0HT9PVr++6JPmnS1SuAaw+1muPtEcDEyVr7gx+yfsP6wgUlxX4td0sXd9KAxlJO+C/GlVhq0QU6mTB2UwiEn8c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VORilKVH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VORilKVH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vCaVSS2sema6KjUMGL5frMyotatJdO4QufmlJruy170=; b=VORilKVHDvhRxo5gnYxKRPPjYE
	DjNC3cQ0vhszupkd/dwgtsO1xYFcPH4ODZ8GSxiZny8bfsE5gXCPnhmlIqUdcHqI00M7jw+Q92EfL
	CwkzeNV19ZmGthGKuQb6S5wIeS+EfPmaSqNp8umi+xXUQVRU/x4Rl6cv75Hf+n4uQKCGg/hfC8mD3
	i4U8OED03bUeX//ifUaikLd3fKfLWOdRBiXqI5G1JZ5ru8D+OQGZMoIZ3kt1bhFHF0n/+3u2zI7O/
	36yMegWCV9O6uPGH1KGWhM2Gm35+MwumcgdPhIg6WCBca9qBrH82Jw85D1JQyyC0UyM84XiBdB7bK
	8jEZn3IqnXahyeDrPEp7DTvotWDwJZvEtRA+hZiY7eJPth/0wT/dylYbpVdP9L1SO4bKyycEJzz4m
	JygAJs3qb7HMWYTiW3DztdI1fpHOcMmd4KRBlVfC0yRa7FBH0Hdt0yXeDJilSoq+z6IiUkRb46FE3
	NquF5Wd04+lHfAwXj4BVyezM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wEXhQ-00000002WTc-1qVU;
	Sun, 19 Apr 2026 19:20:56 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/
Date: Sun, 19 Apr 2026 21:20:18 +0200
Message-ID: <20260419192018.3046449-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This also removes the smbdirect_ prefix from the files.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/linux-cifs/CAHk-=whmue3PVi88K0UZLZO0at22QhQZ-yu+qO2TOKyZpGqecw@mail.gmail.com/
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 MAINTAINERS                                    |  2 +-
 fs/smb/Kconfig                                 |  2 +-
 fs/smb/Makefile                                |  1 +
 fs/smb/client/Kconfig                          |  2 +-
 fs/smb/client/smbdirect.c                      |  2 +-
 fs/smb/client/smbdirect.h                      |  2 +-
 fs/smb/common/Makefile                         |  1 -
 fs/smb/common/smbdirect/Makefile               | 18 ------------------
 fs/smb/server/Kconfig                          |  2 +-
 fs/smb/server/transport_rdma.c                 |  2 +-
 fs/smb/server/transport_rdma.h                 |  2 +-
 fs/smb/{common => }/smbdirect/Kconfig          |  2 +-
 fs/smb/smbdirect/Makefile                      | 18 ++++++++++++++++++
 .../smbdirect_accept.c => smbdirect/accept.c}  |  4 ++--
 .../connect.c}                                 |  4 ++--
 .../connection.c}                              |  2 +-
 .../smbdirect_debug.c => smbdirect/debug.c}    |  2 +-
 .../devices.c}                                 |  2 +-
 .../internal.h}                                |  6 +++---
 .../smbdirect_listen.c => smbdirect/listen.c}  |  2 +-
 .../smbdirect_main.c => smbdirect/main.c}      |  2 +-
 .../smbdirect_mr.c => smbdirect/mr.c}          |  2 +-
 .../smbdirect_pdu.h => smbdirect/pdu.h}        |  0
 .../smbdirect_public.h => smbdirect/public.h}  |  0
 .../smbdirect_rw.c => smbdirect/rw.c}          |  2 +-
 fs/smb/{common => }/smbdirect/smbdirect.h      |  0
 .../smbdirect_socket.c => smbdirect/socket.c}  |  2 +-
 .../smbdirect_socket.h => smbdirect/socket.h}  |  0
 28 files changed, 43 insertions(+), 43 deletions(-)
 delete mode 100644 fs/smb/common/smbdirect/Makefile
 rename fs/smb/{common => }/smbdirect/Kconfig (86%)
 create mode 100644 fs/smb/smbdirect/Makefile
 rename fs/smb/{common/smbdirect/smbdirect_accept.c => smbdirect/accept.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_connect.c => smbdirect/connect.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_connection.c => smbdirect/connection.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_debug.c => smbdirect/debug.c} (98%)
 rename fs/smb/{common/smbdirect/smbdirect_devices.c => smbdirect/devices.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_internal.h => smbdirect/internal.h} (98%)
 rename fs/smb/{common/smbdirect/smbdirect_listen.c => smbdirect/listen.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_main.c => smbdirect/main.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_mr.c => smbdirect/mr.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_pdu.h => smbdirect/pdu.h} (100%)
 rename fs/smb/{common/smbdirect/smbdirect_public.h => smbdirect/public.h} (100%)
 rename fs/smb/{common/smbdirect/smbdirect_rw.c => smbdirect/rw.c} (99%)
 rename fs/smb/{common => }/smbdirect/smbdirect.h (100%)
 rename fs/smb/{common/smbdirect/smbdirect_socket.c => smbdirect/socket.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_socket.h => smbdirect/socket.h} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13f49378b157..ea24891eca5f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24613,7 +24613,7 @@ L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 S:	Maintained
 F:	fs/smb/client/smbdirect.*
-F:	fs/smb/common/smbdirect/
+F:	fs/smb/smbdirect/
 F:	fs/smb/server/transport_rdma.*
 
 SMC91x ETHERNET DRIVER
diff --git a/fs/smb/Kconfig b/fs/smb/Kconfig
index b4b2cfdc2a6b..e549e189ee6a 100644
--- a/fs/smb/Kconfig
+++ b/fs/smb/Kconfig
@@ -4,7 +4,7 @@
 
 source "fs/smb/client/Kconfig"
 source "fs/smb/server/Kconfig"
-source "fs/smb/common/smbdirect/Kconfig"
+source "fs/smb/smbdirect/Kconfig"
 
 config SMBFS
 	tristate
diff --git a/fs/smb/Makefile b/fs/smb/Makefile
index 9a1bf59a1a65..353b1c2eefc4 100644
--- a/fs/smb/Makefile
+++ b/fs/smb/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_SMBFS)		+= common/
+obj-$(CONFIG_SMBDIRECT)		+= smbdirect/
 obj-$(CONFIG_CIFS)		+= client/
 obj-$(CONFIG_SMB_SERVER)	+= server/
diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 63831242fddf..fed621910876 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -182,7 +182,7 @@ config CIFS_SMB_DIRECT
 	bool "SMB Direct support"
 	depends on CIFS && INFINIBAND && INFINIBAND_ADDR_TRANS
 	depends on CIFS=m || INFINIBAND=y
-	select SMB_COMMON_SMBDIRECT
+	select SMBDIRECT
 	help
 	  Enables SMB Direct support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 9e67adcdc7d3..75f9f91a7ec9 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -9,7 +9,7 @@
 #include "cifs_debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-#include "../common/smbdirect/smbdirect_public.h"
+#include "../smbdirect/public.h"
 
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 0017d5b2de44..287ac849213d 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -12,7 +12,7 @@
 
 #include "cifsglob.h"
 
-#include "../common/smbdirect/smbdirect.h"
+#include "../smbdirect/smbdirect.h"
 
 extern int rdma_readwrite_threshold;
 extern int smbd_max_frmr_depth;
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index e6ee65c31b5d..9e0730a385fb 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -4,4 +4,3 @@
 #
 
 obj-$(CONFIG_SMBFS) += cifs_md4.o
-obj-$(CONFIG_SMB_COMMON_SMBDIRECT) += smbdirect/
diff --git a/fs/smb/common/smbdirect/Makefile b/fs/smb/common/smbdirect/Makefile
deleted file mode 100644
index 423f533e1002..000000000000
--- a/fs/smb/common/smbdirect/Makefile
+++ /dev/null
@@ -1,18 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-or-later
-#
-# Makefile for smbdirect support
-#
-
-obj-$(CONFIG_SMB_COMMON_SMBDIRECT) += smbdirect.o
-
-smbdirect-y := \
-	smbdirect_socket.o	\
-	smbdirect_connection.o	\
-	smbdirect_mr.o		\
-	smbdirect_rw.o		\
-	smbdirect_debug.o	\
-	smbdirect_connect.o	\
-	smbdirect_listen.o	\
-	smbdirect_accept.o	\
-	smbdirect_devices.o	\
-	smbdirect_main.o
diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 37387410e5bb..8f15c5fd6d88 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -49,7 +49,7 @@ config SMB_SERVER_SMBDIRECT
 	bool "Support for SMB Direct protocol"
 	depends on SMB_SERVER && INFINIBAND && INFINIBAND_ADDR_TRANS
 	depends on SMB_SERVER=m || INFINIBAND=y
-	select SMB_COMMON_SMBDIRECT
+	select SMBDIRECT
 	default n
 
 	help
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 706a2c897948..a8242c00096f 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -18,7 +18,7 @@
 #include "smb_common.h"
 #include "../common/smb2status.h"
 #include "transport_rdma.h"
-#include "../common/smbdirect/smbdirect_public.h"
+#include "../smbdirect/public.h"
 
 
 #define SMB_DIRECT_PORT_IWARP		5445
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 05352dc47f95..bde3d88aecc7 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -25,6 +25,6 @@ static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
 #endif
 
-#include "../common/smbdirect/smbdirect.h"
+#include "../smbdirect/smbdirect.h"
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
diff --git a/fs/smb/common/smbdirect/Kconfig b/fs/smb/smbdirect/Kconfig
similarity index 86%
rename from fs/smb/common/smbdirect/Kconfig
rename to fs/smb/smbdirect/Kconfig
index a46a2e6ec87a..2bf1b3350f7d 100644
--- a/fs/smb/common/smbdirect/Kconfig
+++ b/fs/smb/smbdirect/Kconfig
@@ -2,7 +2,7 @@
 #
 # smbdirect configuration
 
-config SMB_COMMON_SMBDIRECT
+config SMBDIRECT
 	def_tristate n
 	depends on INFINIBAND && INFINIBAND_ADDR_TRANS
 	depends on m || INFINIBAND=y
diff --git a/fs/smb/smbdirect/Makefile b/fs/smb/smbdirect/Makefile
new file mode 100644
index 000000000000..80d6025984d1
--- /dev/null
+++ b/fs/smb/smbdirect/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for smbdirect support
+#
+
+obj-$(CONFIG_SMBDIRECT) += smbdirect.o
+
+smbdirect-y := \
+	socket.o	\
+	connection.o	\
+	mr.o		\
+	rw.o		\
+	debug.o		\
+	connect.o	\
+	listen.o	\
+	accept.o	\
+	devices.o	\
+	main.o
diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/smbdirect/accept.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_accept.c
rename to fs/smb/smbdirect/accept.c
index d6d5e6a3f5de..704b271af3a8 100644
--- a/fs/smb/common/smbdirect/smbdirect_accept.c
+++ b/fs/smb/smbdirect/accept.c
@@ -5,9 +5,9 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 #include <net/sock.h>
-#include "../../common/smb2status.h"
+#include "../common/smb2status.h"
 
 static int smbdirect_accept_rdma_event_handler(struct rdma_cm_id *id,
 					       struct rdma_cm_event *event);
diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/smbdirect/connect.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_connect.c
rename to fs/smb/smbdirect/connect.c
index 2b54f79dba43..8addee43a381 100644
--- a/fs/smb/common/smbdirect/smbdirect_connect.c
+++ b/fs/smb/smbdirect/connect.c
@@ -3,8 +3,8 @@
  *   Copyright (c) 2012,2016,2017,2025 Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
-#include "../../common/smb2status.h"
+#include "internal.h"
+#include "../common/smb2status.h"
 
 static int smbdirect_connect_setup_connection(struct smbdirect_socket *sc);
 static int smbdirect_connect_resolve_addr(struct smbdirect_socket *sc,
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/smbdirect/connection.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_connection.c
rename to fs/smb/smbdirect/connection.c
index 7e4921b9538c..822366718d45 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -4,7 +4,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 #include <linux/folio_queue.h>
 
 struct smbdirect_map_sges {
diff --git a/fs/smb/common/smbdirect/smbdirect_debug.c b/fs/smb/smbdirect/debug.c
similarity index 98%
rename from fs/smb/common/smbdirect/smbdirect_debug.c
rename to fs/smb/smbdirect/debug.c
index d8664fd7f71a..a66a19d4a463 100644
--- a/fs/smb/common/smbdirect/smbdirect_debug.c
+++ b/fs/smb/smbdirect/debug.c
@@ -4,7 +4,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 #include <linux/seq_file.h>
 
 void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
diff --git a/fs/smb/common/smbdirect/smbdirect_devices.c b/fs/smb/smbdirect/devices.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_devices.c
rename to fs/smb/smbdirect/devices.c
index aaab99e9c045..44962f221c35 100644
--- a/fs/smb/common/smbdirect/smbdirect_devices.c
+++ b/fs/smb/smbdirect/devices.c
@@ -5,7 +5,7 @@
  *   Copyright (c) 2025 Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 
 static u8 smbdirect_ib_device_rdma_capable_node_type(struct ib_device *ib_dev)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/smbdirect/internal.h
similarity index 98%
rename from fs/smb/common/smbdirect/smbdirect_internal.h
rename to fs/smb/smbdirect/internal.h
index 30a1b8643657..2d5acf2c21bc 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -9,8 +9,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "smbdirect.h"
-#include "smbdirect_pdu.h"
-#include "smbdirect_public.h"
+#include "pdu.h"
+#include "public.h"
 
 #include <linux/mutex.h>
 
@@ -34,7 +34,7 @@ struct smbdirect_module_state {
 
 extern struct smbdirect_module_state smbdirect_globals;
 
-#include "smbdirect_socket.h"
+#include "socket.h"
 
 struct smbdirect_device {
 	struct list_head list;
diff --git a/fs/smb/common/smbdirect/smbdirect_listen.c b/fs/smb/smbdirect/listen.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_listen.c
rename to fs/smb/smbdirect/listen.c
index 05c7902e7020..143a7618d95f 100644
--- a/fs/smb/common/smbdirect/smbdirect_listen.c
+++ b/fs/smb/smbdirect/listen.c
@@ -5,7 +5,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 
 static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *id,
 					       struct rdma_cm_event *event);
diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/smbdirect/main.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_main.c
rename to fs/smb/smbdirect/main.c
index fe6e8d93c34c..606732fefb69 100644
--- a/fs/smb/common/smbdirect/smbdirect_main.c
+++ b/fs/smb/smbdirect/main.c
@@ -3,7 +3,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 #include <linux/module.h>
 
 struct smbdirect_module_state smbdirect_globals = {
diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/smbdirect/mr.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_mr.c
rename to fs/smb/smbdirect/mr.c
index fa9be8089925..5228e699cd5d 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -4,7 +4,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 
 /*
  * Allocate MRs used for RDMA read/write
diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/smbdirect/pdu.h
similarity index 100%
rename from fs/smb/common/smbdirect/smbdirect_pdu.h
rename to fs/smb/smbdirect/pdu.h
diff --git a/fs/smb/common/smbdirect/smbdirect_public.h b/fs/smb/smbdirect/public.h
similarity index 100%
rename from fs/smb/common/smbdirect/smbdirect_public.h
rename to fs/smb/smbdirect/public.h
diff --git a/fs/smb/common/smbdirect/smbdirect_rw.c b/fs/smb/smbdirect/rw.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_rw.c
rename to fs/smb/smbdirect/rw.c
index 3b2eb8c48efc..c2f46b17731e 100644
--- a/fs/smb/common/smbdirect/smbdirect_rw.c
+++ b/fs/smb/smbdirect/rw.c
@@ -5,7 +5,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 
 static int smbdirect_connection_wait_for_rw_credits(struct smbdirect_socket *sc,
 						    int credits)
diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/smbdirect/smbdirect.h
similarity index 100%
rename from fs/smb/common/smbdirect/smbdirect.h
rename to fs/smb/smbdirect/smbdirect.h
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/smbdirect/socket.c
similarity index 99%
rename from fs/smb/common/smbdirect/smbdirect_socket.c
rename to fs/smb/smbdirect/socket.c
index 9153e1dbf53d..1b4ab01b745e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -4,7 +4,7 @@
  *   Copyright (c) 2025, Stefan Metzmacher
  */
 
-#include "smbdirect_internal.h"
+#include "internal.h"
 
 bool smbdirect_frwr_is_supported(const struct ib_device_attr *attrs)
 {
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/smbdirect/socket.h
similarity index 100%
rename from fs/smb/common/smbdirect/smbdirect_socket.h
rename to fs/smb/smbdirect/socket.h
-- 
2.43.0

