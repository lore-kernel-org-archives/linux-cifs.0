Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBD240243A
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777470240; cv=none; b=hRda2EuaNWm6nVjFAKKB20XelO4Qi3upk+hH5phB5evZ7MQN6IrObPYqZy0VELFz1j8EXg7dD901w5bbhNLgU3m84C2nOnfRhningXjP9mEm6ZFsW2nf6+ZvxsXPWY4TKULFI1vZCZvE66aoDUq9Dec1yNKCEuv7qjUp93cOvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777470240; c=relaxed/simple;
	bh=rKDokpU8Qj2ou8InpJka+EwAtkij8Rz31fc3I55hSUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9MMcYeqMBIHacb/bc+4V9ZhSUIRBnXknROWRKOZZGWP2znuHib2wN1XJ0qW8OcFuAsGTiDinKn1q/hg5wI+bQ/YpoqFyB3aYd6wonUkUUKMt11qZSAk6BloHf6AjN+YNbMhE+eWlmcCiZe8hSIgeAiHEGppWf1z6RJUXaV1tFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=o2zcOvof; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="o2zcOvof"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=396jvzsjfArsaFWVpdRukF7Y2hwffxEQjnpFNv9IpNQ=; b=o2zcOvofsqAVC4vbrM2fYaPMWF
	svnQFZzsMLohjzacsfiaIcazyOlscvbIA6V2vVvYuKmyiDoj5ZkqH3BJopRrbz2QDLgZa0SOQ8O0c
	qBBaExhajx2B8jox6YG2duggvVjCxpTdc/7WchP4FiSQU1CPZ0QhKgsSNliiZk8bJLxK+eWdybKX3
	5L56lcXgMHL8sTXhvbk5wr22LFN2kYWESIIB7AKLMi0PdND9cZDqrRYaR8NfOfCdKK/moCjsdVrJy
	C9ueuWGyInV+DzAH+x6+RSpNhX8/kUBioVfUJydhs7I/1Lo+uJK7+y4Y0a8wgThGsiLfXXcGN9kBv
	7dNxEflum6RbbohQBCoklWGFp3WzVd3MPHLAoBeishbVruFTHZDWoN9KpjXIJy6XDPsa8lGyQWC7z
	Ey+C50/14oWmhKtfMw/R65PkTWLWJ3H9Dx7kYB3QW1G6DAZ2TjOeFkBmi5iSJPLYb8RfvKvmgaDva
	1fuVCRFUZkCC29qGVghKv5FR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wI5Cl-000000050Xp-2gJU;
	Wed, 29 Apr 2026 13:43:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] smb: smbdirect: introduce and use include/linux/smbdirect.h
Date: Wed, 29 Apr 2026 15:43:36 +0200
Message-ID: <cd5e9336e5cb1d84af6c7f8cacb7ef7ad38d9ed1.1777463800.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777463800.git.metze@samba.org>
References: <cover.1777463800.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This makes it easier to rebuild cifs.ko and ksmbd.ko against
a running kernel.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lore.kernel.org/linux-cifs/aehrPuY60VMcYGU8@infradead.org/
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 MAINTAINERS                                   |  1 +
 fs/smb/client/smbdirect.c                     |  1 -
 fs/smb/client/smbdirect.h                     |  2 +-
 fs/smb/server/transport_rdma.c                |  1 -
 fs/smb/server/transport_rdma.h                |  2 +-
 fs/smb/smbdirect/internal.h                   |  3 +-
 fs/smb/smbdirect/smbdirect.h                  | 52 -------------------
 .../public.h => include/linux/smbdirect.h     | 50 ++++++++++++++++--
 8 files changed, 49 insertions(+), 63 deletions(-)
 delete mode 100644 fs/smb/smbdirect/smbdirect.h
 rename fs/smb/smbdirect/public.h => include/linux/smbdirect.h (76%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..28bb50923d74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24616,6 +24616,7 @@ S:	Maintained
 F:	fs/smb/client/smbdirect.*
 F:	fs/smb/smbdirect/
 F:	fs/smb/server/transport_rdma.*
+F:	include/linux/smbdirect.h
 
 SMC91x ETHERNET DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b9826185de18..563ef488a225 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -9,7 +9,6 @@
 #include "cifs_debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-#include "../smbdirect/public.h"
 
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 287ac849213d..be205ec02077 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -12,7 +12,7 @@
 
 #include "cifsglob.h"
 
-#include "../smbdirect/smbdirect.h"
+#include <linux/smbdirect.h>
 
 extern int rdma_readwrite_threshold;
 extern int smbd_max_frmr_depth;
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 346c051e31f5..b6d63ff8a8a3 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -18,7 +18,6 @@
 #include "smb_common.h"
 #include "../common/smb2status.h"
 #include "transport_rdma.h"
-#include "../smbdirect/public.h"
 
 
 #define SMB_DIRECT_PORT_IWARP		5445
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index bde3d88aecc7..8b78917a1795 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -25,6 +25,6 @@ static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
 #endif
 
-#include "../smbdirect/smbdirect.h"
+#include <linux/smbdirect.h>
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
index 82529b41708b..e9959e6dc13a 100644
--- a/fs/smb/smbdirect/internal.h
+++ b/fs/smb/smbdirect/internal.h
@@ -9,9 +9,8 @@
 #define DEFAULT_SYMBOL_NAMESPACE "SMBDIRECT"
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include "smbdirect.h"
+#include <linux/smbdirect.h>
 #include "pdu.h"
-#include "public.h"
 
 #include <linux/mutex.h>
 
diff --git a/fs/smb/smbdirect/smbdirect.h b/fs/smb/smbdirect/smbdirect.h
deleted file mode 100644
index bbab5f7f7cc9..000000000000
--- a/fs/smb/smbdirect/smbdirect.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- *   Copyright (C) 2025 Stefan Metzmacher
- */
-
-#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
-#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
-
-#include <linux/types.h>
-
-/* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
-struct smbdirect_buffer_descriptor_v1 {
-	__le64 offset;
-	__le32 token;
-	__le32 length;
-} __packed;
-
-/*
- * Connection parameters mostly from [MS-SMBD] 3.1.1.1
- *
- * These are setup and negotiated at the beginning of a
- * connection and remain constant unless explicitly changed.
- *
- * Some values are important for the upper layer.
- */
-struct smbdirect_socket_parameters {
-	__u64 flags;
-#define SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB ((__u64)0x1)
-#define SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW ((__u64)0x2)
-	__u32 resolve_addr_timeout_msec;
-	__u32 resolve_route_timeout_msec;
-	__u32 rdma_connect_timeout_msec;
-	__u32 negotiate_timeout_msec;
-	__u16 initiator_depth;     /* limited to U8_MAX */
-	__u16 responder_resources; /* limited to U8_MAX */
-	__u16 recv_credit_max;
-	__u16 send_credit_target;
-	__u32 max_send_size;
-	__u32 max_fragmented_send_size;
-	__u32 max_recv_size;
-	__u32 max_fragmented_recv_size;
-	__u32 max_read_write_size;
-	__u32 max_frmr_depth;
-	__u32 keepalive_interval_msec;
-	__u32 keepalive_timeout_msec;
-} __packed;
-
-#define SMBDIRECT_FLAG_PORT_RANGE_MASK ( \
-		SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB | \
-		SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW)
-
-#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__ */
diff --git a/fs/smb/smbdirect/public.h b/include/linux/smbdirect.h
similarity index 76%
rename from fs/smb/smbdirect/public.h
rename to include/linux/smbdirect.h
index d4fb36e65254..97f5ba730fa7 100644
--- a/fs/smb/smbdirect/public.h
+++ b/include/linux/smbdirect.h
@@ -3,11 +3,51 @@
  *   Copyright (C) 2025, Stefan Metzmacher
  */
 
-#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__
-#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__
+#ifndef __LINUX_SMBDIRECT_H__
+#define __LINUX_SMBDIRECT_H__
 
-struct smbdirect_buffer_descriptor_v1;
-struct smbdirect_socket_parameters;
+#include <linux/types.h>
+
+/* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
+struct smbdirect_buffer_descriptor_v1 {
+	__le64 offset;
+	__le32 token;
+	__le32 length;
+} __packed;
+
+/*
+ * Connection parameters mostly from [MS-SMBD] 3.1.1.1
+ *
+ * These are setup and negotiated at the beginning of a
+ * connection and remain constant unless explicitly changed.
+ *
+ * Some values are important for the upper layer.
+ */
+struct smbdirect_socket_parameters {
+	__u64 flags;
+#define SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB ((__u64)0x1)
+#define SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW ((__u64)0x2)
+	__u32 resolve_addr_timeout_msec;
+	__u32 resolve_route_timeout_msec;
+	__u32 rdma_connect_timeout_msec;
+	__u32 negotiate_timeout_msec;
+	__u16 initiator_depth;     /* limited to U8_MAX */
+	__u16 responder_resources; /* limited to U8_MAX */
+	__u16 recv_credit_max;
+	__u16 send_credit_target;
+	__u32 max_send_size;
+	__u32 max_fragmented_send_size;
+	__u32 max_recv_size;
+	__u32 max_fragmented_recv_size;
+	__u32 max_read_write_size;
+	__u32 max_frmr_depth;
+	__u32 keepalive_interval_msec;
+	__u32 keepalive_timeout_msec;
+} __packed;
+
+#define SMBDIRECT_FLAG_PORT_RANGE_MASK ( \
+		SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB | \
+		SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW)
 
 struct smbdirect_socket;
 struct smbdirect_send_batch;
@@ -143,4 +183,4 @@ void smbdirect_connection_legacy_debug_proc_show(struct smbdirect_socket *sc,
 						 unsigned int rdma_readwrite_threshold,
 						 struct seq_file *m);
 
-#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PUBLIC_H__ */
+#endif /* __LINUX_SMBDIRECT_H__ */
-- 
2.43.0

