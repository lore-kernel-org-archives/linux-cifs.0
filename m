Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F01C285CAA
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463644; cv=none; b=f9841grRld86/D9MTjrfXFBD4q/reX31mKruxoQ0hBif77ybk/nqKjxrz8E5YCg0s9hyuINrhupTn9kOwydxY+hqcy2m41Q1KgW5P51OdYnybnyOMwraCpkRSQVelSfi1z843lWBMxn+L5T1Rkz7Bs0Mbk/DpPd3ffMv/oULgkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463644; c=relaxed/simple;
	bh=1rZUeHWWMYk8uM5B4DlpWta4YBcXE5YhE9fH+hNzK1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKVMxd5kGNNcCypV2nSPFLaEQyd2aWx9jI+gM7bFqVKfC3dE79egrrtksg+29cmlDpiDdDhAuK3zTSc7UFo0bu9vuPyOfSgDaW+77qFvUGRjowo+UbYofuVRpHOpxXnxCHigm0cZ1XNTp9xN1NucwoV5ut80KLfPKiq/pr/pBvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jHUTIbKu; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jHUTIbKu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IyOmR4T4qVq5Q2mfZc/53rp5C6u73fZwGWuH12xq5/s=;
	b=jHUTIbKuHBGVAc0haE1wj1yzJWaNnSnrsNJ/b1GxdJQhD3evn1kDBMVb2S8idubcFioJav
	8mWJ4xipFOpDj7Y169VuXb2TQme7l85ioo730maa2G/+ZJ0SNCsIB27KYFPIkh7WcJS+V3
	sZRqePeyjC/nE1xo9cMzV4c0MhWqBuM=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 7/7] smb: introduce struct file_posix_info
Date: Thu, 11 Dec 2025 22:32:28 +0800
Message-ID: <20251211143228.172470-8-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Modify the following places:

  - introduce new struct file_posix_info
  - some fields in "struct smb311_posix_qinfo" -> "struct file_posix_info"
  - some fields in "struct smb2_posix_info" -> "struct file_posix_info"

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/inode.c   | 22 ++++++------
 fs/smb/client/readdir.c | 28 ++++++++--------
 fs/smb/client/reparse.h |  4 +--
 fs/smb/client/smb2pdu.h | 15 +--------
 fs/smb/common/fscc.h    | 43 +++++++++++++++++++++++-
 fs/smb/common/smb2pdu.h | 25 --------------
 fs/smb/server/smb2pdu.c | 74 ++++++++++++++++++++---------------------
 fs/smb/server/smb2pdu.h | 21 +-----------
 8 files changed, 108 insertions(+), 124 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f9ee95953fa4..838f437654c7 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -841,16 +841,16 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 	memset(fattr, 0, sizeof(*fattr));
 
 	/* no fattr->flags to set */
-	fattr->cf_cifsattrs = le32_to_cpu(info->DosAttributes);
-	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
+	fattr->cf_cifsattrs = le32_to_cpu(info->fpinfo.DosAttributes);
+	fattr->cf_uniqueid = le64_to_cpu(info->fpinfo.Inode);
 
-	if (info->LastAccessTime)
-		fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
+	if (info->fpinfo.LastAccessTime)
+		fattr->cf_atime = cifs_NTtimeToUnix(info->fpinfo.LastAccessTime);
 	else
 		ktime_get_coarse_real_ts64(&fattr->cf_atime);
 
-	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
-	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
+	fattr->cf_ctime = cifs_NTtimeToUnix(info->fpinfo.ChangeTime);
+	fattr->cf_mtime = cifs_NTtimeToUnix(info->fpinfo.LastWriteTime);
 
 	if (data->adjust_tz) {
 		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
@@ -861,11 +861,11 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 	 * The srv fs device id is overridden on network mount so setting
 	 * @fattr->cf_rdev isn't needed here.
 	 */
-	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
-	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
-	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
-	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
-	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
+	fattr->cf_eof = le64_to_cpu(info->fpinfo.EndOfFile);
+	fattr->cf_bytes = le64_to_cpu(info->fpinfo.AllocationSize);
+	fattr->cf_createtime = le64_to_cpu(info->fpinfo.CreationTime);
+	fattr->cf_nlink = le32_to_cpu(info->fpinfo.HardLinks);
+	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->fpinfo.Mode),
 					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
 
 	if (cifs_open_data_reparse(data) &&
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 6844f1dc3921..5296e15e262b 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -247,22 +247,22 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	posix_info_parse(info, NULL, &parsed);
 
 	memset(fattr, 0, sizeof(*fattr));
-	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
-	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
-	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
+	fattr->cf_uniqueid = le64_to_cpu(info->fpinfo.Inode);
+	fattr->cf_bytes = le64_to_cpu(info->fpinfo.AllocationSize);
+	fattr->cf_eof = le64_to_cpu(info->fpinfo.EndOfFile);
 
-	fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
-	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
-	fattr->cf_ctime = cifs_NTtimeToUnix(info->CreationTime);
+	fattr->cf_atime = cifs_NTtimeToUnix(info->fpinfo.LastAccessTime);
+	fattr->cf_mtime = cifs_NTtimeToUnix(info->fpinfo.LastWriteTime);
+	fattr->cf_ctime = cifs_NTtimeToUnix(info->fpinfo.CreationTime);
 
-	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
-	fattr->cf_cifsattrs = le32_to_cpu(info->DosAttributes);
+	fattr->cf_nlink = le32_to_cpu(info->fpinfo.HardLinks);
+	fattr->cf_cifsattrs = le32_to_cpu(info->fpinfo.DosAttributes);
 
 	if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT)
-		fattr->cf_cifstag = le32_to_cpu(info->ReparseTag);
+		fattr->cf_cifstag = le32_to_cpu(info->fpinfo.ReparseTag);
 
 	/* The Mode field in the response can now include the file type as well */
-	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->Mode),
+	fattr->cf_mode = wire_mode_to_posix(le32_to_cpu(info->fpinfo.Mode),
 					    fattr->cf_cifsattrs & ATTR_DIRECTORY);
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
 
@@ -277,9 +277,9 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	}
 
 	cifs_dbg(FYI, "posix fattr: dev %d, reparse %d, mode %o\n",
-		 le32_to_cpu(info->DeviceId),
-		 le32_to_cpu(info->ReparseTag),
-		 le32_to_cpu(info->Mode));
+		 le32_to_cpu(info->fpinfo.DeviceId),
+		 le32_to_cpu(info->fpinfo.ReparseTag),
+		 le32_to_cpu(info->fpinfo.Mode));
 
 	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
 	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
@@ -516,7 +516,7 @@ static void cifs_fill_dirent_posix(struct cifs_dirent *de,
 	de->name = parsed.name;
 	de->namelen = parsed.name_len;
 	de->resume_key = info->Ignored;
-	de->ino = le64_to_cpu(info->Inode);
+	de->ino = le64_to_cpu(info->fpinfo.Inode);
 }
 
 static void cifs_fill_dirent_unix(struct cifs_dirent *de,
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 19caab2fd11e..fd7f14908075 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -105,10 +105,10 @@ static inline bool cifs_open_data_reparse(struct cifs_open_info_data *data)
 	if (data->contains_posix_file_info) {
 		struct smb311_posix_qinfo *fi = &data->posix_fi;
 
-		attrs = le32_to_cpu(fi->DosAttributes);
+		attrs = le32_to_cpu(fi->fpinfo.DosAttributes);
 		if (data->reparse_point) {
 			attrs |= ATTR_REPARSE_POINT;
-			fi->DosAttributes = cpu_to_le32(attrs);
+			fi->fpinfo.DosAttributes = cpu_to_le32(attrs);
 		}
 
 	} else {
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 4928fb620233..07ba081750fb 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -269,20 +269,7 @@ struct create_posix_rsp {
 struct smb2_posix_info {
 	__le32 NextEntryOffset;
 	__u32 Ignored;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 DosAttributes;
-	__le64 Inode;
-	__le32 DeviceId;
-	__le32 Zero;
-	/* beginning of POSIX Create Context Response */
-	__le32 HardLinks;
-	__le32 ReparseTag;
-	__le32 Mode;
+	struct file_posix_info fpinfo;
 	/*
 	 * var sized owner SID
 	 * var sized group SID
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 14688ab7ebd5..21752439f27e 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -528,9 +528,50 @@ struct file_notify_information {
 } __packed;
 
 /*
- * See POSIX Extensions to MS-FSCC 2.3.2.1
+ * [POSIX-FSCC] POSIX Extensions to MS-FSCC
  * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
  */
+
+/*
+ * This information class is used to query file posix information.
+ * See POSIX-FSCC 2.3.1.1
+ */
+struct file_posix_info {
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 EndOfFile;
+	__le64 AllocationSize;
+	__le32 DosAttributes;
+	__le64 Inode;
+	__le32 DeviceId;
+	__le32 Zero;
+	/*
+	 * beginning of POSIX Create Context Response
+	 * See POSIX-SMB2 2.2.14.2.16
+	 */
+	__le32 HardLinks;
+	__le32 ReparseTag;
+	__le32 Mode;
+	// var sized owner SID
+	// var sized group SID
+	/* end of POSIX Create Context Response */
+	// le32 filenamelength
+	// u8 filename[]
+} __packed;
+
+/* Level 100 query info */
+struct smb311_posix_qinfo {
+	struct file_posix_info fpinfo;
+	u8     Sids[];
+	/*
+	 * le32 filenamelength
+	 * u8  filename[]
+	 */
+} __packed;
+
+/* See POSIX-FSCC 2.3.2.1 */
 typedef struct {
 	/* For undefined recommended transfer size return -1 in that field */
 	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c46b15e9a2d5..098f147680c5 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1606,31 +1606,6 @@ struct smb2_query_info_rsp {
 	__u8   Buffer[];
 } __packed;
 
-/* Level 100 query info */
-struct smb311_posix_qinfo {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 DosAttributes;
-	__le64 Inode;
-	__le32 DeviceId;
-	__le32 Zero;
-	/* beginning of POSIX Create Context Response */
-	__le32 HardLinks;
-	__le32 ReparseTag;
-	__le32 Mode;
-	u8     Sids[];
-	/*
-	 * var sized owner SID
-	 * var sized group SID
-	 * le32 filenamelength
-	 * u8  filename[]
-	 */
-} __packed;
-
 /* See MS-SMB2 2.2.23 through 2.2.25 */
 struct smb2_oplock_break {
 	struct smb2_hdr hdr;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f58b212481e0..c1c99fabe190 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4036,44 +4036,44 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 
 		posix_info = (struct smb2_posix_info *)kstat;
 		posix_info->Ignored = 0;
-		posix_info->CreationTime = cpu_to_le64(ksmbd_kstat->create_time);
+		posix_info->fpinfo.CreationTime = cpu_to_le64(ksmbd_kstat->create_time);
 		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->ctime);
-		posix_info->ChangeTime = cpu_to_le64(time);
+		posix_info->fpinfo.ChangeTime = cpu_to_le64(time);
 		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->atime);
-		posix_info->LastAccessTime = cpu_to_le64(time);
+		posix_info->fpinfo.LastAccessTime = cpu_to_le64(time);
 		time = ksmbd_UnixTimeToNT(ksmbd_kstat->kstat->mtime);
-		posix_info->LastWriteTime = cpu_to_le64(time);
-		posix_info->EndOfFile = cpu_to_le64(ksmbd_kstat->kstat->size);
-		posix_info->AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
-		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
-		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
-		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
+		posix_info->fpinfo.LastWriteTime = cpu_to_le64(time);
+		posix_info->fpinfo.EndOfFile = cpu_to_le64(ksmbd_kstat->kstat->size);
+		posix_info->fpinfo.AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
+		posix_info->fpinfo.DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
+		posix_info->fpinfo.HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
+		posix_info->fpinfo.Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
 		switch (ksmbd_kstat->kstat->mode & S_IFMT) {
 		case S_IFDIR:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
 			break;
 		case S_IFLNK:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
 			break;
 		case S_IFCHR:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
 			break;
 		case S_IFBLK:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
 			break;
 		case S_IFIFO:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
 			break;
 		case S_IFSOCK:
-			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+			posix_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
 		}
 
-		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
-		posix_info->DosAttributes =
+		posix_info->fpinfo.Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
+		posix_info->fpinfo.DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ?
 				FILE_ATTRIBUTE_DIRECTORY_LE : FILE_ATTRIBUTE_ARCHIVE_LE;
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
-			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
+			posix_info->fpinfo.DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
 		/*
 		 * SidBuffer(32) contain two sids(Domain sid(16), UNIX group sid(16)).
 		 * UNIX sid(16) = revision(1) + num_subauth(1) + authority(6) +
@@ -5259,45 +5259,45 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		return ret;
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
-	file_info->CreationTime = cpu_to_le64(fp->create_time);
+	file_info->fpinfo.CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
-	file_info->LastAccessTime = cpu_to_le64(time);
+	file_info->fpinfo.LastAccessTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.mtime);
-	file_info->LastWriteTime = cpu_to_le64(time);
+	file_info->fpinfo.LastWriteTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(stat.ctime);
-	file_info->ChangeTime = cpu_to_le64(time);
-	file_info->DosAttributes = fp->f_ci->m_fattr;
-	file_info->Inode = cpu_to_le64(stat.ino);
+	file_info->fpinfo.ChangeTime = cpu_to_le64(time);
+	file_info->fpinfo.DosAttributes = fp->f_ci->m_fattr;
+	file_info->fpinfo.Inode = cpu_to_le64(stat.ino);
 	if (ksmbd_stream_fd(fp) == false) {
-		file_info->EndOfFile = cpu_to_le64(stat.size);
-		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->fpinfo.EndOfFile = cpu_to_le64(stat.size);
+		file_info->fpinfo.AllocationSize = cpu_to_le64(stat.blocks << 9);
 	} else {
-		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
-		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
+		file_info->fpinfo.EndOfFile = cpu_to_le64(fp->stream.size);
+		file_info->fpinfo.AllocationSize = cpu_to_le64(fp->stream.size);
 	}
-	file_info->HardLinks = cpu_to_le32(stat.nlink);
-	file_info->Mode = cpu_to_le32(stat.mode & 0777);
+	file_info->fpinfo.HardLinks = cpu_to_le32(stat.nlink);
+	file_info->fpinfo.Mode = cpu_to_le32(stat.mode & 0777);
 	switch (stat.mode & S_IFMT) {
 	case S_IFDIR:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
 		break;
 	case S_IFLNK:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
 		break;
 	case S_IFCHR:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
 		break;
 	case S_IFBLK:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
 		break;
 	case S_IFIFO:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
 		break;
 	case S_IFSOCK:
-		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+		file_info->fpinfo.Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
 	}
 
-	file_info->DeviceId = cpu_to_le32(stat.rdev);
+	file_info->fpinfo.DeviceId = cpu_to_le32(stat.rdev);
 
 	/*
 	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 09311a9eb1de..11737e1ac864 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -285,30 +285,11 @@ struct create_sd_buf_req {
 struct smb2_posix_info {
 	__le32 NextEntryOffset;
 	__u32 Ignored;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 DosAttributes;
-	__le64 Inode;
-	__le32 DeviceId;
-	__le32 Zero;
-	/* beginning of POSIX Create Context Response */
-	__le32 HardLinks;
-	__le32 ReparseTag;
-	__le32 Mode;
+	struct file_posix_info fpinfo;
 	/* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
 	u8 SidBuffer[32];
 	__le32 name_len;
 	u8 name[];
-	/*
-	 * var sized owner SID
-	 * var sized group SID
-	 * le32 filenamelength
-	 * u8  filename[]
-	 */
 } __packed;
 
 /* functions */
-- 
2.43.0

