Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB2312FF62
	for <linux-cifs@vger.kernel.org>; Tue,  9 Apr 2024 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712672950; cv=pass; b=KKMMEBSDHKHiGyuAUETPzOr9+9CR0mE6BegVpwjmEP/rQGoXeHzWI4eYDGPhby95jbBB028y7r1Z3MsRGPJQJ2Tsi7DOIA9VEfv7X6CGyFpnVITCZ1AXt/SqiqthD+31Sf+Os4lw7EGw32SkbXnpdt1GpPPsTeItm4M/3x4EAvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712672950; c=relaxed/simple;
	bh=PzSyAR620HXOq297gAooeDDK3W0rlu20e6CMzVBsxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hSKWlhgnDX0KCDSlcX/sRn0JCtQkxUPMq8g+f9Skidj3xB880kSZsHgFhkQIFVfVD3jzmWu5SnAuie2w9It1yNsXyNZirGBT7WmwQ0W+jtnbDDE1nO6HclwEnUfGp6K0H1BbOYO04f1UQFCjQVnszqQj7xHIflnPaGI68qyxN+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=WyGmd5aG; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="WyGmd5aG"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712672946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ADGB5S2QSyr2y5bm7Qi3dPQx7D0Q0NyDbwJxpoAexvU=;
	b=WyGmd5aGGRwu0h1K2ScDC40/wsdutH7XEXSA/rKYv/TZPwVg0YcdyJQGUL4cheJIMm99wv
	2WComfowhohhHd/Vs7Jda/xPn87Z9vlfM4sfD7G4tOxoFrhBe/gNOJ1EIOGBwMZi4vtzYc
	GnjBZHj/6o+pVcjoGETMQrb9vCgPW2n/aXTheQT5akIvH6JOFfIGJ8GZE0lS8PZfhhR27U
	Y/dFXcvwzoCm8F/XFjnVTeZvasLSr9m1dEMz/edx6gLi3v0FHuFXHD8rip4BEUzadPyab0
	WagAwAovGUCl7QvPUBFgtFbA09I4/3GB3t/A1y1BXSCXlJdmcCYulkmBhztIEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712672946; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ADGB5S2QSyr2y5bm7Qi3dPQx7D0Q0NyDbwJxpoAexvU=;
	b=mbhow2ZQK8V0cG9FqALJ4TveigWmJDndY9exxxrBB+ihG1bFjcu2QwI2FTDezmWAlxFTKI
	XKXpgG052TRW+2eiOpFdA7sJExRkIEAPqdzgU8tiJlibrTiUJLghfliV/zCKhuIGmpx6P3
	JlLsPY78nNAz0ioIW7tppoGia0IwJqfGl5fBAVWdqlatMBFWDa7r47dEfVpQNiiTUlrqE9
	75Nyj+I7yMt2e/ug/wGF6pISmbUByqziw50tadIewBs/QKBCat4MdPtvjBqIzausXN0Ik7
	+zNxgZXWkeI+k2zvLr9EyBUPt+8/xKSU84JcfQC6AFhbuGMuovuqmG3rvGUDDQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712672946; a=rsa-sha256;
	cv=none;
	b=h18v+2lkpa7wrriFd0TUzgyldL2/2iepVQhVWcQFfCpT2z0HJVnIYmwxYuzisdEd12jjUP
	5yv8Fmle2DfXagpVjSIjGH18rZzRoYakHehjM3aU/nFQudYqGwEjUIS9ubTbl4n+t3wpWP
	ZEAtJ2ZdJm/uSF2WZiVN+gBVGV04rxsogNIF9j+PWdyjjY2CLHZ6p7lH6U0aTe054UQjj/
	B18yhV7BbQMZc3SFA3qZIxtCGOizHEJVNg622/tdYGBSzGqJU30SvmKvaTX2Wwgzbcnkwo
	jdTFn7kVjxY2YBRKmduR8IDDasgW2ArZ7xyzAc2nvPRau1bQxp6cratmfrNkkQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	roberto.sassu@huawei.com,
	viro@zeniv.linux.org.uk,
	torvalds@linux-foundation.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: instantiate when creating SFU files
Date: Tue,  9 Apr 2024 11:28:59 -0300
Message-ID: <20240409142859.789709-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cifs_sfu_make_node(), on success, instantiate rather than leave it
with dentry unhashed negative to support callers that expect mknod(2)
to always instantiate.

Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" mount option")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 94 ++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 39 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b156eefa75d7..78c94d0350fe 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4964,68 +4964,84 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
 	return 0;
 }
 
-int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
-		       struct dentry *dentry, struct cifs_tcon *tcon,
-		       const char *full_path, umode_t mode, dev_t dev)
+static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+				struct dentry *dentry, struct cifs_tcon *tcon,
+				const char *full_path, umode_t mode, dev_t dev)
 {
-	struct cifs_open_info_data buf = {};
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
 	unsigned int bytes_written;
-	struct win_dev *pdev;
+	struct win_dev pdev = {};
 	struct kvec iov[2];
 	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
 	int rc;
 
-	if (!S_ISCHR(mode) && !S_ISBLK(mode) && !S_ISFIFO(mode))
+	switch (mode & S_IFMT) {
+	case S_IFCHR:
+		strscpy(pdev.type, "IntxCHR");
+		pdev.major = cpu_to_le64(MAJOR(dev));
+		pdev.minor = cpu_to_le64(MINOR(dev));
+		break;
+	case S_IFBLK:
+		strscpy(pdev.type, "IntxBLK");
+		pdev.major = cpu_to_le64(MAJOR(dev));
+		pdev.minor = cpu_to_le64(MINOR(dev));
+		break;
+	case S_IFIFO:
+		strscpy(pdev.type, "LnxFIFO");
+		break;
+	default:
 		return -EPERM;
+	}
 
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
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
+			     FILE_CREATE, CREATE_NOT_DIR |
+			     CREATE_OPTION_SPECIAL, ACL_NO_MODE);
+	oparms.fid = &fid;
 
-	rc = server->ops->open(xid, &oparms, &oplock, &buf);
+	rc = server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-	/*
-	 * BB Do not bother to decode buf since no local inode yet to put
-	 * timestamps in, but we can reuse it safely.
-	 */
-	pdev = (struct win_dev *)&buf.fi;
 	io_parms.pid = current->tgid;
 	io_parms.tcon = tcon;
-	io_parms.length = sizeof(*pdev);
-	iov[1].iov_base = pdev;
-	iov[1].iov_len = sizeof(*pdev);
-	if (S_ISCHR(mode)) {
-		memcpy(pdev->type, "IntxCHR", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-	} else if (S_ISBLK(mode)) {
-		memcpy(pdev->type, "IntxBLK", 8);
-		pdev->major = cpu_to_le64(MAJOR(dev));
-		pdev->minor = cpu_to_le64(MINOR(dev));
-	} else if (S_ISFIFO(mode)) {
-		memcpy(pdev->type, "LnxFIFO", 8);
-	}
+	io_parms.length = sizeof(pdev);
+	iov[1].iov_base = &pdev;
+	iov[1].iov_len = sizeof(pdev);
 
 	rc = server->ops->sync_write(xid, &fid, &io_parms,
 				     &bytes_written, iov, 1);
 	server->ops->close(xid, tcon, &fid);
-	d_drop(dentry);
-	/* FIXME: add code here to set EAs */
-	cifs_free_open_info(&buf);
+	return rc;
+}
+
+int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+		       struct dentry *dentry, struct cifs_tcon *tcon,
+		       const char *full_path, umode_t mode, dev_t dev)
+{
+	struct inode *new = NULL;
+	int rc;
+
+	rc = __cifs_sfu_make_node(xid, inode, dentry, tcon,
+				  full_path, mode, dev);
+	if (rc)
+		return rc;
+
+	if (tcon->posix_extensions) {
+		rc = smb311_posix_get_inode_info(&new, full_path, NULL,
+						 inode->i_sb, xid);
+	} else if (tcon->unix_ext) {
+		rc = cifs_get_inode_info_unix(&new, full_path,
+					      inode->i_sb, xid);
+	} else {
+		rc = cifs_get_inode_info(&new, full_path, NULL,
+					 inode->i_sb, xid, NULL);
+	}
+	if (!rc)
+		d_instantiate(dentry, new);
 	return rc;
 }
 
-- 
2.44.0

