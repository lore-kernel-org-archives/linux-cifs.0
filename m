Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDC42F5095
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751478013; cv=none; b=HGzwUdRYLnrJbUKJmgeWjMRFfUATdrJoDBH+c1RzbQMDpuTfIWzYtUtQ6KawnUzg/EE8+up2LjOM1FU2p6agbkb07e0TWX9optP7U6SWm/KA1Cz5k9al+RWMuA13ZmIGmH3B9wzfJV5NWR9YsuMQCsr7qSZvSfWIfgcr4TsAuKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751478013; c=relaxed/simple;
	bh=xFsuWI2eCuvnBuAZc1WxLx5r8Sak/UAxs9LjmlpRGeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNDM/wW2GkJ2OuXNUyTtSXotZJqaCzWV63aARc7xkC88CvGUFG+hEm4vQP7wMwzOyOMm5n1X6ntkmWnUqO+mLZLjiNLMJFi/wag7Cdt/HBh+jeaAONKg2i0Maub87/lcThCuhXXVpmBjtseY4B5Cm9T9HWv19FNmuqEGPuD2LQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=DJomQ5Sd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="DJomQ5Sd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:In-Reply-To:Content-Type:References:Reply-To:
	Content-ID:Content-Description;
	bh=StxU5GDN6DukLcpSirv/LC9ZOwmt+/INH1M0VUw7CRw=; b=DJomQ5SdptNVnQ2YzZ8J3wyNgK
	y4fFVAPwhWOPKBgA/Ea6X12E1TTLFrndUJmBh15kUrRG6T63xXBitNTi8yVv8X3vrdEd2QF50I3jV
	kXJbxZakGzEj07tGEPpwb/6wmzooPb/v8oDOBBxBuuHcbAS4XXbjo9+5qSkFGXTQ2Y7+ifqJQEnwR
	zSF0VjuhkXxqRRhXi0zNouBAGefKIyAACHSphZvssPdq/G5qFO1QAm7czEu3HM25+rfgMRkh5BQG4
	7kNeRP0YtUsNn7LI6FHWPmYNRvUknoyARzHr3xadCswcnae9N41mFGFcqBfg47JPM93KRvkONggYX
	t3fRV+ow==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uX1RC-000000010HY-2PU5;
	Wed, 02 Jul 2025 14:40:02 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Pierguido Lambri <plambri@redhat.com>,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH] smb: client: fix native SMB symlink traversal
Date: Wed,  2 Jul 2025 14:40:01 -0300
Message-ID: <20250702174001.911761-1-pc@manguebit.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We've seen customers having shares mounted in paths like /??/C:/ or
/??/UNC/foo.example.com/share in order to get their native SMB
symlinks successfully followed from different mounts.

After commit 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks"),
the client would then convert absolute paths from /??/C:/ to "/mnt/c/"
by default.  The absolute paths would vary depending on the value of
symlink= mount option.

Fix this by restoring old behavior of not trying to convert absolute
paths by default.  Only do this if symlinkroot= was _explicitly_ set.

Before patch:

  $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3.1.1,username=xxx,password=yyy
  $ ls -l /mnt/1/symlink2
  lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> /mnt/c/testfile
  $ mkdir -p /??/C:; echo foo > //??/C:/testfile
  $ cat /mnt/1/symlink2
  cat: /mnt/1/symlink2: No such file or directory

After patch:

  $ mount.cifs //w22-fs0/test2 /mnt/1 -o vers=3.1.1,username=xxx,password=yyy
  $ ls -l /mnt/1/symlink2
  lrwxr-xr-x 1 root root 15 Jun 20 14:22 /mnt/1/symlink2 -> '/??/C:/testfile'
  $ mkdir -p /??/C:; echo foo > //??/C:/testfile
  $ cat /mnt/1/symlink2
  foo

Cc: linux-cifs@vger.kernel.org
Cc: Pierguido Lambri <plambri@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/fs_context.c | 13 ++++---------
 fs/smb/client/reparse.c    | 22 +++++++++++++---------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a634a34d4086..d8d2d4a739e8 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1825,9 +1825,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			goto cifs_parse_mount_err;
 		}
 		kfree(ctx->symlinkroot);
-		ctx->symlinkroot = kstrdup(param->string, GFP_KERNEL);
-		if (!ctx->symlinkroot)
+		ctx->symlinkroot = kstrndup(param->string, PATH_MAX, GFP_KERNEL);
+		if (!ctx->symlinkroot) {
+			cifs_errorf(fc, "OOM when copying symlinkroot string\n");
 			goto cifs_parse_mount_err;
+		}
 		break;
 	}
 	/* case Opt_ignore: - is ignored as expected ... */
@@ -1837,13 +1839,6 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		goto cifs_parse_mount_err;
 	}
 
-	/*
-	 * By default resolve all native absolute symlinks relative to "/mnt/".
-	 * Same default has drvfs driver running in WSL for resolving SMB shares.
-	 */
-	if (!ctx->symlinkroot)
-		ctx->symlinkroot = kstrdup("/mnt/", GFP_KERNEL);
-
 	return 0;
 
  cifs_parse_mount_err:
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 1c40e42e4d89..5fa29a97ac15 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -57,6 +57,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	struct reparse_symlink_data_buffer *buf = NULL;
 	struct cifs_open_info_data data = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	const char *symroot = cifs_sb->ctx->symlinkroot;
 	struct inode *new;
 	struct kvec iov;
 	__le16 *path = NULL;
@@ -82,7 +83,8 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		.symlink_target = symlink_target,
 	};
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
+	    symroot && symname[0] == '/') {
 		/*
 		 * This is a request to create an absolute symlink on the server
 		 * which does not support POSIX paths, and expects symlink in
@@ -92,7 +94,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		 * ensure compatibility of this symlink stored in absolute form
 		 * on the SMB server.
 		 */
-		if (!strstarts(symname, cifs_sb->ctx->symlinkroot)) {
+		if (!strstarts(symname, symroot)) {
 			/*
 			 * If the absolute Linux symlink target path is not
 			 * inside "symlinkroot" location then there is no way
@@ -101,12 +103,12 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 			cifs_dbg(VFS,
 				 "absolute symlink '%s' cannot be converted to NT format "
 				 "because it is outside of symlinkroot='%s'\n",
-				 symname, cifs_sb->ctx->symlinkroot);
+				 symname, symroot);
 			rc = -EINVAL;
 			goto out;
 		}
-		len = strlen(cifs_sb->ctx->symlinkroot);
-		if (cifs_sb->ctx->symlinkroot[len-1] != '/')
+		len = strlen(symroot);
+		if (symroot[len - 1] != '/')
 			len++;
 		if (symname[len] >= 'a' && symname[len] <= 'z' &&
 		    (symname[len+1] == '/' || symname[len+1] == '\0')) {
@@ -782,6 +784,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			      const char *full_path,
 			      struct cifs_sb_info *cifs_sb)
 {
+	const char *symroot = cifs_sb->ctx->symlinkroot;
 	char sep = CIFS_DIR_SEP(cifs_sb);
 	char *linux_target = NULL;
 	char *smb_target = NULL;
@@ -815,7 +818,8 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 		goto out;
 	}
 
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) && !relative) {
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS) &&
+	    symroot && !relative) {
 		/*
 		 * This is an absolute symlink from the server which does not
 		 * support POSIX paths, so the symlink is in NT-style path.
@@ -907,15 +911,15 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 		}
 
 		abs_path_len = strlen(abs_path)+1;
-		symlinkroot_len = strlen(cifs_sb->ctx->symlinkroot);
-		if (cifs_sb->ctx->symlinkroot[symlinkroot_len-1] == '/')
+		symlinkroot_len = strlen(symroot);
+		if (symroot[symlinkroot_len - 1] == '/')
 			symlinkroot_len--;
 		linux_target = kmalloc(symlinkroot_len + 1 + abs_path_len, GFP_KERNEL);
 		if (!linux_target) {
 			rc = -ENOMEM;
 			goto out;
 		}
-		memcpy(linux_target, cifs_sb->ctx->symlinkroot, symlinkroot_len);
+		memcpy(linux_target, symroot, symlinkroot_len);
 		linux_target[symlinkroot_len] = '/';
 		memcpy(linux_target + symlinkroot_len + 1, abs_path, abs_path_len);
 	} else if (smb_target[0] == sep && relative) {
-- 
2.50.0

