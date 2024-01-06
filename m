Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD74101DB
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jan 2024 23:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="lbNIFihw"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704582329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eEv8VXAO9UBJuBJEa3SPzu0tOIFg6jeO/vSkX9aACbE=;
	b=lbNIFihw/tq1W97Ho5QVjXtDqsLl3WmD3YE84PKWFR2UM5hZBS7X7xctf5Qa31eH1X1cLc
	LtNuyH5Jt8Y0XRdkWO3Kd2b2YvM42NPqvdjjnCYYrZ/iukttezsHaHMfmLCzxw7h2JtmKR
	jbsYlYgcOJtFvRvc4EPAcM+PYJHoHfL+8BJdgMxt5cvYz3MTLqqOSy7DgEZF6WksV1ECH8
	b8gJfediTMGhmCbn9fbtFlW/wgdg+baIzaOKr8xANEgUjyL/D+dToClwpo4QRUIeOR5XeK
	wdP9gVQJ57HX/XVHe3yPzf3SDOBXKF1MaDzcXXDqSJmhgxDCYWo1LotFEkGA3w==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1704582329; a=rsa-sha256;
	cv=none;
	b=ScBHterlaLelRgYb30QGbqmOGFCnIvVXNHlt4klTH5vlCCmw5MfTbs0BM4bHunXtFTVjxd
	JeZnEtNouJg95lhP9aeXbZDdBAfAWYkMH0OYiO/7LiksRKstXV78nIBMIi4OmqM/s1KXWr
	zo49SCqlZGtZPljuD1p+QLIrVW7QpKiUhh0RlYQ61FWPzgUESDYfYYN2XVVdrY8u7q+Iiz
	mRprki9J2r46tRntmd0xiNyCQsLbi6DZimCMCtT2IH57GK3Ckk2R31VAMdD2SIrHFHif/j
	pv1JvCupzdRFDYadTy8ItpbmiKUD1yHL0t0rfiJdFwLKUSNuxLvcewBa8wftTA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704582329; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=eEv8VXAO9UBJuBJEa3SPzu0tOIFg6jeO/vSkX9aACbE=;
	b=aCG3dtzfqS4YtmLNoRQ8ohE78JJohZvKVY6WQY1fhe45hkeNhuEqEqFt6vcZ7LaeJxOCjt
	1rS3VBkVnbW3/XsYNEwHgoUF72yFM0X0SHLsSqxay7tEQlisLqrHr0SlcWugEEOy6IYNgS
	LKsRm+eBuDjMTXIP2HvnRhtXN47Ze6gCLWZLCT8SqhJO1RFfel+kmwkGww0DTYArR+yC60
	OzzbC7bZu2VWsys6X+Wn/UvYsTAB4sFc4c649/kiAJwFEh6tiZPYXUWYTCo9LvYrIP0EaY
	hJp4jiayLvy1ryuq6HqReRmsXq5LFOAAQq1LP0psQ2YKfvEUKbe6gpGYfRDbvg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/2] smb: client: stop revalidating reparse points unnecessarily
Date: Sat,  6 Jan 2024 20:05:17 -0300
Message-ID: <20240106230518.29920-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Query dir responses don't provide enough information on reparse points
such as major/minor numbers and symlink targets other than reparse
tags, however we don't need to unconditionally revalidate them only
because they are reparse points.  Instead, revalidate them only when
their ctime or reparse tag has changed.

For instance, Windows Server updates ctime of reparse points when
their data have changed.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h |   1 +
 fs/smb/client/inode.c    |   4 +-
 fs/smb/client/readdir.c  | 133 ++++++++++++++++-----------------------
 3 files changed, 57 insertions(+), 81 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f840756e0169..879d5ef8a66e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1565,6 +1565,7 @@ struct cifsInodeInfo {
 	spinlock_t deferred_lock; /* protection on deferred list */
 	bool lease_granted; /* Flag to indicate whether lease or oplock is granted. */
 	char *symlink_target;
+	__u32 reparse_tag;
 };
 
 static inline struct cifsInodeInfo *
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c532aa63a658..9f37c1758f73 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -182,6 +182,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
+	cifs_i->reparse_tag = fattr->cf_cifstag;
 
 	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
 		cifs_i->time = 0;
@@ -209,7 +210,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
 	}
 
-	if (S_ISLNK(fattr->cf_mode)) {
+	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
 		kfree(cifs_i->symlink_target);
 		cifs_i->symlink_target = fattr->cf_symlink_target;
 		fattr->cf_symlink_target = NULL;
@@ -1120,6 +1121,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 	else
 		cifs_open_info_to_fattr(fattr, data, sb);
 out:
+	fattr->cf_cifstag = data->reparse.tag;
 	free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
 	return rc;
 }
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index d30ea2005eb3..056cae1ddcce 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -55,6 +55,23 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
 }
 #endif /* DEBUG2 */
 
+/*
+ * Match a reparse point inode if reparse tag and ctime haven't changed.
+ *
+ * Windows Server updates ctime of reparse points when their data have changed.
+ * The server doesn't allow changing reparse tags from existing reparse points,
+ * though it's worth checking.
+ */
+static inline bool reparse_inode_match(struct inode *inode,
+				       struct cifs_fattr *fattr)
+{
+	struct timespec64 ctime = inode_get_ctime(inode);
+
+	return (CIFS_I(inode)->cifsAttrs & ATTR_REPARSE) &&
+		CIFS_I(inode)->reparse_tag == fattr->cf_cifstag &&
+		timespec64_equal(&ctime, &fattr->cf_ctime);
+}
+
 /*
  * Attempt to preload the dcache with the results from the FIND_FIRST/NEXT
  *
@@ -71,6 +88,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	struct super_block *sb = parent->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
+	int rc;
 
 	cifs_dbg(FYI, "%s: for %s\n", __func__, name->name);
 
@@ -82,9 +100,11 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 		 * We'll end up doing an on the wire call either way and
 		 * this spares us an invalidation.
 		 */
-		if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
-			return;
 retry:
+		if ((fattr->cf_cifsattrs & ATTR_REPARSE) ||
+		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
+			return;
+
 		dentry = d_alloc_parallel(parent, name, &wq);
 	}
 	if (IS_ERR(dentry))
@@ -104,12 +124,34 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
-			/* update inode in place
-			 * if both i_ino and i_mode didn't change */
-			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid &&
-			    cifs_fattr_to_inode(inode, fattr) == 0) {
-				dput(dentry);
-				return;
+			/*
+			 * Update inode in place if both i_ino and i_mode didn't
+			 * change.
+			 */
+			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+				/*
+				 * Query dir responses don't provide enough
+				 * information about reparse points other than
+				 * their reparse tags.  Save an invalidation by
+				 * not clobbering the existing mode, size and
+				 * symlink target (if any) when reparse tag and
+				 * ctime haven't changed.
+				 */
+				rc = 0;
+				if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+					if (likely(reparse_inode_match(inode, fattr))) {
+						fattr->cf_mode = inode->i_mode;
+						fattr->cf_eof = CIFS_I(inode)->server_eof;
+						fattr->cf_symlink_target = NULL;
+					} else {
+						CIFS_I(inode)->time = 0;
+						rc = -ESTALE;
+					}
+				}
+				if (!rc && !cifs_fattr_to_inode(inode, fattr)) {
+					dput(dentry);
+					return;
+				}
 			}
 		}
 		d_invalidate(dentry);
@@ -127,29 +169,6 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	dput(dentry);
 }
 
-static bool reparse_file_needs_reval(const struct cifs_fattr *fattr)
-{
-	if (!(fattr->cf_cifsattrs & ATTR_REPARSE))
-		return false;
-	/*
-	 * The DFS tags should be only intepreted by server side as per
-	 * MS-FSCC 2.1.2.1, but let's include them anyway.
-	 *
-	 * Besides, if cf_cifstag is unset (0), then we still need it to be
-	 * revalidated to know exactly what reparse point it is.
-	 */
-	switch (fattr->cf_cifstag) {
-	case IO_REPARSE_TAG_DFS:
-	case IO_REPARSE_TAG_DFSR:
-	case IO_REPARSE_TAG_SYMLINK:
-	case IO_REPARSE_TAG_NFS:
-	case IO_REPARSE_TAG_MOUNT_POINT:
-	case 0:
-		return true;
-	}
-	return false;
-}
-
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
@@ -181,14 +200,6 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	}
 
 out_reparse:
-	/*
-	 * We need to revalidate it further to make a decision about whether it
-	 * is a symbolic link, DFS referral or a reparse point with a direct
-	 * access like junctions, deduplicated files, NFS symlinks.
-	 */
-	if (reparse_file_needs_reval(fattr))
-		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
-
 	/* non-unix readdir doesn't provide nlink */
 	fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
 
@@ -269,9 +280,6 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		fattr->cf_dtype = DT_REG;
 	}
 
-	if (reparse_file_needs_reval(fattr))
-		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
-
 	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
 	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
 }
@@ -331,38 +339,6 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 	cifs_fill_common_info(fattr, cifs_sb);
 }
 
-/* BB eventually need to add the following helper function to
-      resolve NT_STATUS_STOPPED_ON_SYMLINK return code when
-      we try to do FindFirst on (NTFS) directory symlinks */
-/*
-int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
-			     unsigned int xid)
-{
-	__u16 fid;
-	int len;
-	int oplock = 0;
-	int rc;
-	struct cifs_tcon *ptcon = cifs_sb_tcon(cifs_sb);
-	char *tmpbuffer;
-
-	rc = CIFSSMBOpen(xid, ptcon, full_path, FILE_OPEN, GENERIC_READ,
-			OPEN_REPARSE_POINT, &fid, &oplock, NULL,
-			cifs_sb->local_nls,
-			cifs_remap(cifs_sb);
-	if (!rc) {
-		tmpbuffer = kmalloc(maxpath);
-		rc = CIFSSMBQueryReparseLinkInfo(xid, ptcon, full_path,
-				tmpbuffer,
-				maxpath -1,
-				fid,
-				cifs_sb->local_nls);
-		if (CIFSSMBClose(xid, ptcon, fid)) {
-			cifs_dbg(FYI, "Error closing temporary reparsepoint open\n");
-		}
-	}
-}
- */
-
 static int
 _initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
@@ -431,13 +407,10 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 					  &cifsFile->fid, search_flags,
 					  &cifsFile->srch_inf);
 
-	if (rc == 0)
+	if (rc == 0) {
 		cifsFile->invalidHandle = false;
-	/* BB add following call to handle readdir on new NTFS symlink errors
-	else if STATUS_STOPPED_ON_SYMLINK
-		call get_symlink_reparse_path and retry with new path */
-	else if ((rc == -EOPNOTSUPP) &&
-		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	} else if ((rc == -EOPNOTSUPP) &&
+		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
 		goto ffirst_retry;
 	}
-- 
2.43.0

