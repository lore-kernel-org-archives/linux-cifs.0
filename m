Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5186F48095F;
	Mon,  7 Sep 2026 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781666; cv=none; b=QynVmi0vDR8rwE7Z2zIfqSnnxPx+i3m8MmscgPqelkB1Goa90RYqilPzEka7Ej6Kpqjftu09+s2zjeNXdNcGnQNT0WVcZWWjuhaHeJ03o4/2Y2OWwSOb7vmhPvdbX6wlYD8xCwPWeYZA91Sjr/X28GXH2UTF3vNhsuS6BS0Pw3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781666; c=relaxed/simple;
	bh=58Rtl+4ie1HMeGu6++ry/RZxwFL+2Sig6l9diZUs+6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgBQwD0BEtFdpYKG+ZhNnA2sqzIX7UbbHbOoBHfODb8DGl4d/q1VzJyF1y0LpoRk/I46cQe6UwYBqSf/Wkw3wEs5OnCgAsUWA2mtzviKKK4B6viCbiVJ3XshZOMrZb2AdFl+7Y9jDBZJtoDumgshvHi1VhkIjZ0qFUWq3hWLiE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dz0oqk7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dz0oqk7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D720D1F00A3A;
	Mon,  7 Sep 2026 11:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788781664;
	bh=na3SkmKuSNiVS9Qa8I8s0dayNc1u4gn9wB20/iJMFvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dz0oqk7YEaWzrLvU6pR+jhJyVD7fQcvHShHkpSmBQ/UeC9fwdtPtkJf5zs2qTw/s3
	 M0CNP6KwBE80E8mP8cTFvERkNYnZyN8VutPlynEmeAZXbR7tOdi6OmyZwIXWXCWkrt
	 vGQrIsbvDU/0nKfyvFPy+ZX5ugopciM0weLFi3uZAST93DlwANAfVtXbfCfjlXw8xO
	 NrA5nNbf/iUicyTy22/a25CW4DF/KI8QA/hqp2rWPwSpCYuuZXUG6hYgB1jIZHPXRI
	 +NpnsmVDpajjWtZv1SvW3xoifqtE5G+j2cNJnGrjcSG75PDXWhaeUuQDzh1tmVd1hR
	 LayZjhYvxejMg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/5] cifs: Scripted clean up fs/smb/client/cifs_unicode.h
Date: Mon,  7 Sep 2026 07:47:38 -0400
Message-ID: <20260907114742.2872537-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090351-popper-penpal-d0a0@gregkh>
References: <2026090351-popper-penpal-d0a0@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 696ca7d95658224ba807813101d0d5714d1d8aa4 ]

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_unicode.h | 17 +++++++++--------
 fs/smb/client/inode.c        | 26 ++++++++++++++------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifs_unicode.h b/fs/smb/client/cifs_unicode.h
index e137a0dfbbe9a..d69b64422fe98 100644
--- a/fs/smb/client/cifs_unicode.h
+++ b/fs/smb/client/cifs_unicode.h
@@ -56,19 +56,20 @@
 
 #ifdef __KERNEL__
 int cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
-		    const struct nls_table *cp, int map_type);
+		    const struct nls_table *codepage, int map_type);
 int cifs_utf16_bytes(const __le16 *from, int maxbytes,
 		     const struct nls_table *codepage);
-int cifs_strtoUTF16(__le16 *, const char *, int, const struct nls_table *);
+int cifs_strtoUTF16(__le16 *to, const char *from, int len,
+		    const struct nls_table *codepage);
 char *cifs_strndup_from_utf16(const char *src, const int maxlen,
 			      const bool is_unicode,
 			      const struct nls_table *codepage);
-extern int cifsConvertToUTF16(__le16 *target, const char *source, int maxlen,
-			      const struct nls_table *cp, int mapChars);
-extern int cifs_remap(struct cifs_sb_info *cifs_sb);
-extern __le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
-				     int *utf16_len, const struct nls_table *cp,
-				     int remap);
+int cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
+		       const struct nls_table *cp, int map_chars);
+int cifs_remap(struct cifs_sb_info *cifs_sb);
+__le16 *cifs_strndup_to_utf16(const char *src, const int maxlen,
+			      int *utf16_len, const struct nls_table *cp,
+			      int remap);
 #endif
 
 wchar_t cifs_toupper(wchar_t in);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b67b316538b83..8c422b3c73662 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3115,13 +3115,14 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		rc = cifs_set_file_size(inode, attrs, xid, full_path, direntry);
 		if (rc != 0)
 			goto out;
+		attrs->ia_valid &= ~(ATTR_CTIME | ATTR_MTIME);
 	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 		attrs->ia_valid &= ~ATTR_MODE;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
+	args = kmalloc_obj(*args);
 	if (args == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3217,6 +3218,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct cifsFileInfo *wfile;
 	struct cifs_tcon *tcon;
 	const char *full_path;
@@ -3231,7 +3233,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
@@ -3265,7 +3267,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	rc = 0;
 
 	if ((attrs->ia_valid & ATTR_MTIME) &&
-	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
+	    !(sbflags & CIFS_MOUNT_NOSSYNC)) {
 		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);
@@ -3291,8 +3293,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((sbflags & CIFS_MOUNT_CIFS_ACL) ||
+	    (sbflags & CIFS_MOUNT_MODE_FROM_SID)) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
@@ -3303,9 +3305,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				goto cifs_setattr_exit;
 			}
 		}
-	} else
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
+	} else if (!(sbflags & CIFS_MOUNT_SET_UID)) {
 		attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);
+	}
 
 	/* skip mode change if it's just for clearing setuid/setgid */
 	if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
@@ -3314,8 +3316,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		mode = attrs->ia_mode;
 		rc = 0;
-		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) ||
+		if ((sbflags & CIFS_MOUNT_CIFS_ACL) ||
+		    (sbflags & CIFS_MOUNT_MODE_FROM_SID) ||
 		    posix) {
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
 						INVALID_UID, INVALID_GID);
@@ -3338,7 +3340,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			dosattr = cifsInode->cifsAttrs | ATTR_READONLY;
 
 			/* fix up mode if we're not using dynperm */
-			if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM) == 0)
+			if ((sbflags & CIFS_MOUNT_DYNPERM) == 0)
 				attrs->ia_mode = inode->i_mode & ~S_IWUGO;
 		} else if ((mode & S_IWUGO) &&
 			   (cifsInode->cifsAttrs & ATTR_READONLY)) {
@@ -3349,7 +3351,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				dosattr |= ATTR_NORMAL;
 
 			/* reset local inode permissions to normal */
-			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+			if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
@@ -3358,7 +3360,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 					attrs->ia_mode |=
 						cifs_sb->ctx->file_mode;
 			}
-		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
+		} else if (!(sbflags & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
 			attrs->ia_valid &= ~ATTR_MODE;
 		}
-- 
2.53.0

