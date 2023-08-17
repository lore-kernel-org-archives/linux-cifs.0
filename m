Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F670C3DA41
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352675AbjHQPfn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353249AbjHQPfk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:40 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40E930C5
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:38 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cb18Ulo8cWGi7nbOOAreRRYdVcAEMI5Zo5XtPXRkunA=;
        b=jV7zPS9IaB6y/yMt/sqheer0HJ+9DEO8Q/8HIbLzoMcx6YlprakkTMUuDrs+WKvcgWb21H
        W22KErRBulkn8FvVZujImHUoRQKlOdL76hkK4NIPiDLQyk3XY5bpyR0b6uuYc4bUdXkAWw
        vueGPOSx3QXcYzH+kIEAh/lmnAkw/fCmlCvcpxtRZo4XDJ/JsUUERRzT1h2R7jedh7bLXG
        1G2XA1FB+IBzdOjhd1oO+rVMu8B6kfoTNaD0j6T9PEXKWDx8IDoDQc5ivjtc5gx5PlL+Xa
        UMmTBbeSKlb75rQU4KUIONuSpX6IKkHD+O1fcBSXrWvwkz6lbBy5SjgSZ0qujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cb18Ulo8cWGi7nbOOAreRRYdVcAEMI5Zo5XtPXRkunA=;
        b=kQ3wPzyEBKpWpmcWEt6m6hXdv7jBSA0Sbe1pkQS3A8J7gvdFgUMaJr/q4i05vR/JCKJnPM
        jte9qpnWss8nFuk3erABY5QghMQk4g3VheLvFz483+JDCD1eK+lOhxBIOvJobGZwjrPS7N
        jl/7ET1vXsjMWOTjfbqWnRUdKYsHhpOgKfa+rhhFf07gCGvsDlBjD9TcHhKSzjFxLa9F74
        tKQ8i1HK3lRydBzAWKQXuuipDFTlDxLZ6ZK6xJzvlXUBK14NXZ2+THmPMO1bFTkmN9m6aZ
        oWzwctrRnxD/WG2bmKk7co511VqwKL4+K8hg4weVjDtMQaIJ7/PmEHOpz5lxJw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286537; a=rsa-sha256;
        cv=none;
        b=I6zg1knaZJA0PQamp7/vDikiu60zVlf+Tkv3pipeWQeT1S2BOgeYkFC+CW+S12ku02c9lU
        Kkh2E1p7UAwDzcc/iR4gMeMSSlvbkgcE/FEx0yMXDa1d2by6mDYdbKbW+gKLFPR0VikyKv
        3E9nqCGWBRbwBJWaLJxmxtBefcROl/zk3OsLZkcMhtdDroJwutO2Ue6R19y6egJMnJw2sN
        sXevRg9C1yDwS3LXKW3aNBSkubejeuSCFipcg8GIa3UJNmtkId1uO4olAE0yQiENNvxLkA
        AA44KL3URax1vLz/xIupYY4oI6coi34auz3FoGvnYmyN7Z/wnaReDlV+LVeSrw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 08/17] smb: client: parse reparse point flag in create response
Date:   Thu, 17 Aug 2023 12:34:06 -0300
Message-ID: <20230817153416.28083-9-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Check for reparse point flag on query info calls as specified in
MS-SMB2 2.2.14.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  |   4 ++
 fs/smb/client/cifsproto.h |   3 +
 fs/smb/client/inode.c     | 121 ++++++++++++++++++++++++++------------
 fs/smb/client/readdir.c   |  22 ++-----
 fs/smb/client/smb2inode.c | 115 ++++++++++++++++++++++++------------
 5 files changed, 172 insertions(+), 93 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4792de20a447..95e62502cb01 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -199,6 +199,10 @@ struct cifs_open_info_data {
 	};
 };
 
+#define cifs_open_data_reparse(d) \
+	((d)->reparse_point || \
+	 (le32_to_cpu((d)->fi.Attributes) & ATTR_REPARSE))
+
 static inline void cifs_free_open_info(struct cifs_open_info_data *data)
 {
 	kfree(data->symlink_target);
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 694d16acdf61..7d8035846680 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -207,6 +207,9 @@ extern struct inode *cifs_iget(struct super_block *sb,
 int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			struct cifs_open_info_data *data, struct super_block *sb, int xid,
 			const struct cifs_fid *fid);
+bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
+				 struct cifs_fattr *fattr,
+				 u32 tag);
 extern int smb311_posix_get_inode_info(struct inode **pinode, const char *search_path,
 			struct super_block *sb, unsigned int xid);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index da2ec48dc0f6..51e2916730cf 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -687,6 +687,43 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr,
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
 }
 
+bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
+				 struct cifs_fattr *fattr,
+				 u32 tag)
+{
+	switch (tag) {
+	case IO_REPARSE_TAG_LX_SYMLINK:
+		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
+		fattr->cf_dtype = DT_LNK;
+		break;
+	case IO_REPARSE_TAG_LX_FIFO:
+		fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
+		fattr->cf_dtype = DT_FIFO;
+		break;
+	case IO_REPARSE_TAG_AF_UNIX:
+		fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
+		fattr->cf_dtype = DT_SOCK;
+		break;
+	case IO_REPARSE_TAG_LX_CHR:
+		fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
+		fattr->cf_dtype = DT_CHR;
+		break;
+	case IO_REPARSE_TAG_LX_BLK:
+		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
+		fattr->cf_dtype = DT_BLK;
+		break;
+	case 0: /* SMB1 symlink */
+	case IO_REPARSE_TAG_SYMLINK:
+	case IO_REPARSE_TAG_NFS:
+		fattr->cf_mode = S_IFLNK;
+		fattr->cf_dtype = DT_LNK;
+		break;
+	default:
+		return false;
+	}
+	return true;
+}
+
 static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 				    struct cifs_open_info_data *data,
 				    struct super_block *sb)
@@ -694,7 +731,6 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	struct smb2_file_all_info *info = &data->fi;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	u32 reparse_tag = data->reparse_tag;
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_cifsattrs = le32_to_cpu(info->Attributes);
@@ -717,28 +753,13 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
-
 	fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
-	if (reparse_tag == IO_REPARSE_TAG_LX_SYMLINK) {
-		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_LNK;
-	} else if (reparse_tag == IO_REPARSE_TAG_LX_FIFO) {
-		fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_FIFO;
-	} else if (reparse_tag == IO_REPARSE_TAG_AF_UNIX) {
-		fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_SOCK;
-	} else if (reparse_tag == IO_REPARSE_TAG_LX_CHR) {
-		fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_CHR;
-	} else if (reparse_tag == IO_REPARSE_TAG_LX_BLK) {
-		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_BLK;
-	} else if (data->symlink || reparse_tag == IO_REPARSE_TAG_SYMLINK ||
-		   reparse_tag == IO_REPARSE_TAG_NFS) {
-		fattr->cf_mode = S_IFLNK;
-		fattr->cf_dtype = DT_LNK;
-	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
+
+	if (cifs_open_data_reparse(data) &&
+	    cifs_reparse_point_to_fattr(cifs_sb, fattr, data->reparse_tag))
+		goto out_reparse;
+
+	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
 		fattr->cf_dtype = DT_DIR;
 		/*
@@ -767,6 +788,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 		}
 	}
 
+out_reparse:
 	if (S_ISLNK(fattr->cf_mode)) {
 		fattr->cf_symlink_target = data->symlink_target;
 		data->symlink_target = NULL;
@@ -957,6 +979,40 @@ static inline bool is_inode_cache_good(struct inode *ino)
 	return ino && CIFS_CACHE_READ(CIFS_I(ino)) && CIFS_I(ino)->time != 0;
 }
 
+static int query_reparse(struct cifs_open_info_data *data,
+			 struct super_block *sb,
+			 const unsigned int xid,
+			 struct cifs_tcon *tcon,
+			 const char *full_path,
+			 struct cifs_fattr *fattr)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	bool reparse_point = data->reparse_point;
+	u32 tag = data->reparse_tag;
+	int rc = 0;
+
+	if (!tag && server->ops->query_reparse_tag) {
+		server->ops->query_reparse_tag(xid, tcon, cifs_sb,
+					       full_path, &tag);
+	}
+	switch ((data->reparse_tag = tag)) {
+	case 0: /* SMB1 symlink */
+		reparse_point = false;
+		fallthrough;
+	case IO_REPARSE_TAG_NFS:
+	case IO_REPARSE_TAG_SYMLINK:
+		if (!data->symlink_target && server->ops->query_symlink) {
+			rc = server->ops->query_symlink(xid, tcon,
+							cifs_sb, full_path,
+							&data->symlink_target,
+							reparse_point);
+		}
+		break;
+	}
+	return rc;
+}
+
 int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			struct cifs_open_info_data *data, struct super_block *sb, int xid,
 			const struct cifs_fid *fid)
@@ -1002,23 +1058,12 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 		 * since we have to check if its reparse tag matches a known
 		 * special file type e.g. symlink or fifo or char etc.
 		 */
-		if (data->reparse_point && data->symlink_target) {
-			data->reparse_tag = IO_REPARSE_TAG_SYMLINK;
-		} else if ((le32_to_cpu(data->fi.Attributes) & ATTR_REPARSE) &&
-			   server->ops->query_reparse_tag) {
-			tmprc = server->ops->query_reparse_tag(xid, tcon, cifs_sb, full_path,
-							       &data->reparse_tag);
-			cifs_dbg(FYI, "%s: query_reparse_tag: rc = %d\n", __func__, tmprc);
-			if (server->ops->query_symlink) {
-				tmprc = server->ops->query_symlink(xid, tcon, cifs_sb,
-								   full_path,
-								   &data->symlink_target,
-								   data->reparse_point);
-				cifs_dbg(FYI, "%s: query_symlink: rc = %d\n",
-					 __func__, tmprc);
-			}
+		if (cifs_open_data_reparse(data)) {
+			rc = query_reparse(data, sb, xid, tcon,
+					   full_path, &fattr);
 		}
-		cifs_open_info_to_fattr(&fattr, data, sb);
+		if (!rc)
+			cifs_open_info_to_fattr(&fattr, data, sb);
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index ef638086d734..59bf542d5211 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -163,29 +163,19 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	 * TODO: go through all documented  reparse tags to see if we can
 	 * reasonably map some of them to directories vs. files vs. symlinks
 	 */
+	if ((fattr->cf_cifsattrs & ATTR_REPARSE) &&
+	    cifs_reparse_point_to_fattr(cifs_sb, fattr, fattr->cf_cifstag))
+		goto out_reparse;
+
 	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
 		fattr->cf_dtype = DT_DIR;
-	} else if (fattr->cf_cifstag == IO_REPARSE_TAG_LX_SYMLINK) {
-		fattr->cf_mode |= S_IFLNK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_LNK;
-	} else if (fattr->cf_cifstag == IO_REPARSE_TAG_LX_FIFO) {
-		fattr->cf_mode |= S_IFIFO | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_FIFO;
-	} else if (fattr->cf_cifstag == IO_REPARSE_TAG_AF_UNIX) {
-		fattr->cf_mode |= S_IFSOCK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_SOCK;
-	} else if (fattr->cf_cifstag == IO_REPARSE_TAG_LX_CHR) {
-		fattr->cf_mode |= S_IFCHR | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_CHR;
-	} else if (fattr->cf_cifstag == IO_REPARSE_TAG_LX_BLK) {
-		fattr->cf_mode |= S_IFBLK | cifs_sb->ctx->file_mode;
-		fattr->cf_dtype = DT_BLK;
-	} else { /* TODO: should we mark some other reparse points (like DFSR) as directories? */
+	} else {
 		fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_REG;
 	}
 
+out_reparse:
 	/*
 	 * We need to revalidate it further to make a decision about whether it
 	 * is a symbolic link, DFS referral or a reparse point with a direct
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 69a2969ecdf5..0999383c0284 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -542,6 +542,33 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int parse_create_response(struct cifs_open_info_data *data,
+				 struct cifs_sb_info *cifs_sb,
+				 const struct kvec *iov)
+{
+	struct smb2_create_rsp *rsp = iov->iov_base;
+	bool reparse_point = false;
+	u32 tag = 0;
+	int rc = 0;
+
+	switch (rsp->hdr.Status) {
+	case STATUS_STOPPED_ON_SYMLINK:
+		rc = smb2_parse_symlink_response(cifs_sb, iov,
+						 &data->symlink_target);
+		if (rc)
+			return rc;
+		tag = IO_REPARSE_TAG_SYMLINK;
+		reparse_point = true;
+		break;
+	case STATUS_SUCCESS:
+		reparse_point = !!(rsp->Flags & SMB2_CREATE_FLAG_REPARSEPOINT);
+		break;
+	}
+	data->reparse_point = reparse_point;
+	data->reparse_tag = tag;
+	return rc;
+}
+
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
@@ -551,6 +578,7 @@ int smb2_query_path_info(const unsigned int xid,
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
+	struct smb2_hdr *hdr;
 	struct kvec out_iov[3] = {};
 	int out_buftype[3] = {};
 	bool islink;
@@ -579,39 +607,43 @@ int smb2_query_path_info(const unsigned int xid,
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_QUERY_INFO, cfile,
 			      NULL, NULL, out_iov, out_buftype);
-	if (rc) {
-		struct smb2_hdr *hdr = out_iov[0].iov_base;
+	hdr = out_iov[0].iov_base;
+	/*
+	 * If first iov is unset, then SMB session was dropped or we've got a
+	 * cached open file (@cfile).
+	 */
+	if (!hdr || out_buftype[0] == CIFS_NO_BUFFER)
+		goto out;
 
-		if (unlikely(!hdr || out_buftype[0] == CIFS_NO_BUFFER))
+	switch (rc) {
+	case 0:
+	case -EOPNOTSUPP:
+		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		if (rc || !data->reparse_point)
 			goto out;
-		if (rc == -EOPNOTSUPP && hdr->Command == SMB2_CREATE &&
-		    hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, out_iov,
-							 &data->symlink_target);
-			if (rc)
-				goto out;
 
-			data->reparse_point = true;
-			create_options |= OPEN_REPARSE_POINT;
-
-			/* Failed on a symbolic link - query a reparse point info */
-			cifs_get_readable_path(tcon, full_path, &cfile);
-			rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
-					      FILE_READ_ATTRIBUTES, FILE_OPEN,
-					      create_options, ACL_NO_MODE, data,
-					      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
-					      NULL, NULL);
+		create_options |= OPEN_REPARSE_POINT;
+		/* Failed on a symbolic link - query a reparse point info */
+		cifs_get_readable_path(tcon, full_path, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      FILE_READ_ATTRIBUTES, FILE_OPEN,
+				      create_options, ACL_NO_MODE, data,
+				      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
+				      NULL, NULL);
+		break;
+	case -EREMOTE:
+		break;
+	default:
+		if (hdr->Status != STATUS_OBJECT_NAME_INVALID)
+			break;
+		rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
+						     full_path, &islink);
+		if (rc2) {
+			rc = rc2;
 			goto out;
-		} else if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
-			rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
-							     full_path, &islink);
-			if (rc2) {
-				rc = rc2;
-				goto out;
-			}
-			if (islink)
-				rc = -EREMOTE;
 		}
+		if (islink)
+			rc = -EREMOTE;
 	}
 
 out:
@@ -653,26 +685,32 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES, FILE_OPEN,
 			      create_options, ACL_NO_MODE, data, SMB2_OP_POSIX_QUERY_INFO, cfile,
 			      &sidsbuf, &sidsbuflen, out_iov, out_buftype);
-	if (rc == -EOPNOTSUPP) {
+	/*
+	 * If first iov is unset, then SMB session was dropped or we've got a
+	 * cached open file (@cfile).
+	 */
+	if (!out_iov[0].iov_base || out_buftype[0] == CIFS_NO_BUFFER)
+		goto out;
+
+	switch (rc) {
+	case 0:
+	case -EOPNOTSUPP:
 		/* BB TODO: When support for special files added to Samba re-verify this path */
-		if (out_iov[0].iov_base && out_buftype[0] != CIFS_NO_BUFFER &&
-		    ((struct smb2_hdr *)out_iov[0].iov_base)->Command == SMB2_CREATE &&
-		    ((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_STOPPED_ON_SYMLINK) {
-			rc = smb2_parse_symlink_response(cifs_sb, out_iov, &data->symlink_target);
-			if (rc)
-				goto out;
-		}
-		data->reparse_point = true;
-		create_options |= OPEN_REPARSE_POINT;
+		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		if (rc || !data->reparse_point)
+			goto out;
 
+		create_options |= OPEN_REPARSE_POINT;
 		/* Failed on a symbolic link - query a reparse point info */
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_ATTRIBUTES,
 				      FILE_OPEN, create_options, ACL_NO_MODE, data,
 				      SMB2_OP_POSIX_QUERY_INFO, cfile,
 				      &sidsbuf, &sidsbuflen, NULL, NULL);
+		break;
 	}
 
+out:
 	if (rc == 0) {
 		sidsbuf_end = sidsbuf + sidsbuflen;
 
@@ -692,7 +730,6 @@ int smb311_posix_query_path_info(const unsigned int xid,
 		memcpy(group, sidsbuf + owner_len, group_len);
 	}
 
-out:
 	kfree(sidsbuf);
 	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
 	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
-- 
2.41.0

