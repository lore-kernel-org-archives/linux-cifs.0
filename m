Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C10F1AC45D;
	Wed,  9 Sep 2026 03:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925182; cv=none; b=khPz0uwpVocCjhbFwmDD3GAamuszNZAPcJbNmXXdfrYCkA678eoCCkwt5HqDWj4glPTI8TrEWhrgWWN0nWISTLvEXPvaBaf/iZbGsTxZtiQ79xAXxbeKYrXhDPKkQt5vULTzssTDjTDKSOknDcRG1sfZqgDqCuloCoQ1Kk+X7e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925182; c=relaxed/simple;
	bh=4pV9vMnQZn8PibBgAyN/Wdfqc3vRuw/jAF+jOYsbCnI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZU5QUHeSd0K+UbBerbrPUJCyak0facA04eOxpHQNiiIAwR4onCERzANnmopYpvBg5CPqDdSzqwSeHLmAkfecn4cIERynjuS5L29vqqtwBdvQ0SC0Zk9bGDv6O0bogloIhYIBu5vJRCB92pJKnHCcWLcq4Rj2cCD0pMcw1tD2PEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Y9DCtRcA; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Y9DCtRcA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=l7
	54kcE82NR582rzgKOeiYFW0qHlGeMocNt4TOU2fl4=; b=Y9DCtRcAkTbKnnQ4X3
	ZT5NLLx1yFOOfx0etdM/wt2fAqngkjbB9ED953q5Qm9NPlovakDQeDVHOrollybk
	8Iy57BkWCqUB9xx0nLVcxfFPduRwVlNdG/5q7M4tgKTKvp16MW8tqal3I8TBL9RM
	u3gP47CDsjRPZux+8fmPfSMfs=
Received: from ubuntu.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDXX5Ld1KBqiRSZBg--.34011S2;
	Wed, 09 Sep 2026 11:39:10 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	stable@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2] ksmbd: fix invalid pointer dereference when get_inode_acl() fails
Date: Wed,  9 Sep 2026 11:38:54 +0800
Message-Id: <20260909033854.10107-1-15815827059@163.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXX5Ld1KBqiRSZBg--.34011S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWFyfJF17Kry7uw15ArWrXwb_yoWrJFyUpF
	4rG3Wvkr4YqFy7Kr97JrWUZ3WSgF1ktw4fGrZ7Kw4xA3Z3tryfKry0yry29Fn8ArW8WFyI
	vr4Y9r4IkF15JFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrWrXUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzgAwtWqg1OAfBQAA3v

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
ksmbd_acls_fattr(). Treat -EOPNOTSUPP as indicating that no ACL is
available, and propagate all other errors to the callers. Update
smb2_open() and smb2_get_info_sec() to handle these errors.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: Codex:gpt-5.6-sol
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
Changes:
v2: Treat -EOPNOTSUPP as indicating that no ACL is available

v1: https://lore.kernel.org/all/20260908081631.9735-1-15815827059@163.com/

 fs/smb/server/smb2pdu.c | 42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..08fec734fede 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3634,10 +3634,11 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
 }
 
-static void ksmbd_acls_fattr(struct smb_fattr *fattr,
-			     struct mnt_idmap *idmap,
-			     struct inode *inode)
+static int ksmbd_acls_fattr(struct smb_fattr *fattr,
+			    struct mnt_idmap *idmap,
+			    struct inode *inode)
 {
+	struct posix_acl *acl;
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
 
@@ -3648,10 +3649,28 @@ static void ksmbd_acls_fattr(struct smb_fattr *fattr,
 	fattr->cf_dacls = NULL;
 
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
-		fattr->cf_acls = get_inode_acl(inode, ACL_TYPE_ACCESS);
-		if (S_ISDIR(inode->i_mode))
-			fattr->cf_dacls = get_inode_acl(inode, ACL_TYPE_DEFAULT);
+		acl = get_inode_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl)) {
+			if (acl != ERR_PTR(-EOPNOTSUPP))
+				return PTR_ERR(acl);
+			acl = NULL;
+		}
+		fattr->cf_acls = acl;
+
+		if (S_ISDIR(inode->i_mode)) {
+			acl = get_inode_acl(inode, ACL_TYPE_DEFAULT);
+			if (IS_ERR(acl)) {
+				if (acl != ERR_PTR(-EOPNOTSUPP)) {
+					posix_acl_release(fattr->cf_acls);
+					return PTR_ERR(acl);
+				}
+				acl = NULL;
+			}
+			fattr->cf_dacls = acl;
+		}
 	}
+
+	return 0;
 }
 
 enum {
@@ -4778,7 +4797,10 @@ int smb2_open(struct ksmbd_work *work)
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
@@ -7643,7 +7665,11 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
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

