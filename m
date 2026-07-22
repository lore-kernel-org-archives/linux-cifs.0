Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AED48C3E4
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710477; cv=none; b=XfmFqrRzCe5NyElOFgpD/+owIM5rjXAZerYJai52GJdbkz3ypTGcXanOAhu0Zq7K3Wan8J7edbWlx2EYDMQ+sxHBy7IXRxRxhIKIJrdf6pMzInK4VTyBQRX2LPfYF7RA+3DF1a9UJQtLM7VRiPgkII0P6aVHX0zMUzdNqjQjbNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710477; c=relaxed/simple;
	bh=PqCZKCoG+wkGLabvL7ZmVHD4darNh8gXYXMPI0q2wCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXAbA7tMmyj8XcXA1ycdhSniYBCdkslkPowLOlQp/tATxeEXioXlAZ1V1GGI9HHBgdQS1BKOca2YPToJQpKW6uDGzxiMmP2dHDq0WF+i4idFz51L3ZB24bgVu9iTDTklYXX/YstNPxm8StqSuBvXi482EqCc1A1wLXCXWy3hfOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dnv4mgTa; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dnv4mgTa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784710472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fcXxW7fxjLZiUzBiMzlfHXZGtMtQw6KnKnAvHLofAFo=;
	b=Dnv4mgTa3RwgbVVRbjnhtZAW3TJ5t0oC2xEOYJL9MxNjiPVpBaKixDpF3ARhU5pJk47p+X
	H6lV4AvaKtDyQSLnodA0DGGI+dQ/H0Dv7/f4hTrdecgEDiU8P2q4VVNtp6whz74d9le50O
	+7AWqe+2CZmHYbJPRWiNTYGeqjNWbcs=
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
Subject: [PATCH 2/2] smb/client: remove unused file flags ioctl handlers
Date: Wed, 22 Jul 2026 16:53:33 +0800
Message-ID: <20260722085333.86217-3-huiwen.he@linux.dev>
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

FS_IOC_GETFLAGS and FS_IOC_SETFLAGS are now handled by the generic VFS
fileattr path, so their cifs_ioctl() handlers are unreachable. Remove
the handlers and associated state.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c |  2 +-
 fs/smb/client/ioctl.c  | 82 ------------------------------------------
 2 files changed, 1 insertion(+), 83 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 0a1135602697..603b177f1b09 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1194,7 +1194,7 @@ int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	struct inode *inode = d_inode(dentry);
 	u32 attrs;
 
-	/* Preserve FS_COMPR_FL previously reported by cifs_ioctl(). */
+	/* Report the cached SMB compressed attribute as FS_COMPR_FL. */
 	if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
 		fa->flags |= FS_COMPR_FL;
 
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 8b2ca0c7c06c..1279e215ecd2 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -528,14 +528,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
-	__u64	ExtAttrBits = 0;
-	bool enable_compression;
-	__u16 compression_state;
-#ifdef CONFIG_CIFS_POSIX
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	__u64   caps;
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-#endif /* CONFIG_CIFS_POSIX */
 
 	xid = get_xid();
 
@@ -546,80 +538,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 		trace_smb3_ioctl(xid, pSMBFile->fid.persistent_fid, command);
 
 	switch (command) {
-		case FS_IOC_GETFLAGS:
-			if (pSMBFile == NULL)
-				break;
-			tcon = tlink_tcon(pSMBFile->tlink);
-#ifdef CONFIG_CIFS_POSIX
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
-			if (CIFS_UNIX_EXTATTR_CAP & caps) {
-				__u64	ExtAttrMask = 0;
-				rc = CIFSGetExtAttr(xid, tcon,
-						    pSMBFile->fid.netfid,
-						    &ExtAttrBits, &ExtAttrMask);
-				if (rc == 0)
-					rc = put_user(ExtAttrBits &
-						FS_FL_USER_VISIBLE,
-						(int __user *)arg);
-				if (rc != -EOPNOTSUPP)
-					break;
-			}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-#endif /* CONFIG_CIFS_POSIX */
-			if (CIFS_I(inode)->cifsAttrs & FILE_ATTRIBUTE_COMPRESSED)
-				ExtAttrBits |= FS_COMPR_FL;
-
-			rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
-				      (int __user *)arg);
-			break;
-		case FS_IOC_SETFLAGS:
-			if (pSMBFile == NULL)
-				break;
-			tcon = tlink_tcon(pSMBFile->tlink);
-			/* caps = le64_to_cpu(tcon->fsUnixInfo.Capability); */
-
-			if (get_user(ExtAttrBits, (int __user *)arg)) {
-				rc = -EFAULT;
-				break;
-			}
-
-			/*
-			 * if (CIFS_UNIX_EXTATTR_CAP & caps)
-			 *	rc = CIFSSetExtAttr(xid, tcon,
-			 *		       pSMBFile->fid.netfid,
-			 *		       extAttrBits,
-			 *		       &ExtAttrMask);
-			 * if (rc != -EOPNOTSUPP)
-			 *	break;
-			 */
-
-			/* Currently only flag we can set or clear is compressed. */
-			if (ExtAttrBits & ~FS_COMPR_FL) {
-				rc = -EOPNOTSUPP;
-				break;
-			}
-
-			enable_compression = ExtAttrBits & FS_COMPR_FL;
-			compression_state = enable_compression ?
-				COMPRESSION_FORMAT_DEFAULT :
-				COMPRESSION_FORMAT_NONE;
-
-			rc = cifs_set_compression(xid, filep->f_path.dentry,
-						  tcon, pSMBFile,
-						  compression_state);
-			if (rc == 0) {
-				spin_lock(&inode->i_lock);
-				if (enable_compression)
-					CIFS_I(inode)->cifsAttrs |=
-						FILE_ATTRIBUTE_COMPRESSED;
-				else
-					CIFS_I(inode)->cifsAttrs &=
-						~FILE_ATTRIBUTE_COMPRESSED;
-				spin_unlock(&inode->i_lock);
-			}
-			cifs_dbg(FYI, "set compress flag rc %d\n", rc);
-			break;
 		case CIFS_IOC_COPYCHUNK_FILE:
 			rc = cifs_ioctl_copychunk(xid, filep, arg);
 			break;
-- 
2.43.0

