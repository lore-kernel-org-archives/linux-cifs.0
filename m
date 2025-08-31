Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BA125D218;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643795; cv=none; b=pF5FPZ7ietPLyiYEYNdopDMl6sWh3cQ+QE6Xr+eQIxFKmwxZdlnvToIyzHpzBUokg1NfHMATL53T8wp+HCfsn+Nt6G1GuukL4whL6I4Pl6HSzikkKBWXOtLMw0aRmOQM+VsQPdSuLeMX6sCbDo7f2KZERJEJDOeSez+Cq0BTvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643795; c=relaxed/simple;
	bh=DuCeT8rY6iS66n7NYmrNc7MoJE31jMTchtGIjhcADlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MHwTltFe9y6dZrAGafVjBLtfWD5Oqya+3A9iM0PXZynzV63rf+Dy7CDplfv/MAP5pLkqTld2ehKMIwejPk4qmUCnon4hIbsqXKXjor5Wcshw2oBBJfXuoI+FKwnaRjObR0l95H0P0lu5fjrhhjFJUO7MpSq7NynxCkr66jFZJFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZ8IRncX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZ8IRncX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1E2C4CEFA;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643795;
	bh=DuCeT8rY6iS66n7NYmrNc7MoJE31jMTchtGIjhcADlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ8IRncXSuxSdDqZPq6QN6VKw0YGZrOE3fgQduFt1XAex/19HPHbXSFxo0OfmtawL
	 NGQ22zx5cO6fFYDME0wPAwNJVhoCgPSpojFISM7ClWPgRp2bg09jSXhUXEuwt38SQB
	 W5DKcaSnOtAylkxWCr/XWAkc/v5UmFyTuIiFhsqr24VcCzjwOJTOqlBxWSPkLX7vk8
	 RQUyD9lNN4uIa2V23rk9cx3JZxNYVgnBpJKrfQZHMj2yVZSjHqUwcKGELD1+djdmMV
	 sWnv2ykZLW53g0Bml88RclGYPmJKz+z+Q2ZUDly1VK21Ak+m9zJ1xV1REQF5Hc6Dby
	 crv4anKXtMtOg==
Received: by pali.im (Postfix)
	id CEF701168; Sun, 31 Aug 2025 14:36:31 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/35] cifs: Remove cifs_backup_query_path_info() and replace it by cifs_query_path_info()
Date: Sun, 31 Aug 2025 14:35:33 +0200
Message-Id: <20250831123602.14037-7-pali@kernel.org>
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

Response handling of cifs_backup_query_path_info() function in
cifs_get_fattr() is broken and can cause buffer overflows because
cifs_backup_query_path_info() prepares request with different info levels
but the response parser in cifs_get_fattr() always expects response
structure FILE_DIRECTORY_INFO.

Code which queries file/dir attributes via CIFSFindFirst() is already
implemented in cifs_query_path_info() function, so extend it for
backup_cred(), which is the only missing functionality compared to
cifs_backup_query_path_info().

With this change the cifs_query_path_info() would do everything which is
open-coded in cifs_set_fattr_ino() and cifs_backup_query_path_info()
functions for SMB1. So remove that SMB1 code from cifs_set_fattr_ino() and
also remove whole cifs_backup_query_path_info() function.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c   | 97 -----------------------------------------
 fs/smb/client/smb1ops.c |  7 ++-
 2 files changed, 5 insertions(+), 99 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 75be4b46bc6f..cd06598eacbd 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1046,61 +1046,6 @@ static __u64 simple_hashstr(const char *str)
 	return hash;
 }
 
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-/**
- * cifs_backup_query_path_info - SMB1 fallback code to get ino
- *
- * Fallback code to get file metadata when we don't have access to
- * full_path (EACCES) and have backup creds.
- *
- * @xid:	transaction id used to identify original request in logs
- * @tcon:	information about the server share we have mounted
- * @sb:	the superblock stores info such as disk space available
- * @full_path:	name of the file we are getting the metadata for
- * @resp_buf:	will be set to cifs resp buf and needs to be freed with
- * 		cifs_buf_release() when done with @data
- * @data:	will be set to search info result buffer
- */
-static int
-cifs_backup_query_path_info(int xid,
-			    struct cifs_tcon *tcon,
-			    struct super_block *sb,
-			    const char *full_path,
-			    void **resp_buf,
-			    FILE_ALL_INFO **data)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifs_search_info info = {0};
-	u16 flags;
-	int rc;
-
-	*resp_buf = NULL;
-	info.endOfSearch = false;
-	if (tcon->unix_ext)
-		info.info_level = SMB_FIND_FILE_UNIX;
-	else if ((tcon->ses->capabilities &
-		  tcon->ses->server->vals->cap_nt_find) == 0)
-		info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
-		info.info_level = SMB_FIND_FILE_ID_FULL_DIR_INFO;
-	else /* no srvino useful for fallback to some netapp */
-		info.info_level = SMB_FIND_FILE_DIRECTORY_INFO;
-
-	flags = CIFS_SEARCH_CLOSE_ALWAYS |
-		CIFS_SEARCH_CLOSE_AT_END |
-		CIFS_SEARCH_BACKUP_SEARCH;
-
-	rc = CIFSFindFirst(xid, tcon, full_path,
-			   cifs_sb, NULL, flags, &info, false);
-	if (rc)
-		return rc;
-
-	*resp_buf = (void *)info.ntwrk_buf_start;
-	*data = (FILE_ALL_INFO *)info.srch_entries_start;
-	return 0;
-}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
 static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_block *sb,
 			       struct inode **inode, const char *full_path,
 			       struct cifs_open_info_data *data, struct cifs_fattr *fattr)
@@ -1314,45 +1259,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 		cifs_create_junction_fattr(fattr, sb);
 		rc = 0;
 		break;
-	case -EACCES:
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-		/*
-		 * perm errors, try again with backup flags if possible
-		 *
-		 * For SMB2 and later the backup intent flag
-		 * is already sent if needed on open and there
-		 * is no path based FindFirst operation to use
-		 * to retry with
-		 */
-		if (backup_cred(cifs_sb) && is_smb1_server(server)) {
-			/* for easier reading */
-			FILE_ALL_INFO *fi;
-			FILE_DIRECTORY_INFO *fdi;
-			SEARCH_ID_FULL_DIR_INFO *si;
-
-			rc = cifs_backup_query_path_info(xid, tcon, sb,
-							 full_path,
-							 &smb1_backup_rsp_buf,
-							 &fi);
-			if (rc)
-				goto out;
-
-			move_cifs_info_to_smb2(&data->fi, fi);
-			fdi = (FILE_DIRECTORY_INFO *)fi;
-			si = (SEARCH_ID_FULL_DIR_INFO *)fi;
-
-			cifs_dir_info_to_fattr(fattr, fdi, cifs_sb);
-			fattr->cf_uniqueid = le64_to_cpu(si->UniqueId);
-			/* uniqueid set, skip get inum step */
-			goto handle_mnt_opt;
-		} else {
-			/* nothing we can do, bail out */
-			goto out;
-		}
-#else
-		goto out;
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-		break;
 	default:
 		cifs_dbg(FYI, "%s: unhandled err rc %d\n", __func__, rc);
 		goto out;
@@ -1367,9 +1273,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 	/*
 	 * 4. Tweak fattr based on mount options
 	 */
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-handle_mnt_opt:
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 	/* query for SFU type info if supported and needed */
 	if ((fattr->cf_cifsattrs & ATTR_SYSTEM) &&
 	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)) {
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9dca458dbc96..55ab8a5b150c 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -584,15 +584,18 @@ static int cifs_query_path_info(const unsigned int xid,
 	/*
 	 * Then fallback to CIFSFindFirst() which works also with non-NT servers
 	 * but does not does not provide NumberOfLinks.
+	 * Can be used with backup intent flag to overcome -EACCES error.
 	 */
-	if ((rc == -EOPNOTSUPP || rc == -EINVAL) &&
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL ||
+	     (backup_cred(cifs_sb) && rc == -EACCES)) &&
 	    !non_unicode_wildcard) {
 		if (!(tcon->ses->capabilities & tcon->ses->server->vals->cap_nt_find))
 			search_info.info_level = SMB_FIND_FILE_INFO_STANDARD;
 		else
 			search_info.info_level = SMB_FIND_FILE_FULL_DIRECTORY_INFO;
 		rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb, NULL,
-				   CIFS_SEARCH_CLOSE_ALWAYS | CIFS_SEARCH_CLOSE_AT_END,
+				   CIFS_SEARCH_CLOSE_ALWAYS | CIFS_SEARCH_CLOSE_AT_END |
+				    (backup_cred(cifs_sb) ? CIFS_SEARCH_BACKUP_SEARCH : 0),
 				   &search_info, false);
 		if (rc == 0) {
 			if (!(tcon->ses->capabilities & tcon->ses->server->vals->cap_nt_find)) {
-- 
2.20.1

