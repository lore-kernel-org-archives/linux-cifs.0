Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE678C3065A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352325AbjHQPfl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352419AbjHQPfd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:33 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FC730D1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:31 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TA7u0WoopLEa7a4Pd8C8cxs5u/xTPlq/mWW6rsmRnok=;
        b=rnXgELluKyHavPT0ZK1UeN8C6JaGkSBFhnLFcnIppVTD/5SGCjUEiSZJByuO0wKsvJGvZJ
        FnDC8J2T2h3DbWqE2jKkFiwSjZaUrWjtgiFwF1Umv5q9K0R0uADDXGkYhV8dcDNYj0msjq
        8X4tkaN0oKUsxqqyYg26BwPpWYCmXqSW2G4YyjWWwkhHKDWu6fzrpSIU6j92iEElJ8yP56
        Sk+WIJW5zJh5k7t6+3tM/3/7i9uHu4bR6Thvzg2Vy7Lp7LoeArgKfTNsuIL/ft0galOG0X
        uDsSAgZ1uQtTXC8LBYOvT0G1WTVV2xlQwb4VO6lPy9g2+0HEi1PZGnktV7jG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TA7u0WoopLEa7a4Pd8C8cxs5u/xTPlq/mWW6rsmRnok=;
        b=nAlKaE9CKefUyx310haa/XVQRWOnPFDuQLUOPMZWV8FD8FKMoMfLrWzfFxLJ5seTfJ5vYJ
        Y1ongdCM3Q0GveoKXrQp18JximTxYIpKoHvk8UgOotWW8Pe6L/YriVrv5szymj9+vbx9Xo
        zar0aTw5ck1zJkUI8j5w6dtFBlxcD6MOtCswv6fIlqS8mOwodU4MMYJqqdeDtDjDbXHORY
        W+JdvQABwxWBMPRyMtpS2TxbD53tU+MNyDgYsRB05alL1a6btI2K9leDgJfSf0plHG9u2l
        d0AYga0tlzpErU6EnpmX6Z48yTmNGX8kLAGn71g0FVh41VuWWFRHa2dCpnAyXg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286529; a=rsa-sha256;
        cv=none;
        b=WLmMk6Fos0VQkxe6aNNb3YBNP3p/5r5H3626TgsC4Dpfq7bq2PfRqrAxQDohHsQ9/RHa9u
        kPsQ8UnekhDONdAH9xT5xwA1Imj7hQurj0KGBhXr48IcoUShZM5FxK9YDuEd9Cr98+Q7/u
        23PVtzmVDMIXW5cABVORtAhFoI5PrgI6dmRJvdxWY24Ky1iq7sNc8rNG5M+8XtDl7cJzKB
        mpO4LDK+WvYt4W44qKScZ3q63dfH5//EvVk3bpfl+JM1nzKErdJfnPn3rWYliHcBuzPfLs
        Z8+GEaI5+Vp3Zz42rhitC7HiKC4eTrT9YhQSEmSHlckI9du/PMheonP6ykUZhw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 03/17] smb: client: move some params to cifs_open_info_data
Date:   Thu, 17 Aug 2023 12:34:01 -0300
Message-ID: <20230817153416.28083-4-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Instead of passing @adjust_tz and some reparse point related fields as
parameters in ->query_path_info() and
{smb311_posix,cifs}_info_to_fattr() calls, move them to
cifs_open_info_data structure as they can be easily accessed through
@data.

No functional changes.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  | 14 ++++++--
 fs/smb/client/inode.c     | 68 ++++++++++++++++++---------------------
 fs/smb/client/smb1ops.c   | 15 +++++----
 fs/smb/client/smb2inode.c | 29 +++++++++--------
 fs/smb/client/smb2proto.h | 17 ++++++----
 5 files changed, 77 insertions(+), 66 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 712557c2d526..4792de20a447 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -186,6 +186,12 @@ struct cifs_cred {
 };
 
 struct cifs_open_info_data {
+	bool adjust_tz;
+	union {
+		bool reparse_point;
+		bool symlink;
+	};
+	__u32 reparse_tag;
 	char *symlink_target;
 	union {
 		struct smb2_file_all_info fi;
@@ -318,9 +324,11 @@ struct smb_version_operations {
 	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
 				  struct cifs_sb_info *, const char *);
 	/* query path data from the server */
-	int (*query_path_info)(const unsigned int xid, struct cifs_tcon *tcon,
-			       struct cifs_sb_info *cifs_sb, const char *full_path,
-			       struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse);
+	int (*query_path_info)(const unsigned int xid,
+			       struct cifs_tcon *tcon,
+			       struct cifs_sb_info *cifs_sb,
+			       const char *full_path,
+			       struct cifs_open_info_data *data);
 	/* query file data from the server */
 	int (*query_file_info)(const unsigned int xid, struct cifs_tcon *tcon,
 			       struct cifsFileInfo *cfile, struct cifs_open_info_data *data);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index c3eeae07e139..0d11e63042e2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -632,10 +632,11 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 }
 
 /* Fill a cifs_fattr struct with info from POSIX info struct */
-static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct cifs_open_info_data *data,
+static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
+				       struct cifs_open_info_data *data,
 				       struct cifs_sid *owner,
 				       struct cifs_sid *group,
-				       struct super_block *sb, bool adjust_tz, bool symlink)
+				       struct super_block *sb)
 {
 	struct smb311_posix_qinfo *info = &data->posix_fi;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -655,7 +656,7 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct cifs_ope
 	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
-	if (adjust_tz) {
+	if (data->adjust_tz) {
 		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
 		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
 	}
@@ -669,7 +670,7 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct cifs_ope
 	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
 	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
-	if (symlink) {
+	if (data->symlink) {
 		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		fattr->cf_symlink_target = data->symlink_target;
@@ -690,13 +691,14 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct cifs_ope
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
 }
 
-static void cifs_open_info_to_fattr(struct cifs_fattr *fattr, struct cifs_open_info_data *data,
-				    struct super_block *sb, bool adjust_tz, bool symlink,
-				    u32 reparse_tag)
+static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
+				    struct cifs_open_info_data *data,
+				    struct super_block *sb)
 {
 	struct smb2_file_all_info *info = &data->fi;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	u32 reparse_tag = data->reparse_tag;
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_cifsattrs = le32_to_cpu(info->Attributes);
@@ -711,7 +713,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr, struct cifs_open_i
 	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
-	if (adjust_tz) {
+	if (data->adjust_tz) {
 		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
 		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
 	}
@@ -736,7 +738,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr, struct cifs_open_i
 	} else if (reparse_tag == IO_REPARSE_TAG_LX_BLK) {
 		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_BLK;
-	} else if (symlink || reparse_tag == IO_REPARSE_TAG_SYMLINK ||
+	} else if (data->symlink || reparse_tag == IO_REPARSE_TAG_SYMLINK ||
 		   reparse_tag == IO_REPARSE_TAG_NFS) {
 		fattr->cf_mode = S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
@@ -789,8 +791,6 @@ cifs_get_file_info(struct file *filp)
 	struct cifsFileInfo *cfile = filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	bool symlink = false;
-	u32 tag = 0;
 
 	if (!server->ops->query_file_info)
 		return -ENOSYS;
@@ -800,11 +800,12 @@ cifs_get_file_info(struct file *filp)
 	switch (rc) {
 	case 0:
 		/* TODO: add support to query reparse tag */
+		data.adjust_tz = false;
 		if (data.symlink_target) {
-			symlink = true;
-			tag = IO_REPARSE_TAG_SYMLINK;
+			data.symlink = true;
+			data.reparse_tag = IO_REPARSE_TAG_SYMLINK;
 		}
-		cifs_open_info_to_fattr(&fattr, &data, inode->i_sb, false, symlink, tag);
+		cifs_open_info_to_fattr(&fattr, &data, inode->i_sb);
 		break;
 	case -EREMOTE:
 		cifs_create_dfs_fattr(&fattr, inode->i_sb);
@@ -968,14 +969,11 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	bool adjust_tz = false;
 	struct cifs_fattr fattr = {0};
-	bool is_reparse_point = false;
 	struct cifs_open_info_data tmp_data = {};
 	void *smb1_backup_rsp_buf = NULL;
 	int rc = 0;
 	int tmprc = 0;
-	__u32 reparse_tag = 0;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -992,8 +990,8 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 			goto out;
 		}
-		rc = server->ops->query_path_info(xid, tcon, cifs_sb, full_path, &tmp_data,
-						  &adjust_tz, &is_reparse_point);
+		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
+						  full_path, &tmp_data);
 		data = &tmp_data;
 	}
 
@@ -1008,24 +1006,23 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 		 * since we have to check if its reparse tag matches a known
 		 * special file type e.g. symlink or fifo or char etc.
 		 */
-		if (is_reparse_point && data->symlink_target) {
-			reparse_tag = IO_REPARSE_TAG_SYMLINK;
+		if (data->reparse_point && data->symlink_target) {
+			data->reparse_tag = IO_REPARSE_TAG_SYMLINK;
 		} else if ((le32_to_cpu(data->fi.Attributes) & ATTR_REPARSE) &&
 			   server->ops->query_reparse_tag) {
 			tmprc = server->ops->query_reparse_tag(xid, tcon, cifs_sb, full_path,
-							    &reparse_tag);
-			if (tmprc)
-				cifs_dbg(FYI, "%s: query_reparse_tag: rc = %d\n", __func__, tmprc);
+							       &data->reparse_tag);
+			cifs_dbg(FYI, "%s: query_reparse_tag: rc = %d\n", __func__, tmprc);
 			if (server->ops->query_symlink) {
-				tmprc = server->ops->query_symlink(xid, tcon, cifs_sb, full_path,
+				tmprc = server->ops->query_symlink(xid, tcon, cifs_sb,
+								   full_path,
 								   &data->symlink_target,
-								   is_reparse_point);
-				if (tmprc)
-					cifs_dbg(FYI, "%s: query_symlink: rc = %d\n", __func__,
-						 tmprc);
+								   data->reparse_point);
+				cifs_dbg(FYI, "%s: query_symlink: rc = %d\n",
+					 __func__, tmprc);
 			}
 		}
-		cifs_open_info_to_fattr(&fattr, data, sb, adjust_tz, is_reparse_point, reparse_tag);
+		cifs_open_info_to_fattr(&fattr, data, sb);
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
@@ -1168,9 +1165,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	bool adjust_tz = false;
 	struct cifs_fattr fattr = {0};
-	bool symlink = false;
 	struct cifs_open_info_data data = {};
 	struct cifs_sid owner, group;
 	int rc = 0;
@@ -1190,9 +1185,9 @@ smb311_posix_get_inode_info(struct inode **inode,
 		goto out;
 	}
 
-	rc = smb311_posix_query_path_info(xid, tcon, cifs_sb, full_path, &data,
-					  &owner, &group, &adjust_tz,
-					  &symlink);
+	rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
+					  full_path, &data,
+					  &owner, &group);
 
 	/*
 	 * 2. Convert it to internal cifs metadata (fattr)
@@ -1200,8 +1195,7 @@ smb311_posix_get_inode_info(struct inode **inode,
 
 	switch (rc) {
 	case 0:
-		smb311_posix_info_to_fattr(&fattr, &data, &owner, &group,
-					   sb, adjust_tz, symlink);
+		smb311_posix_info_to_fattr(&fattr, &data, &owner, &group, sb);
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 7d1b3fc014d9..094ef4fe2219 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -542,14 +542,17 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
-				struct cifs_sb_info *cifs_sb, const char *full_path,
-				struct cifs_open_info_data *data, bool *adjustTZ, bool *symlink)
+static int cifs_query_path_info(const unsigned int xid,
+				struct cifs_tcon *tcon,
+				struct cifs_sb_info *cifs_sb,
+				const char *full_path,
+				struct cifs_open_info_data *data)
 {
 	int rc;
 	FILE_ALL_INFO fi = {};
 
-	*symlink = false;
+	data->symlink = false;
+	data->adjust_tz = false;
 
 	/* could do find first instead but this returns more info */
 	rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi, 0 /* not legacy */, cifs_sb->local_nls,
@@ -562,7 +565,7 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, &fi, cifs_sb->local_nls,
 					 cifs_remap(cifs_sb));
-		*adjustTZ = true;
+		data->adjust_tz = true;
 	}
 
 	if (!rc) {
@@ -589,7 +592,7 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		/* Need to check if this is a symbolic link or not */
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
 		if (tmprc == -EOPNOTSUPP)
-			*symlink = true;
+			data->symlink = true;
 		else if (tmprc == 0)
 			CIFSSMBClose(xid, tcon, fid.netfid);
 	}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 8e696fbd72fa..260b2ed23cbd 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -541,9 +541,11 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
-			 struct cifs_sb_info *cifs_sb, const char *full_path,
-			 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse)
+int smb2_query_path_info(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct cifs_sb_info *cifs_sb,
+			 const char *full_path,
+			 struct cifs_open_info_data *data)
 {
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
@@ -553,8 +555,8 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	bool islink;
 	int rc, rc2;
 
-	*adjust_tz = false;
-	*reparse = false;
+	data->adjust_tz = false;
+	data->reparse_point = false;
 
 	if (strcmp(full_path, ""))
 		rc = -ENOENT;
@@ -588,7 +590,7 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			if (rc)
 				goto out;
 
-			*reparse = true;
+			data->reparse_point = true;
 			create_options |= OPEN_REPARSE_POINT;
 
 			/* Failed on a symbolic link - query a reparse point info */
@@ -619,12 +621,13 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 
-int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb, const char *full_path,
+int smb311_posix_query_path_info(const unsigned int xid,
+				 struct cifs_tcon *tcon,
+				 struct cifs_sb_info *cifs_sb,
+				 const char *full_path,
 				 struct cifs_open_info_data *data,
 				 struct cifs_sid *owner,
-				 struct cifs_sid *group,
-				 bool *adjust_tz, bool *reparse)
+				 struct cifs_sid *group)
 {
 	int rc;
 	__u32 create_options = 0;
@@ -636,8 +639,8 @@ int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	size_t sidsbuflen = 0;
 	size_t owner_len, group_len;
 
-	*adjust_tz = false;
-	*reparse = false;
+	data->adjust_tz = false;
+	data->reparse_point = false;
 
 	/*
 	 * BB TODO: Add support for using the cached root handle.
@@ -659,7 +662,7 @@ int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			if (rc)
 				goto out;
 		}
-		*reparse = true;
+		data->reparse_point = true;
 		create_options |= OPEN_REPARSE_POINT;
 
 		/* Failed on a symbolic link - query a reparse point info */
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index d5d7ffb7711c..46eff9ec302a 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -56,9 +56,11 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb, const char *path,
 				__u32 *reparse_tag);
-int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
-			 struct cifs_sb_info *cifs_sb, const char *full_path,
-			 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse);
+int smb2_query_path_info(const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 struct cifs_sb_info *cifs_sb,
+			 const char *full_path,
+			 struct cifs_open_info_data *data);
 extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *full_path, __u64 size,
 			      struct cifs_sb_info *cifs_sb, bool set_alloc);
@@ -275,12 +277,13 @@ extern int smb2_query_info_compound(const unsigned int xid,
 				    struct kvec *rsp, int *buftype,
 				    struct cifs_sb_info *cifs_sb);
 /* query path info from the server using SMB311 POSIX extensions*/
-int smb311_posix_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
-				 struct cifs_sb_info *cifs_sb, const char *full_path,
+int smb311_posix_query_path_info(const unsigned int xid,
+				 struct cifs_tcon *tcon,
+				 struct cifs_sb_info *cifs_sb,
+				 const char *full_path,
 				 struct cifs_open_info_data *data,
 				 struct cifs_sid *owner,
-				 struct cifs_sid *group,
-				 bool *adjust_tz, bool *reparse);
+				 struct cifs_sid *group);
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
-- 
2.41.0

