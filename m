Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XOWwSYlt"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B04C22
	for <linux-cifs@vger.kernel.org>; Tue, 28 Nov 2023 13:24:01 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701206640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pPFDU0u95ADShs4KFsOTiX6GZDKjGRCfrv7BAx3Lnb4=;
	b=XOWwSYltE6dXhidJVz/XjoeVwlcv7yUs/D1S0DlsQ0TeBG6F9BpF7mzS0AObyxGr8gu5nt
	1ys5SyG9Z5jELHqtQ1bGp+xTImnq0pLUMyMsRIRA0JKasKtCy7JkkmNgPCc/NW2hwsV86U
	HfrbHQIjYrUIBua8yfmbJyDHbeWH7uqGMECwUF3vmF53QShRtg5/UMZNXaPQ8IsnMd6Y0D
	psmZmO6d8rCHzKFkn6uEJAjhIHMZeBPuG1Y08G+rW41E1TB9L6liE6/bJazfhSPCdWWozW
	GcHz4GQuIYEPLcEhcnzdInDWEpmCbwPyjEjEK9hp390+eV94NDTaa3Gr2pOpEA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701206640; a=rsa-sha256;
	cv=none;
	b=SPpxdqisqK+2+xU3bv3u2XrmY25iOCeR9ZCBdwLThshy9hWwOMtB9YRvwrb3tN+kRHggEk
	+05+q+n5ncq+DaXmxDcu9+XgEGYHHIxiXNSdqhrOcQ1nmVRcomUlLY9f76htS4I/kFrl4B
	YkcIFrta3GPlf5ERuF2jZRmx80nJVOuNcOXWKcejxtcVXduvz5brTPDr1HKlMKONYkA4M9
	j0ULQ/N1r8TSDlI1mCKKinuwabnNl+VToaL+4zosumomAzm93QZlDg5T8VyGpuRy8cXNGY
	4u4n/2tWABFiF98WHBLJT50Wm5E9bZS0fibCLDHWwyhB8qRQFnTX5RYhgvaBww==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701206640; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pPFDU0u95ADShs4KFsOTiX6GZDKjGRCfrv7BAx3Lnb4=;
	b=R4dg9HK7w6PqzmMQF9zZ4F2AsJxs0npe5hlvLZx+FFg21IdNeuteGB+WF4K3sPazkLuhF+
	h6km+nGHmncILzDTAlxkFFAUK3hP9NlC76F3wKGcj/XX5a9mBje/ofQePCcmXci5aWcc4+
	DK0r6QSGzg1eRDAIjlITpQU3SMUCf0t8/MEwJXsWS86ymvHy2v0ZVPFmDBodQDLr69gUW8
	b1VO0l0gQ6Qpg5kjFcSvveRPYMso/u+wcFhy39hLBlbXDdR3Bct32jQI0IZWuMSP5Z+pTK
	pzFcE/d37UtlsLjdtbs4vdcbhbDrb8oo2LMlYyssg85H0t0/O/MyqreM+uz+SA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: handle special files and symlinks in SMB3 POSIX
Date: Tue, 28 Nov 2023 18:23:33 -0300
Message-ID: <20231128212333.13413-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parse reparse points in SMB3 posix query info as they will be
supported and required by the new specification.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c | 50 +++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0b05e664008e..c600b715edd6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -692,29 +692,36 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
 	}
 
+	/*
+	 * The srv fs device id is overridden on network mount so setting
+	 * @fattr->cf_rdev isn't needed here.
+	 */
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
-
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_mode = (umode_t) le32_to_cpu(info->Mode);
-	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
-	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
-	if (data->symlink) {
-		fattr->cf_mode |= S_IFLNK;
-		fattr->cf_dtype = DT_LNK;
-		fattr->cf_symlink_target = data->symlink_target;
-		data->symlink_target = NULL;
-	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
+	if (cifs_open_data_reparse(data) &&
+	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data))
+		goto out_reparse;
+
+	fattr->cf_mode &= ~S_IFMT;
+	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode |= S_IFDIR;
 		fattr->cf_dtype = DT_DIR;
 	} else { /* file */
 		fattr->cf_mode |= S_IFREG;
 		fattr->cf_dtype = DT_REG;
 	}
-	/* else if reparse point ... TODO: add support for FIFO and blk dev; special file types */
 
+out_reparse:
+	if (S_ISLNK(fattr->cf_mode)) {
+		if (likely(data->symlink_target))
+			fattr->cf_eof = strnlen(data->symlink_target, PATH_MAX);
+		fattr->cf_symlink_target = data->symlink_target;
+		data->symlink_target = NULL;
+	}
 	sid_to_id(cifs_sb, owner, fattr, SIDOWNER);
 	sid_to_id(cifs_sb, group, fattr, SIDGROUP);
 
@@ -739,25 +746,25 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
-			fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFCHR;
 			fattr->cf_dtype = DT_CHR;
 			fattr->cf_rdev = nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_BLK:
-			fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFBLK;
 			fattr->cf_dtype = DT_BLK;
 			fattr->cf_rdev = nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_FIFO:
-			fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFIFO;
 			fattr->cf_dtype = DT_FIFO;
 			break;
 		case NFS_SPECFILE_SOCK:
-			fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFSOCK;
 			fattr->cf_dtype = DT_SOCK;
 			break;
 		case NFS_SPECFILE_LNK:
-			fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
+			fattr->cf_mode |= S_IFLNK;
 			fattr->cf_dtype = DT_LNK;
 			break;
 		default:
@@ -769,29 +776,29 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
-		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	case IO_REPARSE_TAG_LX_FIFO:
-		fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFIFO;
 		fattr->cf_dtype = DT_FIFO;
 		break;
 	case IO_REPARSE_TAG_AF_UNIX:
-		fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFSOCK;
 		fattr->cf_dtype = DT_SOCK;
 		break;
 	case IO_REPARSE_TAG_LX_CHR:
-		fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFCHR;
 		fattr->cf_dtype = DT_CHR;
 		break;
 	case IO_REPARSE_TAG_LX_BLK:
-		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFBLK;
 		fattr->cf_dtype = DT_BLK;
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
 	case IO_REPARSE_TAG_NFS:
-		fattr->cf_mode = S_IFLNK | cifs_sb->ctx->file_mode;
+		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		break;
 	default:
@@ -831,6 +838,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
 	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
 
+	fattr->cf_mode = cifs_sb->ctx->file_mode;
 	if (cifs_open_data_reparse(data) &&
 	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data))
 		goto out_reparse;
-- 
2.43.0

