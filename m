Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E414614AD3B;
	Thu, 23 May 2024 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470686; cv=none; b=YP8s4LUytulaOWRFwWPUnMldyxmx6sSzRw5nfITm6TPx5cZroT0WVeO9soe4A4eXrq/ZfRZSRJChw3n2TfcrzgxBPAWyuSUI2UDf2Gx9hnzfLedjIFWc08t0xEkLxnGqqyXPbvWOMMa+kll35WW1njCxEPKqrgZJMBWoUAeLmRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470686; c=relaxed/simple;
	bh=5EwAjO4XpJTQcTfcKw6ABmgyp64Aru20/pjNXEQs8LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbKu92LA0OeGoHql9k9IcwP1MMwbrlAcBsFufeYQKcv9PGYFg1cZITCXtCDzzR6HG7wAntPyPau5nwK89daIAiG0IfNRs4ZcwoaEWheH1PTqJARClkdpUnKD+BwT/Joa0x0Cgr5qf3bFUatbEREwbcxnyJgazSCqo1UUbmWSARk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSpbC1x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSpbC1x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8ECC2BD10;
	Thu, 23 May 2024 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470685;
	bh=5EwAjO4XpJTQcTfcKw6ABmgyp64Aru20/pjNXEQs8LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSpbC1x8jFFvNJZt2yV6bzwcBkSKzmjM7r/SwoAVJh5wQelmc4E+WYk6sShFBT+DZ
	 p2Gsdn2g36hAHvh6fvzo4pzBl0lPAbJ2+cY5sXaEAk57UlHjWulaytnZPt2En7nug7
	 Ll7yK9WY+xiLnbiBuAVv7tCUnU+d9BBArMjWz0Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/102] cifs: Pass unbyteswapped eof value into SMB2_set_eof()
Date: Thu, 23 May 2024 15:12:46 +0200
Message-ID: <20240523130343.264420043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6ebfede8d57a615dcbdec7e490faed585153f7f1 ]

Change SMB2_set_eof() to take eof as CPU order rather than __le64 and pass
it directly rather than by pointer.  This moves the conversion down into
SMB_set_eof() rather than all of its callers and means we don't need to
undo it for the traceline.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c   | 37 ++++++++++++++++---------------------
 fs/smb/client/smb2pdu.c   |  6 +++---
 fs/smb/client/smb2proto.h |  2 +-
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a623a720db9e0..9b7cdb7d7ece8 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1932,7 +1932,6 @@ static int
 smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile, __u64 size, bool set_alloc)
 {
-	__le64 eof = cpu_to_le64(size);
 	struct inode *inode;
 
 	/*
@@ -1949,7 +1948,7 @@ smb2_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-			    cfile->fid.volatile_fid, cfile->pid, &eof);
+			    cfile->fid.volatile_fid, cfile->pid, size);
 }
 
 static int
@@ -3196,7 +3195,6 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	unsigned long long new_size;
 	long rc;
 	unsigned int xid;
-	__le64 eof;
 
 	xid = get_xid();
 
@@ -3226,9 +3224,8 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 */
 	new_size = offset + len;
 	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
-		eof = cpu_to_le64(new_size);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-				  cfile->fid.volatile_fid, cfile->pid, &eof);
+				  cfile->fid.volatile_fid, cfile->pid, new_size);
 		if (rc >= 0) {
 			truncate_setsize(inode, new_size);
 			fscache_resize_cookie(cifs_inode_cookie(inode), new_size);
@@ -3421,7 +3418,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	__le64 eof;
+	loff_t new_eof;
 
 	xid = get_xid();
 
@@ -3450,14 +3447,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
-		eof = cpu_to_le64(off + len);
+		new_eof = off + len;
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-				  cfile->fid.volatile_fid, cfile->pid, &eof);
+				  cfile->fid.volatile_fid, cfile->pid, new_eof);
 		if (rc == 0) {
-			cifsi->server_eof = off + len;
-			cifs_setsize(inode, off + len);
+			cifsi->server_eof = new_eof;
+			cifs_setsize(inode, new_eof);
 			cifs_truncate_page(inode->i_mapping, inode->i_size);
-			truncate_setsize(inode, off + len);
+			truncate_setsize(inode, new_eof);
 		}
 		goto out;
 	}
@@ -3548,8 +3545,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	__le64 eof;
-	loff_t old_eof;
+	loff_t old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3574,9 +3570,9 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	if (rc < 0)
 		goto out_2;
 
-	eof = cpu_to_le64(old_eof - len);
+	new_eof = old_eof - len;
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-			  cfile->fid.volatile_fid, cfile->pid, &eof);
+			  cfile->fid.volatile_fid, cfile->pid, new_eof);
 	if (rc < 0)
 		goto out_2;
 
@@ -3600,8 +3596,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	unsigned int xid;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct inode *inode = file_inode(file);
-	__le64 eof;
-	__u64  count, old_eof;
+	__u64 count, old_eof, new_eof;
 
 	xid = get_xid();
 
@@ -3614,20 +3609,20 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	count = old_eof - off;
-	eof = cpu_to_le64(old_eof + len);
+	new_eof = old_eof + len;
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof + len - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
 	if (rc < 0)
 		goto out_2;
 	truncate_pagecache_range(inode, off, old_eof);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-			  cfile->fid.volatile_fid, cfile->pid, &eof);
+			  cfile->fid.volatile_fid, cfile->pid, new_eof);
 	if (rc < 0)
 		goto out_2;
 
-	truncate_setsize(inode, old_eof + len);
+	truncate_setsize(inode, new_eof);
 	fscache_resize_cookie(cifs_inode_cookie(inode), i_size_read(inode));
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 70530108b9bb9..51ff9a967c503 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5414,18 +5414,18 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 int
 SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
-	     u64 volatile_fid, u32 pid, __le64 *eof)
+	     u64 volatile_fid, u32 pid, loff_t new_eof)
 {
 	struct smb2_file_eof_info info;
 	void *data;
 	unsigned int size;
 
-	info.EndOfFile = *eof;
+	info.EndOfFile = cpu_to_le64(new_eof);
 
 	data = &info;
 	size = sizeof(struct smb2_file_eof_info);
 
-	trace_smb3_set_eof(xid, persistent_fid, tcon->tid, tcon->ses->Suid, le64_to_cpu(*eof));
+	trace_smb3_set_eof(xid, persistent_fid, tcon->tid, tcon->ses->Suid, new_eof);
 
 	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
 			pid, FILE_END_OF_FILE_INFORMATION, SMB2_O_INFO_FILE,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 1e20f87a5f584..343ada691e763 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -221,7 +221,7 @@ extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tcon *tcon,
 extern void SMB2_query_directory_free(struct smb_rqst *rqst);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, u32 pid,
-			__le64 *eof);
+			loff_t new_eof);
 extern int SMB2_set_info_init(struct cifs_tcon *tcon,
 			      struct TCP_Server_Info *server,
 			      struct smb_rqst *rqst,
-- 
2.43.0



