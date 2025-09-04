Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC92267AF2
	for <linux-cifs@vger.kernel.org>; Thu,  4 Sep 2025 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757020734; cv=none; b=fR9armRlnCvwYtr2hhkPm/YjCh2YhrHsApm59aN3zmHttnHA3CRjfcRlqEjEQqX4YsPt7OlBIltaN0QS9zjWT05ytcH9TrNTaRR95Uek4x/Nuyoqlv4rbV7+PRg8H5y8IKH/0Xqe8eiwd99kHh638JgHuk37x3GOeaebGi8Y+rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757020734; c=relaxed/simple;
	bh=U7N8BHvUNHRBteKg8iJEn5zDZBUPRlGNXkXkhPAc6x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svOoG6qq411YQF9McBiFI+OLuNOQzE14IRfKIuvBGOrWY9xf/Kij4oNVUzmViYa60czrj5U1qtPsNzotNnfRTIHszfuHqPaxtssAW49pLP3ZhZYaxMBj9YJSNuItwYtH5aB98VRr7DdIHp1BE3kLhlTVUV17AtnobkyPb4WW7NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwIQsGTC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwIQsGTC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757020731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vx+T9s+0eco4tlDFO+tjW2C7kJ0mnXQtGbCiSKWzW5o=;
	b=HwIQsGTCP5GdCbtlzJHD3Wel/P0QEQPE+82MvhIY7WnoyYjS/GD+wfgQgsGA9qLu+CXLyz
	iIpf2LugTEDbVbJZsPSSatQHvT/mXXA3ZvJlAZKqD96zvF675sfjq/cDjSmBItaEUsMvbo
	o9AVGNfaQ7iHbAnnP4eBy5pIBEbWH+w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-J21YQZjoMvayPAFno8abFQ-1; Thu,
 04 Sep 2025 17:18:47 -0400
X-MC-Unique: J21YQZjoMvayPAFno8abFQ-1
X-Mimecast-MFC-AGG-ID: J21YQZjoMvayPAFno8abFQ_1757020727
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF9EC1956094;
	Thu,  4 Sep 2025 21:18:46 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C6BB19560AB;
	Thu,  4 Sep 2025 21:18:45 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org
Subject: [RFC PATCH 1/2] cifs: Do some preparation prior to organising the function declarations
Date: Thu,  4 Sep 2025 22:18:32 +0100
Message-ID: <20250904211839.1152340-2-dhowells@redhat.com>
In-Reply-To: <20250904211839.1152340-1-dhowells@redhat.com>
References: <20250904211839.1152340-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Make some preparatory changes prior to running a script to organise the
function declarations within the fs/smb/client/ headers.  These include:

 (1) Creating an smb1proto.h file and #including it in places that will
     need it.  It will be populated by a script in a follow on patch.

 (2) Insert a line saying "/* PROTOTYPES */" in the target headers to set
     the point at which prototypes should be inserted in that file.

 (3) Remove "inline" from the dummy cifs_proc_init/clean() functions as
     they are in a .c file.

 (4) Move should_compress()'s kdoc comment to the .c file.

 (5) Rename CIFS_ALLOW_INSECURE_LEGACY in #endif comments to have CONFIG_
     on the front to allow the script to recognise it.

 (6) Don't let comments have bare words at the left margin as that confused
     the simplistic function detection code in the script.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifs_debug.c    |  4 ++--
 fs/smb/client/cifs_swn.h      |  2 ++
 fs/smb/client/cifs_unicode.c  |  1 +
 fs/smb/client/cifsacl.c       |  1 +
 fs/smb/client/cifsfs.c        |  5 +++--
 fs/smb/client/cifsglob.h      |  2 +-
 fs/smb/client/cifsproto.h     |  9 +++------
 fs/smb/client/cifssmb.c       |  1 +
 fs/smb/client/cifstransport.c |  1 +
 fs/smb/client/compress.c      | 15 +++++++++++++++
 fs/smb/client/compress.h      | 18 ++----------------
 fs/smb/client/connect.c       |  1 +
 fs/smb/client/dir.c           |  1 +
 fs/smb/client/file.c          |  1 +
 fs/smb/client/fs_context.c    |  2 +-
 fs/smb/client/fscache.h       |  4 +---
 fs/smb/client/inode.c         |  1 +
 fs/smb/client/ioctl.c         |  1 +
 fs/smb/client/link.c          |  1 +
 fs/smb/client/misc.c          |  1 +
 fs/smb/client/netmisc.c       |  2 +-
 fs/smb/client/sess.c          |  1 +
 fs/smb/client/smb1ops.c       |  2 ++
 fs/smb/client/smb1proto.h     | 20 ++++++++++++++++++++
 fs/smb/client/smb2proto.h     |  9 ++++-----
 fs/smb/client/smbdirect.h     |  2 ++
 26 files changed, 71 insertions(+), 37 deletions(-)
 create mode 100644 fs/smb/client/smb1proto.h

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index beb4f18f05ef..6f1dd2ee4018 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -1262,11 +1262,11 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
 };
 
 #else
-inline void cifs_proc_init(void)
+void cifs_proc_init(void)
 {
 }
 
-inline void cifs_proc_clean(void)
+void cifs_proc_clean(void)
 {
 }
 #endif /* PROC_FS */
diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
index 8a9d2a5c9077..7063539c41c8 100644
--- a/fs/smb/client/cifs_swn.h
+++ b/fs/smb/client/cifs_swn.h
@@ -14,6 +14,8 @@ struct sk_buff;
 struct genl_info;
 
 #ifdef CONFIG_CIFS_SWN_UPCALL
+
+/* PROTOTYPES */
 extern int cifs_swn_register(struct cifs_tcon *tcon);
 
 extern int cifs_swn_unregister(struct cifs_tcon *tcon);
diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 4cc6e0896fad..e0f9b3e4a25b 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -9,6 +9,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "cifspdu.h"
+#include "cifsproto.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
 
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..d529deb6bd80 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -21,6 +21,7 @@
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
 #include "cifs_debug.h"
 #include "fs_context.h"
 #include "cifs_fs_sb.h"
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e1848276bab4..0ea8e74b3b06 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -28,6 +28,8 @@
 #include <linux/splice.h>
 #include <linux/uuid.h>
 #include <linux/xattr.h>
+#include <linux/mm.h>
+#include <linux/key-type.h>
 #include <uapi/linux/magic.h>
 #include <net/ipv6.h>
 #include "cifsfs.h"
@@ -35,10 +37,9 @@
 #define DECLARE_GLOBALS_HERE
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb2proto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
-#include <linux/mm.h>
-#include <linux/key-type.h>
 #include "cifs_spnego.h"
 #include "fscache.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1e64a4fb6af0..f052e489e941 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2140,7 +2140,7 @@ extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 #define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..a4c8b350eaa4 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -9,6 +9,7 @@
 #define _CIFSPROTO_H
 #include <linux/nls.h>
 #include <linux/ctype.h>
+#include <net/genetlink.h>
 #include "trace.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
@@ -18,11 +19,7 @@ struct statfs;
 struct smb_rqst;
 struct smb3_fs_context;
 
-/*
- *****************************************************************
- * All Prototypes
- *****************************************************************
- */
+/* PROTOTYPES */
 
 extern struct smb_hdr *cifs_buf_get(void);
 extern void cifs_buf_release(void *);
@@ -602,7 +599,7 @@ extern int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 			   const struct nls_table *nls_codepage, int remap);
 extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
 extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
 extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index d20766f664c4..3f6dbfc82a28 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -31,6 +31,7 @@
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index e98b95eff8c9..86f4ebbdf756 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -26,6 +26,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "smbdirect.h"
 #include "compress.h"
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index db709f5cd2e1..c04339419cb5 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -261,6 +261,21 @@ static bool is_compressible(const struct iov_iter *data)
 	return ret;
 }
 
+/**
+ * should_compress() - Determines if a request (write) or the response to a
+ *		       request (read) should be compressed.
+ * @tcon: tcon of the request is being sent to
+ * @rqst: request to evaluate
+ *
+ * Return: true iff:
+ * - compression was successfully negotiated with server
+ * - server has enabled compression for the share
+ * - it's a read or write request
+ * - (write only) request length is >= SMB_COMPRESS_MIN_LEN
+ * - (write only) is_compressible() returns 1
+ *
+ * Return false otherwise.
+ */
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
 {
 	const struct smb2_hdr *shdr = rq->rq_iov->iov_base;
diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index f3ed1d3e52fb..2a51c31d9387 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -29,23 +29,9 @@
 #ifdef CONFIG_CIFS_COMPRESSION
 typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *);
 
-int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn);
+/* PROTOTYPES */
 
-/**
- * should_compress() - Determines if a request (write) or the response to a
- *		       request (read) should be compressed.
- * @tcon: tcon of the request is being sent to
- * @rqst: request to evaluate
- *
- * Return: true iff:
- * - compression was successfully negotiated with server
- * - server has enabled compression for the share
- * - it's a read or write request
- * - (write only) request length is >= SMB_COMPRESS_MIN_LEN
- * - (write only) is_compressible() returns 1
- *
- * Return false otherwise.
- */
+int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn);
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
 
 /**
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dc..ec813bd6c53c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -42,6 +42,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fscache.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "smbdirect.h"
 #include "dns_resolve.h"
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 5223edf6d11a..fdde432bca83 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -17,6 +17,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 186e061068be..7df0441098b2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -27,6 +27,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 072383899e81..a14456accd8d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -505,7 +505,7 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 	case Smb_20:
 		cifs_errorf(fc, "vers=2.0 mount not permitted when legacy dialects disabled\n");
 		return 1;
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 	case Smb_21:
 		ctx->ops = &smb21_operations;
 		ctx->vals = &smb21_values;
diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index f06cb24f5f3c..162865381dac 100644
--- a/fs/smb/client/fscache.h
+++ b/fs/smb/client/fscache.h
@@ -35,9 +35,7 @@ struct cifs_fscache_inode_coherency_data {
 
 #ifdef CONFIG_CIFS_FSCACHE
 
-/*
- * fscache.c
- */
+/* PROTOTYPES */
 extern int cifs_fscache_get_super_cookie(struct cifs_tcon *);
 extern void cifs_fscache_release_super_cookie(struct cifs_tcon *);
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index fe453a4b3dc8..78f377ab4159 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -18,6 +18,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 0a9935ce05a5..356dd46b017b 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -19,6 +19,7 @@
 #include "cifs_debug.h"
 #include "cifsfs.h"
 #include "cifs_ioctl.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "smb2glob.h"
 #include <linux/btrfs.h>
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index fe80e711cd75..d44b089190aa 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -16,6 +16,7 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "cifs_ioctl.h"
 #include "fs_context.h"
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index da23cc12a52c..7659f530c809 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -18,6 +18,7 @@
 #include "nterr.h"
 #include "cifs_unicode.h"
 #include "smb2pdu.h"
+#include "smb2proto.h"
 #include "cifsfs.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dns_resolve.h"
diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 9ec20601cee2..4e0bb1920eae 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -200,7 +200,7 @@ cifs_set_port(struct sockaddr *addr, const unsigned short int port)
 }
 
 /*****************************************************************************
-convert a NT status code to a dos class/code
+ *convert a NT status code to a dos class/code
  *****************************************************************************/
 /* NT status -> dos error map */
 static const struct {
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 0a8c2fcc9ded..b5a68d07f829 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -20,6 +20,7 @@
 #include <linux/version.h>
 #include "cifsfs.h"
 #include "cifs_spnego.h"
+#include "smb1proto.h"
 #include "smb2proto.h"
 #include "fs_context.h"
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 893a1ea8c000..7c30e5c9fa9d 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -10,6 +10,8 @@
 #include <uapi/linux/magic.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "smb1proto.h"
+#include "smb2proto.h"
 #include "cifs_debug.h"
 #include "cifspdu.h"
 #include "cifs_unicode.h"
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
new file mode 100644
index 000000000000..68ab0447b671
--- /dev/null
+++ b/fs/smb/client/smb1proto.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ *
+ *   Copyright (c) International Business Machines  Corp., 2002,2008
+ *   Author(s): Steve French (sfrench@us.ibm.com)
+ *
+ */
+#ifndef _SMB1PROTO_H
+#define _SMB1PROTO_H
+
+#include <linux/nls.h>
+#include <linux/ctype.h>
+#include "trace.h"
+#ifdef CONFIG_CIFS_DFS_UPCALL
+#include "dfs_cache.h"
+#endif
+
+/* PROTOTYPES */
+
+#endif /* _SMB1PROTO_H */
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 6e805ece6a7b..6b0212ccd45c 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -9,17 +9,16 @@
  */
 #ifndef _SMB2PROTO_H
 #define _SMB2PROTO_H
+
 #include <linux/nls.h>
 #include <linux/key-type.h>
+#include "cached_dir.h"
 
 struct statfs;
 struct smb_rqst;
 
-/*
- *****************************************************************
- * All Prototypes
- *****************************************************************
- */
+/* PROTOTYPES */
+
 extern int map_smb2_to_linux_error(char *buf, bool log_err);
 extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index e45aa9ddd71d..e190cb96486f 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -156,6 +156,8 @@ struct smbd_mr *smbd_register_mr(
 	bool writing, bool need_invalidate);
 int smbd_deregister_mr(struct smbd_mr *mr);
 
+/* PROTOTYPES */
+
 #else
 #define cifs_rdma_enabled(server)	0
 struct smbd_connection {};

