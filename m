Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F226262FCD;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=W92tnl61HYKwJWTNsuhagToBc4aXkv7Yc+eNaZEpQWGgW+CaBNbJwv4EPzThTokygmEKhJYWxh0o/6nPDbAUTh5eSA0kgIX5ZXKsuddi4IpERojIDAOVixMY5iM+yNTyZD9V5Q+XFRPsNFB4lmnTRvCyTgW/zcO0ZrVR7RHXwb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=TnPcF/6qorEoK+kPpWDJGGJ4T8oJ3meDyJpxJleBazA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b7Qlq/N0FeYS08BjYL74K3cOs1aN2EuXzfiKZey6UMldv386MtE/sh+fch/2czlqxuxIU/2mUaO7gz9vzFUrCl3OiyIHoEFcjfi59Bca145Hy/pIHPcbW6bds2JzUQxPm/mV8gTptEJMHfAbodtjQqn5jXKbiaxERPGZn26FZTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSIGQFQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSIGQFQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F72C4CEF5;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=TnPcF/6qorEoK+kPpWDJGGJ4T8oJ3meDyJpxJleBazA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSIGQFQXTmIbJGwFAu2Q0/ZROKk5VUz8SK21TD90twLwTURjNPTtW/20V6JhGp/ke
	 wKiGx2lpdFyDyeuX1ga+m/Ercee6OHmCy3eIcNxO96RBZ2ktU8r+UwKCmElr4fGZBd
	 pT19AsXObJTqOJs1RcAd3GQdotBesz8gAiSFITfejTCay4pFSKwAYo8dt96g8qtqkt
	 MZBvrzGs5ZwdX1PFu/BuBFZsjfYfxggPMVhAnRwWm8X3rjaATCAMDnW4GlGZMEKZG5
	 1+1RzFnaOFCHa3LBIBOE6yPw5bo+Htz/OKd1I133j9ENbYFqjQcW/k9uDDykBTEssc
	 D9uUh+pP3lcLw==
Received: by pali.im (Postfix)
	id 9D92812DE; Sun, 31 Aug 2025 14:36:32 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/35] cifs: Improve detect_directory_symlink_target() function
Date: Sun, 31 Aug 2025 14:35:37 +0200
Message-Id: <20250831123602.14037-11-pali@kernel.org>
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

Function detect_directory_symlink_target() is not currently able to detect
if the target path is directory in case the path is in the DELETE_PENDING
state or the user has not granted FILE_READ_ATTRIBUTES permission on the
path. This limitation is written in TODO comment.

Resolve this problem by replacing code which determinate path type by the
query_path_info() callback, which now is able to handle all these cases.

Depends on "cifs: Improve SMB2+ stat() to work also for paths in
DELETE_PENDING state".

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 75 ++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 50 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 7869cec58f52..236629778e1c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -250,18 +250,16 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
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
@@ -284,7 +282,8 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	if (symname[0] == '/') {
 		cifs_dbg(FYI,
 			 "%s: cannot determinate if the symlink target path '%s' "
-			 "is directory or not, creating '%s' as file symlink\n",
+			 "is directory or not because path is absolute, "
+			 "creating '%s' as file symlink\n",
 			 __func__, symname, full_path);
 		return 0;
 	}
@@ -322,58 +321,34 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
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

