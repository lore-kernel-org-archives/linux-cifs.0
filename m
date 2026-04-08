Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1EE3D9037;
	Wed,  8 Apr 2026 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674252; cv=none; b=XxWb75IMX3NgCYDwhX3orsNzaLJWgK92AkhGNFMm3kVp49qI0F9HslZDgZ+riM5nifrT9igp4EvuYzQlhFH8Msb9BhWjX2yMtK2vVLsObldJT6gcgbMwjkdF1kJsmQI5i+UMh12zsvSWZoKlvKRUVnh2fS0v3T1m9YhZwaiQqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674252; c=relaxed/simple;
	bh=swwTAzCqDGHdHSGaDAz7weA9l3Mb3iWNwGEvg7QAZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXryzE3oPWgXihoodSEBKMpeUmTcPzoBhlNGna1RnPGYsTmGtW+FbwqHQnfkTvMkTppeN+onH+I/fw28OWuXt59E+zex3DHiSVmcCskZodSKKXv5h7SeVSM0CWwegbcrrvnktGQfvNFf1ku9r3vNzMfZQX3HHaNHXDCM+Nj4cPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5qy1bM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5qy1bM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058E5C19425;
	Wed,  8 Apr 2026 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674252;
	bh=swwTAzCqDGHdHSGaDAz7weA9l3Mb3iWNwGEvg7QAZ4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5qy1bM82ekKnVTGCFJWW/9giFGiKrKxzCYD5Q1WBWpWZyHSSHbfcy92VuWmWtS/m
	 p4WDRPUY5DT7Eu78LvtsYBNQIJ+SSxAwlk+vcQacXaTmwePLreXu3lemAwD1StCsL9
	 xIahSeJvqWuaeyOWjndIZkEAoX/6tHks6d+en2h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 025/311] smb: client: fix generic/694 due to wrong ->i_blocks
Date: Wed,  8 Apr 2026 20:00:25 +0200
Message-ID: <20260408175940.352885002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 23b5df09c27aec13962b30d32a4167ebdd043f8e ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  6 ++++++
 fs/smb/client/file.c     |  1 -
 fs/smb/client/inode.c    | 21 ++++++---------------
 fs/smb/client/smb2ops.c  | 20 ++++----------------
 4 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0c3d2bbef938e..474d7b2aa2ef5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2324,4 +2324,10 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 	return opts;
 }
 
+/*
+ * The number of blocks is not related to (i_size / i_blksize), but instead
+ * 512 byte (2**9) size is required for calculating num blocks.
+ */
+#define CIFS_INO_BLOCKS(size) DIV_ROUND_UP_ULL((u64)(size), 512)
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index c27a38843aa64..9d703a2474509 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -994,7 +994,6 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 		if (!rc) {
 			netfs_resize_file(&cinode->netfs, 0, true);
 			cifs_setsize(inode, 0);
-			inode->i_blocks = 0;
 		}
 	}
 	if (cfile)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f9ee95953fa4a..c5d89ddc87c00 100644
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
@@ -3009,6 +3003,11 @@ void cifs_setsize(struct inode *inode, loff_t offset)
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
@@ -3081,14 +3080,6 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
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
index 9bfd3711030b4..067e313283291 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1493,6 +1493,7 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct smb2_file_network_open_info file_inf;
 	struct inode *inode;
+	u64 asize;
 	int rc;
 
 	rc = __SMB2_close(xid, tcon, cfile->fid.persistent_fid,
@@ -1516,14 +1517,9 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -2197,14 +2193,6 @@ smb2_duplicate_extents(const unsigned int xid,
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



