Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1C1B423F;
	Tue, 31 Dec 2024 22:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684552; cv=none; b=YFzFJ7Jf1ilYR15/mXYtIi44CzY9FAkw/AjFFGXoWr0KRhQcHk0WTEhhOAKMd8FHLmBCSzZ9Ieqgwv1tRRtkMfC+jqh/0204tHkH95nVussuyhzsx8jV5ntznDFytsx1F21PL18M79Qkc90SQ+UeB4LM6FMXUyXAN/8UsmdK5gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684552; c=relaxed/simple;
	bh=5FhqwMpNh+GxOZdVjCIrqXAW5O5GZC6ckTBgwbfr7cQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Visbnz3414R07xcD//9U3fQXVyqokridGWuTrOMZF/X+955sA8PW0q03SIbLz8fhl1UhB2dwAwDZQFjTnfFqy85HERth9G7vANV1a5yCxfhisI1KnYLoC9ul6SxNTZWCszigU/phyRvCWs6ZKm3XZCm3warb0n3AFGJgrSBr2PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3QUSnri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3QUSnri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3DFC4CEDD;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684552;
	bh=5FhqwMpNh+GxOZdVjCIrqXAW5O5GZC6ckTBgwbfr7cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3QUSnrioqsKnghsxySA5s/sCe3DPnLFpVqdiwmzF29unI7Mb8STDfnWREgBzxfZP
	 pCxx5/Io4a58SQC8tjeC+E1hetIuCPVtd6KCs2JU/wMsu47qQ4c2ABVSMIR0AzuFc7
	 aro6vUuMD1B8zeP8+O6fU2xAFa9clj38knV4oMlZGFavS94npQmXOUDclR5p2skJBd
	 V644n3L1Bln4qyEJG3O3aPDDTnhmdyS/dMuXcyluNCqzaPBojXlSfAmBAO0T33gagx
	 M9PL+DvOoJ03t0cd9FrjbkB+JRavr4rhKh8PG3rMQGRWHDbzS7dRYMlZWN8kTaFc/q
	 ytEJEvW9tvc0g==
Received: by pali.im (Postfix)
	id 682F9D12; Tue, 31 Dec 2024 23:35:41 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] cifs: Improve detect_directory_symlink_target() function
Date: Tue, 31 Dec 2024 23:35:14 +0100
Message-Id: <20241231223514.15595-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223514.15595-1-pali@kernel.org>
References: <20241231223514.15595-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function detect_directory_symlink_target() is not curruntly able to detect
if the target path is directory in case the path is in the DELETE_PENDING
state or the user has not granted FILE_READ_ATTRIBUTES permission on the
path. This limitation is written in TODO comment.

Resolve this problem by replacing code which determinate path type by the
query_path_info() callback, which now is able to handle all these cases.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 75 ++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 50 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 69efbcae6683..ad53b9b4a238 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -248,18 +248,16 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 					   bool *directory)
 {
 	char sep = CIFS_DIR_SEP(cifs_sb);
-	struct cifs_open_parms oparms;
+	struct cifs_open_info_data query_info;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	const char *basename;
-	struct cifs_fid fid;
 	char *resolved_path;
 	int full_path_len;
 	int basename_len;
 	int symname_len;
 	char *path_sep;
-	__u32 oplock;
-	int open_rc;
+	int query_rc;
 
 	/*
 	 * First do some simple check. If the original Linux symlink target ends
@@ -282,7 +280,8 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	if (symname[0] == '/') {
 		cifs_dbg(FYI,
 			 "%s: cannot determinate if the symlink target path '%s' "
-			 "is directory or not, creating '%s' as file symlink\n",
+			 "is directory or not because path is absolute, "
+			 "creating '%s' as file symlink\n",
 			 __func__, symname, full_path);
 		return 0;
 	}
@@ -320,58 +319,34 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	if (sep == '\\')
 		convert_delimiter(path_sep, sep);
 
+	/*
+	 * Query resolved SMB symlink path and check if it is a directory or not.
+	 * Callback query_path_info() already handles cases when the server does
+	 * not grant FILE_READ_ATTRIBUTES permission for object, or when server
+	 * denies opening the object (e.g. because of DELETE_PENDING state).
+	 */
 	tcon = tlink_tcon(tlink);
-	oparms = CIFS_OPARMS(cifs_sb, tcon, resolved_path,
-			     FILE_READ_ATTRIBUTES, FILE_OPEN, 0, ACL_NO_MODE);
-	oparms.fid = &fid;
-
-	/* Try to open as a directory (NOT_FILE) */
-	oplock = 0;
-	oparms.create_options = cifs_create_options(cifs_sb,
-						    CREATE_NOT_FILE | OPEN_REPARSE_POINT);
-	open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
-	if (open_rc == 0) {
-		/* Successful open means that the target path is definitely a directory. */
-		*directory = true;
-		tcon->ses->server->ops->close(xid, tcon, &fid);
-	} else if (open_rc == -ENOTDIR) {
-		/* -ENOTDIR means that the target path is definitely a file. */
-		*directory = false;
-	} else if (open_rc == -ENOENT) {
+	query_rc = tcon->ses->server->ops->query_path_info(xid, tcon, cifs_sb,
+							   resolved_path, &query_info);
+	if (query_rc == 0) {
+		/* Query on path was successful, so just check for directory attr. */
+		*directory = le32_to_cpu(query_info.fi.Attributes) & ATTR_DIRECTORY;
+	} else if (query_rc == -ENOENT) {
 		/* -ENOENT means that the target path does not exist. */
 		cifs_dbg(FYI,
 			 "%s: symlink target path '%s' does not exist, "
 			 "creating '%s' as file symlink\n",
 			 __func__, symname, full_path);
 	} else {
-		/* Try to open as a file (NOT_DIR) */
-		oplock = 0;
-		oparms.create_options = cifs_create_options(cifs_sb,
-							    CREATE_NOT_DIR | OPEN_REPARSE_POINT);
-		open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
-		if (open_rc == 0) {
-			/* Successful open means that the target path is definitely a file. */
-			*directory = false;
-			tcon->ses->server->ops->close(xid, tcon, &fid);
-		} else if (open_rc == -EISDIR) {
-			/* -EISDIR means that the target path is definitely a directory. */
-			*directory = true;
-		} else {
-			/*
-			 * This code branch is called when we do not have a permission to
-			 * open the resolved_path or some other client/process denied
-			 * opening the resolved_path.
-			 *
-			 * TODO: Try to use ops->query_dir_first on the parent directory
-			 * of resolved_path, search for basename of resolved_path and
-			 * check if the ATTR_DIRECTORY is set in fi.Attributes. In some
-			 * case this could work also when opening of the path is denied.
-			 */
-			cifs_dbg(FYI,
-				 "%s: cannot determinate if the symlink target path '%s' "
-				 "is directory or not, creating '%s' as file symlink\n",
-				 __func__, symname, full_path);
-		}
+		/*
+		 * This code branch is called when we do not have a permission to
+		 * query the resolved_path or some other error occurred during query.
+		 */
+		cifs_dbg(FYI,
+			 "%s: cannot determinate if the symlink target path '%s' "
+			 "is directory or not because query path failed (%d), "
+			 "creating '%s' as file symlink\n",
+			 __func__, symname, query_rc, full_path);
 	}
 
 	kfree(resolved_path);
-- 
2.20.1

