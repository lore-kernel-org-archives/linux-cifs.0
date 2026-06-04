Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140313264CA
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780586370; cv=none; b=R7k8GDDKUMNk6kfpQvSSYAs45CDipqf/bFZWm5hRFdMst7VQNlFF9pVAlboIwxO+IEonRFRQ9kscaVsAEHD0/7M6HbLO4jNZNI6FOd+vaSOFVzgcBT3P5Drwob94DhXFvTjtHuY+Ht++0Vnyy9IipBgWyyZHUP6fEQ1PFDme6Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780586370; c=relaxed/simple;
	bh=0hHw4FfGlFIXySlLMLvV+VOCckAac2tW+qQwe1BFLwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tOys0wLDpv0HfDH/gyJfhuKyXDQARUNC6O7hUgVRJVjuC0qtEih00pAfYuvczf31z4AVl4uVYnfLH7mqMDYSnHbw2xcIIUSK82V6Z9kSFZ/mdcmGzNKopdYfMwKtG1wUif39Bq8/xnpBkY8VjZ6Tr9L7TAH60V8VlzdsmD4vlL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sXuZBcQz; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sXuZBcQz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780586367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G3K8FswOToNgL0zQ2Q4pMvXu5LbgeyhbCn79wxZ/wAM=;
	b=sXuZBcQzKXPSTk8R1RkKjeMb+0/M4zSNYfIEwp8xV8pwJu6a2oKNLod+NkB7O/prC+pPxc
	7jdVYU8sM2c8C5KwrIa2kQTMRi0h+OA0UkYJBerDwVQRsKdrr9Him2XlibtNwiE6J5CbbP
	0vD1yvW/lrUblqgNlLDzKfqylTGycIs=
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
Subject: [PATCH] smb/client: use writable handle for FS_IOC_SETFLAGS compression
Date: Thu,  4 Jun 2026 23:18:59 +0800
Message-ID: <20260604151859.102653-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Setting the compressed flag on a CIFS mount can fail with -EACCES:

        $ touch test.bin
        $ chattr +c test.bin
        chattr: Permission denied while setting flags on test.bin

This can be reproduced against a Samba share backed by a filesystem that
supports compression, such as btrfs.

FS_IOC_SETFLAGS is issued on the file handle opened by userspace.  chattr
opens the target read-only before setting FS_COMPR_FL, so the SMB client
currently sends FSCTL_SET_COMPRESSION on a handle that may not have
FILE_WRITE_DATA access.  Samba requires FILE_WRITE_DATA for
FSCTL_SET_COMPRESSION and rejects the request.

Use the current handle only if it already has FILE_WRITE_DATA.  Otherwise
try an existing writable handle for the inode.  If none is available, open
a temporary FILE_WRITE_DATA handle for the compression request.

After FSCTL_SET_COMPRESSION succeeds, update the cached compressed
attribute immediately, matching how smb2_set_sparse() updates
FILE_ATTRIBUTE_SPARSE_FILE after a successful FSCTL_SET_SPARSE.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/ioctl.c | 73 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 17408bb8ab65..9afc43ac2bde 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -67,6 +67,72 @@ static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 	return rc;
 }
 
+static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
+				      struct cifs_tcon *tcon,
+				      struct cifsFileInfo *cfile)
+{
+	struct inode *inode = file_inode(filep);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_open_parms oparms;
+	struct cifsFileInfo *wfile;
+	struct cifsFileInfo tmp_cfile = {};
+	struct cifs_tcon *wtcon;
+	struct cifs_fid fid = {};
+	const char *full_path;
+	__u32 oplock = 0;
+	void *page;
+	int rc;
+
+	if (!server->ops->set_compression)
+		return -EOPNOTSUPP;
+
+	if (cfile && (cfile->fid.access & FILE_WRITE_DATA)) {
+		rc = server->ops->set_compression(xid, tcon, cfile);
+		if (rc != -EACCES)
+			return rc;
+	}
+
+	rc = cifs_get_writable_file(CIFS_I(inode), FIND_FSUID_ONLY, &wfile);
+	if (!rc) {
+		wtcon = tlink_tcon(wfile->tlink);
+		if (wtcon->ses->server->ops->set_compression)
+			rc = wtcon->ses->server->ops->set_compression(xid,
+									  wtcon, wfile);
+		else
+			rc = -EOPNOTSUPP;
+		cifsFileInfo_put(wfile);
+		if (rc != -EACCES)
+			return rc;
+	}
+
+	if (!server->ops->open || !server->ops->close)
+		return -EOPNOTSUPP;
+
+	page = alloc_dentry_path();
+	full_path = build_path_from_dentry(filep->f_path.dentry, page);
+	if (IS_ERR(full_path)) {
+		free_dentry_path(page);
+		return PTR_ERR(full_path);
+	}
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA,
+			     FILE_OPEN, 0, ACL_NO_MODE);
+	oparms.fid = &fid;
+
+	rc = server->ops->open(xid, &oparms, &oplock, NULL);
+	if (rc)
+		goto out;
+
+	tmp_cfile.fid = fid;
+	rc = server->ops->set_compression(xid, tcon, &tmp_cfile);
+
+	server->ops->close(xid, tcon, &fid);
+out:
+	free_dentry_path(page);
+	return rc;
+}
+
 static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd)
 {
@@ -427,8 +493,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 			/* Try to set compress flag */
 			if (tcon->ses->server->ops->set_compression) {
-				rc = tcon->ses->server->ops->set_compression(
-							xid, tcon, pSMBFile);
+				rc = cifs_ioctl_set_compression(xid, filep, tcon,
+								pSMBFile);
+				if (rc == 0)
+					CIFS_I(inode)->cifsAttrs |=
+						FILE_ATTRIBUTE_COMPRESSED;
 				cifs_dbg(FYI, "set compress flag rc %d\n", rc);
 			}
 			break;
-- 
2.43.0

