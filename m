Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC4BEB64DC
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jun 2023 12:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbjFNMYT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jun 2023 08:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244344AbjFNMYJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jun 2023 08:24:09 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590281FCC
        for <linux-cifs@vger.kernel.org>; Wed, 14 Jun 2023 05:24:08 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-652a6bf4e6aso5133498b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 14 Jun 2023 05:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686745447; x=1689337447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jW1BUs54gtTJtzBvjBzwawUWMo5s+Du6aAOeKilYFF0=;
        b=h3D9lfNa5/pT7A7wah3gbvHUQJy4dd0uiK8bt61elI3L9x/tQuhXCe7v7AaMfH1/92
         GESFXHPQMIMsLTd+UvUf3i5Fmvyih06o41649Il32Erq5vFBLNV3z4p+Q5n9deESiXxG
         G02dOASi3zENNtTlZ9AuBTr0RKRN7caLTT9JQItdyCKNE9lviwokgd9G+ElufdugVuna
         MfQ4fSRsxQaf0+AhornTkKYVXz6nJ/YwzT8lf6SGdi+5EtISPh+tQyRTIar6qTHKLvU4
         LwnGsp4uUTuJVMqUmwcx4rm0vhCtLydNbHv8DEZz0jPRJJqr1DvtkVuYXltTE5EXZQU9
         Sm2A==
X-Gm-Message-State: AC+VfDzBTCCaYQ3z9nEoYoscMRjXn8zoCAHtvmRsk9uIfEbQTsdTDP1i
        HIba/mS7yRfZHhkFYfFjo1D7yF7DCFg=
X-Google-Smtp-Source: ACHHUZ5pZ/KxriacKs7N9kO++B61WB3hKCcy3YRvR+LY4c2RM83PkAV2/tnsnYh8EDJP0sDsrIZRsg==
X-Received: by 2002:a05:6a20:a124:b0:10a:ef63:4c33 with SMTP id q36-20020a056a20a12400b0010aef634c33mr1436626pzk.47.1686745447385;
        Wed, 14 Jun 2023 05:24:07 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id i21-20020aa78d95000000b0064d34ace753sm10386180pfr.114.2023.06.14.05.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 05:23:54 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ksmbd: add mnt_want_write to ksmbd vfs functions
Date:   Wed, 14 Jun 2023 21:23:19 +0900
Message-Id: <20230614122319.16381-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd is doing write access using vfs helpers. There are the cases that
mnt_want_write() is not called in vfs helper. This patch add missing
mnt_want_write() to ksmbd vfs functions.

Cc: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 22 +++++++---------
 fs/smb/server/smbacl.c  |  6 ++---
 fs/smb/server/vfs.c     | 56 ++++++++++++++++++++++++++++++++++-------
 fs/smb/server/vfs.h     | 10 ++++----
 4 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 82cadebec459..176061cfe674 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2263,8 +2263,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			/* if the EA doesn't exist, just do nothing. */
 			rc = 0;
 		} else {
-			rc = ksmbd_vfs_setxattr(idmap,
-						path->dentry, attr_name, value,
+			rc = ksmbd_vfs_setxattr(idmap, path, attr_name, value,
 						le16_to_cpu(eabuf->EaValueLength), 0);
 			if (rc < 0) {
 				ksmbd_debug(SMB,
@@ -2321,8 +2320,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
-	rc = ksmbd_vfs_setxattr(idmap, path->dentry,
-				xattr_stream_name, NULL, 0, 0);
+	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
 	return 0;
@@ -2397,8 +2395,7 @@ static void smb2_new_xattrs(struct ksmbd_tree_connect *tcon, const struct path *
 	da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 		XATTR_DOSINFO_ITIME;
 
-	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt),
-					    path->dentry, &da);
+	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da);
 	if (rc)
 		ksmbd_debug(SMB, "failed to store file attribute into xattr\n");
 }
@@ -2970,7 +2967,7 @@ int smb2_open(struct ksmbd_work *work)
 		struct inode *inode = d_inode(path.dentry);
 
 		posix_acl_rc = ksmbd_vfs_inherit_posix_acl(idmap,
-							   path.dentry,
+							   &path,
 							   d_inode(path.dentry->d_parent));
 		if (posix_acl_rc)
 			ksmbd_debug(SMB, "inherit posix acl failed : %d\n", posix_acl_rc);
@@ -2986,7 +2983,7 @@ int smb2_open(struct ksmbd_work *work)
 			if (rc) {
 				if (posix_acl_rc)
 					ksmbd_vfs_set_init_posix_acl(idmap,
-								     path.dentry);
+								     &path);
 
 				if (test_share_config_flag(work->tcon->share_conf,
 							   KSMBD_SHARE_FLAG_ACL_XATTR)) {
@@ -3026,7 +3023,7 @@ int smb2_open(struct ksmbd_work *work)
 
 					rc = ksmbd_vfs_set_sd_xattr(conn,
 								    idmap,
-								    path.dentry,
+								    &path,
 								    pntsd,
 								    pntsd_size);
 					kfree(pntsd);
@@ -5462,7 +5459,7 @@ static int smb2_rename(struct ksmbd_work *work,
 			goto out;
 
 		rc = ksmbd_vfs_setxattr(file_mnt_idmap(fp->filp),
-					fp->filp->f_path.dentry,
+					&fp->filp->f_path,
 					xattr_stream_name,
 					NULL, 0, 0);
 		if (rc < 0) {
@@ -5627,8 +5624,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 			XATTR_DOSINFO_ITIME;
 
-		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap,
-						    filp->f_path.dentry, &da);
+		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da);
 		if (rc)
 			ksmbd_debug(SMB,
 				    "failed to restore file attribute in EA\n");
@@ -7483,7 +7479,7 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
 		ret = ksmbd_vfs_set_dos_attrib_xattr(idmap,
-						     fp->filp->f_path.dentry, &da);
+						     &fp->filp->f_path, &da);
 		if (ret)
 			fp->f_ci->m_fattr = old_fattr;
 	}
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index a93ae72fe4ef..7c99e6ebee9f 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1162,8 +1162,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			pntsd_size += sizeof(struct smb_acl) + nt_size;
 		}
 
-		ksmbd_vfs_set_sd_xattr(conn, idmap,
-				       path->dentry, pntsd, pntsd_size);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
 		kfree(pntsd);
 	}
 
@@ -1415,8 +1414,7 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		/* Update WinACL in xattr */
 		ksmbd_vfs_remove_sd_xattrs(idmap, path->dentry);
-		ksmbd_vfs_set_sd_xattr(conn, idmap,
-				       path->dentry, pntsd, ntsd_len);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
 	}
 
 out:
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 23eb1da4bcad..eaa42f04303d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -439,7 +439,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	memcpy(&stream_buf[*pos], buf, count);
 
 	err = ksmbd_vfs_setxattr(idmap,
-				 fp->filp->f_path.dentry,
+				 &fp->filp->f_path,
 				 fp->stream.name,
 				 (void *)stream_buf,
 				 size,
@@ -585,6 +585,10 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
 		goto out_err;
 	}
 
+	err = mnt_want_write(path->mnt);
+	if (err)
+		goto out_err;
+
 	idmap = mnt_idmap(path->mnt);
 	if (S_ISDIR(d_inode(path->dentry)->i_mode)) {
 		err = vfs_rmdir(idmap, d_inode(parent), path->dentry);
@@ -595,6 +599,7 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
 		if (err)
 			ksmbd_debug(VFS, "unlink failed, err %d\n", err);
 	}
+	mnt_drop_write(path->mnt);
 
 out_err:
 	ksmbd_revert_fsids(work);
@@ -690,6 +695,10 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 		goto out2;
 	}
 
+	err = mnt_want_write(old_path->mnt);
+	if (err)
+		goto out2;
+
 	trap = lock_rename_child(old_child, new_path.dentry);
 
 	old_parent = dget(old_child->d_parent);
@@ -753,6 +762,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 out3:
 	dput(old_parent);
 	unlock_rename(old_parent, new_path.dentry);
+	mnt_drop_write(old_path->mnt);
 out2:
 	path_put(&new_path);
 
@@ -893,19 +903,24 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
  * Return:	0 on success, otherwise error
  */
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
-		       struct dentry *dentry, const char *attr_name,
+		       const struct path *path, const char *attr_name,
 		       void *attr_value, size_t attr_size, int flags)
 {
 	int err;
 
+	err = mnt_want_write(path->mnt);
+	if (err)
+		return err;
+
 	err = vfs_setxattr(idmap,
-			   dentry,
+			   path->dentry,
 			   attr_name,
 			   attr_value,
 			   attr_size,
 			   flags);
 	if (err)
 		ksmbd_debug(VFS, "setxattr failed, err %d\n", err);
+	mnt_drop_write(path->mnt);
 	return err;
 }
 
@@ -1020,6 +1035,10 @@ int ksmbd_vfs_unlink(struct file *filp)
 	struct dentry *dir, *dentry = filp->f_path.dentry;
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 
+	err = mnt_want_write(filp->f_path.mnt);
+	if (err)
+		return err;
+
 	dir = dget_parent(dentry);
 	err = ksmbd_vfs_lock_parent(dir, dentry);
 	if (err)
@@ -1037,6 +1056,7 @@ int ksmbd_vfs_unlink(struct file *filp)
 		ksmbd_debug(VFS, "failed to delete, err %d\n", err);
 out:
 	dput(dir);
+	mnt_drop_write(filp->f_path.mnt);
 
 	return err;
 }
@@ -1370,13 +1390,14 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(struct mnt_idmap *id
 
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   struct smb_ntsd *pntsd, int len)
 {
 	int rc;
 	struct ndr sd_ndr = {0}, acl_ndr = {0};
 	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl, *def_smb_acl = NULL;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 
 	acl.version = 4;
@@ -1428,7 +1449,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 		goto out;
 	}
 
-	rc = ksmbd_vfs_setxattr(idmap, dentry,
+	rc = ksmbd_vfs_setxattr(idmap, path,
 				XATTR_NAME_SD, sd_ndr.data,
 				sd_ndr.offset, 0);
 	if (rc < 0)
@@ -1518,7 +1539,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 }
 
 int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
-				   struct dentry *dentry,
+				   const struct path *path,
 				   struct xattr_dos_attrib *da)
 {
 	struct ndr n;
@@ -1528,7 +1549,7 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 	if (err)
 		return err;
 
-	err = ksmbd_vfs_setxattr(idmap, dentry, XATTR_NAME_DOS_ATTRIBUTE,
+	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
 				 (void *)n.data, n.offset, 0);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
@@ -1765,10 +1786,11 @@ void ksmbd_vfs_posix_lock_unblock(struct file_lock *flock)
 }
 
 int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
-				 struct dentry *dentry)
+				 struct path *path)
 {
 	struct posix_acl_state acl_state;
 	struct posix_acl *acls;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	int rc;
 
@@ -1798,6 +1820,11 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 		return -ENOMEM;
 	}
 	posix_state_to_acl(&acl_state, acls->a_entries);
+
+	rc = mnt_want_write(path->mnt);
+	if (rc)
+		goto out_err;
+
 	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
 	if (rc < 0)
 		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
@@ -1809,16 +1836,20 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
 				    rc);
 	}
+	mnt_drop_write(path->mnt);
+
+out_err:
 	free_acl_state(&acl_state);
 	posix_acl_release(acls);
 	return rc;
 }
 
 int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
-				struct dentry *dentry, struct inode *parent_inode)
+				struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
 	struct posix_acl_entry *pace;
+	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	int rc, i;
 
@@ -1837,6 +1868,10 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 		}
 	}
 
+	rc = mnt_want_write(path->mnt);
+	if (rc)
+		goto out_err;
+
 	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
 	if (rc < 0)
 		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
@@ -1848,6 +1883,9 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
 				    rc);
 	}
+	mnt_drop_write(path->mnt);
+
+out_err:
 	posix_acl_release(acls);
 	return rc;
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 68fe8347e1d5..13f0e6958838 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -108,7 +108,7 @@ ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
 				int attr_name_len);
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
-		       struct dentry *dentry, const char *attr_name,
+		       const struct path *path, const char *attr_name,
 		       void *attr_value, size_t attr_size, int flags);
 int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
 				size_t *xattr_stream_name_size, int s_type);
@@ -144,21 +144,21 @@ int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap,
 			       struct dentry *dentry);
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
-			   struct dentry *dentry,
+			   const struct path *path,
 			   struct smb_ntsd *pntsd, int len);
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   struct smb_ntsd **pntsd);
 int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
-				   struct dentry *dentry,
+				   const struct path *path,
 				   struct xattr_dos_attrib *da);
 int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
 				   struct dentry *dentry,
 				   struct xattr_dos_attrib *da);
 int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
-				 struct dentry *dentry);
+				 struct path *path);
 int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
-				struct dentry *dentry,
+				struct path *path,
 				struct inode *parent_inode);
 #endif /* __KSMBD_VFS_H__ */
-- 
2.25.1

