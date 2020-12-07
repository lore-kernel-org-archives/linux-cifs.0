Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73D4C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A47523998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgLGXkC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLGXkB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=2OCLxxHCUWjrjdCj8PclvWMs2xo8OxCnE9qIyeTNFVM=;
        b=DI18M3RmvfArW1XxRxb353MJ8Ii4v8FWQZTKb8F9K1ekaej31IxROfwCPJGGICYzyRNEKs
        ev3V85PqhzI8kM3S1tQ5UpWfD1sJ5ndFfrEkm5jTn/MIj5M8rzHQTW7hI3fpwlhnCrfOrq
        n0zP3gwkqsD8fSaXGvUu2/iQ000Kg4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-wYgAjC5fNvSvblo9VzMQIg-1; Mon, 07 Dec 2020 18:38:32 -0500
X-MC-Unique: wYgAjC5fNvSvblo9VzMQIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE7E192D785;
        Mon,  7 Dec 2020 23:38:31 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E6C210016DB;
        Mon,  7 Dec 2020 23:38:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 09/21] cifs: remove [gu]id/backup[gu]id/file_mode/dir_mode from cifs_sb
Date:   Tue,  8 Dec 2020 09:36:34 +1000
Message-Id: <20201207233646.29823-9-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can already access these from cifs_sb->ctx so we no longer need
a local copy in cifs_sb.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_fs_sb.h |  6 ------
 fs/cifs/cifsacl.c    |  7 ++++---
 fs/cifs/cifsfs.c     | 12 ++++++------
 fs/cifs/connect.c    | 15 +++++----------
 fs/cifs/file.c       |  5 +++--
 fs/cifs/inode.c      | 29 +++++++++++++++--------------
 fs/cifs/misc.c       |  5 +++--
 fs/cifs/readdir.c    |  9 +++++----
 8 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 8ee37c80880a..3f4f1487f714 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -67,12 +67,6 @@ struct cifs_sb_info {
 	unsigned int wsize;
 	unsigned long actimeo; /* attribute cache timeout (jiffies) */
 	atomic_t active;
-	kuid_t	mnt_uid;
-	kgid_t	mnt_gid;
-	kuid_t	mnt_backupuid;
-	kgid_t	mnt_backupgid;
-	umode_t	mnt_file_mode;
-	umode_t	mnt_dir_mode;
 	unsigned int mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 23b21e943652..d4e33bba4713 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -32,6 +32,7 @@
 #include "cifsacl.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
+#include "fs_context.h"
 
 /* security id for everyone/world system group */
 static const struct cifs_sid sid_everyone = {
@@ -346,8 +347,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
-	kuid_t fuid = cifs_sb->mnt_uid;
-	kgid_t fgid = cifs_sb->mnt_gid;
+	kuid_t fuid = cifs_sb->ctx->linux_uid;
+	kgid_t fgid = cifs_sb->ctx->linux_gid;
 
 	/*
 	 * If we have too many subauthorities, then something is really wrong.
@@ -448,7 +449,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 
 	/*
 	 * Note that we return 0 here unconditionally. If the mapping
-	 * fails then we just fall back to using the mnt_uid/mnt_gid.
+	 * fails then we just fall back to using the ctx->linux_uid/linux_gid.
 	 */
 got_valid_id:
 	rc = 0;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4f27f77d3053..4ea8c3c3bce1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -515,14 +515,14 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	}
 
 	seq_printf(s, ",uid=%u",
-		   from_kuid_munged(&init_user_ns, cifs_sb->mnt_uid));
+		   from_kuid_munged(&init_user_ns, cifs_sb->ctx->linux_uid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
 		seq_puts(s, ",forceuid");
 	else
 		seq_puts(s, ",noforceuid");
 
 	seq_printf(s, ",gid=%u",
-		   from_kgid_munged(&init_user_ns, cifs_sb->mnt_gid));
+		   from_kgid_munged(&init_user_ns, cifs_sb->ctx->linux_gid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
 		seq_puts(s, ",forcegid");
 	else
@@ -532,8 +532,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	if (!tcon->unix_ext)
 		seq_printf(s, ",file_mode=0%ho,dir_mode=0%ho",
-					   cifs_sb->mnt_file_mode,
-					   cifs_sb->mnt_dir_mode);
+					   cifs_sb->ctx->file_mode,
+					   cifs_sb->ctx->dir_mode);
 
 	cifs_show_nls(s, cifs_sb->local_nls);
 
@@ -606,11 +606,11 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
 		seq_printf(s, ",backupuid=%u",
 			   from_kuid_munged(&init_user_ns,
-					    cifs_sb->mnt_backupuid));
+					    cifs_sb->ctx->backupuid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID)
 		seq_printf(s, ",backupgid=%u",
 			   from_kgid_munged(&init_user_ns,
-					    cifs_sb->mnt_backupgid));
+					    cifs_sb->ctx->backupgid));
 
 	seq_printf(s, ",rsize=%u", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%u", cifs_sb->wsize);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7fc27fb49789..96c5b66d4b44 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2225,11 +2225,12 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	if (new->rsize && new->rsize < old->rsize)
 		return 0;
 
-	if (!uid_eq(old->mnt_uid, new->mnt_uid) || !gid_eq(old->mnt_gid, new->mnt_gid))
+	if (!uid_eq(old->ctx->linux_uid, new->ctx->linux_uid) ||
+	    !gid_eq(old->ctx->linux_gid, new->ctx->linux_gid))
 		return 0;
 
-	if (old->mnt_file_mode != new->mnt_file_mode ||
-	    old->mnt_dir_mode != new->mnt_dir_mode)
+	if (old->ctx->file_mode != new->ctx->file_mode ||
+	    old->ctx->dir_mode != new->ctx->dir_mode)
 		return 0;
 
 	if (strcmp(old->local_nls->charset, new->local_nls->charset))
@@ -2678,12 +2679,8 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 	cifs_sb->rsize = ctx->rsize;
 	cifs_sb->wsize = ctx->wsize;
 
-	cifs_sb->mnt_uid = ctx->linux_uid;
-	cifs_sb->mnt_gid = ctx->linux_gid;
-	cifs_sb->mnt_file_mode = ctx->file_mode;
-	cifs_sb->mnt_dir_mode = ctx->dir_mode;
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
-		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
+		 cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
 
 	cifs_sb->actimeo = ctx->actimeo;
 	cifs_sb->local_nls = ctx->local_nls;
@@ -2722,11 +2719,9 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
 	if (ctx->backupuid_specified) {
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
-		cifs_sb->mnt_backupuid = ctx->backupuid;
 	}
 	if (ctx->backupgid_specified) {
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
-		cifs_sb->mnt_backupgid = ctx->backupgid;
 	}
 	if (ctx->override_uid)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab4c96d..3ee510d3dab8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -44,6 +44,7 @@
 #include "cifs_fs_sb.h"
 #include "fscache.h"
 #include "smbdirect.h"
+#include "fs_context.h"
 
 static inline int cifs_convert_flags(unsigned int flags)
 {
@@ -566,7 +567,7 @@ int cifs_open(struct inode *inode, struct file *file)
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
-				cifs_sb->mnt_file_mode /* ignored */,
+				cifs_sb->ctx->file_mode /* ignored */,
 				file->f_flags, &oplock, &fid.netfid, xid);
 		if (rc == 0) {
 			cifs_dbg(FYI, "posix open succeeded\n");
@@ -735,7 +736,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 						~(O_CREAT | O_EXCL | O_TRUNC);
 
 		rc = cifs_posix_open(full_path, NULL, inode->i_sb,
-				     cifs_sb->mnt_file_mode /* ignored */,
+				     cifs_sb->ctx->file_mode /* ignored */,
 				     oflags, &oplock, &cfile->fid.netfid, xid);
 		if (rc == 0) {
 			cifs_dbg(FYI, "posix reopen succeeded\n");
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index daec31be8571..e8a7110db2a6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -37,6 +37,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fscache.h"
+#include "fs_context.h"
 
 
 static void cifs_set_ops(struct inode *inode)
@@ -294,7 +295,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		break;
 	}
 
-	fattr->cf_uid = cifs_sb->mnt_uid;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)) {
 		u64 id = le64_to_cpu(info->Uid);
 		if (id < ((uid_t)-1)) {
@@ -304,7 +305,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		}
 	}
 	
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)) {
 		u64 id = le64_to_cpu(info->Gid);
 		if (id < ((gid_t)-1)) {
@@ -333,8 +334,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
-	fattr->cf_uid = cifs_sb->mnt_uid;
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 	ktime_get_coarse_real_ts64(&fattr->cf_mtime);
 	fattr->cf_atime = fattr->cf_ctime = fattr->cf_mtime;
 	fattr->cf_nlink = 2;
@@ -644,8 +645,8 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 	}
 	/* else if reparse point ... TODO: add support for FIFO and blk dev; special file types */
 
-	fattr->cf_uid = cifs_sb->mnt_uid; /* TODO: map uid and gid from SID */
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid; /* TODO: map uid and gid from SID */
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
 	cifs_dbg(FYI, "POSIX query info: mode 0x%x uniqueid 0x%llx nlink %d\n",
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
@@ -689,7 +690,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		fattr->cf_mode = S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 	} else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
-		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
+		fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
 		fattr->cf_dtype = DT_DIR;
 		/*
 		 * Server can return wrong NumberOfLinks value for directories
@@ -698,7 +699,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		if (!tcon->unix_ext)
 			fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
 	} else {
-		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
+		fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_REG;
 
 		/* clear write bits if ATTR_READONLY is set */
@@ -717,8 +718,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 		}
 	}
 
-	fattr->cf_uid = cifs_sb->mnt_uid;
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 }
 
 static int
@@ -1358,8 +1359,8 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		set_nlink(inode, 2);
 		inode->i_op = &cifs_ipc_inode_ops;
 		inode->i_fop = &simple_dir_operations;
-		inode->i_uid = cifs_sb->mnt_uid;
-		inode->i_gid = cifs_sb->mnt_gid;
+		inode->i_uid = cifs_sb->ctx->linux_uid;
+		inode->i_gid = cifs_sb->ctx->linux_gid;
 		spin_unlock(&inode->i_lock);
 	} else if (rc) {
 		iget_failed(inode);
@@ -2834,10 +2835,10 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 				attrs->ia_mode &= ~(S_IALLUGO);
 				if (S_ISDIR(inode->i_mode))
 					attrs->ia_mode |=
-						cifs_sb->mnt_dir_mode;
+						cifs_sb->ctx->dir_mode;
 				else
 					attrs->ia_mode |=
-						cifs_sb->mnt_file_mode;
+						cifs_sb->ctx->file_mode;
 			}
 		} else if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)) {
 			/* ignore mode change - ATTR_READONLY hasn't changed */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1c14cf01dbef..82e176720ca6 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -35,6 +35,7 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dns_resolve.h"
 #endif
+#include "fs_context.h"
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -632,11 +633,11 @@ bool
 backup_cred(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID) {
-		if (uid_eq(cifs_sb->mnt_backupuid, current_fsuid()))
+		if (uid_eq(cifs_sb->ctx->backupuid, current_fsuid()))
 			return true;
 	}
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPGID) {
-		if (in_group_p(cifs_sb->mnt_backupgid))
+		if (in_group_p(cifs_sb->ctx->backupgid))
 			return true;
 	}
 
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5abf1ea21abe..70676843e169 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -33,6 +33,7 @@
 #include "cifs_fs_sb.h"
 #include "cifsfs.h"
 #include "smb2proto.h"
+#include "fs_context.h"
 
 /*
  * To be safe - for UCS to UTF-8 with strings loaded with the rare long
@@ -165,14 +166,14 @@ static bool reparse_file_needs_reval(const struct cifs_fattr *fattr)
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
-	fattr->cf_uid = cifs_sb->mnt_uid;
-	fattr->cf_gid = cifs_sb->mnt_gid;
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
 	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
-		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
+		fattr->cf_mode = S_IFDIR | cifs_sb->ctx->dir_mode;
 		fattr->cf_dtype = DT_DIR;
 	} else {
-		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
+		fattr->cf_mode = S_IFREG | cifs_sb->ctx->file_mode;
 		fattr->cf_dtype = DT_REG;
 	}
 
-- 
2.13.6

