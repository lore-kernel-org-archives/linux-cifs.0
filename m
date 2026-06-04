Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634D930C152
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585464; cv=none; b=Lc08TpfA+a/qUi411JHbHjiUC5E3gZFmn9AOVu8BhRQpMVHIiPSit35QIU5+HdGlPN/zDeonlnL+9udHd7bqmNqtDWtDdqzZcTfxepVQ/N+rFBgxlC0/qQcqkkTZD1PEhL2SK7eSUYJay8c+374XBhJuPTFGXnPqqREkv3HVtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585464; c=relaxed/simple;
	bh=Fl8w4cXOgr5lDXqFtSwQ9IZDv2lkkk6jR0SUuhcQC4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SARBMl7kk/TpuGm01nGyOqbSCZIpShgHn5hWoI95j1iVfSmcuz/dPk7gRrad832oALjxfpNY/x39q/7eL2KsvpAfiCKzBrdaEVYALmkysGU1TahJcUpLTJdMWk+2QNtHd/EQFEEuF1zUvXVEBuLL0InUiucN6YQOX4XoyFEacAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B/iYrg0z; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B/iYrg0z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780585460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cOgOco8ZjwsSAlu7i2uGVlDd6fH7VjXg/dbhYuUEzU4=;
	b=B/iYrg0zwB8ZWbnThiHJM0C7vxoLgXsPGz5/byiTxHRchG0wvVaOXbiNLQ/thDunCbQp0v
	Pg0zivRDLDk/li8TyTSNjbx/+hswjgBGE44RpT4OiF/PnhYVWhefnmuLZlKJcu0T0LDh+F
	u0fhKQX4kwk6eHhNfl+aYiO41TCS9g8=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 1/3] smb/client: update i_blocks after contiguous writes
Date: Thu,  4 Jun 2026 23:03:47 +0800
Message-ID: <20260604150349.101716-2-huiwen.he@linux.dev>
In-Reply-To: <20260604150349.101716-1-huiwen.he@linux.dev>
References: <20260604150349.101716-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

When a lease allows CIFS to use cached inode attributes, getattr may
return the locally cached attributes instead of revalidating them from
the server. After local writes extend a file, the write path updates the
file size, but i_blocks can remain based on the old allocation size.

For example, while the file is still open after two contiguous writes,
the local block count can remain smaller than the written range:

        after first write:   st_size = 4096,  st_blocks = 7
        after second write:  st_size = 12288, st_blocks = 21
        after close:         st_size = 12288, st_blocks = 24

This can make a fully written file look sparse:

        i_blocks * 512 < i_size

and can cause swap activation to reject a valid write-created swapfile
as having holes. This results in xfstests skipping swap-related tests
on CIFS mounts:

	generic/472         [not run] swapfiles are not supported
	generic/494         [not run] swapfiles are not supported
	generic/497         [not run] swapfiles are not supported
	generic/569         [not run] swapfiles are not supported
	generic/636         [not run] swapfiles are not supported
	generic/643         [not run] swapfiles are not supported

Update the local i_blocks estimate after successful writes, but only
when the write starts at or before the currently known allocated range.
This lets sequential writes grow i_blocks while avoiding treating
write-past-EOF holes as allocated.

Skip the local estimate for files that are already marked sparse, since
their allocation needs to come from the server rather than from a
contiguous-write estimate.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h |  9 ++++++---
 fs/smb/client/file.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..943b7cd2c096 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2387,9 +2387,12 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 }
 
 /*
- * The number of blocks is not related to (i_size / i_blksize), but instead
- * 512 byte (2**9) size is required for calculating num blocks.
+ * inode->i_blocks is counted in 512-byte units, independent of
+ * inode->i_blksize.
  */
-#define CIFS_INO_BLOCKS(size) DIV_ROUND_UP_ULL((u64)(size), 512)
+#define CIFS_INO_BLOCK_SIZE 512ULL
+#define CIFS_INO_BLOCKS(size) \
+	DIV_ROUND_UP_ULL((u64)(size), CIFS_INO_BLOCK_SIZE)
+#define CIFS_INO_BYTES(blocks) ((u64)(blocks) * CIFS_INO_BLOCK_SIZE)
 
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f27..7da96ea3a59e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2514,6 +2514,28 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	return rc;
 }
 
+static void cifs_update_i_blocks_after_write(struct inode *inode, loff_t start,
+					     loff_t end)
+{
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	u64 allocated_end = CIFS_INO_BYTES(inode->i_blocks);
+	u64 blocks;
+
+	if (cinode->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
+		return;
+
+	/*
+	 * Grow the local estimate only across the currently known allocated
+	 * prefix. A write beyond that may leave a hole.
+	 */
+	if ((u64)start > allocated_end)
+		return;
+
+	blocks = CIFS_INO_BLOCKS(end);
+	if ((u64)inode->i_blocks < blocks)
+		inode->i_blocks = blocks;
+}
+
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t result)
 {
 	struct netfs_io_request *wreq = wdata->rreq;
@@ -2532,6 +2554,8 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 			netfs_write_zero_point(inode, wrend);
 		if (wrend > ictx->_remote_i_size)
 			netfs_resize_file(ictx, wrend, true);
+		cifs_update_i_blocks_after_write(inode, wdata->subreq.start,
+						 wrend);
 
 		spin_unlock(&inode->i_lock);
 	}
@@ -2895,6 +2919,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode);
+	loff_t start;
 	ssize_t rc;
 
 	rc = netfs_start_io_write(inode);
@@ -2919,7 +2944,13 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 	}
 
+	start = iocb->ki_pos;
 	rc = netfs_buffered_write_iter_locked(iocb, from, NULL);
+	if (rc > 0) {
+		spin_lock(&inode->i_lock);
+		cifs_update_i_blocks_after_write(inode, start, start + rc);
+		spin_unlock(&inode->i_lock);
+	}
 
 out:
 	up_read(&cinode->lock_sem);
-- 
2.43.0

