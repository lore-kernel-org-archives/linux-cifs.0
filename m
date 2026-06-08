Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C56A3C343E
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927379; cv=none; b=btQUujf4iKWXxc67FpSbscNcdoinGuv+XRUmJg9JaJNXvzLBAiQVMbBFIEJCBZx3BZg2JZV9P5f3jJmIhjzYl+Tz5wEkNfBxCU6XWrULmxmQUAhe57J0BxJU1dmZJ3Vpen2rzgwwDLfV4XE9XT4rXrAacDmFEq+vgJPrmZY3VTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927379; c=relaxed/simple;
	bh=W8ij1twbMTSVQqI/UxPzQN0ypyeen7cWvcqHFsndvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0/eiakZjJqWwVC/X2EdUkrTuxPAETV2KbOBvwVkaJhWcIvr4l4DirG3lfyrKrQGrumuvZ41iqconANUmlfmKeR08k/YgOmy+mzfCkJ76nn1JSXjlNR/LNKVz50e+y3GDOilPyDa2ABhgeubFK+BEnumBRjxy0BWxPXzmY288So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=uYwybWjZ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="uYwybWjZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1mdLQFOckAY8bRNq2TVc8QSLXw1/qrjZexMr5nsbP0=;
	b=uYwybWjZlMuSOGTiOVzHqzgI+MmgqJ6xwJ8WE/zRWCvdN3M+kVrO/UAWqj19RAszRqKpAD
	x+Cg4e1HIIWmxSaZow505N5WborhKW8n6JorGd/KgJa6ZAWnN3chcsMeFcmsS04wZzsaF3
	kvwRd+0L9WV1WBj4aFuWxRZIrk71fJJE62BJXd4I14j5gPQkQcC5HhryVCTScGENS6eDDC
	42SSVhenxpZrXe+nCQFjtoQpWi0itKFHv6BhDunU4TDaxTAx/rSyYWqssNp6JztidNGTVI
	VqawWlJlWXWrTOm5V/VtyRdnoLtMA6UyNWa6q4a+7n+gP0nFgPFAFoJoEFAOKw==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 4/7] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
Date: Mon,  8 Jun 2026 14:01:25 +0000
Message-ID: <20260608140128.387844-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Example:

  1. server: chattr +c /export/file
  2. client: smbinfo getcompression /mnt/file
             Compression: 2 (LZNT1)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smbfsctl.h |  2 +-
 fs/smb/server/smb2pdu.c  | 28 ++++++++++++++++++++++++++++
 fs/smb/server/vfs.c      | 23 +++++++++++++++++++++++
 fs/smb/server/vfs.h      |  1 +
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 74e78bcb4618..9debdd709d1c 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -61,7 +61,7 @@
 #define FSCTL_LOCK_VOLUME            0x00090018
 #define FSCTL_UNLOCK_VOLUME          0x0009001C
 #define FSCTL_IS_PATHNAME_VALID      0x0009002C /* BB add struct */
-#define FSCTL_GET_COMPRESSION        0x0009003C /* BB add struct */
+#define FSCTL_GET_COMPRESSION        0x0009003C
 #define FSCTL_SET_COMPRESSION        0x0009C040 /* BB add struct */
 #define FSCTL_QUERY_FAT_BPB          0x00090058 /* BB add struct */
 /* Verify the next FSCTL number, we had it as 0x00090090 before */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 30c67f1c5109..7cc63678e2e0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8336,6 +8336,34 @@ int smb2_ioctl(struct ksmbd_work *work)
 		ret = -EOPNOTSUPP;
 		rsp->hdr.Status = STATUS_FS_DRIVER_REQUIRED;
 		goto out2;
+	case FSCTL_GET_COMPRESSION: {
+		struct compress_ioctl *cmpr_rsp;
+		struct ksmbd_file *fp;
+		u16 fmt;
+
+		if (out_buf_len < sizeof(struct compress_ioctl)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		fp = ksmbd_lookup_fd_fast(work, id);
+		if (!fp) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		ret = ksmbd_vfs_get_compression(fp, &fmt);
+		ksmbd_fd_put(work, fp);
+		if (ret < 0)
+			goto out;
+
+		cmpr_rsp = (struct compress_ioctl *)&rsp->Buffer[0];
+		cmpr_rsp->CompressionState = cpu_to_le16(fmt);
+		nbytes = sizeof(struct compress_ioctl);
+		rsp->PersistentFileId = req->PersistentFileId;
+		rsp->VolatileFileId = req->VolatileFileId;
+		break;
+	}
 	case FSCTL_CREATE_OR_GET_OBJECT_ID:
 	{
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 6dee609e9749..b8c3ba43452a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1908,3 +1908,26 @@ void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr)
 	else
 		*fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
 }
+
+int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt)
+{
+	struct file_kattr fa = { .flags_valid = true };
+	int rc;
+
+	rc = vfs_fileattr_get(fp->filp->f_path.dentry, &fa);
+	if (rc == -ENOIOCTLCMD) {
+		*fmt = COMPRESSION_FORMAT_NONE;
+		rc = 0;
+		goto out;
+	}
+	if (rc)
+		goto out;
+
+	if (fa.flags & FS_COMPR_FL)
+		*fmt = COMPRESSION_FORMAT_LZNT1;
+	else
+		*fmt = COMPRESSION_FORMAT_NONE;
+
+out:
+	return rc;
+}
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index ac6dda173b75..f6121207dbda 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -169,4 +169,5 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				const struct path *path,
 				struct inode *parent_inode);
 void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr);
+int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt);
 #endif /* __KSMBD_VFS_H__ */
-- 
2.54.0

