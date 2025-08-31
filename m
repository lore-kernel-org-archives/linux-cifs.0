Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C49267386;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=eq0RwkEdAIGHRe2q6+6E7GPhOWzwynWcAdMN8MqcqoThv40P8ProD+ypIy9NTLngOKjvARoWYUcy2UtndKVPlB5oNefBFV5VfHRgaOQMgBMcdsFUUaRnKsoyKlta6GXNQLw/TVEAoZdoWNo+dduT7/XJr000+zLOSZaGLvpG1Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=jS3iUQivvb7RhPhXLqpAYxJyCsCjn5OHdf4ysw4mfY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRJgn7S7niapt9VoEIvfoUiTf+orHZqJAl8uCClzDJnqk6AKG6FOibXPeNlh7jt4p2KWIzlSyy8F6QVV+yVY5wlq8MAsDqSkAZ0uCtmx91KUSDHOrQbuP4zMiEy8Cg7qaX5K3z31UJBAU/yc7Io5D2W4NfHcERGqEwF/a/PEGgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvPEG5sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvPEG5sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDBAC4CEED;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=jS3iUQivvb7RhPhXLqpAYxJyCsCjn5OHdf4ysw4mfY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvPEG5syvUXoLTUgCcpHdsg/AZpLl+V9iXVuoX4d5laUEg3Hz3AaXYR2ZvaXVl5kT
	 Q7Mmm+/yjCCggf80fQ7onDQGFu8Z75o8/xvMJpkzXhSWR1L4Cpab3WYVmcMcIJYdD6
	 +9e/rF+ZHc1IDfA/yZjEZ0ElfiaPGoKotBeGnm/lJ4lRM2bGFBjD9V+ekeGmaSxI9f
	 nB5+1h2O88A2Y5BdwD2SlqcOnIaNn0DysitPVftDEj0BQxanCV0cu2COqXf/zgxhTd
	 PQ76EEHp+i9+OUUt92bHj7Hl5XjodcbjILxzPaB5TS7L9v/32RC+UP0hU93tWhw5aY
	 AVorBa9V5P0bA==
Received: by pali.im (Postfix)
	id 21B10598; Sun, 31 Aug 2025 14:36:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 22/35] cifs: Improve cifs_rename_pending_delete() to work without the PASSTHRU support
Date: Sun, 31 Aug 2025 14:35:49 +0200
Message-Id: <20250831123602.14037-23-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If PASSTHRU support is not supported by SMB server (which is currently
required for renaming the opened file) then rename the file via path before
opening it. This does not require PASSTHRU support on SMB server.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 63 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b0526787138d..9a5504a3406d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1711,9 +1711,13 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	__u32 dosattr, origattr;
+	char *sillyname_full_path = NULL;
+	bool can_rename_opened_file = true;
 	FILE_BASIC_INFO info_buf = {};
 	unsigned char sillyname[SILLYNAME_LEN + 1];
 	int sillyname_len;
+	const char *dirpath_end;
+	size_t dirpath_len;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -1747,13 +1751,26 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	}
 
 	/*
-	 * We cannot rename the file if the server doesn't support
-	 * CAP_INFOLEVEL_PASSTHRU
+	 * We cannot rename the opened file if the SMB1 server doesn't
+	 * support CAP_INFOLEVEL_PASSTHRU. But we can rename file via path.
 	 */
-	if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)) {
-		rc = -EBUSY;
+	if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
+		can_rename_opened_file = false;
+
+	dirpath_end = strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
+	if (!dirpath_end) {
+		rc = -EINVAL;
+		goto out;
+	}
+	dirpath_len = dirpath_end + 1 - full_path;
+
+	sillyname_full_path = kzalloc(dirpath_len + sillyname_len + 1, GFP_KERNEL);
+	if (!sillyname_full_path) {
+		rc = -ENOMEM;
 		goto out;
 	}
+	memcpy(sillyname_full_path, full_path, dirpath_len);
+	memcpy(sillyname_full_path + dirpath_len, sillyname, sillyname_len);
 
 	origattr = cifsInode->cifsAttrs & ~ATTR_NORMAL;
 
@@ -1784,6 +1801,16 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 			dosattr = origattr; /* since not able to change them */
 	}
 
+	/* rename the file path (before open if server does not support renaming opened file) */
+	if (!can_rename_opened_file) {
+		rc = tcon->ses->server->ops->rename(xid, tcon, dentry, full_path,
+						    sillyname_full_path, cifs_sb);
+		if (rc != 0) {
+			rc = -EBUSY;
+			goto undo_setattr;
+		}
+	}
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
@@ -1796,16 +1823,18 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc != 0)
-		goto undo_setattr;
+		goto undo_rename_path;
 
-	/* rename the file */
-	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
+	/* rename the opened file (if it was not already renamed before the open) */
+	if (can_rename_opened_file) {
+		rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
 				   false /* overwrite */,
 				   cifs_sb->local_nls,
 				   cifs_remap(cifs_sb));
-	if (rc != 0) {
-		rc = -EBUSY;
-		goto undo_close;
+		if (rc != 0) {
+			rc = -EBUSY;
+			goto undo_close;
+		}
 	}
 
 	/* try to set DELETE_PENDING */
@@ -1823,13 +1852,14 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		if (rc == -ENOENT)
 			rc = 0;
 		else if (rc != 0)
-			goto undo_rename;
+			goto undo_rename_opened_file;
 		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 	}
 
 	CIFSSMBClose(xid, tcon, fid.netfid);
 
 out:
+	kfree(sillyname_full_path);
 	cifs_put_tlink(tlink);
 	return rc;
 
@@ -1838,12 +1868,19 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	 * dealing with errors here since we can't do anything about
 	 * them anyway.
 	 */
-undo_rename:
-	CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_name.name,
+undo_rename_opened_file:
+	if (can_rename_opened_file)
+		CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_name.name,
 				true /* overwrite */,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
 undo_close:
 	CIFSSMBClose(xid, tcon, fid.netfid);
+undo_rename_path:
+	if (!can_rename_opened_file)
+		CIFSSMBRename(xid, tcon, dentry,
+				sillyname_full_path,
+				full_path,
+				cifs_sb);
 undo_setattr:
 	if (dosattr != origattr) {
 		info_buf.Attributes = cpu_to_le32(origattr);
-- 
2.20.1

