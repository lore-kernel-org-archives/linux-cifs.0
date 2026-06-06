Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530F31B80D
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 09:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780738028; cv=none; b=iQLkc5EWsZ44sS0B543VR6DrKJLnv1WjI4lydFC7gxmpe4Vzf/TStZBY2OygAIQzA4nDzlMGF71EnHZkuYS/NstfzDB2Mln2ZqZkUwjKyrXvUdOh26UtKVj6wPqvrMvdBxGDv3QTSkbCMU9ugLPo4BbkYDCpNexoBHDJhv6yw70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780738028; c=relaxed/simple;
	bh=lLJRLDtdWgGuTPUJVGKtVqtNS7c4iz1t/5AsFk2K90I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf/YCFswVV1OPyVpIncnoeO4/pJ6835Zwclc5soHAJ+yEOLDdkpaH01RizmJwfzpoD1STicJ+e6VrhxEhLOlkuidMMfelB5XjklkPDFe8Ke7cP/NOMHaiX0ORnUXkCxWAS+8YK8q7bS6QU5gzn2paQsQpUjfk6G4eOTmct9MyOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Sb2LnQv6; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Sb2LnQv6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780738023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zL2id6We3cbuk9sGB+YZgdg/o60pEWDbuXogomCwXwM=;
	b=Sb2LnQv6O4JhAG9z4eGXnenb6lMV78LNdjlEvzxAUCFx1AaCItKg3og/CVK+bK1ud/yc1/
	+5Tvv6def6KK+W0RL9DlpfzFRdsWds4gVEesUxRtLkEuMr7N3dNOvbq6Z0J9dD2NcWbF8z
	OOJ8tfpE3haYw5N/SwwP8MhIIj9dYQAZzoFFMliZno35xZBDQPH2ZaYLsZE0czL5hZXYIc
	oL3xYnU4X6tTLjREBa79VWh1zGh2G1lgiuLoAZNjGoZEGjrTbri9CamwSHzLK7eibn4bTK
	DQcQrFnNov6SUA8GYQo9WUjSYMgEsgFefvLW/+0KHLm7+oxC8RYkpicIAPmbRQ==
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
Subject: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
Date: Sat,  6 Jun 2026 09:25:59 +0000
Message-ID: <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
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
             Compression: 1 (UNKNOWN)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++++++++
 fs/smb/server/vfs.c     | 23 +++++++++++++++++++++++
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 52 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 707ad8d17b62..aeede3f11e06 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8338,6 +8338,34 @@ int smb2_ioctl(struct ksmbd_work *work)
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
index 08490a7fb396..fc29df32330b 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1910,3 +1910,26 @@ void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr)
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
+		*fmt = COMPRESSION_FORMAT_DEFAULT;
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

