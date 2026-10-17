Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5209620D4FC
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199079; cv=none; b=iiARqw54BeOkWATRZXDT+OyM+aHDwe/E5GV8nwvAk9/9SBmI0CFqeV7G+fh/Tzt+do+A+74iB1FZjeUwSYI+Q9RXJt04g8Moczjxz65LV5TzNMcnvuw4cGNmv/7x9mGi0zOMVjqSv/d4tOJ82AO+989j1NDr32DGHzpi+bRJKyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199079; c=relaxed/simple;
	bh=2iX7sM6v7VwoTdn9dKtS2+e7CdOsKNtKeph/cVouWQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gRDtLJ9ME/qtMpywPH6ZhqEeMGz8KnHumU0Lr1GlNu/pbDtlJnKypv/6XxaCAuOMpW5witEuBoEfzvE7z3aDw8CiTgXisGL+ogGw7dMPuSSYbqzSjQDGfAarq8VavWfPp/1bkrC6VQmIeVesEG+L2D+VDnjU94GTmovRpV86GkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gliwBw+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gliwBw+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E721F000C4;
	Sat, 17 Oct 2026 01:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199078;
	bh=7XVvZiTN9eLAPhVyQ9IscE2qS4X85Xv+zF1X8w4hlc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gliwBw+9exp3B4ySfXcetobe53enaGwnQjNd5dnNG1QF+i++lAPh26UzZy/oABezf
	 01lAbozskH6II9axTJ3ZTeey+GCqIi5/e+3zyTdVLbirg7r2Wm7dgNUt+pXYX8K54r
	 RTY9MoMnrxPBY9RBPfgcM1qG3xA0LOKjWxHowI+nOI6u1CAd/U9NQUapg2WdN0P2Eb
	 QJH5hdWcQkUkGVdG2SqCPwnQeGPuHYdFVlf8oRuNjbScwX4qPl4LuZS9OuPAcXm17U
	 0DfT/xQIj2C2sIVYg7sFV9zEM2WXpfabjgEIDoPy9Mxxbj6diIAuGf/Bq7AusEvuEL
	 6B6Ax/r6YKeGA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 17/22] ksmbd: apply POSIX mode ACEs in security updates
Date: Sat, 17 Oct 2026 10:03:39 +0900
Message-Id: <20261017010344.11478-17-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Explicit modes carried by NFS mode ACEs can be overwritten by the DACL
permission fallback, and security updates discard special mode bits.

Track modes supplied by ACCESS_ALLOWED NFS mode ACEs and bypass the
permission fallback for them. Apply both permission and special bits
when setting an explicit POSIX mode.

For SET_INFO, require a POSIX open for explicit mode changes and apply
the mode only when DACL security information is requested.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c |  7 +++++--
 fs/smb/server/smbacl.c  | 26 +++++++++++++++++++++++---
 fs/smb/server/smbacl.h  |  4 +++-
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 953a2eeaa15a..92489bb86791 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3667,7 +3667,8 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	    sizeof(struct create_sd_buf_req))
 		return -EINVAL;
 	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
-			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
+			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false,
+			    true, true);
 }
 
 static int ksmbd_acls_fattr(struct smb_fattr *fattr,
@@ -9241,7 +9242,9 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 		return -EACCES;
 
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
-			buf_len, false, true);
+			buf_len, false, true,
+			fp->conn->dialect == SMB311_PROT_ID && fp->is_posix_ctxt,
+			addition_info & DACL_SECINFO);
 }
 
 static int smb2_set_info_quota(struct ksmbd_work *work, struct ksmbd_file *fp,
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index e75247915c87..a01e0a8b76cb 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -477,10 +477,12 @@ static int parse_dacl(struct mnt_idmap *idmap,
 		ppace[i]->access_req =
 			smb_map_generic_desired_access(ppace[i]->access_req);
 
-		if (ppace[i]->sid.num_subauth >= 3 &&
+		if (ppace[i]->type == ACCESS_ALLOWED &&
+		    ppace[i]->sid.num_subauth >= 3 &&
 		    !(compare_sids(&ppace[i]->sid, &sid_unix_NFS_mode))) {
 			fattr->cf_mode =
 				le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+			fattr->cf_posix_mode = true;
 			break;
 		} else if (!compare_sids(&ppace[i]->sid, pownersid)) {
 			acl_mode = access_flags_to_mode(fattr,
@@ -546,6 +548,10 @@ static int parse_dacl(struct mnt_idmap *idmap,
 				((acl_mode & 0700) >> 6) | 0004;
 		}
 	}
+	if (fattr->cf_posix_mode) {
+		ret = 0;
+		goto out;
+	}
 
 	if (owner_found) {
 		/* The owner must be set to at least read-only. */
@@ -1673,7 +1679,8 @@ EXPORT_SYMBOL_IF_KUNIT(smb_check_perm_dacl);
 
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write)
+		 bool type_check, bool get_write, bool posix_open,
+		 bool dacl_requested)
 {
 	int rc;
 	struct smb_fattr fattr = {{0}};
@@ -1688,6 +1695,14 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	rc = parse_sec_desc(idmap, pntsd, ntsd_len, &fattr);
 	if (rc)
 		goto out;
+	if (fattr.cf_posix_mode && !dacl_requested) {
+		fattr.cf_posix_mode = false;
+		fattr.cf_mode = inode->i_mode;
+	}
+	if (fattr.cf_posix_mode && !posix_open) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
 
 	newattrs.ia_valid = ATTR_CTIME;
 	if (!uid_eq(fattr.cf_uid, INVALID_UID)) {
@@ -1699,7 +1714,12 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		newattrs.ia_gid = fattr.cf_gid;
 	}
 	newattrs.ia_valid |= ATTR_MODE;
-	newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
+	if (fattr.cf_posix_mode)
+		newattrs.ia_mode = (inode->i_mode & ~07777) |
+				   (fattr.cf_mode & 07777);
+	else
+		newattrs.ia_mode = (inode->i_mode & ~0777) |
+				   (fattr.cf_mode & 0777);
 
 	ksmbd_vfs_remove_acl_xattrs(idmap, path);
 	/* Update posix acls */
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index 01810c16cc04..c9705548efb2 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -43,6 +43,7 @@ struct smb_fattr {
 	kuid_t	cf_uid;
 	kgid_t	cf_gid;
 	umode_t	cf_mode;
+	bool	cf_posix_mode;
 	__le32 daccess;
 	struct posix_acl *cf_acls;
 	struct posix_acl *cf_dacls;
@@ -99,7 +100,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write);
+		 bool type_check, bool get_write, bool posix_open,
+		 bool dacl_requested);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_init_domain(u32 *sub_auth);
 size_t smb_acl_sec_desc_scratch_len(struct smb_fattr *fattr,
-- 
2.25.1

