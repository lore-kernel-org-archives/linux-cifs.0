Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78C41A4AD7;
	Thu, 12 Sep 2024 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142763; cv=none; b=H+X8Hk+kpH7/PfNi9rprPVcTPr1CIrc3PWdpxe6KgTJU0xv7PPLIW//sBTyea+nviEYNDznf1Ow2RPBxp66U8v9m7YuLqrGgIvNxH5op6iy6xfCxKVwy8dc7D5fziNcCkymIH+uMQkcgXITXhKR4fir1l6Xk+pwGTF5FvXJwDo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142763; c=relaxed/simple;
	bh=MTk345+qR8QZ1Q7CJWE+QoFTNgIlouwTcgnEBuCnNIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LUyk21/n/d6c5N4fYqV1yZdLe//0INaFPpFFiOV06kWw+jFqDH9VbNJbYB5P555V6IbbYUK6uDLY0yEPIiGzx1NllG6urV2JfmcB3AxZ8PE5jcK7w4Ku0GDanNCXTDmXOTtxDyAimeXcWfZHZlQDgEr+GNe79sjd67yEJc1wWKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBTo5NIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBTo5NIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AAAC4CED0;
	Thu, 12 Sep 2024 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142763;
	bh=MTk345+qR8QZ1Q7CJWE+QoFTNgIlouwTcgnEBuCnNIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBTo5NIA47GECeiYkbqlGmaKRyW/fJRN7p9M6Z8rfuMHcimuFYyDJYckxSRIKqqmX
	 +xbI7itEF0k32MOpJtvJl2tTEeQtH3Mh+vg6U8rXQbVIXbn7yVuWWybKkQcgqmFGiQ
	 Xj2o0qcPlAeBuMciAkYCGsz81mbFf66SR5SB4LKGingF9QBboM4KYOH2w3XWbIKKMk
	 AFw2jME0VH/YtbSHz1PjN+px2zv7Y3Lidz2Hv1yMq9gjNy/cKDdl2m4qoWBosFuG9e
	 iXf78GA/3iITJMwWJefUG89dZ6BNt2HVkMF0QBXalvlUpxQZ+2ByFbjtP6JSho64ZF
	 fq20kRVY+aHTQ==
Received: by pali.im (Postfix)
	id 1FAB1C59; Thu, 12 Sep 2024 14:05:56 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] cifs: Add support for creating SFU symlinks
Date: Thu, 12 Sep 2024 14:05:48 +0200
Message-Id: <20240912120548.15877-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When 'sfu' mount option is specified and 'mfsymlinks' is not specified then
create new symlinks in SFU-style. This will provide full SFU compatibility
when mounting share with 'sfu' option. 'mfsymlinks' override SFU for better
Apple compatibility as explained in fs_context.c smb3_update_mnt_flags()
function.

Extend __cifs_sfu_make_node() function, which now can handle also S_IFLNK
type and refactor structures passed to sync_write() in this function, by
splitting SFU type ("IntxCHR\0", "IntxBLK\0", "IntxLNK\1", "\0", "") and
SFU data from original combined struct win_dev (which could be used only
for block and char devices which had major and minor parts). This is needed
because type is variable-length and data is type specific.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h    |  6 ----
 fs/smb/client/cifsproto.h  |  4 +++
 fs/smb/client/fs_context.c | 13 ++++---
 fs/smb/client/link.c       |  3 ++
 fs/smb/client/smb2ops.c    | 71 +++++++++++++++++++++++++++-----------
 5 files changed, 66 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index a2072ab9e586..c3b6263060b0 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2573,12 +2573,6 @@ typedef struct {
 } __attribute__((packed)) FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp data */
 
 
-struct win_dev {
-	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO or LnxSOCK */
-	__le64 major;
-	__le64 minor;
-} __attribute__((packed));
-
 struct fea {
 	unsigned char EA_flags;
 	__u8 name_len;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 497bf3c447bc..791bddac0396 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -676,6 +676,10 @@ char *extract_sharename(const char *unc);
 int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data);
+int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+			 struct dentry *dentry, struct cifs_tcon *tcon,
+			 const char *full_path, umode_t mode, dev_t dev,
+			 const char *symname);
 int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bc926ab2555b..2f0c3894b0f7 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1896,14 +1896,17 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 	if (ctx->mfsymlinks) {
 		if (ctx->sfu_emul) {
 			/*
-			 * Our SFU ("Services for Unix" emulation does not allow
-			 * creating symlinks but does allow reading existing SFU
-			 * symlinks (it does allow both creating and reading SFU
-			 * style mknod and FIFOs though). When "mfsymlinks" and
+			 * Our SFU ("Services for Unix") emulation allows now
+			 * creating new and reading existing SFU symlinks.
+			 * Older Linux kernel versions were not able to neither
+			 * read existing nor create new SFU symlinks. But
+			 * creating and reading SFU style mknod and FIFOs was
+			 * supported for long time. When "mfsymlinks" and
 			 * "sfu" are both enabled at the same time, it allows
 			 * reading both types of symlinks, but will only create
 			 * them with mfsymlinks format. This allows better
-			 * Apple compatibility (probably better for Samba too)
+			 * Apple compatibility, compatibility with older Linux
+			 * kernel clients (probably better for Samba too)
 			 * while still recognizing old Windows style symlinks.
 			 */
 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 80099bbb333b..47ddeb7fa111 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -606,6 +606,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	/* BB what if DFS and this volume is on different share? BB */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
+	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+		rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
+					  full_path, S_IFLNK, 0, symname);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	} else if (pTcon->unix_ext) {
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9e90672caf60..b77a62ccec5c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5055,9 +5055,10 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
 	return 0;
 }
 
-static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
+int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path, umode_t mode, dev_t dev)
+				const char *full_path, umode_t mode, dev_t dev,
+				const char *symname)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
@@ -5065,36 +5066,61 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
 	unsigned int bytes_written;
-	struct win_dev pdev = {};
-	size_t pdev_len = 0;
-	struct kvec iov[2];
+	u8 type[8];
+	int type_len = 0;
+	struct {
+		__le64 major;
+		__le64 minor;
+	} __packed pdev = {};
+	__le16 *symname_utf16 = NULL;
+	u8 *data = NULL;
+	int data_len = 0;
+	struct kvec iov[3];
 	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
 	int rc;
 
 	switch (mode & S_IFMT) {
 	case S_IFCHR:
-		pdev_len = sizeof(pdev);
-		memcpy(pdev.type, "IntxCHR\0", 8);
+		type_len = 8;
+		memcpy(type, "IntxCHR\0", type_len);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
+		data = (u8 *)&pdev;
+		data_len = sizeof(pdev);
 		break;
 	case S_IFBLK:
-		pdev_len = sizeof(pdev);
-		memcpy(pdev.type, "IntxBLK\0", 8);
+		type_len = 8;
+		memcpy(type, "IntxBLK\0", type_len);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
+		data = (u8 *)&pdev;
+		data_len = sizeof(pdev);
+		break;
+	case S_IFLNK:
+		type_len = 8;
+		memcpy(type, "IntxLNK\1", type_len);
+		symname_utf16 = cifs_strndup_to_utf16(symname, strlen(symname),
+						      &data_len, cifs_sb->local_nls,
+						      NO_MAP_UNI_RSVD);
+		if (!symname_utf16) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		data_len -= 2; /* symlink is without trailing wide-nul */
+		data = (u8 *)symname_utf16;
 		break;
 	case S_IFSOCK:
 		/* SFU socket is system file with one zero byte */
-		pdev_len = 1;
-		pdev.type[0] = '\0';
+		type_len = 1;
+		type[0] = '\0';
 		break;
 	case S_IFIFO:
 		/* SFU fifo is system file which is empty */
-		pdev_len = 0;
+		type_len = 0;
 		break;
 	default:
-		return -EPERM;
+		rc = -EPERM;
+		goto out;
 	}
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
@@ -5104,20 +5130,25 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 
 	rc = server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
-		return rc;
+		goto out;
 
-	if (pdev_len > 0) {
+	if (type_len + data_len > 0) {
 		io_parms.pid = current->tgid;
 		io_parms.tcon = tcon;
-		io_parms.length = pdev_len;
-		iov[1].iov_base = &pdev;
-		iov[1].iov_len = pdev_len;
+		io_parms.length = type_len + data_len;
+		iov[1].iov_base = type;
+		iov[1].iov_len = type_len;
+		iov[2].iov_base = data;
+		iov[2].iov_len = data_len;
 
 		rc = server->ops->sync_write(xid, &fid, &io_parms,
-					     &bytes_written, iov, 1);
+					     &bytes_written, iov, 2);
 	}
 
 	server->ops->close(xid, tcon, &fid);
+
+out:
+	kfree(symname_utf16);
 	return rc;
 }
 
@@ -5129,7 +5160,7 @@ int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	int rc;
 
 	rc = __cifs_sfu_make_node(xid, inode, dentry, tcon,
-				  full_path, mode, dev);
+				  full_path, mode, dev, NULL);
 	if (rc)
 		return rc;
 
-- 
2.20.1

