Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFA4C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 18:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B1222571
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 18:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgLLSTr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 13:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgLLSTr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 13:19:47 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599D9C0613CF
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 10:19:07 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id u18so19818458lfd.9
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 10:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fKMkucoBRDIh5iwxzgvQLkxbtFm4JF40421eha9nmQ4=;
        b=fTMopcv22GKDnyYwjoKtvTDcDL3ZBu+FH+kUIYYkXV5y5szlgHWx2tOc4xXI2BwTOX
         Viaro71Zohpw9PHvdG1y8lbWDryKc+LJunyquIqk0ZAK6fVMmEuXgbuVdla79X0UH9Tp
         CADSnpGyDrMbeeAn4/nuBV0UOdcthCKgswYgHA5fuhL9/Ogus/NJPv+UIIIdaYzDwU9l
         2ToNHQKmNLmpbBvLjYyTJPadB5ESc03MrPYnD+rTsP/heU+e7S8MfPGMf9OSbjYEtyqZ
         x+BYtwW0vgzikHQU7FqTlZJftOZKn2T44v2GFF2Q2ccCnS1Jg+wW5/X1YmUF9UeELe2+
         H7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fKMkucoBRDIh5iwxzgvQLkxbtFm4JF40421eha9nmQ4=;
        b=Zr9A14lmchhWNJ31OmAyapDvvN8O65F1vtSST7RLIf0n4iQFVNMuh3hRuRAdiXhvEk
         t+YPizu2J4iPFEwJg8FwU1TBMLzDfgTJXaJXV4Qn7lQ33YZfW7z6r+Orfhx1BqqHfjSw
         LL7c01aNLynL6+PKKvVGkmtqUirpcm+gOl7HwWEngSgmUwpypLu8Uic7wrUX8mTY68bF
         QsWbM7KxD99fG/tW0vZCimE282QJDDR9IEBjeJ7cto7bMW29hLMXZdLzHO3NQ+aaAkiL
         kKD54UcJfKixKSDoQyOyD8aLwUU29OmXjthAnZQOEK4AuPrPYMhUE0CzNinYk2Jhrvzj
         dIvw==
X-Gm-Message-State: AOAM531XVN1T/bLp7nkuPbLYrfBiLHhYsp3OewTZo8iWa3+HCI6pddEd
        888jjSHwniOAfwB80IAGz6IL60r/YQkwnSAichZKg+XFeP3ooQ==
X-Google-Smtp-Source: ABdhPJwcOEG8IQT5tRouPZ0Fg588jrN/n8dtf3Q0zHnfe5Kl/CsATkyrHeOXxHl3hdCzWl1ubX1ebOlL7VpEBln7814=
X-Received: by 2002:a19:6a11:: with SMTP id u17mr6608lfu.184.1607797145024;
 Sat, 12 Dec 2020 10:19:05 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 12:18:53 -0600
Message-ID: <CAH2r5mueeQZHmzffOT=5z7FyENgK+0J_gjTuEVWRj=p1qe-gTQ@mail.gmail.com>
Subject: [PATCH] cifs: remove various function description warnings
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When compiling with W=1 I noticed various functions that
did not follow proper style in describing (in the comments)
the parameters passed in to the function. For example:

fs/cifs/inode.c:2236: warning: Function parameter or member 'mode' not
described in 'cifs_wait_bit_killable'

I did not address the style warnings in two of the six files
(connect.c and misc.c) in order to reduce risk of merge
conflict with pending patches. We can update those later.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_dfs_ref.c |  1 +
 fs/cifs/file.c         |  9 +++++++--
 fs/cifs/inode.c        | 16 +++++++++++-----
 fs/cifs/smb2misc.c     |  4 ++++
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 6f7187b90fda..e4c6ae47a796 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -254,6 +254,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
  * to perform failover in case we failed to connect to the first target in the
  * referral.
  *
+ * @mntpt: directory entry for the path we are trying to automount
  * @cifs_sb: parent/root superblock
  * @fullpath: full path in UNC format
  */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab4c96d..29176a56229f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -416,6 +416,8 @@ static void cifsFileInfo_put_work(struct work_struct *work)
  * cifsFileInfo_put - release a reference of file priv data
  *
  * Always potentially wait for oplock handler. See _cifsFileInfo_put().
+ *
+ * @cifs_file: cifs/smb3 specific info (eg refcounts) for an open file
  */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
@@ -431,8 +433,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
  *
  * If @wait_for_oplock_handler is true and we are releasing the last
  * reference, wait for any running oplock break handler of the file
- * and cancel any pending one. If calling this function from the
- * oplock break handler, you need to pass false.
+ * and cancel any pending one.
+ *
+ * @cifs_file: cifs/smb3 specific info (eg refcounts) for an open file
+ * @wait_oplock_handler: must be false if called from oplock_break_handler
+ * @offload: not offloaded on close and oplock breaks
  *
  */
 void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8debd4c18faf..2a5c4fef9b59 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -804,11 +804,15 @@ static __u64 simple_hashstr(const char *str)
  * cifs_backup_query_path_info - SMB1 fallback code to get ino
  *
  * Fallback code to get file metadata when we don't have access to
- * @full_path (EACCES) and have backup creds.
+ * full_path (EACCES) and have backup creds.
  *When compiling with W=1 I noticed various functions that
did not follow proper style in describing (in the comments)
the parameters passed in to the function. For example:

fs/cifs/inode.c:2236: warning: Function parameter or member 'mode' not
described in 'cifs_wait_bit_killable'

I did not address the style warnings in two of the six files
(connect.c and misc.c) in order to reduce risk of merge
conflict with pending patches. We can update those later.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_dfs_ref.c |  1 +
 fs/cifs/file.c         |  9 +++++++--
 fs/cifs/inode.c        | 16 +++++++++++-----
 fs/cifs/smb2misc.c     |  4 ++++
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 6f7187b90fda..e4c6ae47a796 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -254,6 +254,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
  * to perform failover in case we failed to connect to the first target in the
  * referral.
  *
+ * @mntpt: directory entry for the path we are trying to automount
  * @cifs_sb: parent/root superblock
  * @fullpath: full path in UNC format
  */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab4c96d..29176a56229f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -416,6 +416,8 @@ static void cifsFileInfo_put_work(struct work_struct *work)
  * cifsFileInfo_put - release a reference of file priv data
  *
  * Always potentially wait for oplock handler. See _cifsFileInfo_put().
+ *
+ * @cifs_file: cifs/smb3 specific info (eg refcounts) for an open file
  */
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
@@ -431,8 +433,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
  *
  * If @wait_for_oplock_handler is true and we are releasing the last
  * reference, wait for any running oplock break handler of the file
- * and cancel any pending one. If calling this function from the
- * oplock break handler, you need to pass false.
+ * and cancel any pending one.
+ *
+ * @cifs_file: cifs/smb3 specific info (eg refcounts) for an open file
+ * @wait_oplock_handler: must be false if called from oplock_break_handler
+ * @offload: not offloaded on close and oplock breaks
  *
  */
 void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8debd4c18faf..2a5c4fef9b59 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -804,11 +804,15 @@ static __u64 simple_hashstr(const char *str)
  * cifs_backup_query_path_info - SMB1 fallback code to get ino
  *
  * Fallback code to get file metadata when we don't have access to
- * @full_path (EACCES) and have backup creds.
+ * full_path (EACCES) and have backup creds.
  *
- * @data will be set to search info result buffer
- * @resp_buf will be set to cifs resp buf and needs to be freed with
- * cifs_buf_release() when done with @data.
+ * @xid: transaction id used to identify original request in logs
+ * @tcon: information about the server share we have mounted
+ * @sb: the superblock stores info such as disk space available
+ * @full_path: name of the file we are getting the metadata for
+ * @resp_buf: will be set to cifs resp buf and needs to be freed with
+ * cifs_buf_release() when done with @data
+ * @data: will be set to search info result buffer
  */
 static int
 cifs_backup_query_path_info(int xid,
@@ -2229,7 +2233,9 @@ cifs_invalidate_mapping(struct inode *inode)

 /**
  * cifs_wait_bit_killable - helper for functions that are sleeping on bit locks
- * @word: long word containing the bit lock
+ *
+ * @key: currently unused
+ * @mode: the task state to sleep in
  */
 static int
 cifs_wait_bit_killable(struct wait_bit_key *key, int mode)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index a82008a7cffb..99a4e40a2532 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -876,6 +876,10 @@ smb2_handle_cancelled_mid(char *buffer, struct
TCP_Server_Info *server)
  *
  * Assumes @iov does not contain the rfc1002 length and iov[0] has the
  * SMB2 header.
+ *
+ * @ses: server session structure
+ * @iov: array containing the SMB request we will send to the server
+ * @nvec: number of array entries for the iov
  */
 int
 smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
- * @data will be set to search info result buffer
- * @resp_buf will be set to cifs resp buf and needs to be freed with
- * cifs_buf_release() when done with @data.
+ * @xid: transaction id used to identify original request in logs
+ * @tcon: information about the server share we have mounted
+ * @sb: the superblock stores info such as disk space available
+ * @full_path: name of the file we are getting the metadata for
+ * @resp_buf: will be set to cifs resp buf and needs to be freed with
+ * cifs_buf_release() when done with @data
+ * @data: will be set to search info result buffer
  */
 static int
 cifs_backup_query_path_info(int xid,
@@ -2229,7 +2233,9 @@ cifs_invalidate_mapping(struct inode *inode)

 /**
  * cifs_wait_bit_killable - helper for functions that are sleeping on bit locks
- * @word: long word containing the bit lock
+ *
+ * @key: currently unused
+ * @mode: the task state to sleep in
  */
 static int
 cifs_wait_bit_killable(struct wait_bit_key *key, int mode)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index a82008a7cffb..99a4e40a2532 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -876,6 +876,10 @@ smb2_handle_cancelled_mid(char *buffer, struct
TCP_Server_Info *server)
  *
  * Assumes @iov does not contain the rfc1002 length and iov[0] has the
  * SMB2 header.
+ *
+ * @ses: server session structure
+ * @iov: array containing the SMB request we will send to the server
+ * @nvec: number of array entries for the iov
  */
 int
 smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)

-- 
Thanks,

Steve
