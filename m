From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] cifs: allow for larger rsize= options and change defaults
Date: Wed, 19 Oct 2011 09:24:54 -0400
Message-ID: <1319030695-4115-5-git-send-email-jlayton@redhat.com>
References: <1319030695-4115-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319030695-4115-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently we cap the rsize at a value that fits in CIFSMaxBufSize. That's
not needed any longer for readpages. Allow the use of larger values for
readpages. cifs_iovec_read and cifs_read however are still limited to the
CIFSMaxBufSize. Make sure they don't exceed that.

The patch also changes the rsize defaults. The default when unix
extensions are enabled is set to 1M for parity with the wsize, and there
is a hard cap of ~16M.

When unix extensions are not enabled, the default is set to 60k. According
to MS-CIFS, Windows servers can only send a max of 60k at a time, so
this is more efficient than requesting a larger size. If the user wishes
however, the max can be extended up to 128k - the length of the READ_RSP
header.

Really old servers however require a special hack to ensure that we don't
request too large a read.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |  120 ++++++++++++++++++++++++++++++++---------------------
 fs/cifs/file.c    |   12 ++++-
 2 files changed, 83 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3d518b9..06dfaac 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2310,16 +2310,16 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	    (new->mnt_cifs_flags & CIFS_MOUNT_MASK))
 		return 0;
 
-	if (old->rsize != new->rsize)
-		return 0;
-
 	/*
-	 * We want to share sb only if we don't specify wsize or specified wsize
-	 * is greater or equal than existing one.
+	 * We want to share sb only if we don't specify an r/wsize or
+	 * specified r/wsize is greater than or equal to existing one.
 	 */
 	if (new->wsize && new->wsize < old->wsize)
 		return 0;
 
+	if (new->rsize && new->rsize < old->rsize)
+		return 0;
+
 	if (old->mnt_uid != new->mnt_uid || old->mnt_gid != new->mnt_gid)
 		return 0;
 
@@ -2757,14 +2757,6 @@ void reset_cifs_unix_caps(int xid, struct cifs_tcon *tcon,
 					CIFS_MOUNT_POSIX_PATHS;
 		}
 
-		if (cifs_sb && (cifs_sb->rsize > 127 * 1024)) {
-			if ((cap & CIFS_UNIX_LARGE_READ_CAP) == 0) {
-				cifs_sb->rsize = 127 * 1024;
-				cFYI(DBG2, "larger reads not supported by srv");
-			}
-		}
-
-
 		cFYI(1, "Negotiate caps 0x%x", (int)cap);
 #ifdef CONFIG_CIFS_DEBUG2
 		if (cap & CIFS_UNIX_FCNTL_CAP)
@@ -2809,27 +2801,11 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
-	if (pvolume_info->rsize > CIFSMaxBufSize) {
-		cERROR(1, "rsize %d too large, using MaxBufSize",
-			pvolume_info->rsize);
-		cifs_sb->rsize = CIFSMaxBufSize;
-	} else if ((pvolume_info->rsize) &&
-			(pvolume_info->rsize <= CIFSMaxBufSize))
-		cifs_sb->rsize = pvolume_info->rsize;
-	else /* default */
-		cifs_sb->rsize = CIFSMaxBufSize;
-
-	if (cifs_sb->rsize < 2048) {
-		cifs_sb->rsize = 2048;
-		/* Windows ME may prefer this */
-		cFYI(1, "readsize set to minimum: 2048");
-	}
-
 	/*
-	 * Temporarily set wsize for matching superblock. If we end up using
-	 * new sb then cifs_negotiate_wsize will later negotiate it downward
-	 * if needed.
+	 * Temporarily set r/wsize for matching superblock. If we end up using
+	 * new sb then client will later negotiate it downward if needed.
 	 */
+	cifs_sb->rsize = pvolume_info->rsize;
 	cifs_sb->wsize = pvolume_info->wsize;
 
 	cifs_sb->mnt_uid = pvolume_info->linux_uid;
@@ -2904,29 +2880,41 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 }
 
 /*
- * When the server supports very large writes via POSIX extensions, we can
- * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not including
- * the RFC1001 length.
+ * When the server supports very large reads and writes via POSIX extensions,
+ * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X header, not
+ * including the RFC1001 length.
  *
  * Note that this might make for "interesting" allocation problems during
  * writeback however as we have to allocate an array of pointers for the
  * pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE == 4096.
+ *
+ * For reads, there is a similar problem as we need to allocate an array
+ * of kvecs to handle the receive, though that should only need to be done
+ * once.
  */
 #define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RSIZE ((1<<24) - sizeof(READ_RSP) + 4)
 
 /*
- * When the server doesn't allow large posix writes, only allow a wsize of
- * 2^17-1 minus the size of the WRITE_AND_X header. That allows for a write up
- * to the maximum size described by RFC1002.
+ * When the server doesn't allow large posix writes, only allow a rsize/wsize
+ * of 2^17-1 minus the size of the call header. That allows for a read or
+ * write up to the maximum size described by RFC1002.
  */
 #define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
 
 /*
  * The default wsize is 1M. find_get_pages seems to return a maximum of 256
  * pages in a single call. With PAGE_CACHE_SIZE == 4k, this means we can fill
  * a single wsize request with a single call.
  */
-#define CIFS_DEFAULT_WSIZE (1024 * 1024)
+#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
+
+/*
+ * Windows only supports a max of 60k reads. Default to that when posix
+ * extensions aren't in force.
+ */
+#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
 
 static unsigned int
 cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
@@ -2934,7 +2922,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
-				CIFS_DEFAULT_WSIZE;
+				CIFS_DEFAULT_IOSIZE;
 
 	/* can server support 24-bit write sizes? (via UNIX extensions) */
 	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
@@ -2957,6 +2945,50 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
 	return wsize;
 }
 
+static unsigned int
+cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume_info)
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
+	 *
+	 * If the server advertises a MaxBufferSize of less than one page,
+	 * assume that it also can't satisfy reads larger than that either.
+	 *
+	 * FIXME: Is there a better heuristic for this?
+	 */
+	if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_CAP))
+		defsize = CIFS_DEFAULT_IOSIZE;
+	else if (server->capabilities & CAP_LARGE_READ_X)
+		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
+	else if (server->maxBuf >= PAGE_CACHE_SIZE)
+		defsize = CIFSMaxBufSize;
+	else
+		defsize = server->maxBuf - sizeof(READ_RSP);
+
+	rsize = pvolume_info->rsize ? pvolume_info->rsize : defsize;
+
+	/*
+	 * no CAP_LARGE_READ_X? Then MS-CIFS states that we must limit this to
+	 * the client's MaxBufferSize.
+	 */
+	if (!(server->capabilities & CAP_LARGE_READ_X))
+		rsize = min_t(unsigned int, CIFSMaxBufSize, rsize);
+
+	/* hard limit of CIFS_MAX_RSIZE */
+	rsize = min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
+
+	return rsize;
+}
+
 static int
 is_path_accessible(int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -3234,14 +3266,8 @@ try_mount_again:
 		CIFSSMBQFSAttributeInfo(xid, tcon);
 	}
 
-	if ((tcon->unix_ext == 0) && (cifs_sb->rsize > (1024 * 127))) {
-		cifs_sb->rsize = 1024 * 127;
-		cFYI(DBG2, "no very large read support, rsize now 127K");
-	}
-	if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
-		cifs_sb->rsize = min(cifs_sb->rsize, CIFSMaxBufSize);
-
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
+	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
 
 remote_path_check:
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8f69178..8c19c93 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1758,6 +1758,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	struct smb_com_read_rsp *pSMBr;
 	struct cifs_io_parms io_parms;
 	char *read_data;
+	unsigned int rsize;
 	__u32 pid;
 
 	if (!nr_segs)
@@ -1770,6 +1771,9 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
+	/* FIXME: set up handlers for larger reads and/or convert to async */
+	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
+
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
@@ -1782,7 +1786,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 		cFYI(1, "attempting read on write only file instance");
 
 	for (total_read = 0; total_read < len; total_read += bytes_read) {
-		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
+		cur_len = min_t(const size_t, len - total_read, rsize);
 		rc = -EAGAIN;
 		read_data = NULL;
 
@@ -1874,6 +1878,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	unsigned int bytes_read = 0;
 	unsigned int total_read;
 	unsigned int current_read_size;
+	unsigned int rsize;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *pTcon;
 	int xid;
@@ -1886,6 +1891,9 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 
+	/* FIXME: set up handlers for larger reads and/or convert to async */
+	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
+
 	if (file->private_data == NULL) {
 		rc = -EBADF;
 		FreeXid(xid);
@@ -1906,7 +1914,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	     read_size > total_read;
 	     total_read += bytes_read, current_offset += bytes_read) {
 		current_read_size = min_t(uint, read_size - total_read,
-					  cifs_sb->rsize);
+					  rsize);
 		/* For windows me and 9x we do not want to request more
 		than it negotiated since it will refuse the read then */
 		if ((pTcon->ses) &&
-- 
1.7.6.4
