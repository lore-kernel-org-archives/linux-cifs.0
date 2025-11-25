Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1672632C301
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095365; cv=none; b=lcV1KF4ixsRLmg8ppl/eZ5NzYz8qhY+uL5CaJ+KhrP/sTaNTP33Y35gwIStnK7wqfX1kX8cSLhcSjBD0tq+oDtNeP6xKIVdx4FKNSWUPwmmPYfGju5CsAZ2JmFW8JX89GpY7eCKU/KFKkzJZ2/hmpwEdNwDmmn0FwrUIFg3ZZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095365; c=relaxed/simple;
	bh=/vXkLjclFjQ/93GE51qq/i5kNqhQ9R6N5T8e59oQ1jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLQhs3Dg9S3JOB/nur6aHVCkO4XxB/0VG2fMi+aPIcmlVijNYcOEShpVT/R5OsqC+6VzqwLc0JvvvyUW86M4SaedjMQ6ZS1oyOKU9uO8Gcqd6VEXfaI/dMA+WxN829U3Ew0BkejpNOKIik7lhcZ/wZ9GsYYOR2lnj4ZUXFrCd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=De5B1WTi; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="De5B1WTi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xacxyOElbkk084YQP7LlX2K9VN6ZklaUrPJlYHKN/gU=; b=De5B1WTiaO3d/52nkjOv7P7EhU
	fXMmVo+mnGg3tVlZiDnNLubEE9GwJzjUp6fa1uy0jXSyQExyBrAcTDPkeX2c977qs3EJ4QsGozyeS
	i4iLoi2lmqBT7zmSLdUH5MSMP8LBgpYgTpQzOt9jaE86A2KqNzWeyLKMMsYZSzcmlHiM16K77USPP
	c/6vTk6BmA7TunTht5P3/VTQu5WXoZqxMxBsSZo8gAIgJF8+r6YxTDwGbHOJc0JnopO9HAVK4INwx
	5mTq7FVWdQLYqVTRaPsGv93Uv5ek+TBYlL3U8u+KaSpe/7kFnHFmY+22ksfUCYQhtjIXeJDnCVbNi
	eZWWl3SMBA1LH8x4qxWAO6+E7W0Elgz/3lBz48N94lhiaNmMCDC3ho1A2Lj3dlf9sEiDjG83HDVCI
	qzVrKWV0KGVJFAJ22FSI4Z7zoNzqXX5rJ4wFYu331RbYZvkGV9XYwUHdN+dv7K+ffIxPzlRyXqhsY
	hNVIn6jBHHKAvuqGL4kKBJpd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxhp-00Ffob-1t;
	Tue, 25 Nov 2025 18:24:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 132/145] smb: server: only use public smbdirect functions
Date: Tue, 25 Nov 2025 18:56:18 +0100
Message-ID: <788845f6000f3cf868016625e283413c9d9df510.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also remove a lot of unused includes...

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/smb2pdu.c        |  1 -
 fs/smb/server/transport_rdma.c | 25 +++++++++----------------
 fs/smb/server/transport_rdma.h |  2 ++
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b638d7fb5f51..8ec0708d875f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -23,7 +23,6 @@
 #include "asn1.h"
 #include "connection.h"
 #include "transport_ipc.h"
-#include "../common/smbdirect/smbdirect.h"
 #include "transport_rdma.h"
 #include "vfs.h"
 #include "vfs_cache.h"
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 85aed6963c86..e7d54283ae47 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -13,31 +13,16 @@
 
 #include <linux/kthread.h>
 #include <linux/list.h>
-#include <linux/mempool.h>
-#include <linux/highmem.h>
-#include <linux/scatterlist.h>
 #include <linux/string_choices.h>
 #include <linux/errname.h>
-#include <rdma/ib_verbs.h>
-#include <rdma/rdma_cm.h>
-#include <rdma/rw.h>
 
 #include "glob.h"
 #include "connection.h"
 #include "smb_common.h"
 #include "../common/smb2status.h"
-#include "../common/smbdirect/smbdirect.h"
-#include "../common/smbdirect/smbdirect_pdu.h"
-#include "../common/smbdirect/smbdirect_socket.h"
 #include "transport_rdma.h"
+#include "../common/smbdirect/smbdirect_public.h"
 
-/*
- * This is a temporary solution until all code
- * is moved to smbdirect_all_c_files.c and we
- * have an smbdirect.ko that exports the required
- * functions.
- */
-#include "../common/smbdirect/smbdirect_all_c_files.c"
 
 #define SMB_DIRECT_PORT_IWARP		5445
 #define SMB_DIRECT_PORT_INFINIBAND	445
@@ -642,3 +627,11 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.rdma_write	= smb_direct_rdma_write,
 	.free_transport = smb_direct_free_transport,
 };
+
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
index 3f93c6a9f7e4..e16f625caed2 100644
--- a/fs/smb/server/transport_rdma.h
+++ b/fs/smb/server/transport_rdma.h
@@ -27,4 +27,6 @@ static inline void init_smbd_max_io_size(unsigned int sz) { }
 static inline unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt) { return 0; }
 #endif
 
+#include "../common/smbdirect/smbdirect.h"
+
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
-- 
2.43.0

