Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53E3CE099;
	Tue,  8 Sep 2026 08:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788855428; cv=none; b=tfcJm4LQbjD3SUlf6PLxow+EJqIKFPhS9hak4nZbpjNX7ZRaZVA+fJh+aufH76Xo0RRPPabxcZ6t4ui0EgG342c7rjobwdz7JsDhkC89Fyt21fhLKie2kNuDy36CvAqiBZxkFTf3xZNEHwu9D+HVyngiIhRzuht+d0qbCmRNOQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788855428; c=relaxed/simple;
	bh=Sw65ndDTc8r9n81YHzvmjfvGSaHZtX4ahC8Fk6N37HA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nXsFK5+Escy5yauaGhgXGqctM8M/SbxiIdFnlmO/OpyOrLGUz+6EwEv1RK8eFNWe4QXQuPogaQ5EaFGnjwU4P7mHdN3aX6GbCOZKAOtIwCFs3kBf+SfI58tZc7N4nZ+BZ3oOvfD9d/IHsTbBwY/W9/m4xyzmNyjhKOnCBbThyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j/Z0kEYw; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j/Z0kEYw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=4T
	j/lYeU7aAN9IIwH45WiWFJtIZJ9W4kfuzcyjjsibU=; b=j/Z0kEYw3Y9uc4JFtr
	pU2gvbRC9RJhk1qpWsQQrpl7DlpTJyR9v1U1YN9dq/e20VrzBOJdEDcYnqX8+JCz
	xN06LOW+eVueEjxPunNMkN+V9L3RF3yD+Fv8Y/3v/9eIOvaDq0RlsxNK2R7iYcIU
	ocp7MiXmBMWT6JdEtfyqzy43o=
Received: from ubuntu.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAXQgJhxJ9q1J15BQ--.22909S2;
	Tue, 08 Sep 2026 16:16:34 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	stable@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Tue,  8 Sep 2026 16:16:31 +0800
Message-Id: <20260908081631.9735-1-15815827059@163.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXQgJhxJ9q1J15BQ--.22909S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFyfJF17Kry7uw15Gw4UJwb_yoW5ZF4Upr
	43Ga4vkrs8XFyxWr97JrWUZw1S9F18tw4fGrZ7K3yfA3Z3t34xtry0yryagFn8CrW8WFyI
	vrs09r4S9r17JFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrYFAUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbC8ALLUWqfxGKifwAA3m

From: Henry Hu <huhai@kylinos.cn>

When get_inode_acl() fails, it returns an ERR_PTR(), but
ksmbd_acls_fattr() stored that pointer in smb_fattr without
checking for errors. Later callers then passed the error pointer
to security descriptor helpers or posix_acl_release(), resulting
in an invalid pointer dereference.

This was reproduced on an XFS-backed share when xfs_get_acl()
returned ERR_PTR(-ENOMEM). Querying the SMB ACL from a CIFS client
triggered the crash:

  BUG: unable to handle page fault for address: fffffffffffffff8
  RIP: smb_acl_sec_desc_scratch_len+0x58/0x90 [ksmbd]
  Call Trace:
   smb2_query_info+0x40d/0x17c0 [ksmbd]
   handle_ksmbd_work+0x1ca/0x770 [ksmbd]

Fix this by checking the return values from get_inode_acl() in
ksmbd_acls_fattr() and propagating any errors to its callers.
Update smb2_open() and smb2_get_info_sec() to handle these errors.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: Codex:gpt-5.6-sol
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..c6df9a9789ba 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3634,9 +3634,9 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
 }
 
-static void ksmbd_acls_fattr(struct smb_fattr *fattr,
-			     struct mnt_idmap *idmap,
-			     struct inode *inode)
+static int ksmbd_acls_fattr(struct smb_fattr *fattr,
+			    struct mnt_idmap *idmap,
+			    struct inode *inode)
 {
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
@@ -3649,9 +3649,19 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 		fattr->cf_acls = get_inode_acl(inode, ACL_TYPE_ACCESS);
-		if (S_ISDIR(inode->i_mode))
+		if (IS_ERR(fattr->cf_acls))
+			return PTR_ERR(fattr->cf_acls);
+
+		if (S_ISDIR(inode->i_mode)) {
 			fattr->cf_dacls = get_inode_acl(inode, ACL_TYPE_DEFAULT);
+			if (IS_ERR(fattr->cf_dacls)) {
+				posix_acl_release(fattr->cf_acls);
+				return PTR_ERR(fattr->cf_dacls);
+			}
+		}
 	}
+
+	return 0;
 }
 
 enum {
@@ -4778,7 +4788,10 @@ int smb2_open(struct ksmbd_work *work)
 					int pntsd_size;
 					size_t scratch_len;
 
-					ksmbd_acls_fattr(&fattr, idmap, inode);
+					rc = ksmbd_acls_fattr(&fattr, idmap, inode);
+					if (rc)
+						goto err_out;
+
 					scratch_len = smb_acl_sec_desc_scratch_len(&fattr,
 							NULL, 0,
 							OWNER_SECINFO | GROUP_SECINFO |
@@ -7643,7 +7656,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	idmap = file_mnt_idmap(fp->filp);
 	inode = file_inode(fp->filp);
-	ksmbd_acls_fattr(&fattr, idmap, inode);
+	rc = ksmbd_acls_fattr(&fattr, idmap, inode);
+	if (rc) {
+		ksmbd_fd_put(work, fp);
+		return rc;
+	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR))
-- 
2.40.1

