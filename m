From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 20/45] CIFS: Move r/wsize negotiating to ops struct
Date: Wed, 18 Jul 2012 19:48:36 +0400
Message-ID: <1342626541-29872-21-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---
 fs/cifs/cifsglob.h |   61 ++++++++++++++++++++++
 fs/cifs/connect.c  |  144 +---------------------------------------------------
 fs/cifs/smb1ops.c  |   86 +++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 142 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3d94397..797c17a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -213,6 +213,10 @@ struct smb_version_operations {
 	bool (*need_neg)(struct TCP_Server_Info *);
 	/* negotiate to the server */
 	int (*negotiate)(const unsigned int, struct cifs_ses *);
+	/* set negotiated write size */
+	unsigned int (*negotiate_wsize)(struct cifs_tcon *, struct smb_vol *);
+	/* set negotiated read size */
+	unsigned int (*negotiate_rsize)(struct cifs_tcon *, struct smb_vol *);
 	/* setup smb sessionn */
 	int (*sess_setup)(const unsigned int, struct cifs_ses *,
 			  const struct nls_table *);
@@ -516,6 +520,63 @@ get_next_mid(struct TCP_Server_Info *server)
 }
 
 /*
+ * When the server supports very large reads and writes via POSIX extensions,
+ * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X header, not
+ * including the RFC1001 length.
+ *
+ * Note that this might make for "interesting" allocation problems during
+ * writeback however as we have to allocate an array of pointers for the
+ * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
+ *
+ * For reads, there is a similar problem as we need to allocate an array
+ * of kvecs to handle the receive, though that should only need to be done
+ * once.
+ */
+#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RSIZE ((1<<24) - sizeof(READ_RSP) + 4)
+
+/*
+ * When the server doesn't allow large posix writes, only allow a rsize/wsize
+ * of 2^17-1 minus the size of the call header. That allows for a read or
+ * write up to the maximum size described by RFC1002.
+ */
+#define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
+
+/*
+ * The default wsize is 1M. find_get_pages seems to return a maximum of 256
+ * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
+ * a single wsize request with a single call.
+ */
+#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
+
+/*
+ * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
+ * those values when posix extensions aren't in force. In actuality here, we
+ * use 65536 to allow for a write that is a multiple of 4k. Most servers seem
+ * to be ok with the extra byte even though Windows doesn't send writes that
+ * are that large.
+ *
+ * Citation:
+ *
+ * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
+ */
+#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
+#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
+
+/*
+ * On hosts with high memory, we can't currently support wsize/rsize that are
+ * larger than we can kmap at once. Cap the rsize/wsize at
+ * LAST_PKMAP * PAGE_SIZE. We'll never be able to fill a read or write request
+ * larger than that anyway.
+ */
+#ifdef CONFIG_HIGHMEM
+#define CIFS_KMAP_SIZE_LIMIT   (LAST_PKMAP * PAGE_CACHE_SIZE)
+#else /* CONFIG_HIGHMEM */
+#define CIFS_KMAP_SIZE_LIMIT   (1<<24)
+#endif /* CONFIG_HIGHMEM */
+
+/*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
  */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 99d50bf..bd4dcdd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3260,146 +3260,6 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
-/*
- * When the server supports very large reads and writes via POSIX extensions,
- * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X header, not
- * including the RFC1001 length.
- *
- * Note that this might make for "interesting" allocation problems during
- * writeback however as we have to allocate an array of pointers for the
- * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
- *
- * For reads, there is a similar problem as we need to allocate an array
- * of kvecs to handle the receive, though that should only need to be done
- * once.
- */
-#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
-#define CIFS_MAX_RSIZE ((1<<24) - sizeof(READ_RSP) + 4)
-
-/*
- * When the server doesn't allow large posix writes, only allow a rsize/wsize
- * of 2^17-1 minus the size of the call header. That allows for a read or
- * write up to the maximum size described by RFC1002.
- */
-#define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
-#define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
-
-/*
- * The default wsize is 1M. find_get_pages seems to return a maximum of 256
- * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
- * a single wsize request with a single call.
- */
-#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
-
-/*
- * Windows only supports a max of 60kb reads and 65535 byte writes. Default to
- * those values when posix extensions aren't in force. In actuality here, we
- * use 65536 to allow for a write that is a multiple of 4k. Most servers seem
- * to be ok with the extra byte even though Windows doesn't send writes that
- * are that large.
- *
- * Citation:
- *
- * http://blogs.msdn.com/b/openspecification/archive/2009/04/10/smb-maximum-transmit-buffer-size-and-performance-tuning.aspx
- */
-#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
-#define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
-
-/*
- * On hosts with high memory, we can't currently support wsize/rsize that are
- * larger than we can kmap at once. Cap the rsize/wsize at
- * LAST_PKMAP * PAGE_SIZE. We'll never be able to fill a read or write request
- * larger than that anyway.
- */
-#ifdef CONFIG_HIGHMEM
-#define CIFS_KMAP_SIZE_LIMIT	(LAST_PKMAP * PAGE_CACHE_SIZE)
-#else /* CONFIG_HIGHMEM */
-#define CIFS_KMAP_SIZE_LIMIT	(1<<24)
-#endif /* CONFIG_HIGHMEM */
-
-static unsigned int
-cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
-{
-	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-	struct TCP_Server_Info *server = tcon->ses->server;
-	unsigned int wsize;
-
-	/* start with specified wsize, or default */
-	if (pvolume_info->wsize)
-		wsize = pvolume_info->wsize;
-	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
-		wsize = CIFS_DEFAULT_IOSIZE;
-	else
-		wsize = CIFS_DEFAULT_NON_POSIX_WSIZE;
-
-	/* can server support 24-bit write sizes? (via UNIX extensions) */
-	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
-		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1002_WSIZE);
-
-	/*
-	 * no CAP_LARGE_WRITE_X or is signing enabled without CAP_UNIX set?
-	 * Limit it to max buffer offered by the server, minus the size of the
-	 * WRITEX header, not including the 4 byte RFC1001 length.
-	 */
-	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
-	    (!(server->capabilities & CAP_UNIX) &&
-	     (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
-		wsize = min_t(unsigned int, wsize,
-				server->maxBuf - sizeof(WRITE_REQ) + 4);
-
-	/* limit to the amount that we can kmap at once */
-	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
-
-	/* hard limit of CIFS_MAX_WSIZE */
-	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
-
-	return wsize;
-}
-
-static unsigned int
-cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
-{
-	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-	struct TCP_Server_Info *server = tcon->ses->server;
-	unsigned int rsize, defsize;
-
-	/*
-	 * Set default value...
-	 *
-	 * HACK alert! Ancient servers have very small buffers. Even though
-	 * MS-CIFS indicates that servers are only limited by the client's
-	 * bufsize for reads, testing against win98se shows that it throws
-	 * INVALID_PARAMETER errors if you try to request too large a read.
-	 * OS/2 just sends back short reads.
-	 *
-	 * If the server doesn't advertise CAP_LARGE_READ_X, then assume that
-	 * it can't handle a read request larger than its MaxBufferSize either.
-	 */
-	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
-		defsize = CIFS_DEFAULT_IOSIZE;
-	else if (server->capabilities & CAP_LARGE_READ_X)
-		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
-	else
-		defsize = server->maxBuf - sizeof(READ_RSP);
-
-	rsize = pvolume_info->rsize ? pvolume_info->rsize : defsize;
-
-	/*
-	 * no CAP_LARGE_READ_X? Then MS-CIFS states that we must limit this to
-	 * the client's MaxBufferSize.
-	 */
-	if (!(server->capabilities & CAP_LARGE_READ_X))
-		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
-
-	/* limit to the amount that we can kmap at once */
-	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
-
-	/* hard limit of CIFS_MAX_RSIZE */
-	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
-
-	return rsize;
-}
-
 static void
 cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
@@ -3650,8 +3510,8 @@ try_mount_again:
 	if (!tcon->ipc && server->ops->qfs_tcon)
 		server->ops->qfs_tcon(xid, tcon);
 
-	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
-	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
+	cifs_sb->wsize = server->ops->negotiate_wsize(tcon, volume_info);
+	cifs_sb->rsize = server->ops->negotiate_rsize(tcon, volume_info);
 
 	/* tune readahead according to rsize */
 	cifs_sb->bdi.ra_pages = cifs_sb->rsize / PAGE_CACHE_SIZE;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index df20dd9..7e8a2bd 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -17,6 +17,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/pagemap.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -410,6 +411,89 @@ cifs_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
+static unsigned int
+cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
+{
+	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int wsize;
+
+	/* start with specified wsize, or default */
+	if (volume_info->wsize)
+		wsize = volume_info->wsize;
+	else if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = CIFS_DEFAULT_IOSIZE;
+	else
+		wsize = CIFS_DEFAULT_NON_POSIX_WSIZE;
+
+	/* can server support 24-bit write sizes? (via UNIX extensions) */
+	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1002_WSIZE);
+
+	/*
+	 * no CAP_LARGE_WRITE_X or is signing enabled without CAP_UNIX set?
+	 * Limit it to max buffer offered by the server, minus the size of the
+	 * WRITEX header, not including the 4 byte RFC1001 length.
+	 */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
+	    (!(server->capabilities & CAP_UNIX) &&
+	     (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
+		wsize = min_t(unsigned int, wsize,
+				server->maxBuf - sizeof(WRITE_REQ) + 4);
+
+	/* limit to the amount that we can kmap at once */
+	wsize = min_t(unsigned int, wsize, CIFS_KMAP_SIZE_LIMIT);
+
+	/* hard limit of CIFS_MAX_WSIZE */
+	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
+
+	return wsize;
+}
+
+static unsigned int
+cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
+{
+	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int rsize, defsize;
+
+	/*
+	 * Set default value...
+	 *
+	 * HACK alert! Ancient servers have very small buffers. Even though
+	 * MS-CIFS indicates that servers are only limited by the client's
+	 * bufsize for reads, testing against win98se shows that it throws
+	 * INVALID_PARAMETER errors if you try to request too large a read.
+	 * OS/2 just sends back short reads.
+	 *
+	 * If the server doesn't advertise CAP_LARGE_READ_X, then assume that
+	 * it can't handle a read request larger than its MaxBufferSize either.
+	 */
+	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
+		defsize = CIFS_DEFAULT_IOSIZE;
+	else if (server->capabilities & CAP_LARGE_READ_X)
+		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
+	else
+		defsize = server->maxBuf - sizeof(READ_RSP);
+
+	rsize = volume_info->rsize ? volume_info->rsize : defsize;
+
+	/*
+	 * no CAP_LARGE_READ_X? Then MS-CIFS states that we must limit this to
+	 * the client's MaxBufferSize.
+	 */
+	if (!(server->capabilities & CAP_LARGE_READ_X))
+		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
+
+	/* limit to the amount that we can kmap at once */
+	rsize = min_t(unsigned int, rsize, CIFS_KMAP_SIZE_LIMIT);
+
+	/* hard limit of CIFS_MAX_RSIZE */
+	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
+
+	return rsize;
+}
+
 static void
 cifs_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 {
@@ -678,6 +762,8 @@ struct smb_version_operations smb1_operations = {
 	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
 	.negotiate = cifs_negotiate,
+	.negotiate_wsize = cifs_negotiate_wsize,
+	.negotiate_rsize = cifs_negotiate_rsize,
 	.sess_setup = CIFS_SessSetup,
 	.logoff = CIFSSMBLogoff,
 	.tree_connect = CIFSTCon,
-- 
1.7.1
