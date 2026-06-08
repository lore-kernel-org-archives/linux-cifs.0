Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940ED31E82F
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934335; cv=none; b=bG3bBGwo/NVTvf3yT4hcVUdMY6OZNwZpz4MRk6/GF9zrHIQwKFpP7EUagZ7hVPI+VcqnTKwpuqCOZ/j4uBWQ+HKaC92Ulqd91qRszYRpgFAVYX1FUwSyBy/DQdWJGEsmrtbV+MKq2czSWWL7SyGCzwVC9HYbUzFOugSgb0Zewac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934335; c=relaxed/simple;
	bh=2ra+E//v/sUC9Q5Kwmwy84yveagtJuUgyXzW2ZhBMxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKPy07GjaHrlmS/Ld6mV4yGFalddfUnDPNx/Law5Z9rUu5i0WCXGeLccW26MQJYsqfjm1tuNDc4vWH1DlUsTq21hhH0zVgdsJI0L1izo0LUhDL37nR5O2oz94Vo8xIOrs/Lz/inZ36S3Y7cb32qoJTOVANfEkTGboLczkBgEn1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BxlK2kRt; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BxlK2kRt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NqrW0uV18zKy/D7CkrwNVQJrhUmzfCPyruidCOs6y8k=;
	b=BxlK2kRtrf3NwwrIrFZ6PoOML8LFGuP+YjMewx3h62SfNibnwueEOnj+w6ehL0dnvZGAfb
	KWc23XBdLLPFlHPl/mpn2HL4/rwdxeSxEHpuzqPl3i1yiGM9pXz+9ZsVcuMAAimZwPvDI8
	YBuMAmDIB7jWZeYF5kRulo0QcFucMDs=
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
Subject: [PATCH v2 2/3] smb/client: use writable handle for FS_IOC_SETFLAGS compression
Date: Mon,  8 Jun 2026 23:57:30 +0800
Message-ID: <20260608155731.634984-3-huiwen.he@linux.dev>
In-Reply-To: <20260608155731.634984-1-huiwen.he@linux.dev>
References: <20260608155731.634984-1-huiwen.he@linux.dev>
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

	[compress_share]
		vfs objects = btrfs

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
 fs/smb/client/ioctl.c | 116 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 112 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 746d70091f3d..886e6893a552 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -67,6 +67,110 @@ static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 	return rc;
 }
 
+static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
+					struct cifs_tcon *tcon)
+{
+	struct inode *inode = file_inode(filep);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_open_parms oparms;
+	struct cifs_open_info_data data = {};
+	struct cifsFileInfo *tmp_cfile = NULL;
+	struct cifs_fid fid = {};
+	const char *full_path;
+	__u32 oplock = 0;
+	u64 uniqueid;
+	void *page;
+	int rc;
+
+	if (!server->ops->open || !server->ops->close ||
+	    !server->ops->query_file_info)
+		return -EOPNOTSUPP;
+
+	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM) ||
+	    cifs_sb->mnt_cifs_serverino_autodisabled)
+		return -EOPNOTSUPP;
+
+	if (d_unhashed(filep->f_path.dentry))
+		return -ESTALE;
+
+	page = alloc_dentry_path();
+	full_path = build_path_from_dentry(filep->f_path.dentry, page);
+	if (IS_ERR(full_path)) {
+		free_dentry_path(page);
+		return PTR_ERR(full_path);
+	}
+
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_WRITE_DATA |
+			     FILE_READ_ATTRIBUTES,
+			     FILE_OPEN, 0, ACL_NO_MODE);
+	oparms.fid = &fid;
+
+	rc = server->ops->open(xid, &oparms, &oplock, NULL);
+	if (rc)
+		goto out;
+
+	tmp_cfile = kzalloc_obj(*tmp_cfile);
+	if (!tmp_cfile) {
+		rc = -ENOMEM;
+		goto close;
+	}
+
+	tmp_cfile->fid = fid;
+	rc = server->ops->query_file_info(xid, tcon, tmp_cfile, &data);
+	if (rc)
+		goto close;
+
+	uniqueid = le64_to_cpu(data.fi.IndexNumber);
+	if (uniqueid != CIFS_I(inode)->uniqueid) {
+		rc = -ESTALE;
+		goto close;
+	}
+
+	rc = server->ops->set_compression(xid, tcon, tmp_cfile);
+
+close:
+	server->ops->close(xid, tcon, &fid);
+	if (tmp_cfile)
+		kfree(tmp_cfile);
+	cifs_free_open_info(&data);
+out:
+	free_dentry_path(page);
+	return rc;
+}
+
+static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
+				      struct cifs_tcon *tcon,
+				      struct cifsFileInfo *cfile)
+{
+	struct cifsFileInfo *wfile;
+	struct cifs_tcon *wtcon;
+	struct inode *inode = file_inode(filep);
+	int rc;
+
+	if (!tcon->ses->server->ops->set_compression)
+		return -EOPNOTSUPP;
+
+	if (cfile && (cfile->fid.access & FILE_WRITE_DATA)) {
+		rc = tcon->ses->server->ops->set_compression(xid, tcon, cfile);
+		if (rc != -EACCES)
+			return rc;
+	}
+
+	rc = cifs_get_writable_file(CIFS_I(inode), FIND_FSUID_ONLY, &wfile);
+	if (!rc) {
+		wtcon = tlink_tcon(wfile->tlink);
+		rc = wtcon->ses->server->ops->set_compression(xid, wtcon, wfile);
+		cifsFileInfo_put(wfile);
+		if (rc != -EACCES)
+			return rc;
+	} else if (rc != -EBADF) {
+		return rc;
+	}
+
+	return cifs_set_compression_by_path(xid, filep, tcon);
+}
+
 static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd)
 {
@@ -424,11 +528,15 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				break;
 
 			/* Try to set compress flag */
-			if (tcon->ses->server->ops->set_compression) {
-				rc = tcon->ses->server->ops->set_compression(
-							xid, tcon, pSMBFile);
-				cifs_dbg(FYI, "set compress flag rc %d\n", rc);
+			rc = cifs_ioctl_set_compression(xid, filep, tcon,
+							pSMBFile);
+			if (rc == 0) {
+				spin_lock(&inode->i_lock);
+				CIFS_I(inode)->cifsAttrs |=
+					FILE_ATTRIBUTE_COMPRESSED;
+				spin_unlock(&inode->i_lock);
 			}
+			cifs_dbg(FYI, "set compress flag rc %d\n", rc);
 			break;
 		case CIFS_IOC_COPYCHUNK_FILE:
 			rc = cifs_ioctl_copychunk(xid, filep, arg);
-- 
2.43.0

