Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E6124E4B5
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 02:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780799292; cv=none; b=ryBWxtZnnMxNYWevSl9ikz6Fw5/cyBpxq2HbXsg5+eGX5x9StpjdzIOWJIIIPsAqvXXfDr+CJbxb2Pu99acr5pkKMD0PD4La3hReBqSwHJFmJHErO65iGurbxGGSlJyk9JRxYP7jVikJ0kAy03dte8UXx6VGv7p+lgktr2p6ERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780799292; c=relaxed/simple;
	bh=1gXAIwR7fvz5gBAapJxly4lRFgvO3VO73iPQDHNScZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LODmntKD35Yd7NYD2yuQvfJuDH4dJqCJrOQjcv92sMZzx71pPD+oiTjmDbiqc4W4ercnuiK8+zpqgxzy0Bb5b8AR4/v5erwUkVpzNyziscpf5km4SZaPAkRS2yWXdxnVL2JnYUW1+5xl/3tWohz3lOJujK8JXxHrkCBuVi0la4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=pPbk4wp4; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="pPbk4wp4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780799288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B0xgg2uE3z0surUCYkMpx6PBw3f8wcsmazLl7Vbhzso=;
	b=pPbk4wp4uGryeXbjAjuLGEbiddTuVevLM61swnXA/c5I2lOfZRmi9KGFlP2epqIKUeQP4I
	1EVoKfVBOcgyogQUWNWLxFukgDozGRQI/y4VjyKs8nWS2CQx7TLWgbrEgGGf4qS5lHfgfH
	6XfwpMkJIQ8+X34gaHoPSDvrPm1BY4NGlV8eaVSvCWkoBHusTeHtkTIY7PvmM6nS43+pRj
	I1Ypo6XDDmEq/lEU1eLYwWNU6vdabjQ3Z5mSNYL+K/55oVO4xE9bHl8D3UkUsaSN7bD3KG
	lyu6yv3KBmh9+dFFLjpOCe+cvwx9+CA0Qr/Frsb6IGtLWDYp+fTREzCFYK/oxA==
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
Subject: [PATCH v2 2/5] smb/server: get compression file attribute on open
Date: Sun,  7 Jun 2026 02:27:02 +0000
Message-ID: <20260607022705.317863-3-chenxiaosong@chenxiaosong.com>
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
  2. client: lsattr /mnt/file
             --------c------------- /mnt/file

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c |  5 ++++-
 fs/smb/server/vfs.c     | 18 ++++++++++++++++++
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

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
index d08973b288e5..dd00cceb8ded 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -21,6 +21,7 @@
 #include <linux/crc32c.h>
 #include <linux/namei.h>
 #include <linux/splice.h>
+#include <linux/fileattr.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -1890,3 +1891,20 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
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
+	if (rc == -ENOIOCTLCMD)
+		*fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
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

