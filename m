Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070C7C2D0C1
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 13:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC7521D7D
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 13:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="Qy6eG5S9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLSN4r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 08:56:47 -0500
Received: from mx.cjr.nz ([51.158.111.142]:6626 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbfLSN4q (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Dec 2019 08:56:46 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 624DB808AB;
        Thu, 19 Dec 2019 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1576763803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pe6rll17PT5KE+t/kX2qmf1yPndwnisYjuvru0kC0qM=;
        b=Qy6eG5S9MjnvacvU1ePBlt8eXdggB9DaByhWdPGFBfA910EC57BYmdpDYun1isOERCHpkA
        lmaY2p254e0ueoWPM3cs5llkngpGsyUiPOQquqpFC6pM02z4DZ70F7ssZ5A0Hg1mzK+pnr
        MeVX4YvWe7QvpVY5Ij9OESgLSzhHWabTZd/zt8ZuTSUiZjCNTyYm8Vrfk+wSLe/aH+DpIV
        y0Qk5jfQRRiZanoWUq3FPmtPVbtJ1uG377YKNKbu002RJg+jB+Byjhx4zI1orT0YO9I3aO
        sEl6DpQ/d92Ffsf65zuoHrq6ESJuQupdqNSO9ADZi0tn0XZgb/WFteXnvbI8pQ==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH] cifs: Optimize readdir on reparse points
Date:   Thu, 19 Dec 2019 10:56:30 -0300
Message-Id: <20191219135630.10803-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When listing a directory with thounsands of files and most of them are
reparse points, we simply marked all those dentries for revalidation
and then sending additional (compounded) create/getinfo/close requests
for each of them.

Instead, upon receiving a response from an SMB2_QUERY_DIRECTORY
(FileIdFullDirectoryInformation) command, the directory entries that
have a file attribute of FILE_ATTRIBUTE_REPARSE_POINT will contain an
EaSize field with a reparse tag in it, so we parse it and mark the
dentry for revalidation only if it is a DFS or a symlink.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/readdir.c  | 63 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ce9bac756c2a..40705e862451 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1693,6 +1693,7 @@ struct cifs_fattr {
 	struct timespec64 cf_atime;
 	struct timespec64 cf_mtime;
 	struct timespec64 cf_ctime;
+	u32             cf_cifstag;
 };
 
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 3925a7bfc74d..d17587c2c4ab 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -139,6 +139,28 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	dput(dentry);
 }
 
+static bool reparse_file_needs_reval(const struct cifs_fattr *fattr)
+{
+	if (!(fattr->cf_cifsattrs & ATTR_REPARSE))
+		return false;
+	/*
+	 * The DFS tags should be only intepreted by server side as per
+	 * MS-FSCC 2.1.2.1, but let's include them anyway.
+	 *
+	 * Besides, if cf_cifstag is unset (0), then we still need it to be
+	 * revalidated to know exactly what reparse point it is.
+	 */
+	switch (fattr->cf_cifstag) {
+	case IO_REPARSE_TAG_DFS:
+	case IO_REPARSE_TAG_DFSR:
+	case IO_REPARSE_TAG_SYMLINK:
+	case IO_REPARSE_TAG_NFS:
+	case 0:
+		return true;
+	}
+	return false;
+}
+
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
@@ -158,7 +180,7 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * is a symbolic link, DFS referral or a reparse point with a direct
 	 * access like junctions, deduplicated files, NFS symlinks.
 	 */
-	if (fattr->cf_cifsattrs & ATTR_REPARSE)
+	if (reparse_file_needs_reval(fattr))
 		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 
 	/* non-unix readdir doesn't provide nlink */
@@ -194,19 +216,37 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	}
 }
 
+static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
+{
+	const FILE_DIRECTORY_INFO *fi = info;
+
+	memset(fattr, 0, sizeof(*fattr));
+	fattr->cf_cifsattrs = le32_to_cpu(fi->ExtFileAttributes);
+	fattr->cf_eof = le64_to_cpu(fi->EndOfFile);
+	fattr->cf_bytes = le64_to_cpu(fi->AllocationSize);
+	fattr->cf_createtime = le64_to_cpu(fi->CreationTime);
+	fattr->cf_atime = cifs_NTtimeToUnix(fi->LastAccessTime);
+	fattr->cf_ctime = cifs_NTtimeToUnix(fi->ChangeTime);
+	fattr->cf_mtime = cifs_NTtimeToUnix(fi->LastWriteTime);
+}
+
 void
 cifs_dir_info_to_fattr(struct cifs_fattr *fattr, FILE_DIRECTORY_INFO *info,
 		       struct cifs_sb_info *cifs_sb)
 {
-	memset(fattr, 0, sizeof(*fattr));
-	fattr->cf_cifsattrs = le32_to_cpu(info->ExtFileAttributes);
-	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
-	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
-	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
-	fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
-	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
-	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
+	__dir_info_to_fattr(fattr, info);
+	cifs_fill_common_info(fattr, cifs_sb);
+}
 
+static void cifs_fulldir_info_to_fattr(struct cifs_fattr *fattr,
+				       SEARCH_ID_FULL_DIR_INFO *info,
+				       struct cifs_sb_info *cifs_sb)
+{
+	__dir_info_to_fattr(fattr, info);
+
+	/* See MS-FSCC 2.4.18 FileIdFullDirectoryInformation */
+	if (fattr->cf_cifsattrs & ATTR_REPARSE)
+		fattr->cf_cifstag = le32_to_cpu(info->EaSize);
 	cifs_fill_common_info(fattr, cifs_sb);
 }
 
@@ -755,6 +795,11 @@ static int cifs_filldir(char *find_entry, struct file *file,
 				       (FIND_FILE_STANDARD_INFO *)find_entry,
 				       cifs_sb);
 		break;
+	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
+		cifs_fulldir_info_to_fattr(&fattr,
+					   (SEARCH_ID_FULL_DIR_INFO *)find_entry,
+					   cifs_sb);
+		break;
 	default:
 		cifs_dir_info_to_fattr(&fattr,
 				       (FILE_DIRECTORY_INFO *)find_entry,
-- 
2.24.0

