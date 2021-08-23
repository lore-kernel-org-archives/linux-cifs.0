Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E0AC4320A
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1873061037
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHWPQY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231295AbhHWPQV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7BC61361;
        Mon, 23 Aug 2021 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731739;
        bh=wjmGx9RWhM1oiYr3nj542swhycrJJOD9qedxOWH5YJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NE4YjnUSMb0+QbFPiK3E8NxVX2MdngAQiwLbRGHRgRCexPgRr1mEjWD/DsPRdXInf
         eWkUs8so5LgilhzgQPAoilYV/SIxJydTSgq9FkMh3q85zEfEDInGzpbor8VHEDdLb2
         Z5arLnl1+zrE9SlBYoXDnrTyiM4Z8ZgOTbUeiYk8KZSiMpirZ6f6qFGevfxnNla49z
         XODV9M5j8j+LutyO+yEPy6di8CN2BUDCB3VxLb8SFLVwHUJIXZLXxV4mxCK+NvrxKs
         IPOCCvBPr8Bnf9xqwku0UUb9UTKUUXJN0306WpuinLEEfUsGB+3WHgZdbgCthHBUxS
         U7axSfRhyCEeA==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 11/11] ksmbd: defer notify_change() call
Date:   Mon, 23 Aug 2021 17:13:57 +0200
Message-Id: <20210823151357.471691-12-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2909; h=from:subject; bh=cek1rf+i/3OSujXmoElREcyzhl3Z6YtkSxLvNXe9KiM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zZu4n0cUOZlvvVOb5jQw51HT2zmKp5bPaPu/aZFhZO/ 9hx811HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRlhMM/zNDuc5KZT5wNPB7fb806M FZOZ2bG1r+8h1RW7whWGfSi3qG/046iU9ZmGamCf++tMJVLtjoU/OeY0aLbv8vTGN7eH2DFAsA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When ownership is changed we might in certain scenarios loose the
ability to alter the inode after we changed ownership. This can e.g.
happen when we are on an idmapped mount where uid 0 is mapped to uid
1000 and uid 1000 is mapped to uid 0.
A caller with fs*id 1000 will be able to create files as *id 1000 on
disk. They will also be able to change ownership of files owned by *id 0
to *id 1000 but they won't be able to change ownership in the other
direction. This means acl operations following notify_change() would
fail. Move the notify_change() call after the acls have been updated.
This guarantees that we don't end up with spurious "hash value diff"
warnings later on because we managed to change ownership but didn't
manage to alter acls.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/smbacl.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index ef5896297607..8457a3c27c12 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1334,25 +1334,27 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 	newattrs.ia_valid |= ATTR_MODE;
 	newattrs.ia_mode = (inode->i_mode & ~0777) | (fattr.cf_mode & 0777);
 
-	inode_lock(inode);
-	rc = notify_change(user_ns, path->dentry, &newattrs, NULL);
-	inode_unlock(inode);
-	if (rc)
-		goto out;
-
 	ksmbd_vfs_remove_acl_xattrs(user_ns, path->dentry);
 	/* Update posix acls */
 	if (IS_ENABLED(CONFIG_FS_POSIX_ACL) && fattr.cf_dacls) {
 		rc = set_posix_acl(user_ns, inode,
 				   ACL_TYPE_ACCESS, fattr.cf_acls);
+		if (rc < 0)
+			ksmbd_debug(SMB,
+				    "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
+				    rc);
 		if (S_ISDIR(inode->i_mode) && fattr.cf_dacls)
 			rc = set_posix_acl(user_ns, inode,
 					   ACL_TYPE_DEFAULT, fattr.cf_dacls);
+		if (rc)
+			ksmbd_debug(SMB,
+				    "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
+				    rc);
 	}
 
 	/* Check it only calling from SD BUFFER context */
 	if (type_check && !(le16_to_cpu(pntsd->type) & DACL_PRESENT))
-		goto out;
+		goto out_change;
 
 	if (test_share_config_flag(tcon->share_conf, KSMBD_SHARE_FLAG_ACL_XATTR)) {
 		/* Update WinACL in xattr */
@@ -1361,6 +1363,11 @@ int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 				       path->dentry, pntsd, ntsd_len);
 	}
 
+out_change:
+	inode_lock(inode);
+	rc = notify_change(user_ns, path->dentry, &newattrs, NULL);
+	inode_unlock(inode);
+
 out:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
-- 
2.30.2

