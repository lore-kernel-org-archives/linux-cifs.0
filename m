Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070A229CE1
	for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773881856; cv=none; b=N0Ez9qbzJ27ygc3EsZOTjJam7yLb4SwANN101aLUmYb3StmeKJqHDfwA7DomWe9CB5TXIeunakVxNOtSG1ehGSAVvT6SFEzG1eykNZZTNAr+b8lwTQLo9nDU0c4sK0d21yvGLaKgP1+X+ONuZFpaKgyzknynrkveYkSYi588zOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773881856; c=relaxed/simple;
	bh=ftnVkjQ9UiuirF8YD1Q/5ZIkjkcP2+pcuiXlbDTu8ME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vF2gidN2xQAbEJ6zT377Gr3A0guiGh+Xoopek3/FjVyUFSGYLr/3ByDtCFteqijDJX6vBjT1s0A31OzZMyYRo6uiriRvtKp4hRwtPaABPbfYxhDu5frVktQOVojOtGmliFKhYxSpW1G1BLKoz/AbPlm0UXwRttg8ffE0h2zXSS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=AaIeiN9W; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="AaIeiN9W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mdkeburzGtlatxK5uAY8B3V79pXHCVbr3MUmt6jHvDw=; b=AaIeiN9WVjFuL9kadpURYcneYN
	asS5rG3uAPkc76dDkHMqd4JQbHVWLMTf765ksLM2gM4LHdhEvkoj5USMY7hgNSMn3eZahKAbEonQn
	J4qtqJSitzqri4djDZclO75y50+M9tJljvn1JPkL1LbQIiy73W8LDhJ1W6u6WPYPHX2PnWbJ/NkyI
	KOMGdk1Xpsf2aNwY9DCRnuShZltWFZW692nkSAbPYsk7TIWkZhELHJ4bmhqxVae7z3UqJlwrppiwl
	H7cD9+GXxl501+qB0Sc8oTGnVRLiDgy+6QGtZ9pHHWfERDfS0Pp25KCxIWSqEsCUAPC+9UgyF0xh9
	2tCoS4mg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w31ha-00000001AoZ-1j3w;
	Wed, 18 Mar 2026 21:57:30 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix generic/694 due to wrong ->i_blocks
Date: Wed, 18 Mar 2026 21:57:30 -0300
Message-ID: <20260319005730.330288-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When updating ->i_size, make sure to always update ->i_blocks as well
until we query new allocation size from the server.

generic/694 was failing because smb3_simple_falloc() was missing the
update of ->i_blocks after calling cifs_setsize().  So, fix this by
updating ->i_blocks directly in cifs_setsize(), so all places that
call it doesn't need to worry about updating ->i_blocks later.

Reported-by: Shyam Prasad N <sprasad@microsoft.com>
Closes: https://lore.kernel.org/r/CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  6 ++++++
 fs/smb/client/file.c     |  1 -
 fs/smb/client/inode.c    | 21 ++++++---------------
 fs/smb/client/smb2ops.c  | 12 ++++--------
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7877d327dbb0..7920ed83b2ff 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2386,4 +2386,10 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 	return opts;
 }
 
+/*
+ * The number of blocks is not related to (i_size / i_blksize), but instead 512
+ * 512 byte (2**9) size is required for calculating num blocks.
+ */
+#define CIFS_INO_BLOCKS(size) ((512 - 1 + (size)) >> 9)
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 27f61fe7e4e2..a69e05f86d7e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -993,7 +993,6 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
-			inode->i_blocks = 0;
 		}
 	}
 	if (cfile)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 143fa2e665ed..09e00ce9e0cb 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -219,13 +219,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	 */
 	if (is_size_safe_to_change(cifs_i, fattr->cf_eof, from_readdir)) {
 		i_size_write(inode, fattr->cf_eof);
-
-		/*
-		 * i_blocks is not related to (i_size / i_blksize),
-		 * but instead 512 byte (2**9) size is required for
-		 * calculating num blocks.
-		 */
-		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
+		inode->i_blocks = CIFS_INO_BLOCKS(fattr->cf_bytes);
 	}
 
 	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
@@ -3016,6 +3010,11 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
+	/*
+	 * Until we can query the server for actual allocation size,
+	 * this is best estimate we have for blocks allocated for a file.
+	 */
+	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
@@ -3087,14 +3086,6 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	if (rc == 0) {
 		netfs_resize_file(&cifsInode->netfs, size, true);
 		cifs_setsize(inode, size);
-		/*
-		 * i_blocks is not related to (i_size / i_blksize), but instead
-		 * 512 byte (2**9) size is required for calculating num blocks.
-		 * Until we can query the server for actual allocation size,
-		 * this is best estimate we have for blocks allocated for a file
-		 * Number of blocks must be rounded up so size 1 is not 0 blocks
-		 */
-		inode->i_blocks = (512 - 1 + size) >> 9;
 	}
 
 	return rc;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 98ac4e86bf99..f3dcd123c437 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1497,6 +1497,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_file_network_open_info file_inf;
 	struct inode *inode;
+	u64 asize;
 	int rc;
 
 	rc = __SMB2_close(xid, tcon, cfile->fid.persistent_fid,
@@ -1520,14 +1521,9 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 		inode_set_atime_to_ts(inode,
 				      cifs_NTtimeToUnix(file_inf.LastAccessTime));
 
-	/*
-	 * i_blocks is not related to (i_size / i_blksize),
-	 * but instead 512 byte (2**9) size is required for
-	 * calculating num blocks.
-	 */
-	if (le64_to_cpu(file_inf.AllocationSize) > 4096)
-		inode->i_blocks =
-			(512 - 1 + le64_to_cpu(file_inf.AllocationSize)) >> 9;
+	asize = le64_to_cpu(file_inf.AllocationSize);
+	if (asize > 4096)
+		inode->i_blocks = CIFS_INO_BLOCKS(asize);
 
 	/* End of file and Attributes should not have to be updated on close */
 	spin_unlock(&inode->i_lock);
-- 
2.53.0

