Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EC8C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 05:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D3B46144E
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 05:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhD2FeR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 01:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhD2FeQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 01:34:16 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DD6C06138B
        for <linux-cifs@vger.kernel.org>; Wed, 28 Apr 2021 22:33:30 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u25so36635181ljg.7
        for <linux-cifs@vger.kernel.org>; Wed, 28 Apr 2021 22:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TbCx5PpvMEkGWQ+Nv9B8cWd5H/ikr18Ez55l+pk0yW0=;
        b=ddwB9LfH35YoLitsDbaO3AcpOG9f41VP3MIY8B4fH2W83AgJ3tbOa3uba2K2sqUAZD
         ByXe3caCFCzBiOQodz4ugrqrutQmEHF5dLZSsU69V+x9MSmavMrRkIVqnx3qTpaTFcju
         T1cjFmmJthYIZqNmpHgK3vwSM7fKj3elvVljoLHNKYuSYcrknrVcPdzElUgciptd84jN
         oZsyE/U6s5hudn0u0d0xi2A7376IHLPFUGt6Ua/mN0QOlqpE0v5y5CqQ2e4LrpsoCpMp
         nb3te5ZXniLhvVWcxKDeitb7c5g5KgEbBUHcmVRz8IT2M1KwFn2th2Z9CpO1uK/2PLDa
         zblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TbCx5PpvMEkGWQ+Nv9B8cWd5H/ikr18Ez55l+pk0yW0=;
        b=O7icGnVb8Uq50cthwkw7ztGpUC4GSMfq2MnzRG9HkfwPJrfgCogzakV9odOy/cOLSP
         AfjfmSdO4AhzusWxZtCqTK9q4N2K0NCJYKbvNKpU6jUc9iEGS9np/wxT0fSRjvnsLRl8
         jj+3bVl4T2aYV3oLXxCPOPcWYa3Nuo95YD0D6+RH0siisZ8vyoHS8qKZyN1gNQE0daCn
         dUGR4bZuN7wLDbiZr3BbaA4athO6t9B/ai2Sxk1CFPjaAvu+xpUt9z6sVbMhrwyEpJpg
         pBI0F6hu5kr424Xta0gWeP+jEa9fHUZN6NobPkHXpVrvpjdn1C1S1deyU6nUnM2dnY5P
         P5FA==
X-Gm-Message-State: AOAM530guDkAQoOi2RrKMaxIq6TDVWoFIK4z6oLXIezPUnLKaQ5+aLzj
        8E2ba+xrRuA7Dx+c5An3N5brTliIPQbNTxl84xT+V2UAWWg=
X-Google-Smtp-Source: ABdhPJx8PtRpan6GxbJE8d6/xs6jgLo+wPv8fTmDAPQXCz2WKFKzjCwW1Jz0XitAECeJUY23/L8CBTsP9vCPwQ52r2c=
X-Received: by 2002:a2e:a78b:: with SMTP id c11mr23830627ljf.6.1619674408083;
 Wed, 28 Apr 2021 22:33:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Apr 2021 00:33:17 -0500
Message-ID: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
Subject: [PATCH] cifs: add shutdown support
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000bf420c05c115d540"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bf420c05c115d540
Content-Type: text/plain; charset="UTF-8"

Various filesystem support the shutdown ioctl which is used by various
xfstests. The shutdown ioctl sets a flag on the superblock which
prevents open, unlink, symlink, hardlink, rmdir, create etc.
on the file system until unmount and remounted. The two flags supported
in this patch are:

  FSOP_GOING_FLAGS_LOGFLUSH and FSOP_GOING_FLAGS_NOLOGFLUSH

which require very little other than blocking new operations (since
we do not cache writes to metadata on the client with cifs.ko).
FSOP_GOING_FLAGS_DEFAULT is not supported yet, but could be added in
the future but would need to call syncfs or equivalent to write out
pending data on the mount.  See
https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html for a
description of the flags

With this patch various xfstests now work including tests 043 through
046 for example.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_fs_sb.h |  1 +
 fs/cifs/cifs_ioctl.h | 16 +++++++++++++
 fs/cifs/dir.c        | 10 +++++++++
 fs/cifs/file.c       |  6 +++++
 fs/cifs/inode.c      | 25 +++++++++++++++++++--
 fs/cifs/ioctl.c      | 53 ++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/link.c       |  7 ++++++
 fs/cifs/xattr.c      |  4 ++++
 8 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 2a5325a7ae49..05de08143fcd 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -55,6 +55,7 @@
 #define CIFS_MOUNT_MODE_FROM_SID 0x10000000 /* retrieve mode from
special ACE */
 #define CIFS_MOUNT_RO_CACHE 0x20000000  /* assumes share will not change */
 #define CIFS_MOUNT_RW_CACHE 0x40000000  /* assumes only client accessing */
+#define SMB3_MOUNT_SHUTDOWN 0x80000000

 struct cifs_sb_info {
  struct rb_root tlink_tree;
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index 153d5c842a9b..a744022d2a71 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -78,3 +78,19 @@ struct smb3_notify {
 #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
 #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
 #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
+#define SMB3_IOC_SHUTDOWN _IOR ('X', 125, __u32)
+
+/*
+ * Flags for going down operation
+ */
+#define SMB3_GOING_FLAGS_DEFAULT                0x0     /* going down */
+#define SMB3_GOING_FLAGS_LOGFLUSH               0x1     /* flush log
but not data */
+#define SMB3_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't
flush log nor data */
+
+static inline bool smb3_forced_shutdown(struct cifs_sb_info *sbi)
+{
+ if (SMB3_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
+ return true;
+ else
+ return false;
+}
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 03afad8b24af..bc06a2dc6057 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -34,6 +34,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
+#include "cifs_ioctl.h"

 static void
 renew_parental_timestamps(struct dentry *direntry)
@@ -429,6 +430,9 @@ cifs_atomic_open(struct inode *inode, struct
dentry *direntry,
  __u32 oplock;
  struct cifsFileInfo *file_info;

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  /*
  * Posix open is only called (at lookup time) for file create now. For
  * opens (rather than creates), because we do not know if it is a file
@@ -545,6 +549,9 @@ int cifs_create(struct user_namespace *mnt_userns,
struct inode *inode,
  cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and
dentry = 0x%p\n",
  inode, direntry, direntry);

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
  rc = PTR_ERR(tlink);
  if (IS_ERR(tlink))
@@ -582,6 +589,9 @@ int cifs_mknod(struct user_namespace *mnt_userns,
struct inode *inode,
  return -EINVAL;

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5058252eeae6..bddeca06da08 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -45,6 +45,7 @@
 #include "fscache.h"
 #include "smbdirect.h"
 #include "fs_context.h"
+#include "cifs_ioctl.h"

 static inline int cifs_convert_flags(unsigned int flags)
 {
@@ -542,6 +543,11 @@ int cifs_open(struct inode *inode, struct file *file)
  xid = get_xid();

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb))) {
+ free_xid(xid);
+ return -EIO;
+ }
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink)) {
  free_xid(xid);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index baa9ffb4c446..35020686c66a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/sched/signal.h>
 #include <linux/wait_bit.h>
 #include <linux/fiemap.h>
-
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -38,7 +37,7 @@
 #include "cifs_unicode.h"
 #include "fscache.h"
 #include "fs_context.h"
-
+#include "cifs_ioctl.h"

 static void cifs_set_ops(struct inode *inode)
 {
@@ -1623,6 +1622,9 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)

  cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -1876,6 +1878,8 @@ int cifs_mkdir(struct user_namespace
*mnt_userns, struct inode *inode,
  mode, inode);

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -1958,6 +1962,11 @@ int cifs_rmdir(struct inode *inode, struct
dentry *direntry)
  }

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb))) {
+ rc = -EIO;
+ goto rmdir_exit;
+ }
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink)) {
  rc = PTR_ERR(tlink);
@@ -2092,6 +2101,9 @@ cifs_rename2(struct user_namespace *mnt_userns,
struct inode *source_dir,
  return -EINVAL;

  cifs_sb = CIFS_SB(source_dir->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -2409,6 +2421,9 @@ int cifs_getattr(struct user_namespace
*mnt_userns, const struct path *path,
  struct inode *inode = d_inode(dentry);
  int rc;

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  /*
  * We need to be sure that all dirty pages are written and the server
  * has actual ctime, mtime and file length.
@@ -2481,6 +2496,9 @@ int cifs_fiemap(struct inode *inode, struct
fiemap_extent_info *fei, u64 start,
  struct cifsFileInfo *cfile;
  int rc;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  /*
  * We need to be sure that all dirty pages are written as they
  * might fill holes on the server.
@@ -2967,6 +2985,9 @@ cifs_setattr(struct user_namespace *mnt_userns,
struct dentry *direntry,
  struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
  int rc, retries = 0;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  do {
  if (pTcon->unix_ext)
  rc = cifs_setattr_unix(direntry, attrs);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 08d99fec593e..b34fa6a51a7b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -164,6 +164,56 @@ static long smb_mnt_get_fsinfo(unsigned int xid,
struct cifs_tcon *tcon,
  return rc;
 }

+static int smb3_shutdown(struct super_block *sb, unsigned long arg)
+{
+ struct cifs_sb_info *sbi = CIFS_SB(sb);
+ __u32 flags;
+
+ if (!capable(CAP_SYS_ADMIN))
+ return -EPERM;
+
+ if (get_user(flags, (__u32 __user *)arg))
+ return -EFAULT;
+
+ if (flags > SMB3_GOING_FLAGS_NOLOGFLUSH)
+ return -EINVAL;
+
+ if (smb3_forced_shutdown(sbi))
+ return 0;
+
+ cifs_dbg(VFS, "shut down requested (%d)", flags); /* BB FIXME */
+/* trace_smb3_shutdown(sb, flags);*/
+
+ /*
+ * see:
+ *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html
+ * for more information and description of original intent of the flags
+ */
+ switch (flags) {
+ /*
+ * We could add support later for default flag which requires:
+ *     "Flush all dirty data and metadata to disk"
+ * would need to call syncfs or equivalent to flush page cache for
+ * the mount and then issue fsync to server (if nostrictsync not set)
+ */
+ case SMB3_GOING_FLAGS_DEFAULT:
+ cifs_dbg(VFS, "default flags\n");
+ return -EINVAL;
+ /*
+ * FLAGS_LOGFLUSH is easy since it asks to write out metadata (not
+ * data) but metadata writes are not cached on the client, so can treat
+ * it similarly to NOLOGFLUSH
+ */
+ case SMB3_GOING_FLAGS_LOGFLUSH:
+ case SMB3_GOING_FLAGS_NOLOGFLUSH:
+ sbi->mnt_cifs_flags |= SMB3_MOUNT_SHUTDOWN;
+ return 0;
+ default:
+ return -EINVAL;
+ }
+ return 0;
+}
+
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
  struct inode *inode = file_inode(filep);
@@ -325,6 +375,9 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  rc = -EOPNOTSUPP;
  cifs_put_tlink(tlink);
  break;
+ case SMB3_IOC_SHUTDOWN:
+ rc = smb3_shutdown(inode->i_sb, arg);
+ break;
  default:
  cifs_dbg(FYI, "unsupported ioctl\n");
  break;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 616e1bc0cc0a..ef2e9d2c155d 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -30,6 +30,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "smb2proto.h"
+#include "cifs_ioctl.h"

 /*
  * M-F Symlink Functions - Begin
@@ -518,6 +519,9 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
  struct TCP_Server_Info *server;
  struct cifsInodeInfo *cifsInode;
 Various filesystem support the shutdown ioctl which is used by various
xfstests. The shutdown ioctl sets a flag on the superblock which
prevents open, unlink, symlink, hardlink, rmdir, create etc.
on the file system until unmount and remounted. The two flags supported
in this patch are:

  FSOP_GOING_FLAGS_LOGFLUSH and FSOP_GOING_FLAGS_NOLOGFLUSH

which require very little other than blocking new operations (since
we do not cache writes to metadata on the client with cifs.ko).
FSOP_GOING_FLAGS_DEFAULT is not supported yet, but could be added in
the future but would need to call syncfs or equivalent to write out
pending data on the mount.

With this patch various xfstests now work including tests 043 through
046 for example.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_fs_sb.h |  1 +
 fs/cifs/cifs_ioctl.h | 16 +++++++++++++
 fs/cifs/dir.c        | 10 +++++++++
 fs/cifs/file.c       |  6 +++++
 fs/cifs/inode.c      | 25 +++++++++++++++++++--
 fs/cifs/ioctl.c      | 53 ++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/link.c       |  7 ++++++
 fs/cifs/xattr.c      |  4 ++++
 8 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 2a5325a7ae49..05de08143fcd 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -55,6 +55,7 @@
 #define CIFS_MOUNT_MODE_FROM_SID 0x10000000 /* retrieve mode from
special ACE */
 #define CIFS_MOUNT_RO_CACHE 0x20000000  /* assumes share will not change */
 #define CIFS_MOUNT_RW_CACHE 0x40000000  /* assumes only client accessing */
+#define SMB3_MOUNT_SHUTDOWN 0x80000000

 struct cifs_sb_info {
  struct rb_root tlink_tree;
diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index 153d5c842a9b..a744022d2a71 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -78,3 +78,19 @@ struct smb3_notify {
 #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
 #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
 #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
+#define SMB3_IOC_SHUTDOWN _IOR ('X', 125, __u32)
+
+/*
+ * Flags for going down operation
+ */
+#define SMB3_GOING_FLAGS_DEFAULT                0x0     /* going down */
+#define SMB3_GOING_FLAGS_LOGFLUSH               0x1     /* flush log
but not data */
+#define SMB3_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't
flush log nor data */
+
+static inline bool smb3_forced_shutdown(struct cifs_sb_info *sbi)
+{
+ if (SMB3_MOUNT_SHUTDOWN & sbi->mnt_cifs_flags)
+ return true;
+ else
+ return false;
+}
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 03afad8b24af..bc06a2dc6057 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -34,6 +34,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
+#include "cifs_ioctl.h"

 static void
 renew_parental_timestamps(struct dentry *direntry)
@@ -429,6 +430,9 @@ cifs_atomic_open(struct inode *inode, struct
dentry *direntry,
  __u32 oplock;
  struct cifsFileInfo *file_info;

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  /*
  * Posix open is only called (at lookup time) for file create now. For
  * opens (rather than creates), because we do not know if it is a file
@@ -545,6 +549,9 @@ int cifs_create(struct user_namespace *mnt_userns,
struct inode *inode,
  cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and
dentry = 0x%p\n",
  inode, direntry, direntry);

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
  rc = PTR_ERR(tlink);
  if (IS_ERR(tlink))
@@ -582,6 +589,9 @@ int cifs_mknod(struct user_namespace *mnt_userns,
struct inode *inode,
  return -EINVAL;

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5058252eeae6..bddeca06da08 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -45,6 +45,7 @@
 #include "fscache.h"
 #include "smbdirect.h"
 #include "fs_context.h"
+#include "cifs_ioctl.h"

 static inline int cifs_convert_flags(unsigned int flags)
 {
@@ -542,6 +543,11 @@ int cifs_open(struct inode *inode, struct file *file)
  xid = get_xid();

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb))) {
+ free_xid(xid);
+ return -EIO;
+ }
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink)) {
  free_xid(xid);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index baa9ffb4c446..35020686c66a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/sched/signal.h>
 #include <linux/wait_bit.h>
 #include <linux/fiemap.h>
-
 #include <asm/div64.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -38,7 +37,7 @@
 #include "cifs_unicode.h"
 #include "fscache.h"
 #include "fs_context.h"
-
+#include "cifs_ioctl.h"

 static void cifs_set_ops(struct inode *inode)
 {
@@ -1623,6 +1622,9 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)

  cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -1876,6 +1878,8 @@ int cifs_mkdir(struct user_namespace
*mnt_userns, struct inode *inode,
  mode, inode);

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -1958,6 +1962,11 @@ int cifs_rmdir(struct inode *inode, struct
dentry *direntry)
  }

  cifs_sb = CIFS_SB(inode->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb))) {
+ rc = -EIO;
+ goto rmdir_exit;
+ }
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink)) {
  rc = PTR_ERR(tlink);
@@ -2092,6 +2101,9 @@ cifs_rename2(struct user_namespace *mnt_userns,
struct inode *source_dir,
  return -EINVAL;

  cifs_sb = CIFS_SB(source_dir->i_sb);
+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -2409,6 +2421,9 @@ int cifs_getattr(struct user_namespace
*mnt_userns, const struct path *path,
  struct inode *inode = d_inode(dentry);
  int rc;

+ if (unlikely(smb3_forced_shutdown(CIFS_SB(inode->i_sb))))
+ return -EIO;
+
  /*
  * We need to be sure that all dirty pages are written and the server
  * has actual ctime, mtime and file length.
@@ -2481,6 +2496,9 @@ int cifs_fiemap(struct inode *inode, struct
fiemap_extent_info *fei, u64 start,
  struct cifsFileInfo *cfile;
  int rc;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  /*
  * We need to be sure that all dirty pages are written as they
  * might fill holes on the server.
@@ -2967,6 +2985,9 @@ cifs_setattr(struct user_namespace *mnt_userns,
struct dentry *direntry,
  struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
  int rc, retries = 0;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  do {
  if (pTcon->unix_ext)
  rc = cifs_setattr_unix(direntry, attrs);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 08d99fec593e..b34fa6a51a7b 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -164,6 +164,56 @@ static long smb_mnt_get_fsinfo(unsigned int xid,
struct cifs_tcon *tcon,
  return rc;
 }

+static int smb3_shutdown(struct super_block *sb, unsigned long arg)
+{
+ struct cifs_sb_info *sbi = CIFS_SB(sb);
+ __u32 flags;
+
+ if (!capable(CAP_SYS_ADMIN))
+ return -EPERM;
+
+ if (get_user(flags, (__u32 __user *)arg))
+ return -EFAULT;
+
+ if (flags > SMB3_GOING_FLAGS_NOLOGFLUSH)
+ return -EINVAL;
+
+ if (smb3_forced_shutdown(sbi))
+ return 0;
+
+ cifs_dbg(VFS, "shut down requested (%d)", flags); /* BB FIXME */
+/* trace_smb3_shutdown(sb, flags);*/
+
+ /*
+ * see:
+ *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.html
+ * for more information and description of original intent of the flags
+ */
+ switch (flags) {
+ /*
+ * We could add support later for default flag which requires:
+ *     "Flush all dirty data and metadata to disk"
+ * would need to call syncfs or equivalent to flush page cache for
+ * the mount and then issue fsync to server (if nostrictsync not set)
+ */
+ case SMB3_GOING_FLAGS_DEFAULT:
+ cifs_dbg(VFS, "default flags\n");
+ return -EINVAL;
+ /*
+ * FLAGS_LOGFLUSH is easy since it asks to write out metadata (not
+ * data) but metadata writes are not cached on the client, so can treat
+ * it similarly to NOLOGFLUSH
+ */
+ case SMB3_GOING_FLAGS_LOGFLUSH:
+ case SMB3_GOING_FLAGS_NOLOGFLUSH:
+ sbi->mnt_cifs_flags |= SMB3_MOUNT_SHUTDOWN;
+ return 0;
+ default:
+ return -EINVAL;
+ }
+ return 0;
+}
+
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
  struct inode *inode = file_inode(filep);
@@ -325,6 +375,9 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  rc = -EOPNOTSUPP;
  cifs_put_tlink(tlink);
  break;
+ case SMB3_IOC_SHUTDOWN:
+ rc = smb3_shutdown(inode->i_sb, arg);
+ break;
  default:
  cifs_dbg(FYI, "unsupported ioctl\n");
  break;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 616e1bc0cc0a..ef2e9d2c155d 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -30,6 +30,7 @@
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "smb2proto.h"
+#include "cifs_ioctl.h"

 /*
  * M-F Symlink Functions - Begin
@@ -518,6 +519,9 @@ cifs_hardlink(struct dentry *old_file, struct inode *inode,
  struct TCP_Server_Info *server;
  struct cifsInodeInfo *cifsInode;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -682,6 +686,9 @@ cifs_symlink(struct user_namespace *mnt_userns,
struct inode *inode,
  void *page = alloc_dentry_path();
  struct inode *newinode = NULL;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  xid = get_xid();

  tlink = cifs_sb_tlink(cifs_sb);
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index e351b945135b..c13f93e0e81b 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -30,6 +30,7 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
+#include "cifs_ioctl.h"

 #define MAX_EA_VALUE_SIZE CIFSMaxBufSize
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl" /* DACL only */
@@ -421,6 +422,9 @@ ssize_t cifs_listxattr(struct dentry *direntry,
char *data, size_t buf_size)
  const char *full_path;
  void *page;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
  return -EOPNOTSUPP;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  tlink = cifs_sb_tlink(cifs_sb);
  if (IS_ERR(tlink))
  return PTR_ERR(tlink);
@@ -682,6 +686,9 @@ cifs_symlink(struct user_namespace *mnt_userns,
struct inode *inode,
  void *page = alloc_dentry_path();
  struct inode *newinode = NULL;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  xid = get_xid();

  tlink = cifs_sb_tlink(cifs_sb);
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index e351b945135b..c13f93e0e81b 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -30,6 +30,7 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
+#include "cifs_ioctl.h"

 #define MAX_EA_VALUE_SIZE CIFSMaxBufSize
 #define CIFS_XATTR_CIFS_ACL "system.cifs_acl" /* DACL only */
@@ -421,6 +422,9 @@ ssize_t cifs_listxattr(struct dentry *direntry,
char *data, size_t buf_size)
  const char *full_path;
  void *page;

+ if (unlikely(smb3_forced_shutdown(cifs_sb)))
+ return -EIO;
+
  if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
  return -EOPNOTSUPP;


-- 
Thanks,

Steve

--000000000000bf420c05c115d540
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-cifs-add-shutdown-support.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-add-shutdown-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko2g8w550>
X-Attachment-Id: f_ko2g8w550

RnJvbSBlNmUzYzhkZDk4NjFmYzk3Nzk2OWQ3MTcwM2U3NzZiNTFjZjdmZDRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjkgQXByIDIwMjEgMDA6MTg6NDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhZGQgc2h1dGRvd24gc3VwcG9ydAoKVmFyaW91cyBmaWxlc3lzdGVtIHN1cHBvcnQgdGhl
IHNodXRkb3duIGlvY3RsIHdoaWNoIGlzIHVzZWQgYnkgdmFyaW91cwp4ZnN0ZXN0cy4gVGhlIHNo
dXRkb3duIGlvY3RsIHNldHMgYSBmbGFnIG9uIHRoZSBzdXBlcmJsb2NrIHdoaWNoCnByZXZlbnRz
IG9wZW4sIHVubGluaywgc3ltbGluaywgaGFyZGxpbmssIHJtZGlyLCBjcmVhdGUgZXRjLgpvbiB0
aGUgZmlsZSBzeXN0ZW0gdW50aWwgdW5tb3VudCBhbmQgcmVtb3VudGVkLiBUaGUgdHdvIGZsYWdz
IHN1cHBvcnRlZAppbiB0aGlzIHBhdGNoIGFyZToKCiAgRlNPUF9HT0lOR19GTEFHU19MT0dGTFVT
SCBhbmQgRlNPUF9HT0lOR19GTEFHU19OT0xPR0ZMVVNICgp3aGljaCByZXF1aXJlIHZlcnkgbGl0
dGxlIG90aGVyIHRoYW4gYmxvY2tpbmcgbmV3IG9wZXJhdGlvbnMgKHNpbmNlCndlIGRvIG5vdCBj
YWNoZSB3cml0ZXMgdG8gbWV0YWRhdGEgb24gdGhlIGNsaWVudCB3aXRoIGNpZnMua28pLgpGU09Q
X0dPSU5HX0ZMQUdTX0RFRkFVTFQgaXMgbm90IHN1cHBvcnRlZCB5ZXQsIGJ1dCBjb3VsZCBiZSBh
ZGRlZCBpbgp0aGUgZnV0dXJlIGJ1dCB3b3VsZCBuZWVkIHRvIGNhbGwgc3luY2ZzIG9yIGVxdWl2
YWxlbnQgdG8gd3JpdGUgb3V0CnBlbmRpbmcgZGF0YSBvbiB0aGUgbW91bnQuCgpXaXRoIHRoaXMg
cGF0Y2ggdmFyaW91cyB4ZnN0ZXN0cyBub3cgd29yayBpbmNsdWRpbmcgdGVzdHMgMDQzIHRocm91
Z2gKMDQ2IGZvciBleGFtcGxlLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19mc19zYi5oIHwgIDEgKwogZnMvY2lm
cy9jaWZzX2lvY3RsLmggfCAxNiArKysrKysrKysrKysrCiBmcy9jaWZzL2Rpci5jICAgICAgICB8
IDEwICsrKysrKysrKwogZnMvY2lmcy9maWxlLmMgICAgICAgfCAgNiArKysrKwogZnMvY2lmcy9p
bm9kZS5jICAgICAgfCAyNSArKysrKysrKysrKysrKysrKysrLS0KIGZzL2NpZnMvaW9jdGwuYyAg
ICAgIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZz
L2NpZnMvbGluay5jICAgICAgIHwgIDcgKysrKysrCiBmcy9jaWZzL3hhdHRyLmMgICAgICB8ICA0
ICsrKysKIDggZmlsZXMgY2hhbmdlZCwgMTIwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzX2ZzX3NiLmggYi9mcy9jaWZzL2NpZnNfZnNfc2Iu
aAppbmRleCAyYTUzMjVhN2FlNDkuLjA1ZGUwODE0M2ZjZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzX2ZzX3NiLmgKKysrIGIvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKQEAgLTU1LDYgKzU1LDcgQEAK
ICNkZWZpbmUgQ0lGU19NT1VOVF9NT0RFX0ZST01fU0lEIDB4MTAwMDAwMDAgLyogcmV0cmlldmUg
bW9kZSBmcm9tIHNwZWNpYWwgQUNFICovCiAjZGVmaW5lIENJRlNfTU9VTlRfUk9fQ0FDSEUJMHgy
MDAwMDAwMCAgLyogYXNzdW1lcyBzaGFyZSB3aWxsIG5vdCBjaGFuZ2UgKi8KICNkZWZpbmUgQ0lG
U19NT1VOVF9SV19DQUNIRQkweDQwMDAwMDAwICAvKiBhc3N1bWVzIG9ubHkgY2xpZW50IGFjY2Vz
c2luZyAqLworI2RlZmluZSBTTUIzX01PVU5UX1NIVVRET1dOCTB4ODAwMDAwMDAKIAogc3RydWN0
IGNpZnNfc2JfaW5mbyB7CiAJc3RydWN0IHJiX3Jvb3QgdGxpbmtfdHJlZTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc19pb2N0bC5oIGIvZnMvY2lmcy9jaWZzX2lvY3RsLmgKaW5kZXggMTUzZDVj
ODQyYTliLi5hNzQ0MDIyZDJhNzEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19pb2N0bC5oCisr
KyBiL2ZzL2NpZnMvY2lmc19pb2N0bC5oCkBAIC03OCwzICs3OCwxOSBAQCBzdHJ1Y3Qgc21iM19u
b3RpZnkgewogI2RlZmluZSBDSUZTX1FVRVJZX0lORk8gX0lPV1IoQ0lGU19JT0NUTF9NQUdJQywg
Nywgc3RydWN0IHNtYl9xdWVyeV9pbmZvKQogI2RlZmluZSBDSUZTX0RVTVBfS0VZIF9JT1dSKENJ
RlNfSU9DVExfTUFHSUMsIDgsIHN0cnVjdCBzbWIzX2tleV9kZWJ1Z19pbmZvKQogI2RlZmluZSBD
SUZTX0lPQ19OT1RJRlkgX0lPVyhDSUZTX0lPQ1RMX01BR0lDLCA5LCBzdHJ1Y3Qgc21iM19ub3Rp
ZnkpCisjZGVmaW5lIFNNQjNfSU9DX1NIVVRET1dOIF9JT1IgKCdYJywgMTI1LCBfX3UzMikKKwor
LyoKKyAqIEZsYWdzIGZvciBnb2luZyBkb3duIG9wZXJhdGlvbgorICovCisjZGVmaW5lIFNNQjNf
R09JTkdfRkxBR1NfREVGQVVMVCAgICAgICAgICAgICAgICAweDAgICAgIC8qIGdvaW5nIGRvd24g
Ki8KKyNkZWZpbmUgU01CM19HT0lOR19GTEFHU19MT0dGTFVTSCAgICAgICAgICAgICAgIDB4MSAg
ICAgLyogZmx1c2ggbG9nIGJ1dCBub3QgZGF0YSAqLworI2RlZmluZSBTTUIzX0dPSU5HX0ZMQUdT
X05PTE9HRkxVU0ggICAgICAgICAgICAgMHgyICAgICAvKiBkb24ndCBmbHVzaCBsb2cgbm9yIGRh
dGEgKi8KKworc3RhdGljIGlubGluZSBib29sIHNtYjNfZm9yY2VkX3NodXRkb3duKHN0cnVjdCBj
aWZzX3NiX2luZm8gKnNiaSkKK3sKKwlpZiAoU01CM19NT1VOVF9TSFVURE9XTiAmIHNiaS0+bW50
X2NpZnNfZmxhZ3MpCisJCXJldHVybiB0cnVlOworCWVsc2UKKwkJcmV0dXJuIGZhbHNlOworfQpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9kaXIuYyBiL2ZzL2NpZnMvZGlyLmMKaW5kZXggMDNhZmFkOGIy
NGFmLi5iYzA2YTJkYzYwNTcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lm
cy9kaXIuYwpAQCAtMzQsNiArMzQsNyBAQAogI2luY2x1ZGUgImNpZnNfZnNfc2IuaCIKICNpbmNs
dWRlICJjaWZzX3VuaWNvZGUuaCIKICNpbmNsdWRlICJmc19jb250ZXh0LmgiCisjaW5jbHVkZSAi
Y2lmc19pb2N0bC5oIgogCiBzdGF0aWMgdm9pZAogcmVuZXdfcGFyZW50YWxfdGltZXN0YW1wcyhz
dHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSkKQEAgLTQyOSw2ICs0MzAsOSBAQCBjaWZzX2F0b21pY19v
cGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LAogCV9fdTMy
IG9wbG9jazsKIAlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpmaWxlX2luZm87CiAKKwlpZiAodW5saWtl
bHkoc21iM19mb3JjZWRfc2h1dGRvd24oQ0lGU19TQihpbm9kZS0+aV9zYikpKSkKKwkJcmV0dXJu
IC1FSU87CisKIAkvKgogCSAqIFBvc2l4IG9wZW4gaXMgb25seSBjYWxsZWQgKGF0IGxvb2t1cCB0
aW1lKSBmb3IgZmlsZSBjcmVhdGUgbm93LiBGb3IKIAkgKiBvcGVucyAocmF0aGVyIHRoYW4gY3Jl
YXRlcyksIGJlY2F1c2Ugd2UgZG8gbm90IGtub3cgaWYgaXQgaXMgYSBmaWxlCkBAIC01NDUsNiAr
NTQ5LDkgQEAgaW50IGNpZnNfY3JlYXRlKHN0cnVjdCB1c2VyX25hbWVzcGFjZSAqbW50X3VzZXJu
cywgc3RydWN0IGlub2RlICppbm9kZSwKIAljaWZzX2RiZyhGWUksICJjaWZzX2NyZWF0ZSBwYXJl
bnQgaW5vZGUgPSAweCVwIG5hbWUgaXM6ICVwZCBhbmQgZGVudHJ5ID0gMHglcFxuIiwKIAkJIGlu
b2RlLCBkaXJlbnRyeSwgZGlyZW50cnkpOwogCisJaWYgKHVubGlrZWx5KHNtYjNfZm9yY2VkX3No
dXRkb3duKENJRlNfU0IoaW5vZGUtPmlfc2IpKSkpCisJCXJldHVybiAtRUlPOworCiAJdGxpbmsg
PSBjaWZzX3NiX3RsaW5rKENJRlNfU0IoaW5vZGUtPmlfc2IpKTsKIAlyYyA9IFBUUl9FUlIodGxp
bmspOwogCWlmIChJU19FUlIodGxpbmspKQpAQCAtNTgyLDYgKzU4OSw5IEBAIGludCBjaWZzX21r
bm9kKHN0cnVjdCB1c2VyX25hbWVzcGFjZSAqbW50X3VzZXJucywgc3RydWN0IGlub2RlICppbm9k
ZSwKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAljaWZzX3NiID0gQ0lGU19TQihpbm9kZS0+aV9zYik7
CisJaWYgKHVubGlrZWx5KHNtYjNfZm9yY2VkX3NodXRkb3duKGNpZnNfc2IpKSkKKwkJcmV0dXJu
IC1FSU87CisKIAl0bGluayA9IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CiAJaWYgKElTX0VSUih0
bGluaykpCiAJCXJldHVybiBQVFJfRVJSKHRsaW5rKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmls
ZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggNTA1ODI1MmVlYWU2Li5iZGRlY2EwNmRhMDggMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC00NSw2ICs0
NSw3IEBACiAjaW5jbHVkZSAiZnNjYWNoZS5oIgogI2luY2x1ZGUgInNtYmRpcmVjdC5oIgogI2lu
Y2x1ZGUgImZzX2NvbnRleHQuaCIKKyNpbmNsdWRlICJjaWZzX2lvY3RsLmgiCiAKIHN0YXRpYyBp
bmxpbmUgaW50IGNpZnNfY29udmVydF9mbGFncyh1bnNpZ25lZCBpbnQgZmxhZ3MpCiB7CkBAIC01
NDIsNiArNTQzLDExIEBAIGludCBjaWZzX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0
IGZpbGUgKmZpbGUpCiAJeGlkID0gZ2V0X3hpZCgpOwogCiAJY2lmc19zYiA9IENJRlNfU0IoaW5v
ZGUtPmlfc2IpOworCWlmICh1bmxpa2VseShzbWIzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkp
IHsKKwkJZnJlZV94aWQoeGlkKTsKKwkJcmV0dXJuIC1FSU87CisJfQorCiAJdGxpbmsgPSBjaWZz
X3NiX3RsaW5rKGNpZnNfc2IpOwogCWlmIChJU19FUlIodGxpbmspKSB7CiAJCWZyZWVfeGlkKHhp
ZCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9mcy9jaWZzL2lub2RlLmMKaW5kZXgg
YmFhOWZmYjRjNDQ2Li4zNTAyMDY4NmM2NmEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYwor
KysgYi9mcy9jaWZzL2lub2RlLmMKQEAgLTI2LDcgKzI2LDYgQEAKICNpbmNsdWRlIDxsaW51eC9z
Y2hlZC9zaWduYWwuaD4KICNpbmNsdWRlIDxsaW51eC93YWl0X2JpdC5oPgogI2luY2x1ZGUgPGxp
bnV4L2ZpZW1hcC5oPgotCiAjaW5jbHVkZSA8YXNtL2RpdjY0Lmg+CiAjaW5jbHVkZSAiY2lmc2Zz
LmgiCiAjaW5jbHVkZSAiY2lmc3BkdS5oIgpAQCAtMzgsNyArMzcsNyBAQAogI2luY2x1ZGUgImNp
ZnNfdW5pY29kZS5oIgogI2luY2x1ZGUgImZzY2FjaGUuaCIKICNpbmNsdWRlICJmc19jb250ZXh0
LmgiCi0KKyNpbmNsdWRlICJjaWZzX2lvY3RsLmgiCiAKIHN0YXRpYyB2b2lkIGNpZnNfc2V0X29w
cyhzdHJ1Y3QgaW5vZGUgKmlub2RlKQogewpAQCAtMTYyMyw2ICsxNjIyLDkgQEAgaW50IGNpZnNf
dW5saW5rKHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAKIAljaWZz
X2RiZyhGWUksICJjaWZzX3VubGluaywgZGlyPTB4JXAsIGRlbnRyeT0weCVwXG4iLCBkaXIsIGRl
bnRyeSk7CiAKKwlpZiAodW5saWtlbHkoc21iM19mb3JjZWRfc2h1dGRvd24oY2lmc19zYikpKQor
CQlyZXR1cm4gLUVJTzsKKwogCXRsaW5rID0gY2lmc19zYl90bGluayhjaWZzX3NiKTsKIAlpZiAo
SVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxpbmspOwpAQCAtMTg3Niw2ICsxODc4
LDggQEAgaW50IGNpZnNfbWtkaXIoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLCBz
dHJ1Y3QgaW5vZGUgKmlub2RlLAogCQkgbW9kZSwgaW5vZGUpOwogCiAJY2lmc19zYiA9IENJRlNf
U0IoaW5vZGUtPmlfc2IpOworCWlmICh1bmxpa2VseShzbWIzX2ZvcmNlZF9zaHV0ZG93bihjaWZz
X3NiKSkpCisJCXJldHVybiAtRUlPOwogCXRsaW5rID0gY2lmc19zYl90bGluayhjaWZzX3NiKTsK
IAlpZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxpbmspOwpAQCAtMTk1OCw2
ICsxOTYyLDExIEBAIGludCBjaWZzX3JtZGlyKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBk
ZW50cnkgKmRpcmVudHJ5KQogCX0KIAogCWNpZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsK
KwlpZiAodW5saWtlbHkoc21iM19mb3JjZWRfc2h1dGRvd24oY2lmc19zYikpKSB7CisJCXJjID0g
LUVJTzsKKwkJZ290byBybWRpcl9leGl0OworCX0KKwogCXRsaW5rID0gY2lmc19zYl90bGluayhj
aWZzX3NiKTsKIAlpZiAoSVNfRVJSKHRsaW5rKSkgewogCQlyYyA9IFBUUl9FUlIodGxpbmspOwpA
QCAtMjA5Miw2ICsyMTAxLDkgQEAgY2lmc19yZW5hbWUyKHN0cnVjdCB1c2VyX25hbWVzcGFjZSAq
bW50X3VzZXJucywgc3RydWN0IGlub2RlICpzb3VyY2VfZGlyLAogCQlyZXR1cm4gLUVJTlZBTDsK
IAogCWNpZnNfc2IgPSBDSUZTX1NCKHNvdXJjZV9kaXItPmlfc2IpOworCWlmICh1bmxpa2VseShz
bWIzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkpCisJCXJldHVybiAtRUlPOworCiAJdGxpbmsg
PSBjaWZzX3NiX3RsaW5rKGNpZnNfc2IpOwogCWlmIChJU19FUlIodGxpbmspKQogCQlyZXR1cm4g
UFRSX0VSUih0bGluayk7CkBAIC0yNDA5LDYgKzI0MjEsOSBAQCBpbnQgY2lmc19nZXRhdHRyKHN0
cnVjdCB1c2VyX25hbWVzcGFjZSAqbW50X3VzZXJucywgY29uc3Qgc3RydWN0IHBhdGggKnBhdGgs
CiAJc3RydWN0IGlub2RlICppbm9kZSA9IGRfaW5vZGUoZGVudHJ5KTsKIAlpbnQgcmM7CiAKKwlp
ZiAodW5saWtlbHkoc21iM19mb3JjZWRfc2h1dGRvd24oQ0lGU19TQihpbm9kZS0+aV9zYikpKSkK
KwkJcmV0dXJuIC1FSU87CisKIAkvKgogCSAqIFdlIG5lZWQgdG8gYmUgc3VyZSB0aGF0IGFsbCBk
aXJ0eSBwYWdlcyBhcmUgd3JpdHRlbiBhbmQgdGhlIHNlcnZlcgogCSAqIGhhcyBhY3R1YWwgY3Rp
bWUsIG10aW1lIGFuZCBmaWxlIGxlbmd0aC4KQEAgLTI0ODEsNiArMjQ5Niw5IEBAIGludCBjaWZz
X2ZpZW1hcChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmllbWFwX2V4dGVudF9pbmZvICpm
ZWksIHU2NCBzdGFydCwKIAlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZTsKIAlpbnQgcmM7CiAK
KwlpZiAodW5saWtlbHkoc21iM19mb3JjZWRfc2h1dGRvd24oY2lmc19zYikpKQorCQlyZXR1cm4g
LUVJTzsKKwogCS8qCiAJICogV2UgbmVlZCB0byBiZSBzdXJlIHRoYXQgYWxsIGRpcnR5IHBhZ2Vz
IGFyZSB3cml0dGVuIGFzIHRoZXkKIAkgKiBtaWdodCBmaWxsIGhvbGVzIG9uIHRoZSBzZXJ2ZXIu
CkBAIC0yOTY3LDYgKzI5ODUsOSBAQCBjaWZzX3NldGF0dHIoc3RydWN0IHVzZXJfbmFtZXNwYWNl
ICptbnRfdXNlcm5zLCBzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSwKIAlzdHJ1Y3QgY2lmc190Y29u
ICpwVGNvbiA9IGNpZnNfc2JfbWFzdGVyX3Rjb24oY2lmc19zYik7CiAJaW50IHJjLCByZXRyaWVz
ID0gMDsKIAorCWlmICh1bmxpa2VseShzbWIzX2ZvcmNlZF9zaHV0ZG93bihjaWZzX3NiKSkpCisJ
CXJldHVybiAtRUlPOworCiAJZG8gewogCQlpZiAocFRjb24tPnVuaXhfZXh0KQogCQkJcmMgPSBj
aWZzX3NldGF0dHJfdW5peChkaXJlbnRyeSwgYXR0cnMpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9p
b2N0bC5jIGIvZnMvY2lmcy9pb2N0bC5jCmluZGV4IDA4ZDk5ZmVjNTkzZS4uYjM0ZmE2YTUxYTdi
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2lvY3RsLmMKKysrIGIvZnMvY2lmcy9pb2N0bC5jCkBAIC0x
NjQsNiArMTY0LDU2IEBAIHN0YXRpYyBsb25nIHNtYl9tbnRfZ2V0X2ZzaW5mbyh1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXJldHVybiByYzsKIH0KIAorc3RhdGlj
IGludCBzbWIzX3NodXRkb3duKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHVuc2lnbmVkIGxvbmcg
YXJnKQoreworCXN0cnVjdCBjaWZzX3NiX2luZm8gKnNiaSA9IENJRlNfU0Ioc2IpOworCV9fdTMy
IGZsYWdzOworCisJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJN
OworCisJaWYgKGdldF91c2VyKGZsYWdzLCAoX191MzIgX191c2VyICopYXJnKSkKKwkJcmV0dXJu
IC1FRkFVTFQ7CisKKwlpZiAoZmxhZ3MgPiBTTUIzX0dPSU5HX0ZMQUdTX05PTE9HRkxVU0gpCisJ
CXJldHVybiAtRUlOVkFMOworCisJaWYgKHNtYjNfZm9yY2VkX3NodXRkb3duKHNiaSkpCisJCXJl
dHVybiAwOworCisJY2lmc19kYmcoVkZTLCAic2h1dCBkb3duIHJlcXVlc3RlZCAoJWQpIiwgZmxh
Z3MpOyAvKiBCQiBGSVhNRSAqLworLyoJdHJhY2Vfc21iM19zaHV0ZG93bihzYiwgZmxhZ3MpOyov
CisKKwkvKgorCSAqIHNlZToKKwkgKiAgIGh0dHBzOi8vbWFuNy5vcmcvbGludXgvbWFuLXBhZ2Vz
L21hbjIvaW9jdGxfeGZzX2dvaW5nZG93bi4yLmh0bWwKKwkgKiBmb3IgbW9yZSBpbmZvcm1hdGlv
biBhbmQgZGVzY3JpcHRpb24gb2Ygb3JpZ2luYWwgaW50ZW50IG9mIHRoZSBmbGFncworCSAqLwor
CXN3aXRjaCAoZmxhZ3MpIHsKKwkvKgorCSAqIFdlIGNvdWxkIGFkZCBzdXBwb3J0IGxhdGVyIGZv
ciBkZWZhdWx0IGZsYWcgd2hpY2ggcmVxdWlyZXM6CisJICogICAgICJGbHVzaCBhbGwgZGlydHkg
ZGF0YSBhbmQgbWV0YWRhdGEgdG8gZGlzayIKKwkgKiB3b3VsZCBuZWVkIHRvIGNhbGwgc3luY2Zz
IG9yIGVxdWl2YWxlbnQgdG8gZmx1c2ggcGFnZSBjYWNoZSBmb3IKKwkgKiB0aGUgbW91bnQgYW5k
IHRoZW4gaXNzdWUgZnN5bmMgdG8gc2VydmVyIChpZiBub3N0cmljdHN5bmMgbm90IHNldCkKKwkg
Ki8KKwljYXNlIFNNQjNfR09JTkdfRkxBR1NfREVGQVVMVDoKKwkJY2lmc19kYmcoVkZTLCAiZGVm
YXVsdCBmbGFnc1xuIik7CisJCXJldHVybiAtRUlOVkFMOworCS8qCisJICogRkxBR1NfTE9HRkxV
U0ggaXMgZWFzeSBzaW5jZSBpdCBhc2tzIHRvIHdyaXRlIG91dCBtZXRhZGF0YSAobm90CisJICog
ZGF0YSkgYnV0IG1ldGFkYXRhIHdyaXRlcyBhcmUgbm90IGNhY2hlZCBvbiB0aGUgY2xpZW50LCBz
byBjYW4gdHJlYXQKKwkgKiBpdCBzaW1pbGFybHkgdG8gTk9MT0dGTFVTSAorCSAqLworCWNhc2Ug
U01CM19HT0lOR19GTEFHU19MT0dGTFVTSDoKKwljYXNlIFNNQjNfR09JTkdfRkxBR1NfTk9MT0dG
TFVTSDoKKwkJc2JpLT5tbnRfY2lmc19mbGFncyB8PSBTTUIzX01PVU5UX1NIVVRET1dOOworCQly
ZXR1cm4gMDsKKwlkZWZhdWx0OgorCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisJcmV0dXJuIDA7Cit9
CisKIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGludCBjb21t
YW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9p
bm9kZShmaWxlcCk7CkBAIC0zMjUsNiArMzc1LDkgQEAgbG9uZyBjaWZzX2lvY3RsKHN0cnVjdCBm
aWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNvbW1hbmQsIHVuc2lnbmVkIGxvbmcgYXJnKQogCQkJ
CXJjID0gLUVPUE5PVFNVUFA7CiAJCQljaWZzX3B1dF90bGluayh0bGluayk7CiAJCQlicmVhazsK
KwkJY2FzZSBTTUIzX0lPQ19TSFVURE9XTjoKKwkJCXJjID0gc21iM19zaHV0ZG93bihpbm9kZS0+
aV9zYiwgYXJnKTsKKwkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJY2lmc19kYmcoRllJLCAidW5z
dXBwb3J0ZWQgaW9jdGxcbiIpOwogCQkJYnJlYWs7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2xpbmsu
YyBiL2ZzL2NpZnMvbGluay5jCmluZGV4IDYxNmUxYmMwY2MwYS4uZWYyZTlkMmMxNTVkIDEwMDY0
NAotLS0gYS9mcy9jaWZzL2xpbmsuYworKysgYi9mcy9jaWZzL2xpbmsuYwpAQCAtMzAsNiArMzAs
NyBAQAogI2luY2x1ZGUgImNpZnNfZnNfc2IuaCIKICNpbmNsdWRlICJjaWZzX3VuaWNvZGUuaCIK
ICNpbmNsdWRlICJzbWIycHJvdG8uaCIKKyNpbmNsdWRlICJjaWZzX2lvY3RsLmgiCiAKIC8qCiAg
KiBNLUYgU3ltbGluayBGdW5jdGlvbnMgLSBCZWdpbgpAQCAtNTE4LDYgKzUxOSw5IEBAIGNpZnNf
aGFyZGxpbmsoc3RydWN0IGRlbnRyeSAqb2xkX2ZpbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJ
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyOwogCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpj
aWZzSW5vZGU7CiAKKwlpZiAodW5saWtlbHkoc21iM19mb3JjZWRfc2h1dGRvd24oY2lmc19zYikp
KQorCQlyZXR1cm4gLUVJTzsKKwogCXRsaW5rID0gY2lmc19zYl90bGluayhjaWZzX3NiKTsKIAlp
ZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxpbmspOwpAQCAtNjgyLDYgKzY4
Niw5IEBAIGNpZnNfc3ltbGluayhzdHJ1Y3QgdXNlcl9uYW1lc3BhY2UgKm1udF91c2VybnMsIHN0
cnVjdCBpbm9kZSAqaW5vZGUsCiAJdm9pZCAqcGFnZSA9IGFsbG9jX2RlbnRyeV9wYXRoKCk7CiAJ
c3RydWN0IGlub2RlICpuZXdpbm9kZSA9IE5VTEw7CiAKKwlpZiAodW5saWtlbHkoc21iM19mb3Jj
ZWRfc2h1dGRvd24oY2lmc19zYikpKQorCQlyZXR1cm4gLUVJTzsKKwogCXhpZCA9IGdldF94aWQo
KTsKIAogCXRsaW5rID0gY2lmc19zYl90bGluayhjaWZzX3NiKTsKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMveGF0dHIuYyBiL2ZzL2NpZnMveGF0dHIuYwppbmRleCBlMzUxYjk0NTEzNWIuLmMxM2Y5M2Uw
ZTgxYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy94YXR0ci5jCisrKyBiL2ZzL2NpZnMveGF0dHIuYwpA
QCAtMzAsNiArMzAsNyBAQAogI2luY2x1ZGUgImNpZnNfZGVidWcuaCIKICNpbmNsdWRlICJjaWZz
X2ZzX3NiLmgiCiAjaW5jbHVkZSAiY2lmc191bmljb2RlLmgiCisjaW5jbHVkZSAiY2lmc19pb2N0
bC5oIgogCiAjZGVmaW5lIE1BWF9FQV9WQUxVRV9TSVpFIENJRlNNYXhCdWZTaXplCiAjZGVmaW5l
IENJRlNfWEFUVFJfQ0lGU19BQ0wgInN5c3RlbS5jaWZzX2FjbCIgLyogREFDTCBvbmx5ICovCkBA
IC00MjEsNiArNDIyLDkgQEAgc3NpemVfdCBjaWZzX2xpc3R4YXR0cihzdHJ1Y3QgZGVudHJ5ICpk
aXJlbnRyeSwgY2hhciAqZGF0YSwgc2l6ZV90IGJ1Zl9zaXplKQogCWNvbnN0IGNoYXIgKmZ1bGxf
cGF0aDsKIAl2b2lkICpwYWdlOwogCisJaWYgKHVubGlrZWx5KHNtYjNfZm9yY2VkX3NodXRkb3du
KGNpZnNfc2IpKSkKKwkJcmV0dXJuIC1FSU87CisKIAlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxh
Z3MgJiBDSUZTX01PVU5UX05PX1hBVFRSKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAKLS0gCjIu
MjcuMAoK
--000000000000bf420c05c115d540--
