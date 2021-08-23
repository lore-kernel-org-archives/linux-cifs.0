Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6577C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26EB613D5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhHWPPx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhHWPPs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E90261371;
        Mon, 23 Aug 2021 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731706;
        bh=xN1fgBsqxOu7P1il5TnPRHW4LaeVONZkGx6I/HQcpPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYVv7hRR5MjKMHmV4enAraTBY/pmER500C/bGm+Y201FKyQsboJ4Ri/I9oAXTP5GG
         Bx2BWn3AAQIRhJ6WMyJMV6bUGc1WhBCcFdZYi6dr3n7SOEgqILg6xJaQDJr8kTrckB
         JE70SrM6aodWVZXEQqa+Ob1i9WO3csdnqKdRFXEcP0x/+t2Sr9imGUTR9OJMiwwkKm
         z3JAdDQBa6mn+o+yGsMX75XEEJHZBPx4t1umCAU29smPD6aS4Pw0k6xANPgScbuJqu
         rXG1VV7o74NN/Y9h8EQ2ILwXYh8+9nk+14Tir/qMlOJY5EvODL1GH+hnVnq9Ztt00G
         UZKwGfu1UqpNA==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 02/11] ksmbd: fix translation in smb2_populate_readdir_entry()
Date:   Mon, 23 Aug 2021 17:13:48 +0200
Message-Id: <20210823151357.471691-3-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4111; h=from:subject; bh=zm1WAHe7O/SXdyr4L0I3buvVw4w5PZyJmP7CyQzvjMc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zZQWLuM1z3X6vPZe2INr0qWvsleG9HPd/Sma2KXqLBs yPLojlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkcW87wv+Rdk/qqVbkiT/JVPu6Qqq jQP+NpltDh77fuV4BGZQ/zIkaGl/NDRG8bbcyRsHtt9/wkf1jbd7n5a1tKRabI/fN0XMvNAgA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When transfering ownership information to the
client the k*ids are translated into raw *ids before they are sent over
the wire. The function currently erroneously translates the k*ids
according to the mount's idmapping. Instead, reporting the owning *ids
to userspace the underlying k*ids need to be mapped up in the caller's
user namespace. This is how stat() works.
The caller in this instance is ksmbd itself and ksmbd always runs in the
initial user namespace. Translate according to that.

The idmapping of the mount is already taken into account by the lower
filesystem and so kstat->*id will contain the mapped k*ids.

Switch to from_k*id_munged() which ensures that the overflow*id is
returned instead of the (*id_t)-1 when the k*id can't be translated.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smb2pdu.c    | 6 ++----
 fs/ksmbd/smb_common.c | 4 +---
 fs/ksmbd/smb_common.h | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a400dd292af1..559bfa2623f2 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3324,7 +3324,6 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
  */
 static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 				       struct ksmbd_dir_info *d_info,
-				       struct user_namespace *user_ns,
 				       struct ksmbd_kstat *ksmbd_kstat)
 {
 	int next_entry_offset = 0;
@@ -3478,9 +3477,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 			S_ISDIR(ksmbd_kstat->kstat->mode) ? ATTR_DIRECTORY_LE : ATTR_ARCHIVE_LE;
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			posix_info->DosAttributes |= ATTR_HIDDEN_LE;
-		id_to_sid(from_kuid(user_ns, ksmbd_kstat->kstat->uid),
+		id_to_sid(from_kuid_munged(&init_user_ns, ksmbd_kstat->kstat->uid),
 			  SIDNFS_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
-		id_to_sid(from_kgid(user_ns, ksmbd_kstat->kstat->gid),
+		id_to_sid(from_kgid_munged(&init_user_ns, ksmbd_kstat->kstat->gid),
 			  SIDNFS_GROUP, (struct smb_sid *)&posix_info->SidBuffer[20]);
 		memcpy(posix_info->name, conv_name, conv_len);
 		posix_info->name_len = cpu_to_le32(conv_len);
@@ -3571,7 +3570,6 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 		rc = smb2_populate_readdir_entry(priv->work->conn,
 						 priv->info_level,
 						 priv->d_info,
-						 user_ns,
 						 &ksmbd_kstat);
 		dput(dent);
 		if (rc)
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index b108b918ec84..43d3123d8b62 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -291,7 +291,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 				      char *search_pattern,
 				      int (*fn)(struct ksmbd_conn *, int,
 						struct ksmbd_dir_info *,
-						struct user_namespace *,
 						struct ksmbd_kstat *))
 {
 	int i, rc = 0;
@@ -322,8 +321,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 						    user_ns,
 						    dir->filp->f_path.dentry->d_parent,
 						    &ksmbd_kstat);
-			rc = fn(conn, info_level, d_info,
-				user_ns, &ksmbd_kstat);
+			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
 				break;
 			if (d_info->out_buf_len <= 0)
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index eb667d85558e..57c667c1be06 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -511,7 +511,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
 				      int (*fn)(struct ksmbd_conn *,
 						int,
 						struct ksmbd_dir_info *,
-						struct user_namespace *,
 						struct ksmbd_kstat *));
 
 int ksmbd_extract_shortname(struct ksmbd_conn *conn,
-- 
2.30.2

