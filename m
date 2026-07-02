Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E3823BD1D
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005224; cv=none; b=VrghoAMnUEiinyN+Mx9+404O3QEOSATTcTlgNrON8U+b5GayT2e+rUAS9scfw9HKdkC4Z3zlRh5GGAjJqNkE/Athqs2C+YyjxitZkeD/LYZ2HRBV5D8ajTe9ePquGf9pt3e768G8+fB/KMLIIEc2S0Q26y0/vfSzeHUOnuXsvlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005224; c=relaxed/simple;
	bh=zL+OCyM+K5dyDXl3BQuwhQAzsZBnWVVmXSUfWWnJc/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyClotVPH5UME+rDf1vsGaT/thX7XKvmod4y7MExjw7E2JWAZNuaYg14FTQ40I12URR/VHevcKQkCCahnbNFJlu+YzUpCx+P0Fv8adHTfNchW9bBql1dSIUftSN4ff4a9mky7fOJVoBXoTPSlihmY9A0+dDOoFRLSBfL7RxNprw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ReOiWuDW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ReOiWuDW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783005219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5k+sBeafDIol23sJKFeBKG5ygculRoI4ZPRsWWDJnI=;
	b=ReOiWuDWoEEzB/IhVRq7g2Ijgie6tmK5+nSA1W5ifseFB/eCvZ1SUnn0cJufwrvzITHtw9
	xG/rEJjtyCw1Qyv0V2Iybc2VX1ArNs9CxwUlzlDj52JfQZA1I9oD6kWB6Zbua2pGjS9RuU
	5ABGNn9BK5lOQVNgcYr0ytGsfkToGnM=
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
Subject: [PATCH v7 3/4] smb/client: emulate small EOF-extending mode 0 fallocate ranges
Date: Thu,  2 Jul 2026 23:12:54 +0800
Message-ID: <20260702151255.886945-4-huiwen.he@linux.dev>
In-Reply-To: <20260702151255.886945-1-huiwen.he@linux.dev>
References: <20260702151255.886945-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

When a mode 0 fallocate extends EOF from 1G to 2G + 1M, the client
currently sends SetEOF for 2G + 1M. This can make fallocate return
success without allocating the requested range, or allocate extra
space before that range.

For example, on a fresh file:

        xfs_io -f \
          -c "falloc 0 1G" \
          -c "falloc 2G 1M" \
          -c "truncate 3G" test

The second fallocate should allocate [2G, 2G + 1M), leaving [1G, 2G)
as a hole.

Before this change, the result depended on the server allocation policy.
With Samba "strict allocate = no", SetEOF could return success without
allocating [2G, 2G + 1M). With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            allocated unexpectedly
        [2G, 2G + 1M)       allocated

SMB cannot allocate that arbitrary range, so write zeroes to small
EOF-extending ranges instead. Limit this to 1 MiB to bound the
client-side I/O cost.

With "strict allocate = no", the requested range [2G, 2G + 1M) is
allocated by the writes. With "strict allocate = yes":

	# filefrag -v test
        [0, 1G)             allocated
        [1G, 2G)            hole
        [2G, 2G + 1M)       allocated

This fixes the small EOF-extending range case exercised by generic/213.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 69 +++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e6a7ac8cd99e..9ccc7eb52899 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3610,11 +3610,24 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 				       loff_t off, loff_t len)
 {
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	struct inode *inode = d_inode(cfile->dentry);
 	u32 out_data_len;
 	char *buf = NULL;
 	loff_t l;
 	int rc;
 
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (off >= i_size_read(inode)) {
+		rc = smb3_simple_fallocate_write_range(xid, tcon, cfile,
+						       off, len, buf);
+		goto out;
+	}
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3626,12 +3639,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	tmp_data = out_data;
 	while (len) {
 		/*
@@ -3696,18 +3703,22 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	loff_t new_eof;
+	loff_t old_eof, new_eof;
+	struct smb2_file_all_info file_inf;
+	u64 asize;
+	int qrc;
 
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
+	old_eof = i_size_read(inode);
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
+		if (!keep_size) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
@@ -3717,11 +3728,51 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && old_eof < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range at or beyond EOF can be allocated by writing
+		 * zeroes.  For off > old_eof, this preserves the intervening
+		 * hole instead of allocating from offset 0.
+		 */
+		if (off > old_eof ||
+		    (off == old_eof && old_eof != 0 &&
+		     (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))) {
+			if (len > 1024 * 1024) {
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			if (rc) {
+				spin_lock(&inode->i_lock);
+				cifsi->time = 0;
+				spin_unlock(&inode->i_lock);
+				goto out;
+			}
+
+			new_eof = off + len;
+			netfs_resize_file(&cifsi->netfs, new_eof, true);
+			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
-- 
2.43.0

