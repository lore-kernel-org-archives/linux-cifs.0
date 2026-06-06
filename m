Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA6D31A7E4
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 09:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780738024; cv=none; b=sPWuJwBJXcn/WPDj0Q0/8zXOmAe8dilJeFn4m7xcKKuKFeeYfMubqeSJjev443GucVp6FhBjNnyFmYhk7d0PJsVuj89UtoDZSgqXbplPG1k4BtsNWD85q8sjXQIRYOsekvAsRmvdbrkW3uB+ON27+00auiUuecGjSf6rPAXGVnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780738024; c=relaxed/simple;
	bh=agERKs0Kp9U+KOx1YxiQkF7U3E55cxtyeAXhhqXaq98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6jbjbvtttD2rSu86Hvth1eF3VgA81sIpeCUSs+VqOSSVSeDBLT9rYKAO5Qiz1TLkRGocd3iyVPXMby/rrN2zhXtwOSYtv4dhspzxwmI/KDuqPi2Ejc+HjWDFTaIC5e/4YVeH+0mgYhf4w3L5e71Nh3nkbZsE4NQ6vphq1oCbJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=aqGtZjpD; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="aqGtZjpD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780738020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9FyEpvGTMRudokcb5Qgi/Ms0O/Pu/cht/jPyOAKF+I=;
	b=aqGtZjpDZOcbUnvVqcA9w33HuvkHmVbgtVxMuT+nkYRI42WT1qBNK+EW/7nwiiK57ehpDJ
	IJRDSx1HxGA8/IycH/BjmMMYHQFSaD9z2BWR0dOtg3pdPm28eJfywjcO2xJ1ZJ2jnMkz4m
	HFJiPQdjVKdprdD8teTjIiz1z3fPk+RpDcBalS/dNLI4VsRShW7wzUhIG9F8DU6fZBUFbg
	bRVy3FOoOhP4C01KouO3KYG7Toc5VGHz1LiUAfa0hIaWEKoRSrMEriPX8QCJ5xqAgxINMz
	7lkC15lyL/g3+psnkV8LypZSm/YsJkdM0ggSqVkTOwxWAz9kD+CY5Bvn6tHS9A==
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
Subject: [PATCH 2/5] smb/server: get compression file attribute on open
Date: Sat,  6 Jun 2026 09:25:58 +0000
Message-ID: <20260606092601.299698-3-chenxiaosong@chenxiaosong.com>
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
  2. client: lsattr /mnt/file
             --------c------------- /mnt/file

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c |  5 ++++-
 fs/smb/server/vfs.c     | 20 ++++++++++++++++++++
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3eb3b1711acb..707ad8d17b62 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3603,7 +3603,10 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (!created)
 		smb2_update_xattrs(tcon, &path, fp);
-	else
+
+	ksmbd_vfs_update_compressed_fattr(path.dentry, &fp->f_ci->m_fattr);
+
+	if (created)
 		smb2_new_xattrs(tcon, &path, fp);
 
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d08973b288e5..08490a7fb396 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -21,6 +21,7 @@
 #include <linux/crc32c.h>
 #include <linux/namei.h>
 #include <linux/splice.h>
+#include <linux/fileattr.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -1890,3 +1891,22 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 	posix_acl_release(acls);
 	return rc;
 }
+
+void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr)
+{
+	int rc;
+	struct file_kattr fa = { .flags_valid = true };
+
+	rc = vfs_fileattr_get(dentry, &fa);
+	if (rc == -ENOIOCTLCMD) {
+		*fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
+		return;
+	}
+	if (rc)
+		return;
+
+	if (fa.flags & FS_COMPR_FL)
+		*fattr |= FILE_ATTRIBUTE_COMPRESSED_LE;
+	else
+		*fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
+}
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 16ca29ee16e5..ac6dda173b75 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -168,4 +168,5 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				const struct path *path,
 				struct inode *parent_inode);
+void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr);
 #endif /* __KSMBD_VFS_H__ */
-- 
2.54.0

