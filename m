Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C23C3C02
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927381; cv=none; b=pu1QMwIbt2vsAMMfqsktQ2coGVdiZ+34uAdKkWLkO2wvjso0TCI+KUcgnyL/YsyxeiHtQumhmv3h9Yl8id7yXApkDv4Rkk33/eJ0SW73nn51M5i5uJBmF4nEIRmlVbsAt4GGsfzg2KOUJ2YaPjg6b7r/Se5duzG5h9dx0ldVF0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927381; c=relaxed/simple;
	bh=mlQ904YDa+x7cjAmSFN9NnSzXiOrScSFbjcuINa/d/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to4p1uHJQAYRBST/pxIskc+/9uRd9vxfnbtfSLX53wbdXYznpwvp7wserGrWoJ6lGcy3QX6VpRbXH13AJCy5EPQKzSd8L0jKXfSqFBV9NoUYsjttm18q3G20yjbjARqeIckg8uLp+YQ5QAWMm1kQvs1XP2rroGHAWxdB0kP5aZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hRtE2MsF; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hRtE2MsF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uygkpu+C1mEWzfTRrosdPlbElYFYbOQRVtu9+cvYRVY=;
	b=hRtE2MsFKHAZtptb8FlPWj0LzlZWvzWHRUekUVQNwpO3RnjTK/a+5szAXYE570pscV+sbc
	sMqoUzz51ANPDlovPnj/90sMMlnh73mR6L0Cyt1j1uNWBdhAKM0wnjKBLtFhHcZLifzvKE
	RU0ByPas0gVSHwaaNbRaufDmBBtn8BzEZE98ZyYDTojdy2sACidzoIfby5S+y8Ud8hjjfw
	Kc5xPBne8JwDZ4mxA9ubTTwmSn493eOcj2gTqT4bbC6hJElrhwBHnzpkAa2jkFGC4yySlV
	rtHV0e7QvRXH4EsXMxAEKgvgsVdc1E01B5CfQIF3tlWunI+n86QOXyG32HuSQw==
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
Subject: [PATCH v3 5/7] smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
Date: Mon,  8 Jun 2026 14:01:26 +0000
Message-ID: <20260608140128.387844-6-chenxiaosong@chenxiaosong.com>
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

  1. client: smbinfo setcompression no /mnt/file
  2. client: smbinfo getcompression /mnt/file
             Compression: 0 (NONE)
  3. client: smbinfo setcompression lznt1 /mnt/file
  4. client: smbinfo getcompression /mnt/file
             Compression: 2 (LZNT1)
  5. client: smbinfo setcompression default /mnt/file
  6. client: smbinfo getcompression /mnt/file
             Compression: 2 (LZNT1)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smbfsctl.h |  2 +-
 fs/smb/server/smb2pdu.c  | 28 ++++++++++++++++
 fs/smb/server/vfs.c      | 70 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.h      |  1 +
 4 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 9debdd709d1c..d1fcb46a7cde 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -62,7 +62,7 @@
 #define FSCTL_UNLOCK_VOLUME          0x0009001C
 #define FSCTL_IS_PATHNAME_VALID      0x0009002C /* BB add struct */
 #define FSCTL_GET_COMPRESSION        0x0009003C
-#define FSCTL_SET_COMPRESSION        0x0009C040 /* BB add struct */
+#define FSCTL_SET_COMPRESSION        0x0009C040
 #define FSCTL_QUERY_FAT_BPB          0x00090058 /* BB add struct */
 /* Verify the next FSCTL number, we had it as 0x00090090 before */
 #define FSCTL_FILESYSTEM_GET_STATS   0x00090060 /* BB add struct */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7cc63678e2e0..2b67c5926c67 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8364,6 +8364,34 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->VolatileFileId = req->VolatileFileId;
 		break;
 	}
+	case FSCTL_SET_COMPRESSION: {
+		struct compress_ioctl *cmpr_req;
+		struct ksmbd_file *fp;
+
+		if (in_buf_len < sizeof(struct compress_ioctl)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
+			ksmbd_debug(SMB, "User does not have write permission\n");
+			ret = -EACCES;
+			goto out;
+		}
+
+		cmpr_req = (struct compress_ioctl *)buffer;
+		fp = ksmbd_lookup_fd_fast(work, id);
+		if (!fp) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		ret = ksmbd_vfs_set_compression(work, fp, le16_to_cpu(cmpr_req->CompressionState));
+		ksmbd_fd_put(work, fp);
+		if (ret)
+			goto out;
+		break;
+	}
 	case FSCTL_CREATE_OR_GET_OBJECT_ID:
 	{
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b8c3ba43452a..0be40601ab3d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1931,3 +1931,73 @@ int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt)
 out:
 	return rc;
 }
+
+int ksmbd_vfs_set_compression(struct ksmbd_work *work, struct ksmbd_file *fp, u16 fmt)
+{
+	struct file_kattr fa;
+	struct dentry *dentry = fp->filp->f_path.dentry;
+	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
+	u32 flags;
+	__le32 old_fattr;
+	int rc;
+
+	if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+		rc = -EACCES;
+		goto out;
+	}
+
+	rc = vfs_fileattr_get(dentry, &fa);
+	if (rc)
+		goto out;
+
+	flags = fa.flags;
+	if (fmt == COMPRESSION_FORMAT_NONE) {
+		flags &= ~FS_COMPR_FL;
+	} else if (fmt == COMPRESSION_FORMAT_DEFAULT ||
+		   fmt == COMPRESSION_FORMAT_LZNT1) {
+		flags |= FS_COMPR_FL;
+	} else {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (flags != fa.flags) {
+		fileattr_fill_flags(&fa, flags);
+		rc = mnt_want_write_file(fp->filp);
+		if (rc)
+			goto out;
+
+		rc = vfs_fileattr_set(idmap, dentry, &fa);
+		mnt_drop_write_file(fp->filp);
+		if (rc)
+			goto out;
+	}
+
+	old_fattr = fp->f_ci->m_fattr;
+	if (fmt == COMPRESSION_FORMAT_NONE)
+		fp->f_ci->m_fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
+	else
+		fp->f_ci->m_fattr |= FILE_ATTRIBUTE_COMPRESSED_LE;
+
+	if (fp->f_ci->m_fattr != old_fattr &&
+	    test_share_config_flag(work->tcon->share_conf,
+				   KSMBD_SHARE_FLAG_STORE_DOS_ATTRS)) {
+		struct xattr_dos_attrib da;
+
+		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
+		if (rc <= 0) {
+			rc = 0;
+			goto out;
+		}
+
+		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
+		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap,
+						    &fp->filp->f_path,
+						    &da, true);
+		if (rc)
+			rc = 0;
+	}
+
+out:
+	return rc;
+}
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index f6121207dbda..7b3d2f4fd985 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -170,4 +170,5 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				struct inode *parent_inode);
 void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr);
 int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt);
+int ksmbd_vfs_set_compression(struct ksmbd_work *work, struct ksmbd_file *fp, u16 fmt);
 #endif /* __KSMBD_VFS_H__ */
-- 
2.54.0

