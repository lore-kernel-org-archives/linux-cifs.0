Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=fAHx9+ceAg6W/2kIvFxiqyGabQbGY1tG1VSCSGFh/O/Q+vWl2w0udOb+2m6R2ZRNGOx7
	 I8bLKrBzBk4uN8r4RriLa4QuB+kJkTxcEwsNoOArm/dzmclZnj/45zOv5rY1dRmRDbZsq
	 nyWVYqzHFGGbLATpq3yZrZArP+1k9cvoEOpeuI94smKLe7XNDy51YXIdc6GSR9iQXhKJD
	 ZJWtJlRTED0QMm1iVuihsiCAoJvKV5f/FeqXWUyQiUolQKqvnIXdzAGlRSG4e8Pct9cZG
	 Xtl5bcS6XPytcFjD+QBnZmjAdiDbokbOxGsDdv6jTUYd9B9rY64T7+Ww7WfV08JNPGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XILVu3ePTxb8quX/ZTzf+V7Gy+Nb88dDjus+T2CDvc4=;
	b=F2LSBhBUgAwbNF+o4NdBF46JgXDLKMkR6IqQgP+74LXRF9etlnAthiz7BFRjemSQ1Pye
	 ys6jOsoYLGVyqsaKBFPkfRuTerI1KSdzM6m5zPgFmWQd3FMbMWbH07+6YXiXsQtVLynO1
	 FirQP3INK2wS3OGRUHpQtHhSIyu5J0Exyk9RFGyjTa67AO03m+V5vbC2U+OGu7dfvGNqE
	 Rc6gUQCX8MPPhFMFT/0u45PrRB/f+KxotCSFKYZ5wu56137wFn/TzTaO/MwuHPvG3ksMp
	 pp9ieDiT6+zRMWchJT/Pz50hx0fhOrUDrTYC4/lCT6oWsPtXn8KZ/rHwZ4IsT8OHbaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nE8XNJfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD103606A31D;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nE8XNJfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592F61F031E0;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053573;
	bh=XILVu3ePTxb8quX/ZTzf+V7Gy+Nb88dDjus+T2CDvc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nE8XNJfjJOLVD8fmhpMOL/sUvIY/04acKVti10OEfrDWBQ7j7qe1JfV9TnmSq0Vdf
	 77/CRBvUJc5Z/HrtzRsGR55aTxDU5MHU8FKeqUTAMnGHs8xwwXXow0Gfy6jfvht9m5
	 +EGUREDTSiDyvNqI03QAzahZDskxG8Yo2IYVfpyqBxGO+IlKdXWWbDkeCnOgGAznVY
	 03QhEuxSnFL+kNNXJfII67/k72VPXI71ySwpYmVvdlj2Vzpvv6q846StbabJIOyi3d
	 kBXHOaBGC+RlMEAj6fPF/29YJlaaBCU0HsbAYjzg/oH/KoZwP138Yv0aP/ThC/YC7T
	 HRi88WD38wvLg==
Received: by pali.im (Postfix)
	id E0614ACA; Mon, 26 Oct 2026 23:26:09 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 2/9] cifs: Remove cifs_backup_query_path_info() and replace it by cifs_query_path_info()
Date: Mon, 26 Oct 2026 23:25:53 +0100
Message-Id: <20261026222600.17323-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
index f29555f3c7d0..3620eb378deb 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1070,61 +1070,6 @@ static __u64 simple_hashstr(const char *str)
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
@@ -1340,45 +1285,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
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
@@ -1393,9 +1299,6 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
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

