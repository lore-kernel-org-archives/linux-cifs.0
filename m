Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301294;
	b=dBhY+URPmuBGZgItO4yzAjhE5z89/UJS+DCfl8gh4mXLMxmPNjHv8Ya0btW3u7VpLveT
	 BvK1k+HPwwUa0OnRk/W7srFGaNNnqGjtCIZcPB6z1jHinfaccKWcu48abreUPrDLbjpP6
	 6qn9yPg68zOBk0xKpWihQ+YWrPkZxfkP5Z3egQGcegZ7yfXfiE+FQnfuo4kA+TGwdbicW
	 n2aom37CpyIrC37+nO340atxwJGQxBOu3tMJoUWfzK1ONkNEtTDFk2KzZDTViBqgv5lSP
	 wWmW+hw0tRy0wqGgkO1SO2CXuOLQ5MWZdT0v0CI6Za4GVJoJT31txogX702WcIdspog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301294;
	h=DMARC-Filter:DKIM-Signature:X-Virus-Scanned:Received:From:To:Cc:
	 Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=i6U554pIZDyRRDpm5VeHs9j2QQbJD58wC4vG/s0hFZM=;
	b=Ar0J52qhungGyU10vltKQaHu0Ent+ZdCObUAH+CeXaUnXBFT1Mj4nacp7U3jsbWUKaVK
	 SDWnfq4IwnhsYqXPgPT3b41wuMWdLDvHjYd+KS1KjW2/WiPEpxinrWC9POC8Qeqkg+ZBh
	 Sisz7gCpgsnPf4djij8qs7L1pYAmEwnp1Q9KFsStRs4JxnJr/8aaIybn4CnVGu4Gt2iD6
	 Ah2CY6HxvMmamW96FF+JEVhntYPEXGN4AKOGMNIGuIimao3lsB5q8jFQv/r3yLat1MtEA
	 sNZ4pZP0cq4alxsKwPqdHki/otIoxbuSJCIK72refj2G7oLsUgAbzfnoyA2kbRX3nlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=pass smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=IDk79aKZ;
	arc=none smtp.remote-ip=173.212.254.19
Received: from proxyplus-primary (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B19606A31C;
	Tue, 10 Nov 2026 09:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5B19606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=IDk79aKZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuxist.de; s=201705; h=from:to:subject:date:message-id; bh=i6U554pIZDyRRDpm5VeHs9j2QQbJD58wC4vG/s0hFZM=; b=IDk79aKZbEKuExt50JnRtrqq6KMFs3kKYbn2VHGuqw6V0s4uvdUiti/J7cP3dGvuDXuS/df1yYqzhJgK2DT2Dp5h7Ndism4U1BTdyoRqyXs2eIB43IlQVivPXJ42CG+u3Em6WgW15USq6Qj5WX5roUht5tRTv1p4VMBzFq388jBqLmDFp7k2b3XZovsec+9N1psgdFKCK1cew6nzLhPpHvqDThU6nTvWZOrRS8luO0YjyBsKneS7o4VE7DzgULLAHIIKGgG4/k63DI8xX+ciptveSB3nL2dEFUOIEVHRYe0GXce6e0iFMxlUw4aERLUDj2m5GRVfNlbSgIXXHAlbJg==
Authentication-Results: proxyplus-primary; auth=pass smtp.auth=713ee033-d4f8-4c9d-9e24-a891eb9c547d
X-Virus-Scanned: proxyplus-clamav builtin
Received: from groupi3 ([10.1.2.47]) by proxyplus-primary (ProxyPlus) with ESMTPSA; Tue, 10 Nov 2026 09:00:55 +0000
From: Jan Koester <jan.koester@tuxist.de>
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, brauner@kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/6] ksmbd: don't ignore the owner and group of a descriptor without a DACL
Date: Tue, 10 Nov 2026 09:02:27 +0000
Message-ID: <86878858c5973b660bd04a65@groupi3>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

parse_sec_desc() returned before looking at the owner and group SIDs
when the descriptor had no DACL_PRESENT, so an SMB2 SET_INFO with only
OWNER_SECURITY_INFORMATION or GROUP_SECURITY_INFORMATION -- what Windows
sends to take ownership, and smbcacls -C/-G -- did nothing and still
reported success.

Map the owner and group in any case and parse the DACL only if there is
one. set_info_sec() then changes the mode and the POSIX ACLs only for a
descriptor with a DACL, and leaves the stored descriptor alone without
one: replacing it would drop its DACL, and the owner shown comes from
the inode anyway. This also covers the SD buffer create context, so its
type_check argument goes away.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smbacl.c  | 39 ++++++++++++++++++++++++++-------------
 fs/smb/server/smbacl.h  |  2 +-
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 230bea45de..8e47d725c1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3661,7 +3661,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	    sizeof(struct create_sd_buf_req))
 		return -EINVAL;
 	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
-			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false);
+			    le32_to_cpu(sd_buf->ccontext.DataLength), false);
 }
 
 static void ksmbd_acls_fattr(struct smb_fattr *fattr,
@@ -8535,7 +8535,7 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 		return -EACCES;
 
 	return set_info_sec(fp->conn, fp->tcon, &fp->filp->f_path, pntsd,
-			buf_len, false, true);
+			buf_len, true);
 }
 
 /**
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 126264cc07..d1cf63a9fe 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1017,12 +1017,14 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		    le32_to_cpu(pntsd->sacloffset), dacloffset);
 
 	pntsd_type = le16_to_cpu(pntsd->type);
-	if (!(pntsd_type & DACL_PRESENT)) {
+	/*
+	 * Without a DACL only the owner and group change (Windows sends that
+	 * to take ownership): don't return before them.
+	 */
+	if (pntsd_type & DACL_PRESENT)
+		pntsd->type = cpu_to_le16(DACL_PRESENT);
+	else
 		ksmbd_debug(SMB, "DACL_PRESENT in DACL type is not set\n");
-		return rc;
-	}
-
-	pntsd->type = cpu_to_le16(DACL_PRESENT);
 
 	if (pntsd->osidoffset) {
 		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd))
@@ -1060,6 +1062,9 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		}
 	}
 
+	if (!(pntsd_type & DACL_PRESENT))
+		return 0;
+
 	if ((pntsd_type & (DACL_AUTO_INHERITED | DACL_AUTO_INHERIT_REQ)) ==
 	    (DACL_AUTO_INHERITED | DACL_AUTO_INHERIT_REQ))
 		pntsd->type |= cpu_to_le16(DACL_AUTO_INHERITED);
@@ -1768,18 +1773,21 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write)
+		 bool get_write)
 {
 	int rc;
 	struct smb_fattr fattr = {{0}};
 	struct inode *inode = d_inode(path->dentry);
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct iattr newattrs;
+	bool dacl;
 
 	fattr.cf_uid = INVALID_UID;
 	fattr.cf_gid = INVALID_GID;
 	fattr.cf_mode = inode->i_mode;
 
+	/* parse_sec_desc() rewrites type */
+	dacl = le16_to_cpu(pntsd->type) & DACL_PRESENT;
 	rc = parse_sec_desc(idmap, pntsd, ntsd_len, &fattr);
 	if (rc)
 		goto out;
@@ -1793,12 +1801,14 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		newattrs.ia_valid |= ATTR_GID;
 		newattrs.ia_gid = fattr.cf_gid;
 	}
-	newattrs.ia_valid |= ATTR_MODE;
-	newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
-
-	ksmbd_vfs_remove_acl_xattrs(idmap, path);
+	/* only the owner and group without a DACL: mode and ACLs stay */
+	if (dacl) {
+		newattrs.ia_valid |= ATTR_MODE;
+		newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
+		ksmbd_vfs_remove_acl_xattrs(idmap, path);
+	}
 	/* Update posix acls */
-	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
+	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && dacl && fattr.cf_dacls) {
 		rc = set_posix_acl(idmap, path->dentry,
 				   ACL_TYPE_ACCESS, fattr.cf_acls);
 		if (rc < 0)
@@ -1821,8 +1831,11 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	if (rc)
 		goto out;
 
-	/* Check it only calling from SD BUFFER context */
-	if (type_check && !(le16_to_cpu(pntsd->type) & DACL_PRESENT))
+	/*
+	 * The stored descriptor keeps its DACL when only the owner or group
+	 * changed: the owner shown is the inode's anyway.
+	 */
+	if (!dacl)
 		goto out;
 
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index b6a01f0d45..d4c9b679d8 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -99,7 +99,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			bool strict);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
-		 bool type_check, bool get_write);
+		 bool get_write);
 void id_to_sid(unsigned int cid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_uid_to_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid);
 void ksmbd_gid_to_sid(kgid_t gid, uint sidtype, struct smb_sid *ssid);
-- 
2.56.0
