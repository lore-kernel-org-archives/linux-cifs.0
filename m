Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDA377A8D
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 12:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846861; cv=none; b=kf0tpkU3UrOMsbe0xMtsa9O2PlN0xNlDKPbJrjbnTLnmtmNrAzc0x0prRDGEaNUmQl5+6Buqw4CW3su+cidkl4hcyePN6InJvsm8iPBLY45Z1JnZBXDoNlusKausHHORKV34cqeyzuv/dAaRdi25cNlcoJzMGeApGr8TszMix+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846861; c=relaxed/simple;
	bh=MTrC/vyMClzGy4/GlV8edH0M0of/qGmgKdshnsta9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEGDyNCBAdsKy5wvOGHaD8KK9Z4EkZoE5e0HrUxjebhDlfkseNPaoG3qxG5P51QhFsUijm8PTcHO+n5xXyjrFf0RMdvNUgq3ocZD0JUq9fvpho27n7tT2NHoFJjggxThypFrlAaioKq2L7ElCXUP/EM4ftxPy/c4dhKAFB8FE9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=eAeW42DS; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="eAeW42DS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785846856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNprZeSEOLbkw/9cv2A/TyqB93irDK0a7pKGaKiJBGk=;
	b=eAeW42DS2NVqs0i9P4wwLrWIuWIIexwPzEMLoHPi6Ft2DckqpqpoNapIkFsmu7Xqoeld8u
	H+kc87eunmcDGUuzTIe4bVbAhY8A096OZisJdKLGxJxsX18hxHDlRwcLmRnNZq0Yoy2WSZ
	bOfo/orZcooJCD0YY2B8d/RSgCmO1WXZvD51puWtIrHlAcKf1tMQBwCmN4t95XHxj9txTB
	4ujOZy8IcOEyFm2ngNdeNWROKHuyPcMrTj4Kb1dbS+Uj5IITsDWEbscJrniuUspT5D2e9D
	/Y4ai9vmfD2rwIqV1ADOHPp6gIlAOxPUM9v60++g49Imm0L5FUt9eOmXbJWotQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/3] smb/server: deny overwriting targets with non-POSIX opens
Date: Tue,  4 Aug 2026 12:33:00 +0000
Message-ID: <20260804123301.285434-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount without `posix` option
     mount -t cifs //${server_ip}/export /mnt
  3. client: touch /mnt/file1 /mnt/file2
  4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
  5. client: C program: rename("/mnt/file1", "/mnt/file2");
  6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
                        stbuf.st_nlink is 1, should be 0

This patch fixes xfstests generic/035 when mounted without `posix` option.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c       | 13 +++++++++++++
 fs/smb/server/vfs_cache.c | 32 ++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 46 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 16ef8d051b18..9102ab47a3aa 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -726,6 +726,19 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
 		goto out3;
 	}
 
+	/*
+	 * See MS-FSA 2.1.5.15.12.
+	 * An overwrite rename must fail with STATUS_ACCESS_DENIED if the
+	 * existing target still has a non-POSIX open.
+	 */
+	if (!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)) &&
+	    d_inode(rd.new_dentry) &&
+	    d_inode(rd.new_dentry) != d_inode(old_child) &&
+	    ksmbd_has_other_nonposix_open(rd.new_dentry)) {
+		err = -EACCES;
+		goto out3;
+	}
+
 	err = ksmbd_vfs_check_rename_share(work, old_path);
 	if (err)
 		goto out3;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 028bc1b0f652..94b2b5e48d3d 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1137,6 +1137,38 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	return NULL;
 }
 
+bool ksmbd_has_other_nonposix_open(struct dentry *dentry)
+{
+	struct ksmbd_file *fp;
+	struct ksmbd_inode *ci;
+	struct inode *inode = d_inode(dentry);
+	bool ret = false;
+
+	if (!inode)
+		return false;
+
+	ci = ksmbd_inode_lookup_lock(dentry);
+	if (!ci)
+		return false;
+
+	down_read(&ci->m_lock);
+	list_for_each_entry(fp, &ci->m_fp_list, node) {
+		if (READ_ONCE(fp->f_state) != FP_INITED)
+			continue;
+		if (inode != file_inode(fp->filp))
+			continue;
+		if (fp->is_posix_ctxt)
+			continue;
+
+		ret = true;
+		break;
+	}
+	up_read(&ci->m_lock);
+	ksmbd_inode_put(ci);
+
+	return ret;
+}
+
 bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp)
 {
 	struct dentry *dentry = old_fp->filp->f_path.dentry;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 9dca617bc429..5cac022b540b 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -212,6 +212,7 @@ bool ksmbd_has_stream_without_delete_share(struct ksmbd_file *fp);
 int ksmbd_close_fd_app_instance_id(char *app_instance_id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
+bool ksmbd_has_other_nonposix_open(struct dentry *dentry);
 bool ksmbd_has_nonposix_open_child(struct ksmbd_file *old_fp);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp);
-- 
2.54.0

