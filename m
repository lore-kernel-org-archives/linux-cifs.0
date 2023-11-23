Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA098D66
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:47 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cf8b35a6dbso3202895ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:45:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729147; x=1701333947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LkX3oEL4+rBLKPshyi2trsxy2+WHbKareK88TG6h/Lw=;
        b=gEPBGjTWhtyzh1gJh8Ks6qu0YYEJWa/JfJWobriETJSM396S0MVQNeERzVQZThG6O8
         Qk88qZ3FgiKu+CT7EmPr6UJi8R0tqWphldIACljEX4QVq8dcHcisHFaj2Vk1BYy2JdLc
         nsThj+Lyolsz3ITqMvRTcgBONH0RpEcfjShLnnwEBlqwmmnNd+a9S5nHyuZRN7BnxfVV
         4rvPY4cHxfpIlIAaa+ZmsspIFDFeFnVyfXP8E/6L4e9fdlh3gvZii61qPPDrOow9pskP
         lSdYQN/BE3ZjsoyyFsd6kxrOGVHDRrHHkGGl1xNhqMEoV2qdViLsGR64hw+mgpgD6YqJ
         Y3CQ==
X-Gm-Message-State: AOJu0Yz1qlTO5BzBfJdkx48Xs7ijPk/ixCEPJX2UqBBTRa5nCgew6R90
	ao3LWgjVfqUklCXLATKRKt1ahisbvYE=
X-Google-Smtp-Source: AGHT+IE0hjbciajoWjPDPP0W38VdUw4W+8rOy/pwy1D4/G0aT3TRX25nc5e3q8oeNF7PhU7Da5P6UA==
X-Received: by 2002:a17:902:d2d1:b0:1cd:fbc7:2737 with SMTP id n17-20020a170902d2d100b001cdfbc72737mr5204572plc.52.1700729146829;
        Thu, 23 Nov 2023 00:45:46 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:45:45 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 1/6] ksmbd: fix possible deadlock in smb2_open
Date: Thu, 23 Nov 2023 17:45:02 +0900
Message-Id: <20231123084507.35584-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ 8743.393379] ======================================================
[ 8743.393385] WARNING: possible circular locking dependency detected
[ 8743.393391] 6.4.0-rc1+ #11 Tainted: G           OE
[ 8743.393397] ------------------------------------------------------
[ 8743.393402] kworker/0:2/12921 is trying to acquire lock:
[ 8743.393408] ffff888127a14460 (sb_writers#8){.+.+}-{0:0}, at: ksmbd_vfs_setxattr+0x3d/0xd0 [ksmbd]
[ 8743.393510]
               but task is already holding lock:
[ 8743.393515] ffff8880360d97f0 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}, at: ksmbd_vfs_kern_path_locked+0x181/0x670 [ksmbd]
[ 8743.393618]
               which lock already depends on the new lock.

[ 8743.393623]
               the existing dependency chain (in reverse order) is:
[ 8743.393628]
               -> #1 (&type->i_mutex_dir_key#6/1){+.+.}-{3:3}:
[ 8743.393648]        down_write_nested+0x9a/0x1b0
[ 8743.393660]        filename_create+0x128/0x270
[ 8743.393670]        do_mkdirat+0xab/0x1f0
[ 8743.393680]        __x64_sys_mkdir+0x47/0x60
[ 8743.393690]        do_syscall_64+0x5d/0x90
[ 8743.393701]        entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 8743.393711]
               -> #0 (sb_writers#8){.+.+}-{0:0}:
[ 8743.393728]        __lock_acquire+0x2201/0x3b80
[ 8743.393737]        lock_acquire+0x18f/0x440
[ 8743.393746]        mnt_want_write+0x5f/0x240
[ 8743.393755]        ksmbd_vfs_setxattr+0x3d/0xd0 [ksmbd]
[ 8743.393839]        ksmbd_vfs_set_dos_attrib_xattr+0xcc/0x110 [ksmbd]
[ 8743.393924]        compat_ksmbd_vfs_set_dos_attrib_xattr+0x39/0x50 [ksmbd]
[ 8743.394010]        smb2_open+0x3432/0x3cc0 [ksmbd]
[ 8743.394099]        handle_ksmbd_work+0x2c9/0x7b0 [ksmbd]
[ 8743.394187]        process_one_work+0x65a/0xb30
[ 8743.394198]        worker_thread+0x2cf/0x700
[ 8743.394209]        kthread+0x1ad/0x1f0
[ 8743.394218]        ret_from_fork+0x29/0x50

This patch add mnt_want_write() above parent inode lock and remove
nested mnt_want_write calls in smb2_open().

Fixes: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
Reported-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 47 +++++++++++++---------------
 fs/smb/server/smbacl.c  |  7 +++--
 fs/smb/server/smbacl.h  |  2 +-
 fs/smb/server/vfs.c     | 68 +++++++++++++++++++++++++----------------
 fs/smb/server/vfs.h     | 10 ++++--
 5 files changed, 75 insertions(+), 59 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 658209839729..c996264db2c6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2380,7 +2380,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = 0;
 		} else {
 			rc = ksmbd_vfs_setxattr(idmap, path, attr_name, value,
-						le16_to_cpu(eabuf->EaValueLength), 0);
+						le16_to_cpu(eabuf->EaValueLength),
+						0, true);
 			if (rc < 0) {
 				ksmbd_debug(SMB,
 					    "ksmbd_vfs_setxattr is failed(%d)\n",
@@ -2443,7 +2444,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
-	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0);
+	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
 	return 0;
@@ -2518,7 +2519,7 @@ static void smb2_new_xattrs(struct ksmbd_tree_connect *tcon, const struct path *
 	da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 		XATTR_DOSINFO_ITIME;
 
-	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da);
+	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da, false);
 	if (rc)
 		ksmbd_debug(SMB, "failed to store file attribute into xattr\n");
 }
@@ -2608,7 +2609,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	    sizeof(struct create_sd_buf_req))
 		return -EINVAL;
 	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
-			    le32_to_cpu(sd_buf->ccontext.DataLength), true);
+			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
 }
 
 static void ksmbd_acls_fattr(struct smb_fattr *fattr,
@@ -3152,7 +3153,8 @@ int smb2_open(struct ksmbd_work *work)
 								    idmap,
 								    &path,
 								    pntsd,
-								    pntsd_size);
+								    pntsd_size,
+								    false);
 					kfree(pntsd);
 					if (rc)
 						pr_err("failed to store ntacl in xattr : %d\n",
@@ -3228,12 +3230,6 @@ int smb2_open(struct ksmbd_work *work)
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)
 		ksmbd_fd_set_delete_on_close(fp, file_info);
 
-	if (need_truncate) {
-		rc = smb2_create_truncate(&path);
-		if (rc)
-			goto err_out;
-	}
-
 	if (req->CreateContextsOffset) {
 		struct create_alloc_size_req *az_req;
 
@@ -3398,11 +3394,12 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 err_out:
-	if (file_present || created) {
-		inode_unlock(d_inode(parent_path.dentry));
-		path_put(&path);
-		path_put(&parent_path);
-	}
+	if (file_present || created)
+		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
+
+	if (fp && need_truncate)
+		rc = smb2_create_truncate(&fp->filp->f_path);
+
 	ksmbd_revert_fsids(work);
 err_out1:
 	if (!rc) {
@@ -5537,7 +5534,7 @@ static int smb2_rename(struct ksmbd_work *work,
 		rc = ksmbd_vfs_setxattr(file_mnt_idmap(fp->filp),
 					&fp->filp->f_path,
 					xattr_stream_name,
-					NULL, 0, 0);
+					NULL, 0, 0, true);
 		if (rc < 0) {
 			pr_err("failed to store stream name in xattr: %d\n",
 			       rc);
@@ -5630,11 +5627,9 @@ static int smb2_create_link(struct ksmbd_work *work,
 	if (rc)
 		rc = -EINVAL;
 out:
-	if (file_present) {
-		inode_unlock(d_inode(parent_path.dentry));
-		path_put(&path);
-		path_put(&parent_path);
-	}
+	if (file_present)
+		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
+
 	if (!IS_ERR(link_name))
 		kfree(link_name);
 	kfree(pathname);
@@ -5701,7 +5696,8 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 			XATTR_DOSINFO_ITIME;
 
-		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da);
+		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da,
+				true);
 		if (rc)
 			ksmbd_debug(SMB,
 				    "failed to restore file attribute in EA\n");
@@ -6013,7 +6009,7 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 	fp->saccess |= FILE_SHARE_DELETE_LE;
 
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
-			buf_len, false);
+			buf_len, false, true);
 }
 
 /**
@@ -7582,7 +7578,8 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
 		ret = ksmbd_vfs_set_dos_attrib_xattr(idmap,
-						     &fp->filp->f_path, &da);
+						     &fp->filp->f_path,
+						     &da, true);
 		if (ret)
 			fp->f_ci->m_fattr = old_fattr;
 	}
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 51b8bfab7481..1164365533f0 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1185,7 +1185,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			pntsd_size += sizeof(struct smb_acl) + nt_size;
 		}
 
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size, false);
 		kfree(pntsd);
 	}
 
@@ -1377,7 +1377,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check)
+		 bool type_check, bool get_write)
 {
 	int rc;
 	struct smb_fattr fattr = {{0}};
@@ -1437,7 +1437,8 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		/* Update WinACL in xattr */
 		ksmbd_vfs_remove_sd_xattrs(idmap, path);
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, ntsd_len,
+				get_write);
 	}
 
 out:
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 49a8c292bd2e..2b52861707d8 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -207,7 +207,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			__le32 *pdaccess, int uid);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check);
+		 bool type_check, bool get_write);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index c53dea5598fc..533257b46fc1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -97,6 +97,13 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 		return -ENOENT;
 	}
 
+	err = mnt_want_write(parent_path->mnt);
+	if (err) {
+		path_put(parent_path);
+		putname(filename);
+		return -ENOENT;
+	}
+
 	inode_lock_nested(parent_path->dentry->d_inode, I_MUTEX_PARENT);
 	d = lookup_one_qstr_excl(&last, parent_path->dentry, 0);
 	if (IS_ERR(d))
@@ -123,6 +130,7 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 
 err_out:
 	inode_unlock(d_inode(parent_path->dentry));
+	mnt_drop_write(parent_path->mnt);
 	path_put(parent_path);
 	putname(filename);
 	return -ENOENT;
@@ -451,7 +459,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 fp->stream.name,
 				 (void *)stream_buf,
 				 size,
-				 0);
+				 0,
+				 true);
 	if (err < 0)
 		goto out;
 
@@ -593,10 +602,6 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
 		goto out_err;
 	}
 
-	err = mnt_want_write(path->mnt);
-	if (err)
-		goto out_err;
-
 	idmap = mnt_idmap(path->mnt);
 	if (S_ISDIR(d_inode(path->dentry)->i_mode)) {
 		err = vfs_rmdir(idmap, d_inode(parent), path->dentry);
@@ -607,7 +612,6 @@ int ksmbd_vfs_remove_file(struct ksmbd_work *work, const struct path *path)
 		if (err)
 			ksmbd_debug(VFS, "unlink failed, err %d\n", err);
 	}
-	mnt_drop_write(path->mnt);
 
 out_err:
 	ksmbd_revert_fsids(work);
@@ -907,18 +911,22 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
  * @attr_value:	xattr value to set
  * @attr_size:	size of xattr value
  * @flags:	destination buffer length
+ * @get_write:	get write access to a mount
  *
  * Return:	0 on success, otherwise error
  */
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 		       const struct path *path, const char *attr_name,
-		       void *attr_value, size_t attr_size, int flags)
+		       void *attr_value, size_t attr_size, int flags,
+		       bool get_write)
 {
 	int err;
 
-	err = mnt_want_write(path->mnt);
-	if (err)
-		return err;
+	if (get_write == true) {
+		err = mnt_want_write(path->mnt);
+		if (err)
+			return err;
+	}
 
 	err = vfs_setxattr(idmap,
 			   path->dentry,
@@ -928,7 +936,8 @@ int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 			   flags);
 	if (err)
 		ksmbd_debug(VFS, "setxattr failed, err %d\n", err);
-	mnt_drop_write(path->mnt);
+	if (get_write == true)
+		mnt_drop_write(path->mnt);
 	return err;
 }
 
@@ -1252,6 +1261,13 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 	}
 
 	if (!err) {
+		err = mnt_want_write(parent_path->mnt);
+		if (err) {
+			path_put(path);
+			path_put(parent_path);
+			return err;
+		}
+
 		err = ksmbd_vfs_lock_parent(parent_path->dentry, path->dentry);
 		if (err) {
 			path_put(path);
@@ -1261,6 +1277,14 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 	return err;
 }
 
+void ksmbd_vfs_kern_path_unlock(struct path *parent_path, struct path *path)
+{
+	inode_unlock(d_inode(parent_path->dentry));
+	mnt_drop_write(parent_path->mnt);
+	path_put(path);
+	path_put(parent_path);
+}
+
 struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
 					  const char *name,
 					  unsigned int flags,
@@ -1415,7 +1439,8 @@ static struct xattr_smb_acl *ksmbd_vfs_make_xattr_posix_acl(struct mnt_idmap *id
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len)
+			   struct smb_ntsd *pntsd, int len,
+			   bool get_write)
 {
 	int rc;
 	struct ndr sd_ndr = {0}, acl_ndr = {0};
@@ -1475,7 +1500,7 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 
 	rc = ksmbd_vfs_setxattr(idmap, path,
 				XATTR_NAME_SD, sd_ndr.data,
-				sd_ndr.offset, 0);
+				sd_ndr.offset, 0, get_write);
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
@@ -1564,7 +1589,8 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 
 int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 				   const struct path *path,
-				   struct xattr_dos_attrib *da)
+				   struct xattr_dos_attrib *da,
+				   bool get_write)
 {
 	struct ndr n;
 	int err;
@@ -1574,7 +1600,7 @@ int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 		return err;
 
 	err = ksmbd_vfs_setxattr(idmap, path, XATTR_NAME_DOS_ATTRIBUTE,
-				 (void *)n.data, n.offset, 0);
+				 (void *)n.data, n.offset, 0, get_write);
 	if (err)
 		ksmbd_debug(SMB, "failed to store dos attribute in xattr\n");
 	kfree(n.data);
@@ -1846,10 +1872,6 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 	}
 	posix_state_to_acl(&acl_state, acls->a_entries);
 
-	rc = mnt_want_write(path->mnt);
-	if (rc)
-		goto out_err;
-
 	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
 	if (rc < 0)
 		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
@@ -1861,9 +1883,7 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *idmap,
 			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
 				    rc);
 	}
-	mnt_drop_write(path->mnt);
 
-out_err:
 	free_acl_state(&acl_state);
 	posix_acl_release(acls);
 	return rc;
@@ -1893,10 +1913,6 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 		}
 	}
 
-	rc = mnt_want_write(path->mnt);
-	if (rc)
-		goto out_err;
-
 	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
 	if (rc < 0)
 		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
@@ -1908,9 +1924,7 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
 				    rc);
 	}
-	mnt_drop_write(path->mnt);
 
-out_err:
 	posix_acl_release(acls);
 	return rc;
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 00968081856e..cfe1c8092f23 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -109,7 +109,8 @@ ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				int attr_name_len);
 int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 		       const struct path *path, const char *attr_name,
-		       void *attr_value, size_t attr_size, int flags);
+		       void *attr_value, size_t attr_size, int flags,
+		       bool get_write);
 int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
 				size_t *xattr_stream_name_size, int s_type);
 int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
@@ -117,6 +118,7 @@ int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			       unsigned int flags, struct path *parent_path,
 			       struct path *path, bool caseless);
+void ksmbd_vfs_kern_path_unlock(struct path *parent_path, struct path *path);
 struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work,
 					  const char *name,
 					  unsigned int flags,
@@ -144,14 +146,16 @@ int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap, const struct path *path)
 int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
 			   const struct path *path,
-			   struct smb_ntsd *pntsd, int len);
+			   struct smb_ntsd *pntsd, int len,
+			   bool get_write);
 int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 			   struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   struct smb_ntsd **pntsd);
 int ksmbd_vfs_set_dos_attrib_xattr(struct mnt_idmap *idmap,
 				   const struct path *path,
-				   struct xattr_dos_attrib *da);
+				   struct xattr_dos_attrib *da,
+				   bool get_write);
 int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
 				   struct dentry *dentry,
 				   struct xattr_dos_attrib *da);
-- 
2.25.1

