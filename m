Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E942264D3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094743; cv=none; b=ZPWiqnIrCM95yMUKLQowZIt8d21PNj3QEL4aB0ZK+NfnV5Q1KIIULD7frYjBubdj7UQQ0ARhz2S60I3FdwJLc1FrUNBH4DJYbHD5+eqezDCzPE0DYfFhOSixLbCnuJMNP2QqTO9DxuZxcV54ZDJysBpi0ss/n970lfH4zHDPXa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094743; c=relaxed/simple;
	bh=kpC7RXro7Aldk39xxGVe9KXJUCH40ZgqYf1zHJH/n34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoPeC/qp/0uKWswTPPaQ2NiggDMn5Q30rMqIYMApDArjfSZuw1Gd1I7+4bpy41BYW+IzogUw0nyU8HEV1O0bQnHVK7GEqMwXIS6xHzAbwKgecbmO3NZ73GEP4ScUtccJy2Dbo+adF/GWQEL3TrS9SOKGph047aUX3XcB6/9+tyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=c6vQ2rhl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="c6vQ2rhl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mE57rVtauvS2bCSnUm+jbl3kTiQte38Xf2KvOKdpIlQ=; b=c6vQ2rhlagndOJnRHdEIPIUdqM
	hl3Rr1nF8jqmMjM5TMgy38bBGmGJ8r8dd6R/KtL7af0LFe8x8B2g1rai/uF1Btmeylzu9f5zYcF1v
	IFsZiiFPyxZclzjQ65tBYqEd92wcZhvV+eCkylRGEna8DaBPtNUmoSOjEWB+W0gu9MysCUuph0YXk
	VixQYjhbTGjRHYoCOtYicaduuh4XhtcqRlYnIXcLAp77NL8k/NHMoTDH/doGAWshx4TAdWwBMp8tg
	mOO95akTv/Q7rXMg6xEKdijE8FC9Siyx9KiIjQo3yzwgQcjrGsfNNl0zlqRZNQkdINOANR0Hg446K
	JxGIwgxfwYdlYNaUx9q1auuq/Cf4r2OdrvzkQGVkMuWsy1AjxBymGWlSmSybGMqGKsjAxWFXTyHfj
	V/MuYGDcilxj1bFh4gASp85lqXsGRxfJbZTy6O/GqFZ+q2k2y+AwD9BFX/zDidKST1ofp/03EnCJQ
	pJ3+DbzKm/jRpE3RxR7SIz/R;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUQ-00FeAp-02;
	Tue, 25 Nov 2025 18:10:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 095/145] smb: client: only use public smbdirect functions
Date: Tue, 25 Nov 2025 18:55:41 +0100
Message-ID: <7c128c73bf68c0b6cc5381200fbaf521f7af54b1.1764091285.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2pdu.c   |  1 -
 fs/smb/client/smbdirect.c | 20 +++++++++-----------
 fs/smb/client/smbdirect.h | 13 -------------
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 72062bafbbaa..e736154eedc6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -36,7 +36,6 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
-#include "../common/smbdirect/smbdirect.h"
 #include "smbdirect.h"
 #include "trace.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1efbc15879f4..91ed47ff8f2b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -7,14 +7,12 @@
 
 #define SMBDIRECT_USE_INLINE_C_FILES 1
 
-#include <linux/module.h>
-#include <linux/highmem.h>
-#include <linux/folio_queue.h>
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
+#include "../common/smbdirect/smbdirect_public.h"
 
 /* Port numbers for SMBD transport */
 #define SMB_PORT	445
@@ -95,14 +93,6 @@ module_param(smbd_logging_level, uint, 0644);
 MODULE_PARM_DESC(smbd_logging_level,
 	"Logging level for SMBD transport, 0 (default): error, 1: info");
 
-/*
- * This is a temporary solution until all code
- * is moved to smbdirect_all_c_files.c and we
- * have an smbdirect.ko that exports the required
- * functions.
- */
-#include "../common/smbdirect/smbdirect_all_c_files.c"
-
 static bool smbd_logging_needed(struct smbdirect_socket *sc,
 				void *private_ptr,
 				unsigned int lvl,
@@ -537,3 +527,11 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 						    server->rdma_readwrite_threshold,
 						    m);
 }
+
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 35172076f2ee..bd03ae72e9c8 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -11,12 +11,8 @@
 #define cifs_rdma_enabled(server)	((server)->rdma)
 
 #include "cifsglob.h"
-#include <rdma/ib_verbs.h>
-#include <rdma/rdma_cm.h>
-#include <linux/mempool.h>
 
 #include "../common/smbdirect/smbdirect.h"
-#include "../common/smbdirect/smbdirect_socket.h"
 
 extern int rdma_readwrite_threshold;
 extern int smbd_max_frmr_depth;
@@ -27,15 +23,6 @@ extern int smbd_max_send_size;
 extern int smbd_send_credit_target;
 extern int smbd_receive_credit_max;
 
-/*
- * The context for the SMBDirect transport
- * Everything related to the transport is here. It has several logical parts
- * 1. RDMA related structures
- * 2. SMBDirect connection parameters
- * 3. Memory registrations
- * 4. Receive and reassembly queues for data receive path
- * 5. mempools for allocating packets
- */
 struct smbd_connection {
 	struct smbdirect_socket *socket;
 	struct workqueue_struct *workqueue;
-- 
2.43.0

