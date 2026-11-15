Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794736081;
	b=F5D+SOAoG5hTH78G0wLR1NfGkGxq7q4/ymDZARRklQKLimpUaRJvJbikJDjh44fmvouX
	 vSS3sL9A1iZjeYoKeQTrRg9SWsyE7Z/YDptUZq8AKT7gFOfxiG9zKrOfxiKwk5TW0Oxsb
	 e6vtRDm8rq1xCBplIBn8FjhYL3BT+ulFAlFS8UnimXs98QDP06CX5Y22qWiAw8RdOff/H
	 2bBGZKonoahgns7PdI8lO7qNjhTEjLfoLMdTDIet1sruv19FrjTmQAVSgjOEiowMjae8a
	 NWVVBJOdPi23GOO7fHSqKakeInvOeEZsEOwmTDBeoDF8fY5Mllz8o0W+nX7CW44rReg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794736081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3YvPVGIUV6UeKNktyOpHIaKZATW29j3wAKF5lED/ZM=;
	b=TGKhdI7Y5D9CpUg5BOfU3cn1DLCLq+I/JRFPb/ml5xa3ArxypKT/o9ycIa9NSw0xqz5q
	 REbYpiG7r2HacLp5kZj9X/PHAJNPK9qA1hA7Uy0C2IZsFh72bfrPiJ7977ViQ/8ngBw9b
	 1Ms7xkoYAQvuC7T3lkYLs4ecyCQDiQkfRaSJAR1UouS+iEgsugCy6CcT16JjscaQSDbES
	 59t2cOrCN0dW4TX2LuC0QhexJk8Qb2cJWBroZPUoytSi6rN9vmNPqVbWnKqyatX0X1B8z
	 sbV32LafD6cpyBx9jgr6MlSmXKMGUUfajZ9x1UbEJ14jjTZ5kF2dsSE1dbVc6vUvXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lA4H8NIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55509606A31A;
	Sun, 15 Nov 2026 09:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lA4H8NIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA51F000C4;
	Sun, 15 Nov 2026 09:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794736080;
	bh=W3YvPVGIUV6UeKNktyOpHIaKZATW29j3wAKF5lED/ZM=;
	h=From:To:Cc:Subject:Date;
	b=lA4H8NIq4rbYfksDegTpSngx+ydGH+ws02/MVvVCh+a/ddEUe4NZpOQ/PavRtokmw
	 4mWUZ+RxWP0BF4EE/qCacmBDAq+u2V9uGusmOLQT2sNLyExVVbWjYAixcXQktLlRcR
	 flU9z0VFKMvarop6Ci5M06rhO3I4nIewCtDPAK4rrmMpSJm8tWFvPiXN+Qn9oBVpi1
	 QwYZka0Rg3ErXvgAlLeRPjR939bPWiekbz0hrlMAD4NZjWnPS7znk3eaMZ+fHdyJPE
	 HrbwQPdUpP+cq0EYmQui7unU6A3s7xJx9/zDvP2KJJbnNAvnXWorhbpPEi5LQ5Hc2L
	 7zPQzWoOfz7EQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	icb@fastmail.org,
	mike.michalo@gmail.com,
	wangzhaolong633@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: protect SET_INFO metadata updates against filesystem freezing
Date: Sun, 15 Nov 2026 18:47:36 +0900
Message-Id: <20261115094737.8532-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SET_INFO calls notify_change() and set_posix_acl() without a mount write
reference. During a filesystem freeze, these updates can reach ext4
without the usual freeze protection and trigger WARN_ON() in
ext4_journal_check_start().

Hold a write reference around the metadata updates. Drop it before storing
the security descriptor xattrs, whose helpers acquire their own references.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 17 +++++++++++++----
 fs/smb/server/smbacl.c  |  9 +++++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index fc0987d99a57..1b8471d75afa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8998,6 +8998,10 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	    (file_info->Attributes & FILE_ATTRIBUTE_TEMPORARY_LE))
 		return -EINVAL;
 
+	rc = mnt_want_write_file(filp);
+	if (rc)
+		return rc;
+
 	crtime = (s64)le64_to_cpu(file_info->CreationTime);
 	if (crtime > 0)
 		fp->create_time = crtime;
@@ -9025,7 +9029,8 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		if (!S_ISDIR(inode->i_mode) &&
 		    file_info->Attributes & FILE_ATTRIBUTE_DIRECTORY_LE) {
 			pr_err("can't change a file to a directory\n");
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 
 		if (!(S_ISDIR(inode->i_mode) && file_info->Attributes == FILE_ATTRIBUTE_NORMAL_LE))
@@ -9046,7 +9051,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			XATTR_DOSINFO_ITIME;
 
 		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da,
-				true);
+				false);
 		if (rc)
 			ksmbd_debug(SMB,
 				    "failed to restore file attribute in EA\n");
@@ -9057,13 +9062,17 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		struct dentry *dentry = filp->f_path.dentry;
 		struct inode *inode = d_inode(dentry);
 
-		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-			return -EACCES;
+		if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+			rc = -EACCES;
+			goto out;
+		}
 
 		inode_lock(inode);
 		rc = notify_change(idmap, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}
+out:
+	mnt_drop_write_file(filp);
 	return rc;
 }
 
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 6b5f22d6280c..04dd4a6d7092 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/mount.h>
 
 #include "smbacl.h"
 #include "smb_common.h"
@@ -1944,6 +1945,12 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 				   (fattr.cf_mode & 0777);
 
 	ksmbd_vfs_remove_acl_xattrs(idmap, path);
+	if (get_write) {
+		rc = mnt_want_write(path->mnt);
+		if (rc)
+			goto out;
+	}
+
 	/* Update posix acls */
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
 		rc = set_posix_acl(idmap, path->dentry,
@@ -1965,6 +1972,8 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	inode_lock(inode);
 	rc = notify_change(idmap, path->dentry, &newattrs, NULL);
 	inode_unlock(inode);
+	if (get_write)
+		mnt_drop_write(path->mnt);
 	if (rc)
 		goto out;
 
-- 
2.25.1

