Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B912C534
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182928; cv=none; b=YNgJB6uz+4vZT8s3GK/Jce/kfRmvLB8iPx5BXuBiRREZqCGjdTqq5btwWUOq0Zo7csR80vfLEimGxavbqtCUnBgpxJdsbx3A4IIToL8tR8vhmg340lBYJwoZaRbUlOFWjQvnlKxOSRnv7WnmmvnNYDRddbQcmTs6BGhcW1MLOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182928; c=relaxed/simple;
	bh=39ZHHfBXjNKznc1MjedS6Wal5jGYPJtv2UF9yfda37o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX/8T9qjiA/nemywJcQGhDkT9EYLCUUj3aZG3Fxcrr/F//1p9cY11sAjipUTvnYawc13USb7kV7NL1kOfR68ojnNx8ccViuiyditqdflRKH3k2Wr3GxqGgQBTk0pvqQ9kMrDfTliLoYU4pxaWEWgGRHeA3oDtqPWbUsNWEqvRdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Yl1Fh/UM; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Yl1Fh/UM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6o+w2UuSjXTypiZKN4gOXQMsNl5agtHCmLnjv5Ly9/A=;
	b=Yl1Fh/UMuPCsMZTrztrG/UwnB9JVXbSyNbAlyUnkQnroRlwCDRdcKtcktVekoi14ozByLz
	8PlFtAGjaM/4bJjfkU2wYNQpFYN4I2UEjWWbzRx/N1ZhGYwmjtjiKWLcbmeOES8uRFC35t
	mgF6xVMn82WZCQQetWWENvtXA8HIqCo=
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
Subject: [PATCH 5/7] smb/client: verify allocation after EOF-extending fallocate
Date: Tue, 23 Jun 2026 10:46:17 +0800
Message-ID: <20260623024619.1360127-6-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-1-huiwen.he@linux.dev>
References: <20260623024619.1360127-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

EOF-extending fallocate(mode=0) currently returns success after SetEOF
even if the server has not allocated the requested space. This gives
userspace a false preallocation guarantee and can cause a later write
into that range to fail with ENOSPC.

This happens because SMB2 has no operation that directly matches Linux
fallocate for an arbitrary byte range. SetEOF changes only the logical
file size, while FILE_ALLOCATION_INFORMATION can request allocation only
from offset 0 up to a specified allocation size.

Use FILE_ALLOCATION_INFORMATION only when allocation from offset 0 can
cover the requested range, and verify the resulting AllocationSize before
returning success. Arbitrary non-zero-offset ranges remain unsupported.
Request and verify allocation before changing EOF, so a failed allocation
leaves EOF unchanged. Invalidate the cached inode attributes when the
operation fails.

With Samba `strict allocate=yes`, this allows generic/496, generic/568 and
generic/701 to pass after verifying the server allocation. With
`strict allocate=no`, the requests fail instead of reporting false
preallocation success.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c   | 69 +++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   | 19 +++++++++++
 fs/smb/client/smb2proto.h |  3 ++
 fs/smb/common/fscc.h      |  5 +++
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 61b581d86686..8b931581870a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3665,12 +3665,16 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	loff_t new_eof;
+	loff_t old_eof, new_eof;
+	struct smb2_file_all_info file_inf;
+	u64 asize = 0;
+	int qrc;
 
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
+	old_eof = i_size_read(inode);
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
@@ -3686,11 +3690,24 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && old_eof < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
 
+		/*
+		 * FILE_ALLOCATION_INFORMATION sets the file allocation size. It
+		 * cannot allocate an arbitrary byte range. Use it only when
+		 * allocating blocks from offset 0 to the new EOF is sufficient.
+		 *
+		 * A non-zero offset is allowed only for an empty file, where this
+		 * covers all blocks touched by the requested range.
+		 */
+		if (off != 0 && old_eof != 0) {
+			rc = -EOPNOTSUPP;
+			goto out;
+		}
+
 		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) &&
 		    !smb2_set_sparse(xid, tcon, cfile, inode, false)) {
 			rc = -EOPNOTSUPP;
@@ -3698,12 +3715,52 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 
 		new_eof = off + len;
+
+		qrc = SMB2_query_info(xid, tcon, cfile->fid.persistent_fid,
+				      cfile->fid.volatile_fid, &file_inf);
+		if (qrc == 0)
+			asize = le64_to_cpu(file_inf.AllocationSize);
+
+		if (qrc || asize < new_eof) {
+			rc = SMB2_set_allocation(xid, tcon,
+						 cfile->fid.persistent_fid,
+						 cfile->fid.volatile_fid,
+						 cfile->pid, new_eof);
+			if (rc)
+				goto invalidate_attrs;
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			if (qrc) {
+				rc = qrc;
+				goto invalidate_attrs;
+			}
+
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			if (asize < new_eof) {
+				rc = -EOPNOTSUPP;
+				goto invalidate_attrs;
+			}
+		}
+
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
-		if (rc == 0) {
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
-		}
+		if (rc)
+			goto invalidate_attrs;
+
+		netfs_resize_file(&cifsi->netfs, new_eof, true);
+		cifs_setsize(inode, new_eof);
+
+		spin_lock(&inode->i_lock);
+		inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		spin_unlock(&inode->i_lock);
+		goto out;
+
+invalidate_attrs:
+		spin_lock(&inode->i_lock);
+		cifsi->time = 0;
+		spin_unlock(&inode->i_lock);
 		goto out;
 	}
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4972cfe249f6..1c6fadb7fbf3 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5899,6 +5899,25 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 			0, 1, &data, &size);
 }
 
+int
+SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
+		    u64 persistent_fid, u64 volatile_fid, u32 pid,
+		    loff_t allocation_size)
+{
+	struct smb2_file_alloc_info info;
+	void *data;
+	unsigned int size;
+
+	info.AllocationSize = cpu_to_le64(allocation_size);
+
+	data = &info;
+	size = sizeof(struct smb2_file_alloc_info);
+
+	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+			pid, FILE_ALLOCATION_INFORMATION, SMB2_O_INFO_FILE,
+			0, 1, &data, &size);
+}
+
 int
 SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 78a4e1c340f9..16a02c1eb0a1 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -204,6 +204,9 @@ void SMB2_query_directory_free(struct smb_rqst *rqst);
 int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 		 u64 persistent_fid, u64 volatile_fid, u32 pid,
 		 loff_t new_eof);
+int SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
+			u64 persistent_fid, u64 volatile_fid, u32 pid,
+			loff_t allocation_size);
 int SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		       struct smb_rqst *rqst, u64 persistent_fid,
 		       u64 volatile_fid, u32 pid, u8 info_class, u8 info_type,
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index bc3012cc295d..c9d5aa94727f 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -265,6 +265,11 @@ struct smb2_file_eof_info { /* encoding of request for level 10 */
 	__le64 EndOfFile; /* new end of file value */
 } __packed; /* level 20 Set */
 
+/* See MS-FSCC 2.4.4 */
+struct smb2_file_alloc_info { /* encoding of request for level 19 */
+	__le64 AllocationSize;
+} __packed;
+
 /* See MS-FSCC 2.4.15 */
 typedef struct {
 	__le32 NextEntryOffset;
-- 
2.43.0

