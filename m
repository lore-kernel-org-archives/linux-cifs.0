Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568713B6340
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773240066; cv=none; b=qmZoV3zVpW6voIJh4BBMtSiCZ9vZAz69WRB6PKtWMEItaIHKWfvPvMm8T9RHmUa/rBmz/+eiaUJjCUpsW98oL8foIwE8/MdlAYEmAm4LKgPybua3YPldzj0ezuftriBwc3t31HSOF8c4zspcOSZIuYtYksN0XhBtzWUIZ6yFvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773240066; c=relaxed/simple;
	bh=rcVGCVd+4u8nKu+oWGEqzh8R7eweeTuR7vHBJAPPnXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VSj7BFhibtYjDSAkxtDQdeC+ns0DwENt6RgdAVeKztMNSRH3sDLs56X1wB0+AFIeD/kR1Ij8ZdgjJSZTjdiTC78gfAHRZ3e31MHGhQ1UFdeqeQD25I32C78jsSORoEdj03W9Q9f6AUz7ouj01G1uJCkQ5eUGO6XbwZZhaD2Z5vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Y0JtvZlc; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Y0JtvZlc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WVtoeruvPvrFZg0wrQmWtQT912vvdc/LynjyKdaZqEI=; b=Y0JtvZlcUJ3G4rzWiZmpPFDvRD
	QxETQRhAoIEl31PPMIo2RFEaId+LOrEld8DJ5oOTh7ARzrG9Lo6dTHAWukiMt2bLthkRahM057fyr
	pbvRaIJltU0Ab3UQB0WeBNPOVJZQ7H6XLPuUPs6oIRjCvi3Zmo8RKJgNTf+yvO00YBAnZzzwPa/6x
	2Yv0eueC+rl2d78MCpMcSw/Si2U/3MbH33jgKbNbIVf0aPhPoFD/KKWiHTvf5/jrFmbjQgEd3hkv0
	X2O6uzx14U3KGfuyHLs2OTtQr7/BBniSMcDeo91OqM501gnQk/q17gio4gZc60+jk3J645TILzqlN
	2eo3MXew==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w0Kk3-00000000i11-0wQH;
	Wed, 11 Mar 2026 11:40:55 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix open handle lookup in cifs_open()
Date: Wed, 11 Mar 2026 11:40:55 -0300
Message-ID: <20260311144055.523527-1-pc@manguebit.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When looking up open handles to be re-used in cifs_open(), calling
cifs_get_{writable,readable}_path() is wrong as it will look up for
the first matching open handle, and if @file->f_flags doesn't match,
it will ignore the remaining open handles in
cifsInodeInfo::openFileList that might potentially match
@file->f_flags.

For writable handles, fix this by calling __cifs_get_writable_file()
directly with FIND_WR_OPEN_FLAGS, and for readable handles, call
find_readable_file().

With the patch, the following program ends up with two opens instead
of three sent over the wire.

```
  #define _GNU_SOURCE
  #include <unistd.h>
  #include <string.h>
  #include <fcntl.h>

  int main(int argc, char *argv[])
  {
          int fd;

          fd = open("/mnt/1/foo", O_CREAT | O_WRONLY | O_TRUNC, 0664);
          close(fd);
          fd = open("/mnt/1/foo", O_DIRECT | O_WRONLY);
          close(fd);
          fd = open("/mnt/1/foo", O_WRONLY);
          close(fd);
          fd = open("/mnt/1/foo", O_DIRECT | O_WRONLY);
          close(fd);
          return 0;
  }
```

```
$ mount.cifs //srv/share /mnt/1 -o ...
$ gcc test.c && ./a.out
```

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h | 13 +++++--
 fs/smb/client/file.c      | 75 ++++++++++++++++++++++++---------------
 3 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index bb0fe4b60240..d56eeeb8f2b8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1891,6 +1891,7 @@ enum cifs_writable_file_flags {
 	FIND_WR_FSUID_ONLY		= (1U << 0),
 	FIND_WR_WITH_DELETE		= (1U << 1),
 	FIND_WR_NO_PENDING_DELETE	= (1U << 2),
+	FIND_WR_OPEN_FLAGS		= (1U << 3),
 };
 
 #define   MID_FREE 0
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 800a7e418c32..683ba00297a3 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -138,8 +138,9 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata,
 				      ssize_t result);
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					int flags);
-int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
-			   struct cifsFileInfo **ret_file);
+int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+			     int find_flags, unsigned int open_flags,
+			     struct cifsFileInfo **ret_file);
 int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name, int flags,
 			   struct cifsFileInfo **ret_file);
 struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
@@ -596,4 +597,12 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 	}
 }
 
+static inline int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+					 int find_flags,
+					 struct cifsFileInfo **ret_file)
+{
+	find_flags &= ~FIND_WR_OPEN_FLAGS;
+	return __cifs_get_writable_file(cifs_inode, find_flags, 0, ret_file);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 13dda87f7711..2e261c22c0f3 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1061,32 +1061,26 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	/* Get the cached handle as SMB2 close is deferred */
 	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
-		rc = cifs_get_writable_path(tcon, full_path,
-					    FIND_WR_FSUID_ONLY |
-					    FIND_WR_NO_PENDING_DELETE,
-					    &cfile);
+		rc = __cifs_get_writable_file(CIFS_I(inode),
+					      FIND_WR_FSUID_ONLY |
+					      FIND_WR_NO_PENDING_DELETE |
+					      FIND_WR_OPEN_FLAGS,
+					      file->f_flags, &cfile);
 	} else {
-		rc = cifs_get_readable_path(tcon, full_path, &cfile);
+		cfile = find_readable_file(CIFS_I(inode), 0);
+		rc = cfile ? 0 : -ENOENT;
 	}
 	if (rc == 0) {
-		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
-		unsigned int cflags = cfile->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
-
-		if (cifs_convert_flags(oflags, 0) == cifs_convert_flags(cflags, 0) &&
-		    (oflags & (O_SYNC|O_DIRECT)) == (cflags & (O_SYNC|O_DIRECT))) {
-			file->private_data = cfile;
-			spin_lock(&CIFS_I(inode)->deferred_lock);
-			cifs_del_deferred_close(cfile);
-			spin_unlock(&CIFS_I(inode)->deferred_lock);
-			goto use_cache;
-		}
-		_cifsFileInfo_put(cfile, true, false);
-	} else {
-		/* hard link on the defeered close file */
-		rc = cifs_get_hardlink_path(tcon, inode, file);
-		if (rc)
-			cifs_close_deferred_file(CIFS_I(inode));
+		file->private_data = cfile;
+		spin_lock(&CIFS_I(inode)->deferred_lock);
+		cifs_del_deferred_close(cfile);
+		spin_unlock(&CIFS_I(inode)->deferred_lock);
+		goto use_cache;
 	}
+	/* hard link on the defeered close file */
+	rc = cifs_get_hardlink_path(tcon, inode, file);
+	if (rc)
+		cifs_close_deferred_file(CIFS_I(inode));
 
 	if (server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -2512,6 +2506,27 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 	netfs_write_subrequest_terminated(&wdata->subreq, result);
 }
 
+static bool open_flags_match(struct cifsInodeInfo *cinode,
+			     unsigned int oflags, unsigned int cflags)
+{
+	struct inode *inode = &cinode->netfs.inode;
+	int crw = 0, orw = 0;
+
+	oflags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+	cflags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+
+	if (cifs_fscache_enabled(inode)) {
+		if (OPEN_FMODE(cflags) & FMODE_WRITE)
+			crw = 1;
+		if (OPEN_FMODE(oflags) & FMODE_WRITE)
+			orw = 1;
+	}
+	if (cifs_convert_flags(oflags, orw) != cifs_convert_flags(cflags, crw))
+		return false;
+
+	return (oflags & (O_SYNC | O_DIRECT)) == (cflags & (O_SYNC | O_DIRECT));
+}
+
 struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
@@ -2547,17 +2562,17 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 }
 
 /* Return -EBADF if no handle is found and general rc otherwise */
-int
-cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
-		       struct cifsFileInfo **ret_file)
+int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
+			     int find_flags, unsigned int open_flags,
+			     struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
 	int rc = -EBADF;
 	unsigned int refind = 0;
-	bool fsuid_only = flags & FIND_WR_FSUID_ONLY;
-	bool with_delete = flags & FIND_WR_WITH_DELETE;
+	bool fsuid_only = find_flags & FIND_WR_FSUID_ONLY;
+	bool with_delete = find_flags & FIND_WR_WITH_DELETE;
 	*ret_file = NULL;
 
 	/*
@@ -2591,9 +2606,13 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 			continue;
 		if (with_delete && !(open_file->fid.access & DELETE))
 			continue;
-		if ((flags & FIND_WR_NO_PENDING_DELETE) &&
+		if ((find_flags & FIND_WR_NO_PENDING_DELETE) &&
 		    open_file->status_file_deleted)
 			continue;
+		if ((find_flags & FIND_WR_OPEN_FLAGS) &&
+		    !open_flags_match(cifs_inode, open_flags,
+				      open_file->f_flags))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-- 
2.53.0

