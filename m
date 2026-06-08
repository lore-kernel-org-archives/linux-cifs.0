Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB173B9D91
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927376; cv=none; b=GRTJb0wxbgpwiKedU0zQFnmHfy4RmRSo8xgN18NF3EHUlJbIT7xyU+0T7hL5cGVdrzOWZKTbR0Rgkog22P7E1UTHBVf2lc1bigieNYpFDc+lOuVDV84+KuQvntdNHFQlEHEkaoMIuSC2T6ffGGatzGubc0CuZaTah+JB8lC1Hak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927376; c=relaxed/simple;
	bh=79IZVYYTpCAAHUjMLCLtEj39bTMnp94PWbANR1MJiUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMM145cddyDvf6S4MGASYbVfWmhi8HwfTzPOA2tDqyccvoXuo+kCXn3ULwirv+EB5IVz8gUarzxztt/8quHGq0n9KbWf/Pc4iNcF3e8CN222utX+xLWz46Nl28BU8wqfjynjDW1U1Ls+1FLcJjGcTJODgNu8r28LnjfGQ9MtUlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=sfW0duPj; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="sfW0duPj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2XDT0guey2NHnDyiKQIYngdJ8/aqV1kuXPGRSbuENJU=;
	b=sfW0duPjdOl/V5wXbeLPhyWEU/kRHFI6eftuKlTPYMThwP2ORVlVNhTHPVBgmpWPltnzlb
	c1Jgm31E0rT2XwV4CYVay2bh3HasjMobW3VgzbGxx57XDz0R5Ij+jiGwCkk7p5mpdktEtN
	QLHWqe78cQJWseSzgPcVE0pMJO3bQe7hHe4CqmnkuAgpP6Qrx+BUBUqwaOn+ZpNFpypJCy
	tLfL0/AhK8qGhX7xBhtx90efI5OGDKikvekZX7wAcUIn1eqkQPwU31AD+MvAAupJyk0raN
	8UHBn7DcgC3STRkRCSfg77IVo+WBVRSGtrMpW6KvewGj4/RflDZYygLLYyld4Q==
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
Subject: [PATCH v3 3/7] smb/server: get compression file attribute on open
Date: Mon,  8 Jun 2026 14:01:24 +0000
Message-ID: <20260608140128.387844-4-chenxiaosong@chenxiaosong.com>
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
  2. client: lsattr /mnt/file
             --------c------------- /mnt/file

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c |  5 ++++-
 fs/smb/server/vfs.c     | 18 ++++++++++++++++++
 fs/smb/server/vfs.h     |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8bf418e2da1c..30c67f1c5109 100644
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
index e020e59d1d5d..6dee609e9749 100644
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

