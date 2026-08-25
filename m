Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761F23AD539;
	Tue, 25 Aug 2026 23:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699200; cv=none; b=XZnR60CDKNTivvrT4fYs4ZFEJ+PplDuzWOOu6KRXjsAgz2WpWMj15N4S3UgRPDqGa2EFZgOVCetlVn2W1amI/YuK97OXDLgpg/zxXbGtu12a3TikrFNkmBIyVWT0edC9/emaudnnioVk1maZl8KEiTNoxGhRv85tyx9LL2pYcqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699200; c=relaxed/simple;
	bh=pFzHvlTXc1rqFQljxVWQXdatV81xMEL+ZNONZpGfWrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2V2p5n8EtNqup0+KHHO6CBgJpzP8ZdwY3+lIj0BcZZb+iLyfE2cZZve20fYv7MK+V9FQezvuSWDd9jlheTPRFnw6GWykqcnOu86YYDSPeJ24om9oHaECfcNDogiXd9S9CU+cTAoOityoWEJPt1/MHJlyzMRSFjiBiajoW471kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CGErFt6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CGErFt6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70A1F00A3A;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699198;
	bh=yX1zCwM0MN6Wp1aXNNFAVvJ91aOPpZNfkxMWeKivRhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGErFt6TVevbBEvFCgcBwIehQyJUBCsfSNBssZkKWelSPS1PHpm4jdN3Sx53v1BvE
	 T6kuILJuM75CJXsXJkvUitoA8R6u69GGcKhhDYhR8dH+vYDXZLAJXerVSd7+f/RzUK
	 8nmhsEmhLNN+JlVQLVezqx+WNPksSMrHFPwF2rwMgAvFTioMVaf1K+nVj4C7zcnCZQ
	 7kIT7SFi+mLNuWEddCDbzM570F4iagm89J7cP2UKdzkr9OdTQHYIPjyYSpddTLxmrA
	 D96mmxzfv3XBtQTXbZx7wBxKL6gWqWIeW32Kh8XU1lTYwL/hTV4/vaViv6tswvzT6X
	 1kAlfoTLvTIXA==
Received: by pali.im (Postfix)
	id 45F5BB82; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] cifs: Remove cifs_backup_query_path_info() and replace it by cifs_query_path_info()
Date: Wed, 26 Aug 2026 01:06:15 +0200
Message-Id: <20260825230622.24617-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
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
index 12ed8db10e00..4ccfc83f7d3b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1063,61 +1063,6 @@ static __u64 simple_hashstr(const char *str)
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
-	else if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_SERVER_INUM)
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
@@ -1333,45 +1278,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
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
-			FILE_ID_FULL_DIR_INFO *si;
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
-			si = (FILE_ID_FULL_DIR_INFO *)fi;
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
@@ -1386,9 +1292,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 	/*
 	 * 4. Tweak fattr based on mount options
 	 */
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-handle_mnt_opt:
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 	sbflags = cifs_sb_flags(cifs_sb);
 	/* query for SFU type info if supported and needed */
 	if ((fattr->cf_cifsattrs & ATTR_SYSTEM) &&
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9c77752cb7f9..be73e4b9028c 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -569,15 +569,18 @@ static int cifs_query_path_info(const unsigned int xid,
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

