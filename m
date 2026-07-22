Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE303E3C74
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 08:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710474; cv=none; b=SR0lZMNouw2FfqACl1MxBxLDuYI3eCPCh4Ew8bb/KC8fxNXDWw3maRuhO2aCrQnVR5HQTKXtASe9+ZnBOyQb9IQ8c4GM93LpCJro5SP1JZ8P/e1IPEa80Wwd8rn6ussSJ6qXp2MGQzj9q1IGhvwzNoMtnghMnyLFR0BHWduUe3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710474; c=relaxed/simple;
	bh=Z8iOsxx9ozYxSO0fzsphTgnl+xEF0AtKlRwiu7GVpjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvVSh973SN0HhWbEIV2PqqFFPnTSvEEmQEoQbwyIpbZJPXyKYXAlMI3aJGq/8erqtRbdKpGErTkcBdtl8QUPDPS9cjDaTlgyOf1Jk/vs5tcmozD6D+R8pjpM/+ErP0irkMFIenJiCjJbFWP7UTJyrzabI/gPZU66L3M/22B3D0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nkuDlR3q; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nkuDlR3q"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784710468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehZPG50oGlTnBdfgmS1WKk/VTGlUqyEbIHtZE3Htj/U=;
	b=nkuDlR3qYjXtdlppmXpU9MS5jfwoJigZTH9pUZ050UZoVXRDB5XKv7g9+QmfBJh7CoJIRO
	ufwMmVIQHzFRvsNDyFkDrI/JMRYVvGJI/JtQPHWElFb3VVqZLQyp1pcCkKaYUKwysXFiwK
	4+5130zM8meW81oBs0NYEtQOwal3LDg=
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
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 1/2] smb/client: implement fileattr_set for compression flags
Date: Wed, 22 Jul 2026 16:53:32 +0800
Message-ID: <20260722085333.86217-2-huiwen.he@linux.dev>
In-Reply-To: <20260722085333.86217-1-huiwen.he@linux.dev>
References: <20260722085333.86217-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

CIFS handles FS_IOC_SETFLAGS in cifs_ioctl() because it does not
implement ->fileattr_set. This causes the request to fall back from the
generic fileattr path and bypass its permission and serialization checks.

Implement ->fileattr_set for regular files and directories and use the
existing compression helper for FS_COMPR_FL. Accept an unchanged
FS_CASEFOLD_FL reported by fileattr_get so chattr can update compression
on case-insensitive shares.

Tested chattr +c and -c on files and directories against Samba. Non-owner
and read-only mount requests were rejected by the VFS checks.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c |  4 +-
 fs/smb/client/cifsfs.h |  2 +
 fs/smb/client/ioctl.c  | 89 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 81 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 66b9104e7ca2..0a1135602697 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1195,7 +1195,7 @@ int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	u32 attrs;
 
 	/* Preserve FS_COMPR_FL previously reported by cifs_ioctl(). */
-	if (CIFS_I(inode)->cifsAttrs & ATTR_COMPRESSED)
+	if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
 		fa->flags |= FS_COMPR_FL;
 
 	/*
@@ -1256,6 +1256,7 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.get_acl = cifs_get_acl,
 	.set_acl = cifs_set_acl,
 	.fileattr_get = cifs_fileattr_get,
+	.fileattr_set = cifs_fileattr_set,
 };
 
 const struct inode_operations cifs_file_inode_ops = {
@@ -1267,6 +1268,7 @@ const struct inode_operations cifs_file_inode_ops = {
 	.get_acl = cifs_get_acl,
 	.set_acl = cifs_set_acl,
 	.fileattr_get = cifs_fileattr_get,
+	.fileattr_set = cifs_fileattr_set,
 };
 
 const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 854e672a4e37..10dcf51378d3 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -91,6 +91,8 @@ extern const struct inode_operations cifs_namespace_inode_operations;
 
 struct file_kattr;
 int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
+int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
+		      struct file_kattr *fa);
 
 
 /* Functions related to files and directories */
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 9fa743be3652..8b2ca0c7c06c 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -10,6 +10,7 @@
 
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/fileattr.h>
 #include <linux/mount.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -67,11 +68,11 @@ static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 	return rc;
 }
 
-static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
+static int cifs_set_compression_by_path(unsigned int xid, struct dentry *dentry,
 					struct cifs_tcon *tcon,
 					__u16 compression_state)
 {
-	struct inode *inode = file_inode(filep);
+	struct inode *inode = d_inode(dentry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
@@ -92,11 +93,11 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 	    cifs_sb->mnt_cifs_serverino_autodisabled)
 		return -EOPNOTSUPP;
 
-	if (d_unhashed(filep->f_path.dentry))
+	if (d_unhashed(dentry))
 		return -ESTALE;
 
 	page = alloc_dentry_path();
-	full_path = build_path_from_dentry(filep->f_path.dentry, page);
+	full_path = build_path_from_dentry(dentry, page);
 	if (IS_ERR(full_path)) {
 		free_dentry_path(page);
 		return PTR_ERR(full_path);
@@ -123,6 +124,10 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 		goto close;
 
 	uniqueid = le64_to_cpu(data.fi.IndexNumber);
+	if (!uniqueid) {
+		rc = -EOPNOTSUPP;
+		goto close;
+	}
 	if (uniqueid != CIFS_I(inode)->uniqueid) {
 		rc = -ESTALE;
 		goto close;
@@ -141,14 +146,14 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 	return rc;
 }
 
-static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
-				      struct cifs_tcon *tcon,
-				      struct cifsFileInfo *cfile,
-				      __u16 compression_state)
+static int cifs_set_compression(unsigned int xid, struct dentry *dentry,
+				struct cifs_tcon *tcon,
+				struct cifsFileInfo *cfile,
+				__u16 compression_state)
 {
 	struct cifsFileInfo *wfile;
 	struct cifs_tcon *wtcon;
-	struct inode *inode = file_inode(filep);
+	struct inode *inode = d_inode(dentry);
 	int rc;
 
 	if (!tcon->ses->server->ops->set_compression)
@@ -173,10 +178,68 @@ static int cifs_ioctl_set_compression(unsigned int xid, struct file *filep,
 		return rc;
 	}
 
-	return cifs_set_compression_by_path(xid, filep, tcon,
+	return cifs_set_compression_by_path(xid, dentry, tcon,
 					    compression_state);
 }
 
+int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
+		      struct file_kattr *fa)
+{
+	struct inode *inode = d_inode(dentry);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct file_kattr current_fa = {};
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	__u16 compression_state;
+	bool enable_compression;
+	u32 allowed = FS_COMPR_FL;
+	unsigned int xid;
+	int rc;
+
+	if (!fa->flags_valid)
+		return -EOPNOTSUPP;
+
+	/*
+	 * chattr writes back all flags returned by fileattr_get(). Accept
+	 * FS_CASEFOLD_FL only when it reflects the share's casefold state.
+	 */
+	if (fa->flags & FS_CASEFOLD_FL) {
+		rc = cifs_fileattr_get(dentry, &current_fa);
+		if (rc)
+			return rc;
+		if (current_fa.flags & FS_CASEFOLD_FL)
+			allowed |= FS_CASEFOLD_FL;
+	}
+	if (fa->flags & ~allowed)
+		return -EOPNOTSUPP;
+
+	enable_compression = fa->flags & FS_COMPR_FL;
+	compression_state = enable_compression ? COMPRESSION_FORMAT_DEFAULT :
+						 COMPRESSION_FORMAT_NONE;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+
+	xid = get_xid();
+	rc = cifs_set_compression(xid, dentry, tcon, NULL, compression_state);
+	free_xid(xid);
+	cifs_put_tlink(tlink);
+
+	if (!rc) {
+		spin_lock(&inode->i_lock);
+		if (enable_compression)
+			CIFS_I(inode)->cifsAttrs |= FILE_ATTRIBUTE_COMPRESSED;
+		else
+			CIFS_I(inode)->cifsAttrs &= ~FILE_ATTRIBUTE_COMPRESSED;
+		spin_unlock(&inode->i_lock);
+	}
+
+	cifs_dbg(FYI, "set compress flag rc %d\n", rc);
+	return rc;
+}
+
 static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
 			unsigned long srcfd)
 {
@@ -542,9 +605,9 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				COMPRESSION_FORMAT_DEFAULT :
 				COMPRESSION_FORMAT_NONE;
 
-			rc = cifs_ioctl_set_compression(xid, filep, tcon,
-						pSMBFile,
-						compression_state);
+			rc = cifs_set_compression(xid, filep->f_path.dentry,
+						  tcon, pSMBFile,
+						  compression_state);
 			if (rc == 0) {
 				spin_lock(&inode->i_lock);
 				if (enable_compression)
-- 
2.43.0

