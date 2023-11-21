Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="kU86hta3"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C110C
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 15:13:13 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cgXWkr7PijOXDnKD4ry6zjOo+2LuHkJbHf01mFqwVp8=;
	b=kU86hta3brWbvSgadfUwNjEHh/GPNMM3/kPbkjnOWgdEhzThtuYqhBykZ2QZPkvuMD4640
	KuIccsY+ypJb7eGCwMjVliJyIcMj7+RD9whE4J28nPgONo/rZIE6dz4lfzqmQIGKiTGM/M
	+KvPJz7Lz783JtmY/ELQavN/ML+DSaplh3OKmKZ1Mkgw2TL9A+i9j8ylorwn+9tn54z537
	gFL/izaCOTpcayZVm+QuP97s6KIHcdutvGanMqzkxS8HhSqB9ReWqITvHpUQKbsuGRw7CJ
	kT81w56FZxecBbzpEzCV2m3LDOxsQCFXeOtJk+a072/D0Fo8FuRo0YvZJzEXsw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700608391; a=rsa-sha256;
	cv=none;
	b=LeMA5/3Jxrr3AwnXqBCuBpT53FFuVk7SgSVTSQUQ4dnS7xo3K1ZIwdfk/NS5Lp75KcC4XS
	BzX3ynBZwF1qmBxL2k45wWQm2XLmOgT94dwiLxVbvityr/Su8YNj2myc+kS+a4uLnX3kro
	qpL68o5VFQUncEba8FBH16CoYoFhD+00KzZxjCD1nYUKRSozE+u9UFstAQ++enQ+YY9v5Z
	ps/iIw6IVaetsK1V2D8+3A+4kXxM3KZRtz0u8QOSwcIz4QPtlx607WRDgrBuBdRjn+XNDh
	7ZjnyNEyLF9EzpvF3+ICpC+vOkx+cy5rFmxInh0AEYGhtaoSr6QmkluZGhhA8Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608391; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cgXWkr7PijOXDnKD4ry6zjOo+2LuHkJbHf01mFqwVp8=;
	b=k084nqYsAa+o2fqJRlk3+L9yvxaH/Aa9GNzuVS+cjgxDjKPoBrn2m6neYxTrzPp4PenA+x
	W0TC/WX9HsvXPev6LuTwo965aGvdDJpQpwRRzWkfPfW+iK8DNHiG/3/7P/kBkvzQWER9oW
	84IH8BPZRP0iKkawruaYvs6MH8pI1go+ukzSedQtZMsQM2B1LGDafmtVWVV1BLAxnvhBt+
	svm5RZK7Z2El0HHUaTKa/zfKT17ZqSnXgoO+97v7NAu//V8WE3mqXKjhwsXuit8g0SJiaU
	T1weKJgbONqtTmOsmudFB6JiiJCaOSwDoKxP0V3oPACgD8vyzmyOhV4wV+qwvQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/7] smb: client: introduce cifs_sfu_make_node()
Date: Tue, 21 Nov 2023 20:12:55 -0300
Message-ID: <20231121231258.29562-4-pc@manguebit.com>
In-Reply-To: <20231121231258.29562-1-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231121231258.29562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicate code and add new helper for creating special files in
SFU (Services for UNIX) format that can be shared by SMB1+ code.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsproto.h |  3 ++
 fs/smb/client/smb1ops.c   | 80 ++++-------------------------------
 fs/smb/client/smb2ops.c   | 89 ++++++++++++++++++---------------------
 3 files changed, 52 insertions(+), 120 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c00f84420559..46feaa0880bd 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -668,6 +668,9 @@ char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data);
+int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+		       struct dentry *dentry, struct cifs_tcon *tcon,
+		       const char *full_path, umode_t mode, dev_t dev);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 64e25233e85d..a9eaba8083b0 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1041,15 +1041,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct inode *newinode = NULL;
-	int rc = -EPERM;
-	struct cifs_open_info_data buf = {};
-	struct cifs_io_parms io_parms;
-	__u32 oplock = 0;
-	struct cifs_fid fid;
-	struct cifs_open_parms oparms;
-	unsigned int bytes_written;
-	struct win_dev *pdev;
-	struct kvec iov[2];
+	int rc;
 
 	if (tcon->unix_ext) {
 		/*
@@ -1083,74 +1075,18 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 			d_instantiate(dentry, newinode);
 		return rc;
 	}
-
 	/*
-	 * SMB1 SFU emulation: should work with all servers, but only
-	 * support block and char device (no socket & fifo)
+	 * Check if mounted with mount parm 'sfu' mount parm.
+	 * SFU emulation should work with all servers, but only
+	 * supports block and char device (no socket & fifo),
+	 * and was used by default in earlier versions of Windows
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return rc;
-
-	if (!S_ISCHR(mode) && !S_ISBLK(mode))
-		return rc;
-
-	cifs_dbg(FYI, "sfu compat create special file\n");
-
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.cifs_sb = cifs_sb,
-		.desired_access = GENERIC_WRITE,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						      CREATE_OPTION_SPECIAL),
-		.disposition = FILE_CREATE,
-		.path = full_path,
-		.fid = &fid,
-	};
-
-	if (tcon->ses->server->oplocks)
-		oplock = REQ_OPLOCK;
-	else
-		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
-	if (rc)
-		return rc;
-
-	/*
-	 * BB Do not bother to decode buf since no local inode yet to put
-	 * timestamps in, but we can reuse it safely.
-	 */
-
-	pdev = (struct win_dev *)&buf.fi;
-	io_parms.pid = current->tgid;
-	io_parms.tcon = tcon;
-	io_parms.offset = 0;
-	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = &buf.fi;
-	iov[1].iov_len = sizeof(struct win_dev);
-	if (S_ISCHR(mode)) {
-		memcpy(pdev->type, "IntxCHR", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
-	} else if (S_ISBLK(mode)) {
-		memcpy(pdev->type, "IntxBLK", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
-	}
-	tcon->ses->server->ops->close(xid, tcon, &fid);
-	d_drop(dentry);
-
-	/* FIXME: add code here to set EAs */
-
-	cifs_free_open_info(&buf);
-	return rc;
+		return -EPERM;
+	return cifs_sfu_make_node(xid, inode, dentry, tcon,
+				  full_path, mode, dev);
 }
 
-
-
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f01a929a7a3a..82ab62fd0040 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5068,41 +5068,24 @@ smb2_next_header(char *buf)
 	return le32_to_cpu(hdr->NextCommand);
 }
 
-static int
-smb2_make_node(unsigned int xid, struct inode *inode,
-	       struct dentry *dentry, struct cifs_tcon *tcon,
-	       const char *full_path, umode_t mode, dev_t dev)
+int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+		       struct dentry *dentry, struct cifs_tcon *tcon,
+		       const char *full_path, umode_t mode, dev_t dev)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	int rc = -EPERM;
 	struct cifs_open_info_data buf = {};
-	struct cifs_io_parms io_parms = {0};
-	__u32 oplock = 0;
-	struct cifs_fid fid;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cifs_io_parms io_parms = {};
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_fid fid;
 	unsigned int bytes_written;
 	struct win_dev *pdev;
 	struct kvec iov[2];
-
-	/*
-	 * Check if mounted with mount parm 'sfu' mount parm.
-	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
-	 * and was used by default in earlier versions of Windows
-	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return rc;
-
-	/*
-	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
-	 * their current NFS server) uses this approach to expose special files
-	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
-	 */
+	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
+	int rc;
 
 	if (!S_ISCHR(mode) && !S_ISBLK(mode) && !S_ISFIFO(mode))
-		return rc;
-
-	cifs_dbg(FYI, "sfu compat create special file\n");
+		return -EPERM;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -5115,11 +5098,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 		.fid = &fid,
 	};
 
-	if (tcon->ses->server->oplocks)
-		oplock = REQ_OPLOCK;
-	else
-		oplock = 0;
-	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &buf);
+	rc = server->ops->open(xid, &oparms, &oplock, &buf);
 	if (rc)
 		return rc;
 
@@ -5127,42 +5106,56 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	 * BB Do not bother to decode buf since no local inode yet to put
 	 * timestamps in, but we can reuse it safely.
 	 */
-
 	pdev = (struct win_dev *)&buf.fi;
 	io_parms.pid = current->tgid;
 	io_parms.tcon = tcon;
-	io_parms.offset = 0;
-	io_parms.length = sizeof(struct win_dev);
-	iov[1].iov_base = &buf.fi;
-	iov[1].iov_len = sizeof(struct win_dev);
+	io_parms.length = sizeof(*pdev);
+	iov[1].iov_base = pdev;
+	iov[1].iov_len = sizeof(*pdev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
 		pdev->major = cpu_to_le64(MAJOR(dev));
 		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	} else if (S_ISBLK(mode)) {
 		memcpy(pdev->type, "IntxBLK", 8);
 		pdev->major = cpu_to_le64(MAJOR(dev));
 		pdev->minor = cpu_to_le64(MINOR(dev));
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	} else if (S_ISFIFO(mode)) {
 		memcpy(pdev->type, "LnxFIFO", 8);
-		pdev->major = 0;
-		pdev->minor = 0;
-		rc = tcon->ses->server->ops->sync_write(xid, &fid, &io_parms,
-							&bytes_written, iov, 1);
 	}
-	tcon->ses->server->ops->close(xid, tcon, &fid);
+
+	rc = server->ops->sync_write(xid, &fid, &io_parms,
+				     &bytes_written, iov, 1);
+	server->ops->close(xid, tcon, &fid);
 	d_drop(dentry);
-
 	/* FIXME: add code here to set EAs */
-
 	cifs_free_open_info(&buf);
 	return rc;
 }
 
+static int smb2_make_node(unsigned int xid, struct inode *inode,
+			  struct dentry *dentry, struct cifs_tcon *tcon,
+			  const char *full_path, umode_t mode, dev_t dev)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+
+	/*
+	 * Check if mounted with mount parm 'sfu' mount parm.
+	 * SFU emulation should work with all servers, but only
+	 * supports block and char device (no socket & fifo),
+	 * and was used by default in earlier versions of Windows
+	 */
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+		return -EPERM;
+	/*
+	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
+	 * their current NFS server) uses this approach to expose special files
+	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
+	 */
+	return cifs_sfu_make_node(xid, inode, dentry, tcon,
+				  full_path, mode, dev);
+}
+
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
-- 
2.42.1

