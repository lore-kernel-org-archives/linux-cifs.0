Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C4471265;
	Mon,  7 Sep 2026 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793265; cv=none; b=uXue4A6x34z1ZD6ZpGG4WEn5IahQw+AlD6t+eXxg88Cgyj+oEYT5FxLvsmVVKrwMClYBs3I/tET4jCLBr2iMBlz5gybSSHayWrkBK3wRArXF+tF35zB5z4WC/bHIUcXuxzKeCnugxzZicmAlAkyDu2s0yriDIoxSk9MF5lrJqZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793265; c=relaxed/simple;
	bh=39UUn2yP1cvDjmc+zrH9fSz2Egeo6asXiU4UJKKQ/6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtiWWjq216Jc7lP3yzgpTIyz7n+VdIx+NG/5wKHaMrKjondiY5DNivpmeQEojpPbe+1p5hr3muo1D/PtLbMDIyxM1ewq4ZuGps5sSf0HgPFV/h46LzuPkz575rypP1V3iMhwp26K2cLNyrpR2836xpDDaMj0KIaY+FFolbIxiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AX7YCDaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AX7YCDaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF951F00A3F;
	Mon,  7 Sep 2026 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793263;
	bh=jcDm/y4MbLmKD+TCAj3jOJ//yimwJBq82zL8M3HhO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AX7YCDaYg9hJMzCWm6GrKL6vZYyRDcaBWVoXReYMkdPmx3O8stnMYj6cjSea/7DNs
	 oklq0XQoD6Uv5M5MjG6D678Znq81WM2LA4EgfASv8E41VnB78rU6H6kL8WeAhzRs/F
	 XkHWbLn8mehBQfLfVOM1b2sfml5yxPaA5nMlCmjMjdTf+Y2MPuIPh98ChtfcdsTNMe
	 ovgA2LCHc2NH3dK2yo1rT8puj85+qfZ/NPXs1rTVqB/EW2N4wtn5O06sRnImbrt7w0
	 LE83U4p/YJIkL03VrxXtywin88MMZlAZxck9inZWGHBFh47qtGOmlzKHvEaJTRvVQa
	 h818hioZw9gZg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 2/6] cifs: Do some preparation prior to organising the function declarations
Date: Mon,  7 Sep 2026 11:00:55 -0400
Message-ID: <20260907150059.3712249-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907150059.3712249-1-sashal@kernel.org>
References: <2026090303-ashamed-silver-ed5c@gregkh>
 <20260907150059.3712249-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 32a60868093aed5ccaa5e57f3b57f791f22ac133 ]

Make some preparatory cleanups prior to running a script to organise the
function declarations within the fs/smb/client/ headers.  These include:

 (1) Remove "inline" from the dummy cifs_proc_init/clean() functions as
     they are in a .c file.

 (2) Move should_compress()'s kdoc comment to the .c file and remove kdoc
     markers from the comments.

 (3) Rename CIFS_ALLOW_INSECURE_LEGACY in #endif comments to have CONFIG_
     on the front to allow the script to recognise it.

 (4) Don't let comments have bare words at the left margin as that confused
     the simplistic function detection code in the script.

 (5) Adjust some argument lists so that when and if the cleanup script is
     run they don't end up over 100 chars.

 (6) Fix a few comments to have missing '*' added or the "*/" moved to
     their own lines so that checkpatch doesn't moan over the cleanup
     script patch.

 (7) Move struct cifs_calc_sig_ctx to cifsglob.h.

 (8) Remove some __KERNEL__ conditionals.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c   |  4 ++--
 fs/smb/client/cifs_spnego.h  |  2 --
 fs/smb/client/cifs_unicode.h |  3 ---
 fs/smb/client/cifsfs.c       |  5 +++--
 fs/smb/client/cifsglob.h     |  2 +-
 fs/smb/client/cifsproto.h    |  2 +-
 fs/smb/client/compress.c     | 21 ++++++++++++++++++---
 fs/smb/client/compress.h     | 19 ++-----------------
 fs/smb/client/dir.c          |  2 +-
 fs/smb/client/dns_resolve.h  |  3 ---
 fs/smb/client/fs_context.c   |  2 +-
 fs/smb/client/misc.c         |  1 +
 fs/smb/client/netmisc.c      |  2 +-
 fs/smb/client/smb2file.c     |  3 ++-
 fs/smb/client/smb2inode.c    |  1 -
 fs/smb/client/smb2maperror.c |  3 +--
 fs/smb/client/smb2ops.c      |  4 ++--
 fs/smb/client/smb2pdu.c      |  5 +++--
 fs/smb/client/smb2proto.h    |  2 ++
 19 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 9092051776fc1..bd9ebd4368887 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -1209,11 +1209,11 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
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
diff --git a/fs/smb/client/cifs_spnego.h b/fs/smb/client/cifs_spnego.h
index e4d751b0c8127..e70929db3611f 100644
--- a/fs/smb/client/cifs_spnego.h
+++ b/fs/smb/client/cifs_spnego.h
@@ -27,10 +27,8 @@ struct cifs_spnego_msg {
 	uint8_t		data[];
 };
 
-#ifdef __KERNEL__
 extern struct key_type cifs_spnego_key_type;
 extern struct key *cifs_get_spnego_key(struct cifs_ses *sesInfo,
 				       struct TCP_Server_Info *server);
-#endif /* KERNEL */
 
 #endif /* _CIFS_SPNEGO_H */
diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
index e137a0dfbbe9a..6e4b99786498d 100644
--- a/fs/smb/client/cifs_unicode.h
+++ b/fs/smb/client/cifs_unicode.h
@@ -54,7 +54,6 @@
 #define SFM_MAP_UNI_RSVD	1
 #define SFU_MAP_UNI_RSVD	2
 
-#ifdef __KERNEL__
 int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 		    const struct nls_table *cp, int map_type);
 int cifs_utf16_bytes(const __le16 *from, int maxbytes,
@@ -69,8 +68,6 @@ extern int cifs_remap(struct cifs_sb_info *cifs_sb);
 extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
 				     int *utf16_len, const struct nls_table *cp,
 				     int remap);
-#endif
-
 wchar_t cifs_toupper(wchar_t in);
 
 #endif /* _CIFS_UNICODE_H */
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 08e7931cdda2b..f7cf455b9e124 100644
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
index d61a6424f20ca..13b01a90c2ea4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2065,7 +2065,7 @@ extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
 extern struct smb_version_values smbdefault_values;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 5f28eee91eb9d..7965a751d35c0 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -595,7 +595,7 @@ extern int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 			   const struct nls_table *nls_codepage, int remap);
 extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
 extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
 extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index db709f5cd2e1f..fb2a48f1d2ad0 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -44,7 +44,7 @@ struct bucket {
 	unsigned int count;
 };
 
-/**
+/*
  * has_low_entropy() - Compute Shannon entropy of the sampled data.
  * @bkt:	Bytes counts of the sample.
  * @slen:	Size of the sample.
@@ -82,7 +82,7 @@ static bool has_low_entropy(struct bucket *bkt, size_t slen)
 #define BYTE_DIST_BAD		0
 #define BYTE_DIST_GOOD		1
 #define BYTE_DIST_MAYBE		2
-/**
+/*
  * calc_byte_distribution() - Compute byte distribution on the sampled data.
  * @bkt:	Byte counts of the sample.
  * @slen:	Size of the sample.
@@ -182,7 +182,7 @@ static int collect_sample(const struct iov_iter *source, ssize_t max, u8 *sample
 	return s;
 }
 
-/**
+/*
  * is_compressible() - Determines if a chunk of data is compressible.
  * @data: Iterator containing uncompressed data.
  *
@@ -261,6 +261,21 @@ static bool is_compressible(const struct iov_iter *data)
 	return ret;
 }
 
+/*
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
index f3ed1d3e52fbf..63aea32fbe921 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -29,26 +29,11 @@
 #ifdef CONFIG_CIFS_COMPRESSION
 typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *);
 
-int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn);
 
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
 
-/**
+/*
  * smb_compress_alg_valid() - Validate a compression algorithm.
  * @alg: Compression algorithm to check.
  * @valid_none: Conditional check whether NONE algorithm should be
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 6bb0e98462a98..7c528dec4149e 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -432,7 +432,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 
 int
 cifs_atomic_open(struct inode *inode, struct dentry *direntry,
-		 struct file *file, unsigned oflags, umode_t mode)
+		 struct file *file, unsigned int oflags, umode_t mode)
 {
 	int rc;
 	unsigned int xid;
diff --git a/fs/smb/client/dns_resolve.h b/fs/smb/client/dns_resolve.h
index 6eb0c15a24406..2e991cdd2f496 100644
--- a/fs/smb/client/dns_resolve.h
+++ b/fs/smb/client/dns_resolve.h
@@ -13,8 +13,5 @@
 
 #include <linux/net.h>
 
-#ifdef __KERNEL__
 int dns_resolve_server_name_to_ip(const char *unc, struct sockaddr *ip_addr, time64_t *expiry);
-#endif /* KERNEL */
-
 #endif /* _DNS_RESOLVE_H */
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 769380020d41a..37665788f62bf 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -443,7 +443,7 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 	case Smb_20:
 		cifs_errorf(fc, "vers=2.0 mount not permitted when legacy dialects disabled\n");
 		return 1;
-#endif /* CIFS_ALLOW_INSECURE_LEGACY */
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 	case Smb_21:
 		ctx->ops = &smb21_operations;
 		ctx->vals = &smb21_values;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ce8f3fdffc3bd..f7b842eac044e 100644
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
index 8db57bd1a39de..407bafe6dc2ef 100644
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
diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 279aaa755106a..e1bc36c0dc951 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -102,7 +102,8 @@ int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const struct kvec
 					 cifs_sb);
 }
 
-int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32 *oplock, void *buf)
+int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
+		   __u32 *oplock, void *buf)
 {
 	int rc;
 	__le16 *smb2_path;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 4f08c808e4a3e..a85fc7354b613 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -21,7 +21,6 @@
 #include "cifs_unicode.h"
 #include "fscache.h"
 #include "smb2glob.h"
-#include "smb2pdu.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
 #include "../common/smb2status.h"
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index b05313acf9b2b..43a2f4be494b2 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -10,10 +10,9 @@
 #include <linux/errno.h>
 #include "cifsglob.h"
 #include "cifs_debug.h"
-#include "smb2pdu.h"
 #include "smb2proto.h"
-#include "../common/smb2status.h"
 #include "smb2glob.h"
+#include "../common/smb2status.h"
 #include "trace.h"
 
 struct status_to_posix_error {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e6e8c64a5d3d6..06c6d431c6123 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -17,9 +17,9 @@
 #include <uapi/linux/magic.h>
 #include "cifsfs.h"
 #include "cifsglob.h"
-#include "smb2pdu.h"
-#include "smb2proto.h"
 #include "cifsproto.h"
+#include "smb2proto.h"
+#include "smb2pdu.h"
 #include "cifs_debug.h"
 #include "cifs_unicode.h"
 #include "../common/smb2status.h"
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index bd271d614ed6c..bb409d3ec454f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -26,8 +26,8 @@
 #include <linux/netfs.h>
 #include <trace/events/netfs.h>
 #include "cifsglob.h"
-#include "cifsacl.h"
 #include "cifsproto.h"
+#include "cifsacl.h"
 #include "smb2proto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
@@ -3939,7 +3939,8 @@ int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 /* currently unused, as now we are doing compounding instead (see smb311_posix_query_path_info) */
 int
 SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
-		u64 persistent_fid, u64 volatile_fid, struct smb311_posix_qinfo *data, u32 *plen)
+			u64 persistent_fid, u64 volatile_fid,
+			struct smb311_posix_qinfo *data, u32 *plen)
 {
 	size_t output_len = sizeof(struct smb311_posix_qinfo) +
 			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 51d890f74e36f..c0d9728977e80 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -9,8 +9,10 @@
  */
 #ifndef _SMB2PROTO_H
 #define _SMB2PROTO_H
+
 #include <linux/nls.h>
 #include <linux/key-type.h>
+#include "cached_dir.h"
 
 struct statfs;
 struct smb_rqst;
-- 
2.53.0

