Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D383F787B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481690; cv=none; b=FuE77W/M/5/XA//8OVU5vyHrGbp5IuN8mVnlm+LCjzD7bCRuO4hk6MQDJ49k6Psgbpi4UE5TUVPN2PbjsnxwBLYwCV789X0hV2qZBv9fUIvpzOtGq1dD5Lf7U1Axe6ZlvToYo59Oq+ZHSoauGKrHxIHsF8o22E2j/WRTNUhJZno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481690; c=relaxed/simple;
	bh=kZOS2qDPrwWduL8kjk/KLc2MP5pk/GeGpeUhiTYXFMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfFsaO8b85O2ID+nzRSPJeTrkjHS/CRdzQKQhd6XtIefDG6lI6tYnnaXMnd5oxmdQgMntM8zRNmrzw+ZjXOUtfd3+n/Dr04wpaj+nZVHAA15qELeHhu0/O6I0h8s0HBXy5H/lNk7ZRUIqFxAq4f05FMHCArqTXESlp2xlO/WgfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kB0AwC4t; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kB0AwC4t"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TD/QP//0+GRy2z8xmdMp4dHTsVRxCWCO6ndcQAivqWk=;
	b=kB0AwC4tktyxHpzRQgZLmlqvf6OWLLW3w1j2KtLFNGhQavto4HR9DKobiIe2Rd0Upq/wYV
	r9kVnuaDXC8Oe44l6R9lYXdpVQi60L/vy6CIJJfi5QkOBU4zJSlxUUBhJd0UiCY1dZvSl2
	pmSfWeEsu15lcbT/yd4BnpL7Re7YWWo=
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
Subject: [PATCH v4 6/7] smb/client: emulate small mode 0 fallocate ranges at or past EOF
Date: Fri, 26 Jun 2026 21:47:18 +0800
Message-ID: <20260626134719.158270-7-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-1-huiwen.he@linux.dev>
References: <20260626134719.158270-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

The xfstest generic/213 has a mode 0 fallocate case like:

        falloc 0 1G
        falloc 2G 1M
        truncate 3G

The expected layout is:

        allocated [0, 1G)
        hole      [1G, 2G)
        allocated [2G, 2G + 1M)

Current CIFS can pass this test while allocating the intervening hole.
Before this change, the server-side layout was effectively:

        allocated [0, 1G)
        allocated [1G, 2G + 1M)

so [1G, 2G) was allocated as part of the second extent.

Emulate small mode 0 fallocate ranges that start at or past EOF by writing
zeroes only to the requested range.  For off > old_eof, this preserves the
hole between old_eof and off. Keep this emulation limited to 1 MiB so the
client-side I/O cost remains bounded; larger unsupported ranges remain
rejected.

After this change, the same pattern gives the intended layout:

        allocated [0, 1G)
        hole      [1G, 2G)
        allocated [2G, 2G + 1M)

This changes generic/213 from a false pass into a range-correct pass.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 50 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 311709d73798..02ecba985daa 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3693,18 +3693,22 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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
@@ -3714,11 +3718,51 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) {
 			rc = smb2_set_sparse(xid, tcon, cfile, inode, false);
 			if (rc)
-- 
2.43.0

