Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0BD2AD00
	for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 03:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773891777; cv=none; b=RcmuH4ySN24Xijvr1/zpr151yUpb11IdhZULzuAWxzrLn6jVK/d+AANlCQPw7Lfito+QXVQxtuGH8dgpF4xyZBgaDUmut8/EYahYNW23W5igB28U40EuLqsokCE3ISRkAN4pSoGC5QrnHdez+QAMv9qDNEOJuFQLAT0Nv+BFT8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773891777; c=relaxed/simple;
	bh=P0aj2xGHyjZVjHhyQOj81jPuzIMbf1y1d7lPD5AsLas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWPQMBsgZ7SCEW07gsxuOwYcacWLNogqbfgCPoa730IjPqH27RaE+gw4OVg06SX+rOk6ndkFOub6ZHulHHOIYZ/o4NWPaa4X4scLYxLCkwAc6o1IshJ/r/UPoNORBh/+liybDOV5d3AbCNLD96RY8XYpV/PZOM0wSi1MjduA/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vyWPgLYO; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vyWPgLYO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PEpGLLg/v6sgnqVGOrJR9Ae81fNokJdDazeO9D9jBlA=; b=vyWPgLYOCHmhQzq86zfUsoQy61
	7vJobU48mFCJ0O8t08eqeyAADMWDSSydsiUJYXwdKlmn82oYmMBVBDTDkH4rwLNDHhp5fIHE3NHNc
	JGb8w8amXLMNw9uNo6jjuFzKeAF1NzO53h3HBi0/juBZD43ewJshuiZn6y6wQ8EjqOsR7nmyXVj1e
	v/qMN2Gp9RrNNpMtCECNEhUcFJ0jlFDQvDe1lRB1dTd5rGMF61F0SpsOCN/a4uaszvMoTeeQaVNIQ
	uH8RjqL9zEPO12Ttrkd/rdeepSR+0tcvAQMvq30G5oH5pxJGHutR8XzVSTQq7kDeynedkbaT3Vmek
	VCxs5glg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w34Hc-00000001BIJ-2dH3;
	Thu, 19 Mar 2026 00:42:52 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: fix generic/694 due to wrong ->i_blocks
Date: Thu, 19 Mar 2026 00:42:52 -0300
Message-ID: <20260319034252.472217-1-pc@manguebit.org>
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
v1 -> v2:
 - update ->i_blocks under spinlock in cifs_setsize()
 - fixed comment in CIFS_INO_BLOCKS()
 - removed obsolete comment in smb2_duplicate_extents()

 fs/smb/client/cifsglob.h |  6 ++++++
 fs/smb/client/file.c     |  1 -
 fs/smb/client/inode.c    | 21 ++++++---------------
 fs/smb/client/smb2ops.c  | 20 ++++----------------
 4 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 7877d327dbb0..bc8d002c3847 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2386,4 +2386,10 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 	return opts;
 }
 
+/*
+ * The number of blocks is not related to (i_size / i_blksize), but instead
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
index 143fa2e665ed..888f9e35f14b 100644
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
@@ -3015,6 +3009,11 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 {
 	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
+	/*
+	 * Until we can query the server for actual allocation size,
+	 * this is best estimate we have for blocks allocated for a file.
+	 */
+	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
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
index 98ac4e86bf99..509fcea28a42 100644
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
@@ -2204,14 +2200,6 @@ smb2_duplicate_extents(const unsigned int xid,
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-
-		/*
-		 * Although also could set plausible allocation size (i_blocks)
-		 * here in addition to setting the file size, in reflink
-		 * it is likely that the target file is sparse. Its allocation
-		 * size will be queried on next revalidate, but it is important
-		 * to make sure that file's cached size is updated immediately
-		 */
 		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
 	}
-- 
2.53.0

