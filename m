Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A18D23ED6F
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 02:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780799296; cv=none; b=SzThbUVr4dy8l9N7trQ7BfsjCHk1fpXikKVTf9AX79ngbcbkY5s7lfdWKXnRJxzVccJ7dwiJjbNkdWGdCLvxZP0t4O7oMGmn+59Wk4USd5E7atsa37frATd/nUz9fI9V+wdZmF7AY4ttpgSYdkHIumP7YNytz1MMw9v3UK1Z7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780799296; c=relaxed/simple;
	bh=1FFCiCnN7VZKScHVD/ibXdsbEubyeM7eyxcB4VzTsMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3LGJtA7usHVGgxePvaNsuIYdTh1o78SQhbaR9zFxEt9ZMa24Rda7FlCxqXUi2Lh3g1MD2WuE78wjaCJc8VqsoWuV28r8DmvBiE1pk+p4rsMy8ebzNADW+sl/B+5gXJ3RCohE5iquFMxnVzbZHfhXeZk1fiRlbCRRiycze8Kh1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=JiehYVO4; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="JiehYVO4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780799291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bGkpy6K2qbMwl5/Oio+V04ustVc3Io0MDzPAL5SdK+o=;
	b=JiehYVO4rbUfzYMd78xglkm792ep7loSZfIkd7CmITP3IelBgQZisVnL/k6Qe5xUlO/zvS
	TNHzeGnGAURdjeyso/OYgv/76zfKQJ1GWl6BoiSWBw/yC8LtiXTtryhKhFiPkegyXq286D
	yCUqDElQYst35tsVtamqLUlflKQvAkL1Bf1OJz5fY1tGZdGAAyydfX9CfulJjZMAk3qYil
	pjy9a0EJx71Vz3v7GuuHyFiM4ixMcrFzpKvSCDSu7x9XnjXyHY9HYYLe/RJrvLR3m1ev+b
	DojFJHknAUmdjw94YKIAK9w+rGfcVAcXkJ8gw+E9Qik3zD60s1k2SR+wFcDOew==
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
Subject: [PATCH v2 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
Date: Sun,  7 Jun 2026 02:27:03 +0000
Message-ID: <20260607022705.317863-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260607022705.317863-1-chenxiaosong@chenxiaosong.com>
References: <20260607022705.317863-1-chenxiaosong@chenxiaosong.com>
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
index dd00cceb8ded..e7f09b3f758c 100644
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

