Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76E2874E0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744910; cv=none; b=Vh5o27WcyEbPzqvaxbcI0kxsNz+JustP3A8KboYIseRzmnrkUbBCzo8b9Qe3MAJkzEmfV2Gwr9mQAkS4b2oRT1WyLE6MT00joFH6A4HzoZvm5X2XpvL4+CxVCNz60RVOMup0EB/L6ijlwOi4BIt6vZt/8Y7XHVMhjI2tWPgjR8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744910; c=relaxed/simple;
	bh=GqbiQ3oKDSjex9VtT4hARB8N0YnvxDspWRD2TDqjJms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omsksX0+bSPAVFEMj+f+5UGmYu7LvY9GjPmCzRHZjRy5SfWO59qH4PAxcDPn6mpHuDSk+EXJxu4ZdhxhIVNUrBWABgqzXLWu5Bkp5ueuhikIbNSQZNGPM+TS/uRLaykxTNUs9IN/Jxk/Xa4aJ67/QTduUxz6LtkDiD6mXz2FNKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Pb56kyw+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Pb56kyw+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=u6ZrSeo7qDnyhVxwIwE5oTQMMftuwo7Sn9Iwmaj0xTU=; b=Pb56kyw+s/9GCReUmwS+8i524q
	NiHqVlOlDvOUp5Z8IEMXyMbSgw+4nfUHEchvcrRENhoEGGFo8a3Se5vo0qsvbRuvw18BjTOEHS6tr
	yjmV6GzKj4kqpPEm8D6gZK9CdVqwy4un9P2UNds9fntQ2NC6hz4vaxx3IeSUFwNtztCSNIW3FX2Z5
	uyKWB/ADrzC3g/p2otkvc4OrK5lF8jrWtTYJCyIPXQ1oTEWXaoLilgQ0ng4N9m/87wUiWcehJpQd8
	TgZdW0G1jMvCu7viZWTAGumntgMnlp+rC0UlGHzJH3tuNRz1/Z3Z45sgbCjaa4ounCzoTT4UYl4ZC
	fIxYRgnNPeq4+lTTmZ4agijXsevypKCjmf0gn2kBuGuSZKHHFeMVSnU16KOS05W2Mz1ud5/MMFkOs
	PHGigKOTeuZDP2w8AbGJFDhD5jEU27h68CGLQXpISZOqbDHXf0FpQU5k0+HQheeFqNgmNePlRVMdx
	meDZ+Nb37a+bQB4eGhYUPBzF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6KP-00BdA4-0Q;
	Wed, 29 Oct 2025 13:35:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 126/127] smb: server: only use public smbdirect functions
Date: Wed, 29 Oct 2025 14:21:44 +0100
Message-ID: <4fc4b0faf0e290a3c59942ddcc61f940168af653.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
---
 fs/smb/server/smb2pdu.c        |  1 -
 fs/smb/server/transport_rdma.c | 25 +++++++++----------------
 fs/smb/server/transport_rdma.h |  2 ++
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68a..d20c8e5cd18e 100644
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

