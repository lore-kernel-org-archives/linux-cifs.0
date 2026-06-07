Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549FE1DFF0
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780799300; cv=none; b=KIry4HrRIQ4QU3oPzUuXYl4/BEw4ZsJdUW5Y+yloLZ2WOxi2nc5Z8uCNO2jJ4a2VC4vgkqUXgooE7X6Dx0pjMlttwvpUdflrKgtXUPSXehMKzSEf6p829ONuzBvWKjJRpymUGyznTE0cIzWWsAXjjG0Z6v9z7FNo/Y45UPe6E6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780799300; c=relaxed/simple;
	bh=iaGTG3kDGIxEWk6mgeynxvaWvlHiGa9TOS4qBiHgf3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjOTdavMmjizMoeDzRxpyyYrUN/jbbI+ao85/aB8WtRoujxykLWv7L9C57HxrIDZeIanTl2ncyMqP45V2l+UnUSvoZssVwmbfROHFeIMeyyAuhPvxf76GB3404Q2kG1gzcBoxKYoT9eI388xWhsXduR7fM8By2hW7+3NamVvs/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=p3kQDDkq; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="p3kQDDkq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780799296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+td0nyQZSiCS1R1fdJERkDr7D2UlSaXkhbM5PFWfG6E=;
	b=p3kQDDkqjGvqUJv67f9r1aGh3BKv6fDO/RuVH+NowloZSix9fdzWbnVcEXE/DZozh+eK3W
	xXJ0bSqtNKgpkqOeoHvAL38jRQZ94tQBPren1j37Ojrpv8eKu284Qp+qjX3BqAkP0lDfUO
	bAvh6WDmgYOs+feO+gsKsuyVWtBm+XX+rFYStKGduRLLecirpkBIUlwF5Gg3f+vMepDMHt
	zC7p4r2cdxk8DmdVzCnXrNc5A61bwEVR8BDRsToKHy8nY9BHK9jlAC9yL61anDg7yinHLg
	9XWgVKZprmYSDwk+uE0t/6U8CV3bgAHXN+1/Ni+CO7TOZEIMJJsA2F4g2ghchw==
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
Subject: [PATCH v2 4/5] smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
Date: Sun,  7 Jun 2026 02:27:04 +0000
Message-ID: <20260607022705.317863-5-chenxiaosong@chenxiaosong.com>
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
 fs/smb/server/smb2pdu.c | 28 +++++++++++++++++
 fs/smb/server/vfs.c     | 70 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 99 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index aeede3f11e06..8c40631ce64a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8366,6 +8366,34 @@ int smb2_ioctl(struct ksmbd_work *work)
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
index e7f09b3f758c..4355a0c743bd 100644
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

