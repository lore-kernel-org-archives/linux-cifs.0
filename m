Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F154F39B97E
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403454; cv=none; b=JKFje0CrjC/Pzw4EKcO4cU66WpzkF8HCNHzfYeivrtLSjp7yQnqp33G4jtPicyQKEByq/vBL2h9Y7UKvlfGtamQbj0QVQVxEz/uw0dd8WJAnmWW0oQP0d/fmdamjzn+efeU9VxAK86kdYsNQxfQk11jpF4h5bWQwRdzOsSlOVyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403454; c=relaxed/simple;
	bh=spQVkS3ia7CsXNYmHiGMKnJFZCmF3bTDeBwe1iWv8Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I21WvHzupJa71AuDxwj25mOOXmJPdHY7KfdR3fEUshVswwQ534miyMS8N1/gf2e0g9RE4aGvM3kTyO4BDt+cdecCY0gCPBNVnKmB2S5u1qqa4DCiSP3x3cJvkyLGyuu2AWIHPYOrGJEJluVnJ5ZYJ1+gDjnYcJFCoxCF+kewE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cAKBi3R9; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cAKBi3R9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782403444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ncd3ryR3cliVVEBskSPqr/trcvDmSU6zB9AkdisaL4M=;
	b=cAKBi3R98wfnU6AKX4jgtsIhFTEtMXnXRgUxQG15vm/Q+fejhDNU1/7zZQPBO1QM6qx9Rb
	Wnd2ejB4psugczqlPQSBIH24n15UGi894nGUv91irOCiPWS36mE6l5ystj3g0kLb+dM74r
	M6IBeTIKJl1SH+tHbhZyYURp/M2RlX4=
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
Subject: [PATCH v3 8/9] smb/client: emulate small mode 0 fallocate ranges at or past EOF
Date: Fri, 26 Jun 2026 00:01:53 +0800
Message-ID: <20260625160154.104450-9-huiwen.he@linux.dev>
In-Reply-To: <20260625160154.104450-1-huiwen.he@linux.dev>
References: <20260625160154.104450-1-huiwen.he@linux.dev>
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
index 5f2e4a0722a6..73a80671a584 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3677,18 +3677,22 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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
@@ -3698,11 +3702,51 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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

